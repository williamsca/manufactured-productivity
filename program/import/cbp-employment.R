# Import MH employment from Census County Business Patterns API
#
# Task 1(b): Extend MH employment backward using:
#   - SIC 2451 (Mobile Homes) for 1986-1997
#   - NAICS 321991 (Manufactured Home Manufacturing) for 1998+
#
# The CBP API uses different NAICS vintage variable names by year:
#   1986-1997: SIC=2451
#   1998-2002: NAICS1997=321991
#   2003-2007: NAICS2002=321991
#   2008-2011: NAICS2007=321991
#   2012-2016: NAICS2012=321991
#   2017+:     NAICS2017=321991

rm(list = ls())
library(here)
library(data.table)
library(httr2)

# Read Census API key from .Renviron
readRenviron(here(".Renviron"))
key <- Sys.getenv("CENSUS_KEY")

# Helper: pull one year from CBP API ----
pull_cbp <- function(year, key) {
    base_url <- paste0("https://api.census.gov/data/", year, "/cbp")

    # Determine industry filter based on year
    if (year <= 1997) {
        industry_param <- list(SIC = "2451")
        system <- "SIC"
    } else if (year <= 2002) {
        industry_param <- list(NAICS1997 = "321991")
        system <- "NAICS1997"
    } else if (year <= 2007) {
        industry_param <- list(NAICS2002 = "321991")
        system <- "NAICS2002"
    } else if (year <= 2011) {
        industry_param <- list(NAICS2007 = "321991")
        system <- "NAICS2007"
    } else if (year <= 2016) {
        industry_param <- list(NAICS2012 = "321991")
        system <- "NAICS2012"
    } else {
        industry_param <- list(NAICS2017 = "321991")
        system <- "NAICS2017"
    }

    query <- c(
        list(get = "EMP,ESTAB,PAYANN", `for` = "us:*", key = key),
        industry_param
    )

    req <- request(base_url) |> req_url_query(!!!query)

    resp <- tryCatch(
        req_perform(req),
        error = function(e) {
            message("Error for year ", year, ": ", conditionMessage(e))
            return(NULL)
        }
    )

    if (is.null(resp) || resp_status(resp) != 200) {
        message("Failed for year ", year, " (status ", resp_status(resp), ")")
        return(NULL)
    }

    raw <- resp_body_json(resp, simplifyVector = TRUE)
    dt <- as.data.table(raw[-1, , drop = FALSE])
    setnames(dt, raw[1, ])

    dt[, year := year]
    dt[, industry_system := system]
    dt[, EMP := as.integer(EMP)]
    dt[, ESTAB := as.integer(ESTAB)]
    dt[, PAYANN := as.numeric(PAYANN)]  # annual payroll in $1,000

    return(dt)
}

# Pull all years ----
years_sic   <- 1986:1997   # SIC 2451
years_naics <- 1998:2022   # NAICS 321991 (various vintages)
all_years   <- c(years_sic, years_naics)

message("Pulling CBP data for ", length(all_years), " years...")
results <- lapply(all_years, function(yr) {
    message("  ", yr, "...")
    Sys.sleep(0.2)  # be polite to the API
    pull_cbp(yr, key)
})

dt_cbp <- rbindlist(results, fill = TRUE)

# Keep only total employment rows (suppress size-class breakdowns)
# CBP returns total-employment row when EMPSZES is absent (national query)
dt_cbp <- dt_cbp[, .(year, emp_cbp = EMP, estab_cbp = ESTAB,
                       payann_cbp = PAYANN, industry_system)]

# Note: CBP employment is March 12 pay-period employment (comparable to QCEW)
# PAYANN is in $1,000; convert to dollars
dt_cbp[, payann_cbp := payann_cbp * 1000]

setorder(dt_cbp, year)

message("Years covered: ", min(dt_cbp$year), "-", max(dt_cbp$year))
message("Rows: ", nrow(dt_cbp))
print(dt_cbp)

# Export ----
saveRDS(dt_cbp, here("derived", "cbp_emp.Rds"))
message("Saved to derived/cbp_emp.Rds")
