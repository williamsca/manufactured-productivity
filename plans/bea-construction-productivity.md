# Plan: Replicate Goolsbee & Syverson Figure 1 from BEA Data

## Goal

Construct annual labor productivity (real VA / FTE) and TFP index series
for the construction sector (NAICS 23) using BEA national and industry
accounts data, replicating the methodology in Goolsbee & Syverson (2023)
Figure 1. Add these series to the existing plots so MH (NBER-CES) and
site-built construction (BEA) appear side by side.

## G&S Methodology (from their Figure 1 note)

- **Labor productivity** = real value added / FTE employees
- **TFP growth** = growth in VA minus Divisia-weighted growth in labor
  and capital
  - Weights = cost shares averaged across current and prior year
  - Labor cost = compensation + 0.67 * proprietor's income
  - Capital cost = depreciation + (real interest rate * current-cost net
    capital stock) + 0.33 * proprietor's income
- **TFP index** = cumulated from growth rates; normalize 1997 = 1.0 to
  match NBER-CES base year

## Data Sources (all via BEA API + FRED)

| Variable | Dataset | Table | Industry / Line | Years |
|----------|---------|-------|-----------------|-------|
| Real value added | GDPbyIndustry | TableID 10 | Industry `23` | 1997-- |
| Nominal value added | GDPbyIndustry | TableID 1 | Industry `23` | 1997-- |
| FTE employees | NIPA | T60500B/C/D | Line 12 (construction) | 1948-- |
| Compensation | NIPA | T60200B/C/D | Line 12 | 1948-- |
| Proprietor's income | NIPA | T61200B/C/D | Construction line | 1948-- |
| Depreciation | FixedAssets | FAAt304ESI | Line 10 | 1947-- |
| Net capital stock | FixedAssets | FAAt301ESI | Line 10 | 1947-- |
| 10-yr Treasury rate | FRED | GS10 | -- | 1953-- |
| GDP deflator | FRED | GDPDEF | -- | 1947-- |

**Historical coverage note.** GDPbyIndustry (NAICS-based) starts ~1997.
For earlier years, BEA publishes historical GDP-by-industry tables back
to 1947 via `UnderlyingGDPbyIndustry` or the interactive iTable. The
NIPA Section 6 tables use B (1948-1987, SIC), C (1987-2000, bridge), and
D (1998-present, NAICS) suffixes. The B/C/D tables overlap, so splice at
the overlap years.

For value added pre-1997, options:
1. Use FRED series `RVAC` (real VA, construction) which goes back to
   1947 as a single spliced series.
2. Pull `UnderlyingGDPbyIndustry` tables from BEA API.
3. Download the historical GDP-by-industry CSV directly from BEA.

Option 1 (FRED) is simplest and most robust for the construction
aggregate. Use the `fredr` R package.

## Scripts to Write

All scripts go in `program/databuild-bea/`.

### 1. `import-bea-gdpbyindustry.R`

- Use `httr` + BEA API key from `.Renviron` (or `bea.R` package if
  installed)
- Pull GDPbyIndustry TableID 1 (nominal VA) and 10 (real VA) for
  Industry = `23` and `ALL` (total private industries), all years
- Also pull the GDP price index (TableID 11) for construction
- Save to `derived/bea-gdpbyindustry.Rds`

### 2. `import-bea-nipa.R`

- Pull NIPA tables:
  - T60500D (FTE employees, 1998+)
  - T60500C (FTE, 1987-2000)
  - T60500B (FTE, 1948-1987)
  - T60200B/C/D (compensation)
  - T61200B/C/D (proprietor's income)
- Extract construction lines from each table
- Splice B/C/D series at overlap years (prefer D > C > B where they
  overlap)
- Save to `derived/bea-nipa-construction.Rds`

### 3. `import-bea-fixedassets.R`

- Pull FixedAssets tables:
  - FAAt301ESI (current-cost net stock, construction = Line 10)
  - FAAt304ESI (depreciation, construction = Line 10)
- Save to `derived/bea-fixedassets-construction.Rds`

### 4. `import-fred.R`

- Use `fredr` package with FRED API key (add `FRED_API_KEY` to
  `.Renviron` if not already present; or use direct `httr` calls)
- Pull:
  - `GS10` (10-year Treasury constant maturity rate)
  - `GDPDEF` (GDP implicit price deflator)
  - `RVAC` (real value added, construction -- single spliced series
    back to 1947; use as fallback / cross-check for pre-1997 real VA)
- Compute: real interest rate = GS10 - annual % change in GDPDEF
- Save to `derived/fred-rates.Rds`

### 5. `build-bea-construction.R`

- Merge all four imported datasets by year
- Compute:
  1. **Labor productivity** = real VA / FTE (straightforward)
  2. **Factor costs:**
     - `labor_cost = compensation + 0.67 * proprietors_income`
     - `capital_cost = depreciation + real_rate * net_capital_stock +
       0.33 * proprietors_income`
  3. **Cost shares** (Divisia weights):
     - `s_L_t = labor_cost / (labor_cost + capital_cost)`
     - `s_K_t = 1 - s_L_t`
     - `w_L = (s_L_t + s_L_{t-1}) / 2`
     - `w_K = (s_K_t + s_K_{t-1}) / 2`
  4. **TFP growth:**
     - `dln_tfp = dln_VA - w_L * dln_FTE - w_K * dln_K`
     - where `dln_K = log(net_capital_stock_t / net_capital_stock_{t-1})`
  5. **TFP index:** cumulate from growth rates; set 1997 = 1.0
- Also compute the same series for total private industries (or total
  economy) as a comparison benchmark
- Save to `derived/bea-construction-productivity.Rds`

### 6. Integration with existing pipeline

- In `program/import/databuild.R` or a new merge step: load
  `bea-construction-productivity.Rds` and join to the national panel so
  the BEA construction series are available alongside MH
- In `program/plot.R`: add BEA construction labor productivity and TFP
  to the existing VA and TFP figures (or create a new combined figure)

## Validation

- Cross-check labor productivity against G&S Figure 1 visually (they
  show an index, roughly 1.0 in 1950 rising to ~1.8 by 1970 then
  declining)
- Cross-check real VA levels against FRED `RVAC` series
- Verify TFP index reproduces the well-known pattern: roughly flat
  1950-1970, mild rise to ~1990, then steep decline

## Open Questions

1. **FRED API key.** Check whether `.Renviron` already has one; if not,
   either add one or use unauthenticated FRED downloads (CSV).
2. **Pre-1997 real VA.** If GDPbyIndustry API doesn't go back far
   enough, fall back to FRED `RVAC` for the full historical series.
3. **Line numbers.** The exact line numbers for construction in NIPA and
   FixedAssets tables need to be confirmed by inspecting the API
   response; they may differ across B/C/D vintages.
4. **Residential vs. all construction.** G&S use all of NAICS 23. Confirm
   this is what we want (vs. just residential construction, NAICS 236).
