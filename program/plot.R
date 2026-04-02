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

theme_web <- function(base_size = 14) {
    theme_classic(base_size = base_size) +
        theme(
            text = element_text(family = "Palatino"),
            legend.position = "bottom",
            panel.grid.major.y = element_line(color = "gray90"),
            panel.grid.minor = element_blank(),
            plot.background = element_rect(fill = "#fffff8", color = NA),
            panel.background = element_rect(fill = "#fffff8", color = NA)
        )
}

# import ----
dt_nat <- as.data.table(readRDS(here("derived", "sample.Rds")))


(dt_nat[year == 2018, avg_sales_price] - dt_nat[year == 1990, avg_sales_price]) / dt_nat[year == 1990, avg_sales_price]

dt_nat[year == 1997, tfp4_nberces] - dt_nat[year == 2015, tfp4_nberces]

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
nberces_va_labels <- c(
    mh = "Manufactured homes",
    other_321 = "Other 321 industries",
    other_manufacturing = "All other manufacturing"
)
nberces_tfp_labels <- c(
    mh = "Manufactured homes",
    other_321 = "Other 321 industries",
    other_manufacturing = "All other manufacturing"
)
mh_capital_labels <- c(
    invest_nberces = "Investment",
    cap_nberces = "Capital stock"
)
nberces_colors <- c(
    mh = v_palette[1],
    prefab_wood_bldg = v_palette[2],
    truck_trailers = v_palette[3],
    wood_kitchen_cabinets = "#CC79A7",
    other_321 = "#D55E00",
    other_32 = "#009E73",
    other_manufacturing = "#595959"
)
nberces_shapes <- setNames(v_shapes, names(nberces_series_labels))
nberces_lines <- setNames(v_lines, names(nberces_series_labels))
nberces_agg_shapes <- c(
    mh = 16,
    other_321 = 17,
    other_manufacturing = 18
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
ggsave(
    here("output", "output_pemp.png"),
    p_output_pemp + theme_web(),
    width = 6, height = 4, dpi = 150, bg = "#fffff8"
)

# Plot 2: Real value added per employee (NBER-CES) ----
dt_va <- dt_nberces_ind[
    !is.na(real_vadd_pemp_nberces) & series %in% names(nberces_va_labels)
]

p_va_pemp <- ggplot(dt_va, aes(
    x = year, y = real_vadd_pemp_nberces, color = series, shape = series
)) +
    geom_line(linewidth = 0.5, linetype = "dashed") +
    geom_point(size = 2) +
    scale_color_manual(
        values = nberces_colors,
        breaks = names(nberces_va_labels),
        labels = unname(nberces_va_labels)
    ) +
    scale_shape_manual(
        values = nberces_agg_shapes,
        breaks = names(nberces_va_labels),
        labels = unname(nberces_va_labels)
    ) +
    labs(
        x = NULL,
        y = "Real value added per employee (1997$, thousands)",
        color = NULL,
        shape = NULL
    ) +
    theme_paper()

ggsave(
    here("output", "va_pemp.pdf"),
    p_va_pemp,
    width = 9,
    height = 5
)
ggsave(
    here("output", "va_pemp.png"),
    p_va_pemp + theme_web(),
    width = 6, height = 4, dpi = 150, bg = "#fffff8"
)

# Plot 3: MH investment and capital stock (NBER-CES) ----
dt_mh_capital <- melt(
    dt_nat[, .(year, invest_nberces, cap_nberces)],
    id.vars = "year",
    variable.name = "series",
    value.name = "value"
)[!is.na(value)]

p_mh_capital <- ggplot(dt_mh_capital, aes(
    x = year, y = value, color = series, shape = series
)) +
    geom_line(linewidth = 0.5, linetype = "dashed") +
    geom_point(size = 2) +
    scale_color_manual(
        values = setNames(v_palette[seq_along(mh_capital_labels)], names(mh_capital_labels)),
        breaks = names(mh_capital_labels),
        labels = unname(mh_capital_labels)
    ) +
    scale_shape_manual(
        values = setNames(v_shapes[seq_along(mh_capital_labels)], names(mh_capital_labels)),
        breaks = names(mh_capital_labels),
        labels = unname(mh_capital_labels)
    ) +
    labs(
        x = NULL,
        y = "Millions of current dollars",
        color = NULL,
        shape = NULL
    ) +
    theme_paper()

ggsave(
    here("output", "mh_capital.pdf"),
    p_mh_capital,
    width = 9,
    height = 5
)
ggsave(
    here("output", "mh_capital.png"),
    p_mh_capital + theme_web(),
    width = 6, height = 4, dpi = 150, bg = "#fffff8"
)

# Plot 4: TFP index (NBER-CES) ----
dt_tfp <- dt_nberces_ind[
    !is.na(tfp4_nberces) & series %in% names(nberces_tfp_labels)
]

p_tfp <- ggplot(dt_tfp, aes(
    x = year, y = tfp4_nberces, color = series, shape = series
)) +
    geom_line(linewidth = 0.5, linetype = "dashed") +
    geom_point(size = 2) +
    scale_color_manual(
        values = nberces_colors,
        breaks = names(nberces_tfp_labels),
        labels = unname(nberces_tfp_labels)
    ) +
    scale_shape_manual(
        values = nberces_agg_shapes,
        breaks = names(nberces_tfp_labels),
        labels = unname(nberces_tfp_labels)
    ) +
    labs(
        x = NULL,
        y = "TFP index (1997 = 1.0)",
        color = NULL,
        shape = NULL
    ) +
    theme_paper()

ggsave(
    here("output", "tfp.pdf"),
    p_tfp,
    width = 9,
    height = 5
)
ggsave(
    here("output", "tfp.png"),
    p_tfp + theme_web(),
    width = 6, height = 4, dpi = 150, bg = "#fffff8"
)

# Plot 5: Share of double-wide units in shipments and placements ----
double_wide_labels <- c(
    share_double_ship  = "Shipments",
    share_double_place = "Placements"
)

dt_double <- dt_nat[
    !is.na(shipments_double) | !is.na(placements_double),
    .(
        year,
        share_double_ship  = shipments_double / shipments,
        share_double_place = placements_double / placements
    )
]

dt_double_long <- melt(
    dt_double,
    id.vars = "year",
    variable.name = "series",
    value.name = "share"
)[!is.na(share)]

p_double_wide <- ggplot(
    dt_double_long[series %in% names(double_wide_labels)],
    aes(x = year, y = share, color = series, shape = series)
) +
    geom_line(linewidth = 0.5, linetype = "dashed") +
    geom_point(size = 2) +
    scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
    scale_color_manual(
        values = setNames(v_palette[seq_along(double_wide_labels)], names(double_wide_labels)),
        breaks = names(double_wide_labels),
        labels = unname(double_wide_labels)
    ) +
    scale_shape_manual(
        values = setNames(v_shapes[seq_along(double_wide_labels)], names(double_wide_labels)),
        breaks = names(double_wide_labels),
        labels = unname(double_wide_labels)
    ) +
    labs(
        x = NULL,
        y = "Share double-wide",
        color = NULL,
        shape = NULL
    ) +
    theme_paper()

ggsave(
    here("output", "double_wide_share.pdf"),
    p_double_wide,
    width = 9,
    height = 5
)
ggsave(
    here("output", "double_wide_share.png"),
    p_double_wide + theme_web(),
    width = 6, height = 4, dpi = 150, bg = "#fffff8"
)
