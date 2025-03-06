# This script computes national measures of productivity in the
# manufactured housing industry using data from the Bureau of Labor
# Statistics and the Census Bureau.

# Total employment in NAICS 321991 (Manufactured Home Manufacturing)
# is from the Bureau of Labor Statistics Quarterly Census of Employment &
# Wages:
# https://www.bls.gov/data/home.htm

# TODO: figure out the appropriate deflator for value-added

rm(list = ls())
library(here)
library(data.table)
library(readxl)

# Import ----
# shipments
dt_mhs <- readRDS(here("derived", "mhs.Rds"))

# employment
dt_emp <- as.data.table(read_xlsx(
    here("data", "bls-qcew", "SeriesReport-20250306162328_a93737.xlsx"),
    skip = 13))
dt_emp <- dt_emp[!is.na(Annual), .(year = Year, emp_bls = Annual)]

# value-added
source(here("program", "import-asm.R"))
dt_val <- readRDS(here("derived", "asm.Rds"))
dt_val[, names(dt_val) := lapply(.SD, as.numeric)]

# Merge ----
dt <- merge(dt_ship, dt_emp, by = "year")

dt <- merge(dt, dt_val, by = "year", all.x = TRUE)

# Compute ----
dt[, ship_pemp := shipments / emp_bls]
dt[, valadd_pemp := valadd_asm / emp_bls]

# Export ----
saveRDS(dt, here("derived", "sample.Rds"))
