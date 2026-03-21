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

compute_fisher_quantity <- function(
    dt, qty_cols, price_cols, year_col = "year") {
    stopifnot(length(qty_cols) == 2L, length(price_cols) == 2L)

    out <- rep(NA_real_, nrow(dt))
    keep <- complete.cases(
        dt[, c(year_col, qty_cols, price_cols), with = FALSE])

    if (!any(keep)) {
        return(out)
    }

    idx <- which(keep)
    dt_work <- copy(dt[idx, c(year_col, qty_cols, price_cols), with = FALSE])
    setorderv(dt_work, year_col)

    q1 <- dt_work[[qty_cols[1]]]
    q2 <- dt_work[[qty_cols[2]]]
    p1 <- dt_work[[price_cols[1]]]
    p2 <- dt_work[[price_cols[2]]]

    fisher_index <- rep(NA_real_, nrow(dt_work))
    fisher_index[1] <- 1

    if (nrow(dt_work) > 1L) {
        for (i in 2:nrow(dt_work)) {
            laspeyres <- (
                p1[i - 1] * q1[i] + p2[i - 1] * q2[i]
            ) / (
                p1[i - 1] * q1[i - 1] + p2[i - 1] * q2[i - 1]
            )
            paasche <- (
                p1[i] * q1[i] + p2[i] * q2[i]
            ) / (
                p1[i] * q1[i - 1] + p2[i] * q2[i - 1]
            )

            fisher_index[i] <- fisher_index[i - 1] * sqrt(laspeyres * paasche)
        }
    }

    base_qty <- q1[1] + q2[1]
    out[idx[order(dt_work[[year_col]])]] <- fisher_index * base_qty
    out
}

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
dt_nberces <- readRDS(here("derived", "nberces-mh.Rds"))

# CBP: state and national wide employment ----
v_emp_cols <- c(
    "321991" = "emp_mh")

# Through 2016 we have county rows from the harmonized Eckert panel.
# From 2017 onward the importer appends raw Census API state rows
# (countyfp == 0) and U.S. rows (statefp == 0, countyfp == 0).
dt_cbp_state_src <- dt_cbp[
    statefp > 0 &
        (
            year <= 2016 |
            (year >= 2017 & countyfp == 0)
        )
]
dt_cbp_nat_src <- rbindlist(list(
    dt_cbp[year <= 2016 & statefp > 0],
    dt_cbp[year >= 2017 & statefp == 0 & countyfp == 0]
), use.names = TRUE, fill = TRUE)

dt_cbp_mh_state <- dt_cbp_state_src[naics12 %in% names(v_emp_cols)]
dt_cbp_mh_nat <- dt_cbp_nat_src[naics12 %in% names(v_emp_cols)]
# Residential building construction aggregate; includes remodelers in 2361.
dt_cbp_recon_state <- dt_cbp_state_src[startsWith(naics12, "2361")]
dt_cbp_recon_nat <- dt_cbp_nat_src[startsWith(naics12, "2361")]

dt_cbp_state <- dt_cbp_mh_state[, .(emp = sum(emp)),
    by = .(year, statefp, naics12)
]
dt_cbp_state <- dcast(dt_cbp_state, year + statefp ~ naics12, value.var = "emp")
setnames(dt_cbp_state, names(v_emp_cols), v_emp_cols)

dt_cbp_recon_state <- dt_cbp_recon_state[
    ,
    .(emp_recon_total = sum(emp)),
    by = .(year, statefp)
]

dt_cbp <- dt_cbp_mh_nat[, .(emp = sum(emp)), by = .(year, naics12)]
dt_cbp <- dcast(dt_cbp, year ~ naics12, value.var = "emp")
setnames(dt_cbp, names(v_emp_cols), v_emp_cols)

dt_cbp_recon <- dt_cbp_recon_nat[, .(emp_recon_total = sum(emp)), by = year]

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
dt_nat[, placements_fisher := compute_fisher_quantity(
    .SD,
    qty_cols = c("placements_single", "placements_double"),
    price_cols = c("avg_sales_price_single", "avg_sales_price_double")
)]

dt_nat <- compute_productivity_metrics(dt_nat)
dt_nat[, placements_fisher_pemp := placements_fisher / emp_mh]

# NBER-CES: value added, TFP, deflators ----
dt_nat <- merge(dt_nat, dt_nberces, by = "year", all = TRUE)

# real value added per employee (1997$, thousands)
dt_nat[, real_vadd_pemp := (vadd_nberces / piship_nberces) / emp_nberces]

# MH shipments per employee (NBER-CES)
dt_nat[, ship_pemp_mh_nberces := shipments / (emp_nberces * 1000)]
dt_nat[, place_pemp_mh_nberces := placements / (emp_nberces * 1000)]
dt_nat[, place_fisher_pemp_mh_nberces :=
    placements_fisher / (emp_nberces * 1000)]

setorder(dt_nat, year)

# export ----
saveRDS(dt_state, here("derived", "sample-state.Rds"))
saveRDS(dt_nat, here("derived", "sample.Rds"))

print_panel_summary(dt_state, "Saved state-year panel")
print_panel_summary(dt_nat, "Saved national-year panel")
