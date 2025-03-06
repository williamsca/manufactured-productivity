# This script imports data from the Annual Survey of Manufacturers
# using the Census API.

# rm(list = ls())
library(here)
library(data.table)
library(censusapi)

# Import ----
census_key <- Sys.getenv("CENSUS_KEY")

read_asm_year <- function(year) {
    data <- tryCatch({
        getCensus(
            name = "timeseries/asm/industry",
            vars = c("GEO_TTL", "NAICS_TTL", "EMP", "VALADD"),
            region = "us:*",
            time = year,
            NAICS = "321991",
            key = census_key
        )
    }, error = function(e) {
        if (grepl("204", e$message)) {
            message("Error: 204, no content was returned.")
            return(NULL)
        } else {
            stop(e)
        }
    })
    return(data)
}

if (!file.exists(here("derived", "asm.Rds"))) {
    dt <- rbindlist(lapply(2002:2016, read_asm_year))
    setnames(dt, names(dt), tolower(names(dt)))

    dt <- dt[, .(year = time, emp_asm = emp, valadd_asm = valadd)]

    # Export ----
    saveRDS(dt, here("derived", "asm.Rds"))
}
