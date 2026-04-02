# manufactured-productivity

Replication materials for "Productivity in Manufactured Housing."

## Replication

### Requirements

- R with packages: `data.table`, `ggplot2`, `here`, `readxl`, `jsonlite`, `scales`
- Pandoc (with `latex.template` at `~/.pandoc/templates/latex.template`)
- TeX Live (pdflatex + bibtex)
- GNU Make 4.3+

### Data

Two sources are bundled in the repo; two more must be present in Dropbox before running Make.

**In repo (`data/`):**

| Directory | Contents |
|-----------|----------|
| `data/census-mhs/` | Census Manufactured Housing Survey — shipments, placements, and average sales price files (XLSX) |
| `data/nber-ces/` | NBER-CES Manufacturing Industry Database, 1958–2018 (`nberces5818v1_n1997.csv`). Downloaded automatically from `data.nber.org` if missing. |

**In Dropbox (`$DATA_PATH`, set in `.Renviron`):**

| Path | Contents |
|------|----------|
| `data/census-cbp/1975-2018/efsy_panel_naics.csv.zip` | Harmonized County Business Patterns panel from Eckert et al. (2022). Download from <https://www.fpeckert.me/cbp/>. |
| `data/census-bps/BPS_Compiled_File.csv` | Census Building Permits Survey compiled file. Download from <https://socds.huduser.gov/permits/>. |
| `crosswalk/states.txt` | State FIPS crosswalk (two columns: `statefp`, `state_name`). |

The `.Renviron` file sets `DATA_PATH=/home/colin/Dropbox/research-data` and is excluded from version control. Replicators should create their own `.Renviron` pointing to wherever these files live.

### Build

```bash
make paper.pdf
```

This runs the full pipeline in order:

1. `program/import/import-mhs.R` → `derived/mhs-state-year.Rds`, `derived/mhs-national-year.Rds`
2. `program/import/import-cbp.R` → `derived/census-cbp.csv`
3. `program/import/import-bps.R` → `derived/census-bps.Rds`
4. `program/import/import-nberces.R` → `derived/nberces-industries.Rds`, `derived/nberces-mh.Rds`
5. `program/import/databuild.R` → `derived/sample.Rds`, `derived/sample-state.Rds`
6. `program/plot.R` → `output/*.pdf` (figures embedded in the paper)
7. Pandoc + pdflatex → `paper.pdf`

Intermediate files in `derived/` and `output/` are excluded from version control (see `.gitignore`).

## County Business Patterns Data

Data downloaded from <https://www.fpeckert.me/cbp/> on 3/20/2026.

Abstract:
The County Business Patterns data published by the US Census Bureau track employment by county and industry from 1946 to the present. Two features of the data limit their usefulness to researchers: (1) employment for the majority of county-industry cells is suppressed to protect confidentiality, and (2) industry classifications change over time. We address both issues. First, we develop a linear programming method that exploits the large set of adding-up constraints implicit in the hierarchical arrangement of the data to impute missing employment. Second, we provide concordances to map all data to a consistent set of industry codes. Finally, we construct a user-friendly, 1975 to 2018 county-level panel that classifies industries according to a consistent set of 2012 NAICS codes in all years.

The NAICS long panel records employment at the most detailed industry-county level of aggregation possible. The sum of all observations in this panel represents the national total. For reasons explained in detail in our working paper, it is not always possible to assign employment to a six-digit NAICS code. In these cases, the employment is attributed to a more aggregate code, e.g., 11////.   

We note that unlike in the raw CBP data and the text, where we describe codes such as 11//// as a root that contains the sum of all codes that are more detailed than 11////, that is not what codes of this form represent in the long panel. Instead, the roots in this dataset contain the remainder of 11//// employment that we could not assign to a more disaggregated NAICS code.  Users can obtain the total 11//// employment by summing employment over all codes that start with 11.

NB: Census changed the way the CBP data are reported starting in 2017. For these years, Census now perturbs cells with small employment counts, making these data fundamentally different from earlier periods. We do not impute data in those years since there are no missing cells in the data. We nevertheless appended 2017 and 2018 to the panel for completeness. Note that the 2017 and 2018 data are reported on a NAICS2017 basis.
