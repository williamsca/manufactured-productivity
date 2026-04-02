# Build national-year productivity panels.
#
# National panel output:
#   derived/sample-national-year.Rds
#
# Core output measures:
#   shipments / placements / prices from Census MHS
#

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


print_panel_summary <- function(dt, label) {
    message(
        label, ": ", nrow(dt), " rows; years ",
        min(dt$year, na.rm = TRUE), "-", max(dt$year, na.rm = TRUE)
    )
}

# Import ----
dt_mhs_state <- readRDS(here("derived", "mhs-state-year.Rds"))
dt_mhs_nat <- readRDS(here("derived", "mhs-national-year.Rds"))
dt_nberces <- readRDS(here("derived", "nberces-mh.Rds"))

# National panel ----
dt_nat <- copy(dt_mhs_nat)

dt_nat[, placements_fisher := compute_fisher_quantity(
    .SD,
    qty_cols = c("placements_single", "placements_double"),
    price_cols = c("avg_sales_price_single", "avg_sales_price_double")
)]

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
saveRDS(dt_nat, here("derived", "sample.Rds"))

print_panel_summary(dt_nat, "Saved national-year panel")
