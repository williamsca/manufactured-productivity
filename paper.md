---
title: "Productivity in Manufactured Housing"
author:
- name: Colin Williams
  affiliation: University of Virginia
  email: chv7bg@virginia.edu
date: March 2026
abstract:
bibliography: manufactured-productivity.bib
---

# Introduction

Aggregate data point to a large and decades-long decline in U.S.
construction sector productivity. Value added per worker in 2020
was roughly 40 percent below its 1970 level, a stunningly poor
record for a major sector [@goolsbee_strange_2023]. Conversely, in manufacturing industries where goods can be produced in factories, productivity has risen substantially over time [@potter_origins_2025].

But about manufactured housing? 

Manufactured homes are immune to many of the frictions that are often blamed for poor construction productivity: unpredictable weather, fragmented local building codes, and the complex coordination of multiple subcontractors on a construction site. Factory-built housing is assembled indoors in a controlled environment and has been regulated by a single federal code since 1976. Thus, the sector offers a natural test case: are site-specific frictions the main drivers of poor construction productivity, or are there more general forces at work that have also hamstrung factory-build housing?

I start by studying physical output measures. Manufactured housing
(MH) shipments per employee fell by roughly half between the
mid-1990s and the mid-2000s, though they partly recovered after 2015. In terms of raw output, MH productivity is dismal.

The quality of MH units has improved substantially over time, however. In nominal terms, average sales prices nearly tripled between 1990 and 2018, rising from \$28,000 to almost \$80,000, reflecting a shift to higher-quality double-wide units with better fixtures and appliances. To capture these quality improvements, I turn to the real value added per employee. This series tells a similar story: after steady growth from the late 1950s through the 1990s, real value added per worked stagnated after 2000. At the same time, value added in similar wood product manufacturing industries and the rest of manufacturing continued to grow, suggesting that something specific to the MH industry drove the post-2000 stagnation.

Measures of total factor productivity (TFP) suggest an even starker post-2000 collapse. After years of moderate growth, the NBER-CES TFP index for the MH sector collapsed by over 40\% between 1999 and 2015 even as productivity in other manufacturing industries continued to grow. MH are not immune to the construction productivity puzzle, and appear to be even more vulnerable to the forces driving down construction productivity.

# Data

I combine three data sources to construct a national panel of
manufactured housing productivity from 1958 to 2018.

**Census Manufactured Housing Survey (MHS).** The MHS provides
annual counts of manufactured home shipments and placements,
average sales prices by unit type (single-wide and double-wide),
and state-level shipment detail. The shipments series extends back
to 1959.

**County Business Patterns (CBP).** I use the harmonized CBP
panel from @eckert_early_2022 through 2016 and splice in Census API
data from 2017 onward for NAICS 321991 (Manufactured Home
Manufacturing). CBP provides March-12 reference payroll
employment.

**NBER-CES Manufacturing Industry Database.** The NBER-CES
database [@becker_nber-ces_2021] provides annual data on employment, value
added, shipments, materials costs, capital stocks, and total
factor productivity for all U.S. manufacturing industries at the
six-digit NAICS level from 1958 to 2018. I use the 1997 NAICS
concordance file, which includes NAICS 321991 throughout the
panel. Value added is deflated using the industry-specific
shipments price deflator (1997 = 1.0). The four-factor TFP index
accounts for labor, capital, energy, and materials inputs.

# Results

## Physical output per employee

Figure \ref{fig:output-pemp} plots units of housing output per
employee for manufactured housing (using both MHS shipments and
placements) and residential construction (building permits per
employee in NAICS 2361). MH shipments per worker averaged roughly
six units per employee through the mid-1990s, then fell sharply
to roughly two to three units by the mid-2000s. This decline
coincided with the collapse of the subprime lending channel
that had financed many MH purchases, which eliminated the
lowest-income buyers and shifted demand toward larger,
higher-quality units.

\begin{figure}[htbp]
  \centering
  \caption{Physical output per employee}\label{fig:output-pemp}
  \includegraphics[width=\textwidth]{output/output_pemp.pdf}
  \begin{flushleft}
  \begin{footnotesize}
  \emph{  Notes:} MH placements and shipments per employee. Fisher placements are a price-weighted aggregate of single- and double-wide placements. Census MHS and NBER-CES Manufacturing Industry Database.
  \end{footnotesize}
  \end{flushleft}
\end{figure}

## Real value added per employee

Figure \ref{fig:va-pemp} shows real value added per employee
from the NBER-CES database. In contrast to the physical output
measure, labor productivity shows a long upward trend: real value
added per worker roughly tripled from \$22,000 in 1958 to
\$63,000 in 1998 (1997 dollars). The post-2000 decline was
cyclical rather than secular, and by 2016 real value added per
employee had recovered to \$61,000, near its late-1990s peak.
The divergence between Figures \ref{fig:output-pemp} and
\ref{fig:va-pemp} reflects quality upgrading: workers produce
fewer but substantially more valuable homes.

\begin{figure}[htbp]
  \centering
  \caption{Real value added per employee}\label{fig:va-pemp}
  \includegraphics[width=\textwidth]{output/va_pemp.pdf}
  \begin{flushleft}
  \begin{footnotesize}
  \emph{  Notes:} Value added deflated by shipments price index (1997 =
  1.0). Comparison series are
  aggregates for other NAICS 321 industries and all other
  manufacturing industries excluding NAICS 321991. NAICS 321 is
  wood product manufacturing. NBER-CES Manufacturing Industry Database.
  \end{footnotesize}
  \end{flushleft}
\end{figure}

## Total factor productivity

Figure \ref{fig:tfp} plots the NBER-CES four-factor TFP index,
which adjusts for labor, capital, energy, and materials inputs,
for manufactured housing and a Domar-weighted aggregate of all
other manufacturing industries. MH TFP rose steadily from 0.67
in 1958 to a peak of 1.01 in 1998, then declined precipitously
to 0.54 by 2013. The partial recovery to 0.65 by 2016 still
leaves TFP well below its 1972 level. By contrast, the rest of
manufacturing returned to roughly its 1997 level by 2016. This
sharp post-1998 divergence suggests MH's productivity collapse
was not a broad manufacturing phenomenon. The magnitude of the
MH decline is comparable to the productivity collapse that
@goolsbee_strange_2023 document for the site-built construction
sector as a whole.

The juxtaposition of Figures \ref{fig:va-pemp} and \ref{fig:tfp}
implies that labor productivity recovered only through capital
deepening---firms invested in more capital per worker, but the
efficiency with which they combine all inputs deteriorated
dramatically. Manufactured housing factories, despite their
controlled environment, standardized processes, and federal
regulation, have not escaped the forces driving down construction
productivity.

\begin{figure}[htbp]
  \centering
  \caption{Total factor productivity}\label{fig:tfp}
  \includegraphics[width=\textwidth]{output/tfp.pdf}
  \begin{flushleft}
  \begin{footnotesize}
  \emph{  Notes:} Four-factor TFP index using labor, capital, energy, and
  materials inputs. Base year 1997 = 1.0. Comparison series are
  Domar-weighted aggregates of annual industry TFP growth for
  other NAICS 321 industries and all other manufacturing
  industries excluding NAICS 321991. NAICS 321 is wood product
  manufacturing. NBER-CES Manufacturing Industry Database.
  \end{footnotesize}
  \end{flushleft}
\end{figure}

# Discussion and Next Steps

The TFP collapse after 1998 coincides almost exactly with the
demand shock that hit manufactured housing when the subprime
chattel-lending channel dried up. MH shipments fell from roughly
375,000 units per year at their late-1990s peak to fewer than
80,000 by the mid-2000s---a decline of nearly 80 percent from
which the industry has never recovered. One interpretation of
the TFP decline is that it reflects lost economies of scale at
the industry level rather than technological regress.

Factory-built housing has high fixed costs: the factory itself,
jigs, tooling, and quality-control infrastructure. At 1990s
volumes these costs were spread over many units. After the demand
collapse, the same capital stock produced a fraction of the
output, and the "capital deepening" visible in Figure
\ref{fig:va-pemp} may partly reflect underutilized capacity
rather than genuine investment per unit of output. At the same
time, the thick network of specialized component suppliers and
trained assembly workers that supported peak-era production
thinned out as volume fell---suppliers exited and skilled labor
dispersed. Rebuilding these networks at lower volumes is more
costly per unit.

Part of the post-1998 TFP decline may therefore reflect a
transitional measurement issue rather than technological regress.
If factories and equipment installed during the boom remained in
place as shipments collapsed, measured capital input would adjust
more slowly than output, mechanically depressing TFP. In
principle this effect should fade as capital depreciates or is
scrapped, but the persistence of low TFP through 2016 suggests
that excess legacy capital was not the whole story and that the
industry may instead have settled into a persistently low-scale
equilibrium.

Geographic fragmentation compounds the problem. Transport costs
for finished manufactured homes are steep (wide loads, escort
vehicles, state permits), so each factory serves a limited
radius. With aggregate demand down 75 percent and spread
unevenly across states, many regional markets cannot sustain a
factory at efficient scale. The industry faces the worst of both
worlds: too few units nationally for industry-level scale
economies, and too dispersed geographically for any single plant
to compensate.

Several extensions could test this scale hypothesis. First,
plant-level microdata from the Census of Manufactures for NAICS
321991 would allow direct estimation of plant-level scale
elasticities and could show whether plants that maintained volume
had better productivity trajectories than those that did not.
Second, CBP establishment counts over time could reveal whether
the industry consolidated toward fewer, larger plants---the
efficient response to a scale-driven productivity decline---or
instead saw a more uniform contraction. Third, cross-state
variation in the severity of the demand shock, constructed from
MHS state-level shipment data, could serve as a source of
identifying variation: states where MH demand held up better
should show smaller productivity declines if scale is the binding
mechanism.

If the TFP decline is largely a scale phenomenon, the
implications for the broader construction productivity puzzle are
significant. It would suggest that the distinction between
factory and site production matters less than demand conditions,
and that the parallel productivity declines in site-built
construction after 2006 may share the same underlying
mechanism rather than reflecting site-specific frictions like
weather, regulation, or fragmented project management.

# References
