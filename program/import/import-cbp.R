# Import MH and residential construction employment from Census CBP API
#
# Industries pulled:
#   mh             SIC 2451 (1986-1997) / NAICS 321991 (1998+)
#   recon_sf       NAICS1997 23321 (1998-2002) / NAICS 236115 (2003+)
#   recon_mf       NAICS1997 23322 (1998-2002) / NAICS 236116 (2003+)
#   recon_forsale  NAICS 236117 (2003+)
#   recon_remodel  NAICS 236118 (2003+)
#
# Construction SIC codes (1521/1522) return empty from the CBP API -- CBP does
# not cover construction in the SIC era. Residential construction data begins
# with NAICS in 1998.
#
# NAICS1997 used 5-digit codes for residential construction (23321/23322);
# NAICS2002+ reorganized these into 6-digit 236115/236116. The NAICS1997 codes
# for operative builders (23324) and remodelers (23325) also return empty, so
# recon_forsale and recon_remodel begin in 2003.
#
# NAICS vintage variable names by year:
#   1986-1997: SIC
#   1998-2002: NAICS1997
#   2003-2007: NAICS2002
#   2008-2011: NAICS2007
#   2012-2016: NAICS2012
#   2017+:     NAICS2017

rm(list = ls())
library(here)
library(data.table)
library(httr2)

# Read Census API key from .Renviron
readRenviron(here(".Renviron"))
key <- Sys.getenv("CENSUS_KEY")

# Helper: NAICS vintage variable name for a given year ----
naics_vintage <- function(year) {
    if (year <= 1997) return("SIC")
    if (year <= 2002) return("NAICS1997")
    if (year <= 2007) return("NAICS2002")
    if (year <= 2011) return("NAICS2007")
    if (year <= 2016) return("NAICS2012")
    return("NAICS2017")
}

# Helper: pull one year/industry from CBP API ----
pull_cbp <- function(year, key, industry_code, label) {
    base_url <- paste0("https://api.census.gov/data/", year, "/cbp")
    system   <- naics_vintage(year)

    query <- c(
        list(get = "EMP,ESTAB,PAYANN", `for` = "state:*", key = key),
        setNames(list(industry_code), system)
    )

    req  <- request(base_url) |> req_url_query(!!!query)
    resp <- tryCatch(
        req_perform(req),
        error = function(e) {
            message("Error for year ", year, " (", label, "): ", conditionMessage(e))
            return(NULL)
        }
    )

    if (is.null(resp) || resp_status(resp) != 200) {
        status <- if (is.null(resp)) "network error" else resp_status(resp)
        message("Failed for year ", year, " (", label, ", status ", status, ")")
        return(NULL)
    }

    raw <- resp_body_json(resp, simplifyVector = TRUE)
    dt  <- as.data.table(raw[-1, , drop = FALSE])
    setnames(dt, raw[1, ])

    dt[, year            := year]
    dt[, industry_label  := label]
    dt[, industry_system := system]
    dt[, statefp := as.integer(state)]
    dt[, state   := NULL]
    dt[, EMP    := as.integer(EMP)]
    dt[, ESTAB  := as.integer(ESTAB)]
    dt[, PAYANN := as.numeric(PAYANN)]  # annual payroll in $1,000

    return(dt)
}

# Industry definitions ----
# Fields: label, sic (SIC era), naics1997 (1998-2002), naics (2003+), start year
industries <- list(
    list(label = "mh",
         sic = "2451",   naics1997 = "321991",  naics = "321991",
         start = 1986),
    list(label = "recon_sf",
         sic = NA,       naics1997 = "23321",   naics = "236115",
         start = 1998),
    list(label = "recon_mf",
         sic = NA,       naics1997 = "23322",   naics = "236116",
         start = 1998),
    list(label = "recon_forsale",
         sic = NA,       naics1997 = NA,        naics = "236117",
         start = 2003),
    list(label = "recon_remodel",
         sic = NA,       naics1997 = NA,        naics = "236118",
         start = 2003)
)

# Build task list: one row per (year, industry_code, label) ----
all_years <- 1986:2022

tasks <- rbindlist(lapply(industries, function(ind) {
    rbindlist(lapply(all_years[all_years >= ind$start], function(yr) {
        code <- if (yr <= 1997 && !is.na(ind$sic))        ind$sic
                else if (yr <= 2002 && !is.na(ind$naics1997)) ind$naics1997
                else if (yr >= 2003 && !is.na(ind$naics))     ind$naics
                else NA_character_
        if (is.na(code)) return(NULL)
        data.table(year = yr, code = code, label = ind$label)
    }))
}))

# Pull all tasks ----
message("Pulling CBP data: ", nrow(tasks), " requests...")
results <- lapply(seq_len(nrow(tasks)), function(i) {
    row <- tasks[i]
    message("  ", row$year, " | ", row$label, " (", row$code, ")")
    Sys.sleep(0.2)  # be polite to the API
    pull_cbp(row$year, key, row$code, row$label)
})

dt_cbp <- rbindlist(results, fill = TRUE)

# Clean up ----
# Note: CBP employment is March 12 pay-period employment (comparable to QCEW)
# PAYANN is in $1,000; convert to dollars
dt_cbp <- dt_cbp[, .(statefp, year, industry_label, industry_system,
                      emp_cbp    = EMP,
                      estab_cbp  = ESTAB,
                      payann_cbp = PAYANN * 1000)]

setorder(dt_cbp, industry_label, statefp, year)

message("Years covered: ", min(dt_cbp$year), "-", max(dt_cbp$year))
message("Rows: ", nrow(dt_cbp))
print(dt_cbp)

# Export ----
saveRDS(dt_cbp, here("derived", "cbp_emp.Rds"))
message("Saved to derived/cbp_emp.Rds")
