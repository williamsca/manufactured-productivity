# This script imports the NBER-CES Manufacturing Industry Database
# (version 2021a, 1958-2018) for manufactured housing and selected
# comparison industries.
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
    tfp4_nberces = tfp4,
    tfp5_nberces = tfp5
)]

dt_mh <- dt_industries[series == "mh"][, !c("naics", "series", "industry_label")]

message(
    "NBER-CES selected industries: ", uniqueN(dt_industries$naics),
    " industries, ", min(dt_industries$year), "-", max(dt_industries$year)
)

saveRDS(dt_industries, here("derived", "nberces-industries.Rds"))
saveRDS(dt_mh, here("derived", "nberces-mh.Rds"))
