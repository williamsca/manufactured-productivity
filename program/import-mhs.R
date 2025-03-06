# This script imports shipments and placements of manufactured
# homes from the Census Bureau's Survey of Manufactured Housing.

# Total shipments of manufactured homes are
# from:
# https://www.census.gov/programs-surveys/mhs/data/latest-data.html

rm(list = ls())
library(here)
library(data.table)
library(readxl)

# Import ----
# shipments
dt_ship <- as.data.table(read_xlsx(
    here("data", "census-mhs", "annual_shipmentstostates.xlsx"),
    skip = 4
))

dt_ship <- dt_ship[!grepl("Totals", State) & !is.na(State)]
dt_ship[, `2024` := as.numeric(`2024`)]

dt_ship <- melt(
    dt_ship,
    id.vars = "State", variable.name = "year",
    value.name = "shipments", variable.factor = FALSE
)

dt_ship <- dt_ship[, .(shipments = sum(shipments)), by = .(year)]
dt_ship[, year := as.numeric(year)]

# old survey (prices and placements)
file <- "place_hist.xlsx"

import_mhs <- function(file) {
    value <- ifelse(grepl("place", file), "place", "avgslsprice")

    dt <- as.data.table(read_xlsx(
        here("data", "census-mhs", file),
        skip = 2, col_names = FALSE
    ))

    v_types <- c("tot", "single", "double")
    v_years <- seq(2013, 1980, -1)

    v_names <- as.vector(outer(v_years, v_types, paste, sep = "_"))
    v_names <- v_names[order(v_names, decreasing = TRUE)]
    v_names <- c("region", "state_name", v_names)

    setnames(dt, v_names)

    # Clean ----
    dt <- dt[region == "United States"]
    dt$region <- NULL

    dt <- melt(
        dt,
        id.vars = "state_name", variable.name = "year_type",
        value.name = "value"
    )

    if (grepl("place", file)) {
        dt[, value := 1000 * as.integer(value)]
    } else {
        dt[, value := as.integer(value)]
    }

    dt[, c("year", "type") := tstrsplit(year_type, "_", fixed = TRUE)]

    dt <- dcast(dt, state_name + year ~ type, value.var = "value")
    setnames(dt, v_types, paste0(value, "_", v_types))

    dt[, year := as.integer(year)]
    dt$state_name <- NULL

    return(dt)
}

dt_place <- import_mhs("place_hist.xlsx")
dt_price <- import_mhs("avgslsprice_hist.xlsx")

dt <- merge(dt_place, dt_price, by = c("year"), all = TRUE)

# Merge ----
dt <- merge(dt, dt_ship, by = "year", all = TRUE)

# Export ----
saveRDS(dt, here("derived", "mhs.Rds"))
