# manufactured-productivity

Replication materials for "Productivity in Manufactured Housing."

## Replication

### Requirements

- R with packages: `data.table`, `ggplot2`, `here`, `readxl`, `jsonlite`, `scales`
- Pandoc (with `latex.template` at `~/.pandoc/templates/latex.template`)
- TeX Live (pdflatex + bibtex)
- GNU Make 4.3+

### Data

| Directory | Contents |
|-----------|----------|
| `data/census-mhs/` | Census Manufactured Housing Survey — shipments, placements, and average sales price files (XLSX) |
| `data/nber-ces/` | NBER-CES Manufacturing Industry Database, 1958–2018 (`nberces5818v1_n1997.csv`). Downloaded automatically from `data.nber.org` if missing. |
| `crosswalk/states.txt` | State FIPS crosswalk (two columns: `statefp`, `state_name`). |

### Build

```bash
make paper.pdf
```

This runs the full pipeline in order:

1. `program/import/import-mhs.R` → `derived/mhs-state-year.Rds`, `derived/mhs-national-year.Rds`
2. `program/import/import-nberces.R` → `derived/nberces-industries.Rds`, `derived/nberces-mh.Rds`
3. `program/import/databuild.R` → `derived/sample.Rds`, `derived/sample-state.Rds`
4. `program/plot.R` → `output/*.pdf` (figures embedded in the paper)
5. Pandoc + pdflatex → `paper.pdf`

Intermediate files in `derived/` and `output/` are excluded from version control (see `.gitignore`).
