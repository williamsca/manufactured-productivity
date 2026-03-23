# This script imports the NBER-CES Manufacturing Industry Database
# (version 2021a, 1958-2018) for manufactured housing, selected
# comparison industries, and aggregate manufacturing benchmarks.
#
# Source: nber.org/research/data/nber-ces-manufacturing-industry-database
# Data:   data.nber.org/nberces/nberces5818v1/
#
# Key variables (all in millions of nominal dollars unless noted):
#   emp    - total employment (thousands)
#   vadd   - value added
#   vship  - value of shipments
#   matcost- materials cost
#   piship - shipments price deflator (1997 = 1.0)
#   pimat  - materials price deflator (1997 = 1.0)
#   tfp4   - 4-factor TFP index
#   tfp5   - 5-factor TFP index

library(here)
library(data.table)

csv_path <- here("data", "nber-ces", "nberces5818v1_n1997.csv")

if (!file.exists(csv_path)) {
    dir.create(dirname(csv_path), showWarnings = FALSE, recursive = TRUE)
    url <- "https://data.nber.org/nberces/nberces5818v1/nberces5818v1_n1997.csv"
    message("Downloading NBER-CES data from ", url)
    download.file(url, csv_path, mode = "wb")
}

dt <- fread(csv_path)
setorder(dt, naics, year)

industry_map <- data.table(
    naics = c(321991L, 321992L, 336212L, 337110L),
    series = c(
        "mh",
        "prefab_wood_bldg",
        "truck_trailers",
        "wood_kitchen_cabinets"
    ),
    industry_label = c(
        "Manufactured homes",
        "Prefabricated wood buildings",
        "Truck trailers",
        "Wood kitchen cabinets"
    )
)

dt_industries <- dt[naics %in% industry_map$naics]
stopifnot(nrow(dt_industries) > 0L)

dt_industries <- merge(
    dt_industries,
    industry_map,
    by = "naics",
    all.x = TRUE
)

# Keep relevant columns and rename for clarity
dt_industries <- dt_industries[, .(
    naics,
    series,
    industry_label,
    year,
    emp_nberces = emp,        # thousands
    vadd_nberces = vadd,      # millions, nominal
    vship_nberces = vship,    # millions, nominal
    matcost_nberces = matcost,# millions, nominal
    piship_nberces = piship,  # shipments deflator (1997=1)
    pimat_nberces = pimat,    # materials deflator (1997=1)
    real_vadd_pemp_nberces = (vadd / piship) / emp,
    tfp4_nberces = tfp4,
    tfp5_nberces = tfp5
)]

dt_mh <- dt_industries[series == "mh"][, !c("naics", "series", "industry_label")]

# Aggregate comparison groups. For TFP, NBER-CES supplies annual
# productivity growth (dtfp4), so the natural aggregate is a weighted
# average of growth rates, not a weighted average of index levels.
dt[, `:=`(
    vship_lag = shift(vship),
    vadd_lag = shift(vadd)
), by = naics]

aggregate_specs <- list(
    list(
        series = "other_321",
        industry_label = "Other 321 industries",
        subset = dt$naics != 321991L & substr(sprintf("%06d", dt$naics), 1L, 3L) == "321"
    ),
    list(
        series = "other_32",
        industry_label = "Other 32 industries",
        subset = dt$naics != 321991L & substr(sprintf("%06d", dt$naics), 1L, 2L) == "32"
    ),
    list(
        series = "other_manufacturing",
        industry_label = "All other manufacturing",
        subset = dt$naics != 321991L
    )
)

build_aggregate_series <- function(subset_idx, series_id, label) {
    dt_tfp_agg <- dt[
        subset_idx & !is.na(dtfp4) & !is.na(vship_lag) & !is.na(vadd_lag),
        {
            total_vadd_lag <- sum(vadd_lag, na.rm = TRUE)
            .(
                dtfp4_nberces = sum((vship_lag / total_vadd_lag) * dtfp4, na.rm = TRUE)
            )
        },
        by = year
    ][order(year)]

    dt_va_agg <- dt[
        subset_idx & !is.na(vadd) & !is.na(piship) & !is.na(emp),
        .(
            real_vadd_pemp_nberces =
                sum(vadd / piship, na.rm = TRUE) / sum(emp, na.rm = TRUE)
        ),
        by = year
    ]

    dt_agg <- merge(dt_tfp_agg, dt_va_agg, by = "year", all = TRUE)

    base_year <- 1997L
    dt_agg[, log_tfp4_nberces := NA_real_]
    dt_agg[year == base_year, log_tfp4_nberces := 0]

    for (y in dt_agg[year > base_year, year]) {
        dt_agg[year == y, log_tfp4_nberces :=
            dt_agg[year == y - 1L, log_tfp4_nberces] +
            dt_agg[year == y, dtfp4_nberces]]
    }

    for (y in rev(dt_agg[year < base_year, year])) {
        dt_agg[year == y, log_tfp4_nberces :=
            dt_agg[year == y + 1L, log_tfp4_nberces] -
            dt_agg[year == y + 1L, dtfp4_nberces]]
    }

    dt_agg[, `:=`(
        naics = NA_integer_,
        series = series_id,
        industry_label = label,
        tfp4_nberces = exp(log_tfp4_nberces)
    )]

    dt_agg[, .(
        naics,
        series,
        industry_label,
        year,
        emp_nberces = NA_real_,
        vadd_nberces = NA_real_,
        vship_nberces = NA_real_,
        matcost_nberces = NA_real_,
        piship_nberces = NA_real_,
        pimat_nberces = NA_real_,
        real_vadd_pemp_nberces,
        tfp4_nberces,
        tfp5_nberces = NA_real_
    )]
}

dt_aggregates <- rbindlist(lapply(
    aggregate_specs,
    function(spec) build_aggregate_series(spec$subset, spec$series, spec$industry_label)
), use.names = TRUE)

dt_industries <- rbindlist(list(dt_industries, dt_aggregates), use.names = TRUE)

message(
    "NBER-CES selected industries plus aggregate benchmark: ",
    uniqueN(dt_industries$series),
    " series, ", min(dt_industries$year), "-", max(dt_industries$year)
)

saveRDS(dt_industries, here("derived", "nberces-industries.Rds"))
saveRDS(dt_mh, here("derived", "nberces-mh.Rds"))
