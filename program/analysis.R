# This script computes various measures of productivity
# for the manufactured housing industry.

rm(list = ls())
library(here)
library(data.table)
library(ggplot2)
library(fixest)

v_palette <- c("#0072B2", "#D55E00", "#009E73", "#F0E460")

# Import ----
dt <- readRDS(here("derived", "sample.Rds"))

# Analysis ----
# value-added per employee
ggplot(dt, aes(x = year, y = valadd_pemp)) +
    geom_line(linewidth = 2, color = v_palette[1]) +
    labs(
        title = "",
        x = "",
        y = "Value-Added per Employee"
    ) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    theme_classic()

# shipments per employee
ggplot(dt, aes(x = year, y = ship_pemp)) +
    geom_line(linewidth = 2, color = v_palette[1]) +
    labs(
        title = "",
        x = "",
        y = "Shipments per Employee"
    ) +
    geom_hline(yintercept = 0, linetype = "dashed") +
    theme_classic()
