---
title: "Productivity in Off-Site Construction"
author:
- name: Colin Williams
  affiliation: University of Virginia
  email: chv7bg@virginia.edu
date: March 2026
abstract:
bibliography: manufactured-productivity.bib
---

# Introduction

Aggregate data point to a large and decades-long decline in U.S. construction sector productivity. Value added per worker in 2020 was roughly 40 percent below its 1970 level, a remarkably poor record for a major sector [@goolsbee_strange_2023]. Conversely, in manufacturing industries where goods can be produced in factories, productivity has risen substantially over time [@potter_origins_2025].

So, what about manufactured housing? 

Manufactured homes are immune to many of the frictions that are often blamed for poor construction productivity: unpredictable weather, fragmented local building codes, and the complex coordination of multiple subcontractors on a construction site. Factory-built housing is assembled indoors in a controlled environment and has been regulated by a single federal code since 1976. Thus, the sector offers a natural test case: are site-specific frictions the main drivers of poor construction productivity, or are there more general forces at work that have also hamstrung factory-build housing?

I start by studying physical output measures. Manufactured housing (MH) shipments per employee fell by roughly half between the mid-1990s and the mid-2000s, though they partly recovered after 2015. In terms of raw output, MH productivity appears dismal.

Quantity-based measures of productivity struggle to account for changes in quality over time. Despite the apparent homogeneity of mobile homes, quality in this market does appear to have increased: in nominal terms, average sales prices nearly tripled between 1990 and 2018, rising from \$28,000 to almost \$80,000. The market also shifted modestly towards double-wide units over the same period, potentially with higher quality fixtures and appliances.

To capture these quality improvements, I turn to the real value added per employee. This series tells a similar story: after steady growth from the late 1950s through the 1990s, real value added per worked stagnated after 2000. At the same time, value added in similar wood product manufacturing industries and the rest of manufacturing continued to grow, suggesting that something specific to the MH industry drove the post-2000 stagnation.

Measures of total factor productivity (TFP) suggest an even starker post-2000 collapse. After years of moderate growth, the NBER-CES TFP index for the MH sector collapsed by over 40\% between 1999 and 2015, a stark divergence from related manufacturing industries.

MH are not immune to the construction productivity puzzle. Indeed, they appear to have performed even worse the site-built construction, especially after 2000.

# Data

I combine two data sources to construct a national panel of manufactured housing productivity from 1958 to 2018.

**Census Manufactured Housing Survey (MHS).** The MHS provides annual counts of manufactured home shipments and placements, average sales prices by unit type (single-wide and double-wide), and state-level shipment detail. The shipments series extends back to 1959.

<!--
**County Business Patterns (CBP).** I use the harmonized CBP panel from @eckert_early_2022 through 2016 and splice in Census API data from 2017 onward for NAICS 321991 (Manufactured Home Manufacturing).
-->

**NBER-CES Manufacturing Industry Database.** The NBER-CES database provides annual data on employment, value added, shipments, materials costs, capital stocks, and total factor productivity for all U.S. manufacturing industries at the six-digit NAICS level from 1958 to 2018 [@becker_nber-ces_2021]. Value added is deflated using the industry-specific shipments price deflator (1997 = 1.0), and the four-factor TFP index accounts for labor, capital, energy, and materials inputs.

# Results

## Physical output per employee

Figure \ref{fig:output-pemp} plots units of housing output per employee for manufactured housing. MH shipments per worker averaged above five units per employee through the mid-1990s, then fell sharply to roughly 2.5 units by the mid-2000s.

This decline in physical output is partly the consequence of large and rapid changes in demand. Financing for MH collapsed in the early 2000s, eliminating the lowest-income buyers and shifting industry output to satisfy the remaining customers, with better credit and demand for larger, higher-quality units.

I partly account for this shift by constructing a price-weighted Fisher aggregate of single- and double-wide placements per employee. This measure accounts for the modest shift in the mix of units over time by weighting the quantity of single- and double-wide placements by their relative prices. However, it cannot capture quality improvements within unit types. The Fisher aggregate shows a similar post-2000 decline, though the drop is slightly less severe.

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

Figure \ref{fig:va-pemp} shows real value added per employee from the NBER-CES database. In contrast to the physical output measure, labor productivity shows a long upward trend since 1958: from a base of \$22,000, real value added per worker roughly tripled over the next forty years to \$63,000 (1997 dollars). Post-2000, value-added stagnated but did not fall, and by the late 2010s value added per employee remained near its peak.

At the same time, however, the industry performed much worse than other manufacturing sectors. Wood product manufacturing industries grew steadily through the 2000s, ending the 2010s with nearly double the real value added per employee of MH despite starting at a similar level in the 1990s. All other manufacturing industries grew even faster over the same period.

\begin{figure}[htbp]
  \centering
  \caption{Real value added per employee}\label{fig:va-pemp}
  \includegraphics[width=\textwidth]{output/va_pemp.pdf}
  \begin{flushleft}
  \begin{footnotesize}
  \emph{  Notes:} Value added deflated by shipments price index (1997 =
  1.0). Comparison series are aggregates for other NAICS 321 industries and all other manufacturing industries excluding NAICS 321991. NAICS 321 is wood product manufacturing. NBER-CES Manufacturing Industry Database.
  \end{footnotesize}
  \end{flushleft}
\end{figure}

## Total factor productivity

Figure \ref{fig:tfp} plots the NBER-CES four-factor TFP index, which adjusts for labor, capital, energy, and materials inputs, for manufactured housing and Domar-weighted aggregates of other manufacturing industries.[^1] The story is quite similar to value added: MH TFP rose steadily between 1960 and 1999, then declined precipitously to 0.54 by 2013. The partial recovery to 0.65 by 2016 still leaves TFP well below its level in 1960. 

By contrast, other manufacturing industries show no break in trends around 2000. MH's productivity collapse was not a broad manufacturing phenomenon, and its is comparable to the productivity collapse that @goolsbee_strange_2023 document for the site-built construction sector as a whole.

[^1]: TODO

The juxtaposition of Figures \ref{fig:va-pemp} and \ref{fig:tfp} implies that labor productivity recovered only through capital deepening---firms invested in more capital per worker, but the efficiency with which they combine all inputs deteriorated dramatically. Manufactured housing factories, despite their controlled environment, standardized processes, and federal regulation, have not escaped the forces driving down construction productivity.

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

The TFP collapse after 1998 coincides almost exactly with the demand shock that hit manufactured housing when the subprime chattel-lending channel dried up. MH shipments fell from roughly 375,000 units per year at their late-1990s peak to fewer than 80,000 by the mid-2000s---a decline of nearly 80 percent from
which the industry has never recovered. One interpretation of the TFP decline is that it reflects lost economies of scale at the industry level rather than technological regress.

Factory-built housing has high fixed costs: the factory itself, jigs, tooling, and quality-control infrastructure. At 1990s volumes these costs were spread over many units. After the demand collapse, the same capital stock produced a fraction of the output, and the "capital deepening" visible in Figure \ref{fig:va-pemp} may partly reflect underutilized capacity rather than genuine investment per unit of output. At the same time, the thick network of specialized component suppliers and trained assembly workers that supported peak-era production thinned out as volume fell---suppliers exited and skilled labor dispersed. Rebuilding these networks at lower volumes is more costly per unit.

Part of the post-1998 TFP decline may therefore reflect a transitional measurement issue rather than technological regress. If factories and equipment installed during the boom remained in place as shipments collapsed, measured capital input would adjust more slowly than output, mechanically depressing TFP. In principle this effect should fade as capital depreciates or is scrapped, but the persistence of low TFP through 2016 suggests that excess legacy capital was not the whole story and that the industry may instead have settled into a persistently low-scale equilibrium.

Geographic fragmentation compounds the problem. Transport costs for finished manufactured homes are steep (about $13-14 per mile), so each factory serves a limited radius. With aggregate demand down 75 percent and spread unevenly across states, many regional markets cannot sustain a factory at efficient scale. The industry faces the worst of both worlds: too few units nationally for industry-level scale economies, and too dispersed geographically for any single plant to compensate.

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
