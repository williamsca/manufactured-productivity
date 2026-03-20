# This script imports the County Business Patterns (CBP) data from the
# US Census Bureau, provided by Fabian Eckert:
# https://www.fpeckert.me/cbp/

# These data have been harmonized to 2012 NAICS codes and missing values
# have been imputed according to a linear programming approach.

rm(list = ls())
library(here)
library(data.table)

data_path <- Sys.getenv("DATA_PATH")

# import ----

# * historical (1946-1974)
# (can't identify MH manufacturing employment before 1972)

# * intermediate (1975-2018)
file_path <- file.path(
  data_path, "data", "census-cbp", "1975-2018", "efsy_panel_naics.csv.zip")

tmp_dir <- tempfile(pattern = "cbp_")
dir.create(tmp_dir)

unzipped_file <- unzip(file_path, exdir = tmp_dir)

dt <- fread(unzipped_file)

# clean ----
setnames(dt,
  old = c("fipstate", "fipscty"),
  new = c("statefp", "countyfp"))

setkey(dt, countyfp, year, naics12)

# export ----
fwrite(dt, here("derived", "census-cbp.csv"))

