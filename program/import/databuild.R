# Build state-year panel: output per employee for MH and residential construction.
#
# Output measures:
#   mh_ship   -- MH shipments (Census MHS, 1994-2024)
#   permits_sf -- SF building permits (Census BPS, 1980-2023)
#   permits_mf -- MF building permits (Census BPS, 1980-2023)
#
# Employment measures from Census CBP (March-12 pay-period):
#   emp_mh          -- NAICS 321991 / SIC 2451 (1986-2022)
#   emp_recon_sf    -- NAICS 236115 (SF builders, 2003-2022) /
#                      NAICS1997 23321 (1998-2002)
#   emp_recon_mf    -- NAICS 236116 (MF builders, 2003-2022) /
#                      NAICS1997 23322 (1998-2002)
#   emp_recon_fs    -- NAICS 236117 (for-sale builders, 2003-2022)
#   emp_recon_remod -- NAICS 236118 (remodelers, 2003-2022)
#
# Ratios computed:
#   ship_per_mh_emp  -- MH shipments / MH employment
#   sf_per_recon_emp -- SF permits / (SF + for-sale) employment
#   mf_per_recon_emp -- MF permits / MF employment
#   tot_per_recon_emp -- total permits / total recon employment

rm(list = ls())
library(here)
library(data.table)

# Import ----
dt_mhs <- readRDS(here("derived", "mhs.Rds"))         # statefp x year
dt_cbp <- readRDS(here("derived", "cbp_emp.Rds"))     # statefp x year x industry
dt_bps <- readRDS(here("derived", "bps-permits.Rds")) # statefp x year

# Reshape CBP to wide (one row per statefp x year) ----
dt_emp <- dcast(
    dt_cbp,
    statefp + year ~ industry_label,
    value.var = "emp_cbp"
)
setnames(dt_emp,
    c("mh", "recon_forsale", "recon_mf", "recon_remodel", "recon_sf"),
    c("emp_mh", "emp_recon_fs", "emp_recon_mf", "emp_recon_remod", "emp_recon_sf")
)

# BPS: derive MF permits ----
dt_bps[, permits_mf := permits_tot - permits_sf]
dt_bps[, permits_tot := NULL]

# Merge ----
dt <- merge(dt_mhs, dt_emp, by = c("statefp", "year"), all = TRUE)
dt <- merge(dt, dt_bps[, .(statefp, year, permits_sf, permits_mf)],
            by = c("statefp", "year"), all = TRUE)

# Compute output per employee ----
# MH: shipments per MH manufacturing employee
dt[, ship_per_mh_emp := shipments / emp_mh]

# SF residential construction: SF permits per (SF + for-sale) employee
# Note: recon_forsale begins 2003; before that use recon_sf alone
dt[, emp_sf_total := fcoalesce(emp_recon_sf, 0L) + fcoalesce(emp_recon_fs, 0L)]
dt[emp_sf_total == 0L, emp_sf_total := NA_integer_]
dt[, sf_per_recon_emp := permits_sf / emp_sf_total]

# MF residential construction: MF permits per MF employee
dt[, mf_per_recon_emp := permits_mf / emp_recon_mf]

# Total recon: total permits per all recon employees (excluding remodelers)
dt[, emp_recon_total := fcoalesce(emp_recon_sf, 0L) +
                        fcoalesce(emp_recon_mf, 0L) +
                        fcoalesce(emp_recon_fs, 0L)]
dt[emp_recon_total == 0L, emp_recon_total := NA_integer_]
dt[, permits_tot := permits_sf + permits_mf]
dt[, tot_per_recon_emp := permits_tot / emp_recon_total]

setorder(dt, statefp, year)

# Export ----
saveRDS(dt, here("derived", "sample.Rds"))
message("Saved state-year panel: ", nrow(dt), " rows, ",
        uniqueN(dt$statefp), " states, years ",
        min(dt$year, na.rm = TRUE), "-", max(dt$year, na.rm = TRUE))
