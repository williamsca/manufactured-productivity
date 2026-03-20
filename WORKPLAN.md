# Workplan: Manufactured Housing Productivity

## Motivation

Goolsbee & Syverson (2023) document a 50-year decline in U.S. construction sector productivity. Manufactured housing (MH) offers a natural comparison: factory-built, federally regulated (HUD Code), and concentrated among a few large producers. If MH productivity is flat or rising while site-built falls, the implication is that the construction productivity puzzle is about the *site*, not about building per se.

## Current State

- Census MHS shipments (national, 1980-2024) + BLS QCEW employment (NAICS 321991, ~2001-present) + ASM value-added (2002-2016 only)
- CBP employment extended back to 1986: SIC 2451 (1986-1997) + NAICS 321991 (1998-2022) via Census API → `derived/cbp_emp.Rds`; using CBP throughout (single consistent series, March-12 reference)
- Two exploratory plots: shipments/employee, value-added/employee
- **Bug**: `databuild.R:33` merges `dt_ship` (undefined) instead of `dt_mhs`
- **No deflator** applied to value-added
- **No conventional construction comparison series**
- **ASM coverage too narrow** for multi-decade comparison

---

## Phase 1: Data Requirements

| ID | Task | Detail | Source |
|----|------|--------|--------|
| 1a | BEA construction sector productivity | Real value-added, employment, and TFP for NAICS 23 (Construction), 1950-present. The G&S comparison benchmark. | BEA Industry Accounts / KLEMS |
| 1c | Extend MH value-added | ASM 2002-2016 is too short. Census of Manufactures (quinquennial) covers SIC 2451 back to 1972. Annual ASM may extend to 2022 via newer API endpoints. Also consider NBER-CES Manufacturing Database for a continuous series. | Census CoM, NBER-CES |
| 1d | Deflator for MH value-added | Options: (i) PPI for NAICS 321991, (ii) broader PPI for prefab wood buildings (PCU321992), (iii) GDP deflator (G&S robustness check), (iv) CPI for housing. Deflator choice is analytically important — mirrors the core G&S finding about deflator sensitivity. | BLS PPI, BEA |
| 1e | Site-built housing physical output | Census housing completions (SF, MF) + CES employment for residential construction (NAICS 2361/2362). Replicates G&S Figure 6 as one half of the comparison. | Census New Residential Construction, BLS CES |


## Phase 2: Core Analyses

| ID | Task | Detail |
|----|------|--------|
| 2a | Fix databuild.R bug | `dt_ship` → `dt_mhs` on line 33 |
| 2b | **Core comparison figure** | Units shipped per employee (MH) vs. housing units completed per employee (site-built), indexed to a common base year (~1972 or 1990). This is the headline result. |
| 2c | Value-added productivity comparison | Real value-added per worker in MH manufacturing vs. construction sector (NAICS 23), deflated consistently. Show with both sector-specific and GDP deflators (following G&S Figure 4 logic). |
| 2d | Quality-adjusted physical productivity | Square footage per employee for both MH and site-built, paralleling G&S Figure 7. MH has a natural advantage here since units are more standardized. |
| 2e | Materials productivity in MH | Ratio of value-added to gross output over time in MH manufacturing. Does MH show the same deteriorating materials efficiency G&S document for construction? |
| 2f | Decompose MH shipments trends | Separate single-wide vs. double-wide mix shift. Double-wides require more labor per unit; the shift toward doubles could mechanically depress units/employee even as real productivity rises. |

## Phase 3: MH-Specific Extensions

| ID | Task | Rationale |
|----|------|-----------|
| 3a | Factory vs. field productivity | The core contribution. MH removes weather, site logistics, and local code variation. Divergent productivity paths between MH and site-built would locate the construction productivity puzzle at the job site. |
| 3b | HUD Code structural break | MH has been regulated under a single federal code since 1976. Test whether HUD Code adoption shows a structural break in MH productivity. Contrast with G&S's hypothesis about market frictions from local regulation. |
| 3c | State-level reallocation test | Replicate G&S Table 1 for MH using state shipment data + state employment. MH firms can ship across state lines, so if reallocation works anywhere in housing, it should work here. |
| 3d | Industry concentration and plant scale | MH is far more concentrated than site-built construction. Use Census of Manufactures plant-level tabulations to document scale economies. Connects to Schmitz (2020) on competition. |
| 3e | Price comparison | Compare MH average sales price per sq ft to Census new home price per sq ft over time. If MH prices grow more slowly, that's independent evidence of better productivity performance (per G&S deflator logic). |
| 3f | Regulatory/zoning friction | MH placements face geographic constraints (zoning exclusions, community siting). The gap between shipments and placements, and its geographic variation, measures a friction limiting the productivity channel G&S identify. |

---

## Delegation Structure

| Agent | Tasks | Dependencies |
|-------|-------|--------------|
| **Data acquisition** | 1a-1f | None — can start immediately |
| **Databuild** | 2a, 2f | Requires 1a-1f |
| **Core analysis** | 2b-2e | Requires databuild |
| **Extensions** | 3a-3f | Requires core analysis for context; some (3c, 3e) need additional data |
| **Writing** | Draft paper sections | As results arrive |

## Sequencing

```
Phase 1 (data) ──→ Phase 2 (core) ──→ Phase 3 (extensions)
                                    ──→ Writing (parallel with Phase 3)
```

The headline figure (2b) should drive the venue decision: if MH productivity is clearly rising while site-built falls, that's a journal-worthy finding; if the picture is muddier, a policy brief framing may be more appropriate.
