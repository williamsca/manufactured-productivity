# Plot national trends in output per employee:
# for various construction output measures

rm(list = ls())
library(here)
library(data.table)
library(ggplot2)

v_palette <- c("#0072B2", "#D55E00", "#009E73", "#F0E460")

index_to <- function(x, years, base) {
    base_val <- x[years == base]
    if (length(base_val) == 0 || is.na(base_val)) {
        return(rep(NA_real_, length(x)))
    }
    x / base_val
}

# import ----
dt_nat <- as.data.table(readRDS(here("derived", "sample.Rds")))

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
    dt_long[!is.na(output_pemp)],
    aes(x = year, y = output_pemp, color = series)
) +
    geom_line(linewidth = 1) +
    geom_hline(yintercept = 1, linetype = "dashed", color = "grey50") +
    scale_color_manual(values = v_palette) +
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
    p_index,
    width = 9,
    height = 5
)