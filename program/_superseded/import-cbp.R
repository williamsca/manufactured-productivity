# This script imports the County Business Patterns (CBP) data from the
# US Census Bureau, provided by Fabian Eckert:
# https://www.fpeckert.me/cbp/
#
# We keep the harmonized Eckert county panel through 2016 only. Starting in
# 2017, we splice in raw Census CBP aggregates for the mobile-home
# manufacturing series and residential building construction.

rm(list = ls())
library(here)
library(data.table)
library(jsonlite)

data_path <- Sys.getenv("DATA_PATH", unset = "")

historical_end_year <- 2016L
api_start_year <- 2017L
api_target_end_year <- 2024L
api_codes <- c("321991", "2361")

find_historical_file <- function(data_path) {
  candidate_paths <- c(
    if (nzchar(data_path)) {
      file.path(data_path, "data", "census-cbp", "1975-2018", "efsy_panel_naics.csv.zip")
    },
    if (nzchar(data_path)) {
      file.path(data_path, "data", "census-cbp", "1975-2018", "efsy_panel_naics.csv")
    }
  )

  candidate_paths <- Filter(nzchar, candidate_paths)
  existing_paths <- candidate_paths[file.exists(candidate_paths)]

  if (!length(existing_paths)) {
    stop(
      "Could not locate the Eckert CBP panel. Set DATA_PATH so ",
      "data/census-cbp/1975-2018/efsy_panel_naics.csv(.zip) is available."
    )
  }

  existing_paths[[1]]
}

read_historical_cbp <- function(file_path) {
  if (endsWith(file_path, ".zip")) {
    tmp_dir <- tempfile(pattern = "cbp_")
    dir.create(tmp_dir)
    on.exit(unlink(tmp_dir, recursive = TRUE), add = TRUE)
    file_path <- unzip(file_path, exdir = tmp_dir)
  }

  dt <- fread(file_path)
  setnames(dt,
    old = c("fipstate", "fipscty"),
    new = c("statefp", "countyfp"))

  dt[, `:=`(
    statefp = as.integer(statefp),
    countyfp = as.integer(countyfp),
    year = as.integer(year)
  )]

  dt[year <= historical_end_year]
}

api_exists <- function(year) {
  url <- sprintf("https://api.census.gov/data/%d/cbp/variables.html", year)

  isTRUE(tryCatch(
    {
      suppressWarnings(readLines(url, n = 1L, warn = FALSE))
      TRUE
    },
    error = function(e) FALSE
  ))
}

detect_latest_api_year <- function(max_year, min_year) {
  for (year in seq.int(max_year, min_year, by = -1L)) {
    if (api_exists(year)) {
      return(year)
    }
  }

  stop("Could not find a published CBP API vintage.")
}

fetch_api_slice <- function(year, naics_code, geography = c("state", "us")) {
  geography <- match.arg(geography)
  naics_var <- if (year <= 2016L) "NAICS2012" else "NAICS2017"
  geo_clause <- switch(
    geography,
    state = "for=state:*",
    us = "for=us:1"
  )
  url <- sprintf(
    "https://api.census.gov/data/%d/cbp?get=EMP&%s=%s&%s",
    year, naics_var, naics_code, geo_clause
  )

  payload <- tryCatch(
    paste(readLines(url, warn = FALSE), collapse = "\n"),
    error = function(e) {
      stop(
        sprintf(
          "Failed to fetch CBP API data for year %d, NAICS %s, geography %s.",
          year, naics_code, geography
        ),
        call. = FALSE
      )
    }
  )
  parsed <- fromJSON(payload)
  dt <- as.data.table(parsed[-1, , drop = FALSE])
  setnames(dt, parsed[1, ])

  if (geography == "state") {
    dt[, `:=`(
      statefp = as.integer(state),
      countyfp = 0L
    )]
  } else {
    dt[, `:=`(
      statefp = 0L,
      countyfp = 0L
    )]
  }

  dt[, `:=`(
    naics12 = naics_code,
    emp = as.numeric(EMP),
    year = as.integer(year),
    v1 = NA
  )]

  dt[, .(statefp, countyfp, naics12, emp, year, v1)]
}

fetch_api_cbp <- function(start_year, end_year, naics_codes) {
  dt_list <- vector("list", length = 0L)

  for (year in seq.int(start_year, end_year)) {
    for (naics_code in naics_codes) {
      dt_list[[length(dt_list) + 1L]] <- fetch_api_slice(year, naics_code, "state")
      dt_list[[length(dt_list) + 1L]] <- fetch_api_slice(year, naics_code, "us")
    }
  }

  rbindlist(dt_list, use.names = TRUE)
}

# import ----

# * historical (1946-1974)
# (can't identify MH manufacturing employment before 1972)

# * harmonized county panel (1975-2016)
historical_file <- find_historical_file(data_path)
dt_hist <- read_historical_cbp(historical_file)

# * raw Census API aggregates (2017-latest available, capped at 2024)
latest_api_year <- detect_latest_api_year(
  max_year = api_target_end_year,
  min_year = api_start_year
)
if (latest_api_year < api_target_end_year) {
  message(
    "CBP API is available through ", latest_api_year,
    "; requested cap was ", api_target_end_year, "."
  )
}
message(
  "Appending raw Census CBP aggregates for ",
  api_start_year, "-", latest_api_year, "."
)
dt_api <- fetch_api_cbp(
  start_year = api_start_year,
  end_year = latest_api_year,
  naics_codes = api_codes
)

dt <- rbindlist(list(dt_hist, dt_api), use.names = TRUE, fill = TRUE)

# clean ----
setkey(dt, statefp, countyfp, year, naics12)

# export ----
fwrite(dt, here("derived", "census-cbp.csv"))
