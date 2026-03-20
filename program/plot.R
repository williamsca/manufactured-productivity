# Plot national trends in output per employee:
#   (1) MH shipments per MH manufacturing employee
#   (2) SF permits per SF residential construction employee
#   (3) MF permits per MF residential construction employee
#
# All series indexed to 1 in a common base year for comparison.

rm(list = ls())
library(here)
library(data.table)
library(ggplot2)

BASE_YEAR <- 1998  # first year all three employment series overlap

# Import ----
dt <- readRDS(here("derived", "sample.Rds"))

# Aggregate to national ----
dt_nat <- dt[, .(
    shipments      = sum(shipments,      na.rm = TRUE),
    permits_sf     = sum(permits_sf,     na.rm = TRUE),
    permits_mf     = sum(permits_mf,     na.rm = TRUE),
    emp_mh         = sum(emp_mh,         na.rm = TRUE),
    emp_sf_total   = sum(emp_sf_total,   na.rm = TRUE),
    emp_recon_mf   = sum(emp_recon_mf,   na.rm = TRUE),
    emp_recon_total = sum(emp_recon_total, na.rm = TRUE)
), by = year]

dt_nat[emp_mh       == 0L, emp_mh       := NA_integer_]
dt_nat[emp_sf_total == 0L, emp_sf_total := NA_integer_]
dt_nat[emp_recon_mf == 0L, emp_recon_mf := NA_integer_]

dt_nat[, ship_per_mh_emp  := shipments  / emp_mh]
dt_nat[, sf_per_recon_emp := permits_sf / emp_sf_total]
dt_nat[, mf_per_recon_emp := permits_mf / emp_recon_mf]

# Index to base year ----
index_to <- function(x, years, base) {
    base_val <- x[years == base]
    if (length(base_val) == 0 || is.na(base_val)) return(rep(NA_real_, length(x)))
    x / base_val
}

dt_nat[, ship_idx := index_to(ship_per_mh_emp,  year, BASE_YEAR)]
dt_nat[, sf_idx   := index_to(sf_per_recon_emp, year, BASE_YEAR)]
dt_nat[, mf_idx   := index_to(mf_per_recon_emp, year, BASE_YEAR)]

# Reshape to long for ggplot ----
dt_long <- melt(
    dt_nat[, .(year, ship_idx, sf_idx, mf_idx)],
    id.vars = "year", variable.name = "series", value.name = "index"
)

series_labels <- c(
    ship_idx = "MH: shipments / MH emp",
    sf_idx   = "Site-built SF: permits / SF emp",
    mf_idx   = "Site-built MF: permits / MF emp"
)
dt_long[, series := factor(series, levels = names(series_labels),
                            labels = series_labels)]

v_palette <- c("#0072B2", "#D55E00", "#009E73")

# Plot 1: Indexed output per employee ----
p_index <- ggplot(dt_long[!is.na(index)],
                  aes(x = year, y = index, color = series)) +
    geom_line(linewidth = 1) +
    geom_hline(yintercept = 1, linetype = "dashed", color = "grey50") +
    scale_color_manual(values = v_palette) +
    labs(
        title = paste0("Output per employee (", BASE_YEAR, " = 1)"),
        x = NULL, y = NULL, color = NULL
    ) +
    theme_classic() +
    theme(legend.position = "bottom")

ggsave(here("output", "fig_productivity_index.pdf"),
       p_index, width = 9, height = 5)

# Plot 2: Raw ratios in levels ----
dt_levels <- melt(
    dt_nat[, .(year, ship_per_mh_emp, sf_per_recon_emp, mf_per_recon_emp)],
    id.vars = "year", variable.name = "series", value.name = "ratio"
)
levels_labels <- c(
    ship_per_mh_emp  = "MH shipments / MH emp",
    sf_per_recon_emp = "SF permits / SF emp",
    mf_per_recon_emp = "MF permits / MF emp"
)
dt_levels[, series := factor(series, levels = names(levels_labels),
                              labels = levels_labels)]

p_levels <- ggplot(dt_levels[!is.na(ratio)],
                   aes(x = year, y = ratio, color = series)) +
    geom_line(linewidth = 1) +
    scale_color_manual(values = v_palette) +
    facet_wrap(~series, scales = "free_y", ncol = 1) +
    labs(x = NULL, y = "Units per employee", color = NULL) +
    theme_classic() +
    theme(legend.position = "none")

ggsave(here("output", "fig_productivity_levels.pdf"),
       p_levels, width = 7, height = 9)

message("Saved figures to output/")
