# Plot national trends in output per employee:
# for various construction output measures

rm(list = ls())
library(here)
library(data.table)
library(ggplot2)

v_palette <- c("#0072B2", "#D55E00", "#009E73", "#F0E460")

# import ----
dt_nat <- as.data.table(readRDS(here("derived", "sample.Rds")))
series_labels <- c(
    ship_pemp_mh = "MH shipments / L",
    place_pemp_mh = "MH placements / L",
    placements_fisher_pemp = "MH placements / L (Fisher)",
    permits_pemp = "Residential permits / L",
    ship_pemp_mh_nberces = "MH shipments / L (NBER-CES)"
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
    scale_color_manual(
        values = setNames(v_palette[seq_along(series_labels)], names(series_labels)),
        breaks = names(series_labels),
        labels = unname(series_labels)
    ) +
    labs(
        title = paste0("Output per employee"),
        x = NULL,
        y = NULL,
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
dt_va <- dt_nat[!is.na(real_vadd_pemp)]

p_va_pemp <- ggplot(dt_va, aes(x = year, y = real_vadd_pemp)) +
    geom_point(size = 2, color = v_palette[1]) +
    geom_line(
        linewidth = 0.5, linetype = "dashed", color = v_palette[1]
    ) +
    labs(
        title = "Real value added per employee (1997$, thousands)",
        subtitle = "NAICS 321991, NBER-CES Manufacturing Database",
        x = NULL,
        y = NULL
    ) +
    theme_classic()

ggsave(
    here("output", "va_pemp.pdf"),
    p_va_pemp,
    width = 9,
    height = 5
)

# Plot 3: TFP index (NBER-CES) ----
dt_tfp <- dt_nat[!is.na(tfp4_nberces)]

p_tfp <- ggplot(dt_tfp, aes(x = year, y = tfp4_nberces)) +
    geom_point(size = 2, color = v_palette[1]) +
    geom_line(
        linewidth = 0.5, linetype = "dashed", color = v_palette[1]
    ) +
    labs(
        title = "Total factor productivity index",
        subtitle = "NAICS 321991, NBER-CES Manufacturing Database",
        x = NULL,
        y = NULL
    ) +
    theme_classic()

ggsave(
    here("output", "tfp.pdf"),
    p_tfp,
    width = 9,
    height = 5
)
