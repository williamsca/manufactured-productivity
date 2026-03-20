# Build state-year and national-year productivity panels.
#
# State panel output:
#   derived/sample-state-year.Rds
#   derived/sample.Rds              (legacy alias)
#
# National panel output:
#   derived/sample-national-year.Rds
#
# Core output measures:
#   shipments / placements / prices from Census MHS
#   permits_sf / permits_mf from Census BPS
#
# Employment:
#   State: CBP only
#   National: CBP aggregate plus optional CES extension for MH employment

rm(list = ls())
library(here)
library(data.table)

compute_productivity_metrics <- function(dt) {
    dt[, ship_pemp_mh := shipments / emp_mh]
    dt[, place_pemp_mh := placements / emp_mh]

    dt[, permits_pemp := (permits_sf + permits_mf) / emp_recon_total]

    dt
}

print_panel_summary <- function(dt, label) {
    message(
        label, ": ", nrow(dt), " rows; years ",
        min(dt$year, na.rm = TRUE), "-", max(dt$year, na.rm = TRUE)
    )
}

# Import ----
dt_mhs_state <- readRDS(here("derived", "mhs-state-year.Rds"))
dt_mhs_nat <- readRDS(here("derived", "mhs-national-year.Rds"))
dt_cbp <- fread(here("derived", "census-cbp.csv"))
dt_bps <- readRDS(here("derived", "census-bps.Rds"))

# CBP: state and national wide employment ----
v_emp_cols <- c(
    "321991" = "emp_mh")

dt_cbp_mh <- dt_cbp[naics12 %in% names(v_emp_cols)]
# Residential building construction aggregate; includes remodelers in 2361.
dt_cbp_recon <- dt_cbp[startsWith(naics12, "2361")]

dt_cbp_state <- dt_cbp_mh[, .(emp = sum(emp)),
    by = .(year, statefp, naics12)
]
dt_cbp_state <- dcast(dt_cbp_state, year + statefp ~ naics12, value.var = "emp")
setnames(dt_cbp_state, names(v_emp_cols), v_emp_cols)

dt_cbp_recon_state <- dt_cbp_recon[
    ,
    .(emp_recon_total = sum(emp)),
    by = .(year, statefp)
]

dt_cbp <- dt_cbp_mh[, .(emp = sum(emp)), by = .(year, naics12)]
dt_cbp <- dcast(dt_cbp, year ~ naics12, value.var = "emp")
setnames(dt_cbp, names(v_emp_cols), v_emp_cols)

dt_cbp_recon <- dt_cbp_recon[, .(emp_recon_total = sum(emp)), by = year]

dt_cbp_state <- merge(
    dt_cbp_state,
    dt_cbp_recon_state,
    by = c("year", "statefp"),
    all = TRUE
)

dt_cbp <- merge(dt_cbp, dt_cbp_recon, by = "year", all = TRUE)

# BPS: state and national permits ----
dt_bps_state <- copy(dt_bps)
dt_bps_state[, permits_mf := permits_tot - permits_sf]
dt_bps_state[, permits_tot := NULL]

dt_bps_nat <- dt_bps[
    ,
    .(
        permits_sf = sum(permits_sf, na.rm = TRUE),
        permits_tot = sum(permits_tot, na.rm = TRUE)
    ),
    by = year
]
dt_bps_nat[, permits_mf := permits_tot - permits_sf]
dt_bps_nat[, permits_tot := NULL]

# State panel ----
dt_state <- copy(dt_mhs_state)

dt_state <- merge(
    dt_state, dt_cbp_state, by = c("statefp", "year"), all.x = TRUE
)

dt_state <- merge(
    dt_state,
    dt_bps_state,
    by = c("statefp", "year"),
    all = TRUE
)
dt_state <- compute_productivity_metrics(dt_state)
setorder(dt_state, statefp, year)

# National panel ----
dt_nat <- copy(dt_mhs_nat)

dt_nat <- merge(dt_nat, dt_cbp, by = c("year"), all = TRUE)
dt_nat <- merge(dt_nat, dt_bps_nat, by = "year", all = TRUE)

dt_nat <- compute_productivity_metrics(dt_nat)

setorder(dt_nat, year)

# export ----
saveRDS(dt_state, here("derived", "sample-state.Rds"))
saveRDS(dt_nat, here("derived", "sample.Rds"))

print_panel_summary(dt_state, "Saved state-year panel")
print_panel_summary(dt_nat, "Saved national-year panel")
