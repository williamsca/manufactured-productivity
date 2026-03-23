# Plot national trends in output per employee:
# for various construction output measures

rm(list = ls())
library(here)
library(data.table)
library(ggplot2)

v_palette <- c("#0072B2", "#D55E00", "#009E73", "#F0E460")

# import ----
dt_nat <- as.data.table(readRDS(here("derived", "sample.Rds")))
dt_nberces_ind <- as.data.table(readRDS(here("derived", "nberces-industries.Rds")))
series_labels <- c(
    place_pemp_mh_nberces = "MH placements / L",
    # placements_fisher_pemp = "MH placements / L (Fisher)",
    place_fisher_pemp_mh_nberces = "MH placements / L (Fisher)",
    # permits_pemp = "Residential permits / L",
    ship_pemp_mh_nberces = "MH shipments / L"
)
nberces_series_labels <- c(
    mh = "Manufactured homes",
    prefab_wood_bldg = "Prefabricated wood buildings",
    truck_trailers = "Truck trailers",
    wood_kitchen_cabinets = "Wood kitchen cabinets"
)
nberces_colors <- c(
    mh = v_palette[1],
    prefab_wood_bldg = v_palette[2],
    truck_trailers = v_palette[3],
    wood_kitchen_cabinets = "#CC79A7"
)

# Reshape to long for ggplot ----
v_emp <- grep("_pemp", names(dt_nat), value = TRUE)

dt_long <- melt(
    dt_nat[, c("year", v_emp), with = FALSE],
    id.vars = "year",
    variable.name = "series",
    value.name = "output_pemp"
)

# Plot 1: output per employee ----
p_output_pemp <- ggplot(
    dt_long[!is.na(output_pemp) & series %in% names(series_labels)],
    aes(x = year, y = output_pemp, color = series)
) +
    geom_point(size = 2) +
    geom_line(linewidth = 0.5, linetype = "dashed") +
    geom_hline(yintercept = 0, linetype = "dashed", color = "grey50") +
    # geom_vline(xintercept = 1976, linetype = "dashed", color = "grey50") +
    scale_color_manual(
        values = setNames(v_palette[seq_along(series_labels)], names(series_labels)),
        breaks = names(series_labels),
        labels = unname(series_labels)
    ) +
    labs(
        x = NULL,
        y = "Units per employee",
        color = NULL
    ) +
    theme_classic() +
    theme(legend.position = "bottom")

p_output_pemp

ggsave(
    here("output", "output_pemp.pdf"),
    p_output_pemp,
    width = 9,
    height = 5
)

# Plot 2: Real value added per employee (NBER-CES) ----
dt_va <- dt_nberces_ind[!is.na(vadd_nberces / piship_nberces / emp_nberces)]
dt_va[, real_vadd_pemp := vadd_nberces / piship_nberces / emp_nberces]

p_va_pemp <- ggplot(dt_va, aes(
    x = year, y = real_vadd_pemp, color = series
)) +
    geom_point(size = 1.6) +
    geom_line(
        linewidth = 0.5, linetype = "dashed"
    ) +
    scale_color_manual(
        values = nberces_colors,
        breaks = names(nberces_series_labels),
        labels = unname(nberces_series_labels)
    ) +
    labs(
        x = NULL,
        y = "Real value added per employee (1997$, thousands)",
        color = NULL
    ) +
    theme_classic() +
    theme(legend.position = "bottom")

ggsave(
    here("output", "va_pemp.pdf"),
    p_va_pemp,
    width = 9,
    height = 5
)

# Plot 3: TFP index (NBER-CES) ----
dt_tfp <- dt_nberces_ind[!is.na(tfp4_nberces)]

p_tfp <- ggplot(dt_tfp, aes(x = year, y = tfp4_nberces, color = series)) +
    geom_point(size = 1.6) +
    geom_line(
        linewidth = 0.5, linetype = "dashed"
    ) +
    scale_color_manual(
        values = nberces_colors,
        breaks = names(nberces_series_labels),
        labels = unname(nberces_series_labels)
    ) +
    labs(
        x = NULL,
        y = "TFP index (1997 = 1.0)",
        color = NULL
    ) +
    theme_classic() +
    theme(legend.position = "bottom")

ggsave(
    here("output", "tfp.pdf"),
    p_tfp,
    width = 9,
    height = 5
)
