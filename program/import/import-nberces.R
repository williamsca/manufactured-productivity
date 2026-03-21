# This script imports the NBER-CES Manufacturing Industry Database
# (version 2021a, 1958-2018) for NAICS 321991 (Manufactured Home Mfg).
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
dt_mh <- dt[naics == 321991]

stopifnot(nrow(dt_mh) > 0L)

# Keep relevant columns and rename for clarity
dt_mh <- dt_mh[, .(
    year,
    emp_nberces   = emp,        # thousands
    vadd_nberces  = vadd,       # millions, nominal
    vship_nberces = vship,      # millions, nominal
    matcost_nberces = matcost,  # millions, nominal
    piship_nberces = piship,    # shipments deflator (1997=1)
    pimat_nberces  = pimat,     # materials deflator (1997=1)
    tfp4_nberces   = tfp4,
    tfp5_nberces   = tfp5
)]

message(
    "NBER-CES MH data: ", nrow(dt_mh), " rows, ",
    min(dt_mh$year), "-", max(dt_mh$year)
)

saveRDS(dt_mh, here("derived", "nberces-mh.Rds"))
