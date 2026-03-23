# Plot national trends in output per employee:
# for various construction output measures

rm(list = ls())
library(here)
library(data.table)
library(ggplot2)

v_palette <- c("#0072B2", "#D55E00", "#009E73", "#F0E442")
v_shapes <- c(16, 17, 15, 18)
v_lines <- c("solid", "dashed", "dotted", "twodash")

theme_paper <- function(base_size = 14) {
    theme_classic(base_size = base_size) +
        theme(
            text = element_text(family = "serif"),
            legend.position = "bottom",
            panel.grid.major.y = element_line(color = "gray90"),
            panel.grid.minor = element_blank()
        )
}

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
nberces_shapes <- setNames(v_shapes, names(nberces_series_labels))
nberces_lines <- setNames(v_lines, names(nberces_series_labels))

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
    aes(x = year, y = output_pemp, color = series, shape = series)
) +
    geom_line(linewidth = 0.5, linetype = "dashed") +
    geom_point(size = 2) +
    geom_hline(yintercept = 0, linetype = "dashed", color = "gray") +
    scale_color_manual(
        values = setNames(v_palette[seq_along(series_labels)], names(series_labels)),
        breaks = names(series_labels),
        labels = unname(series_labels)
    ) +
    scale_shape_manual(
        values = setNames(v_shapes[seq_along(series_labels)], names(series_labels)),
        breaks = names(series_labels),
        labels = unname(series_labels)
    ) +
    labs(
        x = NULL,
        y = "Units per employee",
        color = NULL,
        shape = NULL
    ) +
    theme_paper()

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
    x = year, y = real_vadd_pemp, color = series, shape = series, linetype = series
)) +
    geom_line(linewidth = 0.7) +
    geom_point(size = 2) +
    scale_color_manual(
        values = nberces_colors,
        breaks = names(nberces_series_labels),
        labels = unname(nberces_series_labels)
    ) +
    scale_shape_manual(
        values = nberces_shapes,
        breaks = names(nberces_series_labels),
        labels = unname(nberces_series_labels)
    ) +
    scale_linetype_manual(
        values = nberces_lines,
        breaks = names(nberces_series_labels),
        labels = unname(nberces_series_labels)
    ) +
    labs(
        x = NULL,
        y = "Real value added per employee (1997$, thousands)",
        color = NULL
    ) +
    theme_paper()

ggsave(
    here("output", "va_pemp.pdf"),
    p_va_pemp,
    width = 9,
    height = 5
)

# Plot 3: TFP index (NBER-CES) ----
dt_tfp <- dt_nberces_ind[!is.na(tfp4_nberces)]

p_tfp <- ggplot(dt_tfp, aes(
    x = year, y = tfp4_nberces, color = series, shape = series, linetype = series
)) +
    geom_line(linewidth = 0.7) +
    geom_point(size = 2) +
    scale_color_manual(
        values = nberces_colors,
        breaks = names(nberces_series_labels),
        labels = unname(nberces_series_labels)
    ) +
    scale_shape_manual(
        values = nberces_shapes,
        breaks = names(nberces_series_labels),
        labels = unname(nberces_series_labels)
    ) +
    scale_linetype_manual(
        values = nberces_lines,
        breaks = names(nberces_series_labels),
        labels = unname(nberces_series_labels)
    ) +
    labs(
        x = NULL,
        y = "TFP index (1997 = 1.0)",
        color = NULL
    ) +
    theme_paper()

ggsave(
    here("output", "tfp.pdf"),
    p_tfp,
    width = 9,
    height = 5
)