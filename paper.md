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

Manufactured homes are immune to many of the frictions that are often blamed for poor construction productivity: unpredictable weather, fragmented local building codes, and the complex coordination of multiple subcontractors on a construction site. These complications are absent from the production process for manufactured homes, which are assembled indoors in a controlled environment and have been regulated by a single federal code since 1976. Thus, the sector offers a natural test case: are site-specific frictions the main drivers of poor construction productivity, or are there more general forces at work? Have the same or similar forces also hamstrung factory-built housing?

I start by studying physical output measures. The story is grim: manufactured housing (MH) shipments per employee fell by roughly half between the mid-1990s and the mid-2000s, though they partly recovered after 2015. In terms of raw output, MH productivity appears dismal.[^1]

[^1]: An important qualification for all these measures of productivity is that they struggle to account for changes in quality over time. Despite the apparent homogeneity of mobile homes, quality in this market does appear to have increased: in nominal terms, average sales prices nearly tripled between 1990 and 2018, rising from \$28,000 to almost \$80,000. The market also shifted modestly towards double-wide units over the same period, potentially with higher quality fixtures and appliances.

Units per worker, however, treats every home equally: a small single-wide counts the same as a large double-wide. After the demand collapse of the early 2000s wiped out the low-end chattel-lending market, the remaining buyers demanded larger, higher-quality units. When the product mix shifts toward more expensive homes, units per worker can fall even as dollar-valued productivity holds steady — fewer but more valuable units per worker is the same dollars per worker. Real value added per employee, from the NBER-CES database, measures the dollar value the industry adds (revenue minus materials costs) per worker, adjusted for inflation.[^2]

This series tells a more nuanced story: labor productivity grew steadily from the late 1950s through the 1990s, then stagnated after 2000 rather than collapsing outright. The divergence between falling units per worker and flat value added per worker is consistent with the post-2000 composition shift toward larger, more expensive homes. At the same time, value added in similar wood product manufacturing industries continued to grow, suggesting that something specific to the MH industry drove the post-2000 stagnation.

[^2]: The NBER-CES deflator is based on the Producer Price Index for manufactured housing, which tracks prices for specific product categories over time. It is not hedonic, so within-product quality improvements — better insulation or appliances at a given price point — are not recognized as output gains. To the extent that such improvements occurred, real value added understates true performance.

Measures of total factor productivity (TFP), which strip out the contribution of capital along with other inputs, suggest an even starker post-2000 collapse. After years of moderate growth, the NBER-CES TFP index for the MH sector fell by over 40\% between 1999 and 2015, a stark divergence from related manufacturing industries.

MH are not immune to the construction productivity puzzle. Indeed, they appear to have performed even worse than site-built construction, especially after 2000.

# Data

I combine two data sources to construct a national panel of manufactured housing productivity from 1958 to 2018.

**Census Manufactured Housing Survey (MHS).** The MHS provides annual counts of manufactured home shipments and placements, average sales prices by unit type (single-wide and double-wide), and state-level shipment detail. The shipments series extends back to 1959.

<!--
**County Business Patterns (CBP).** I use the harmonized CBP panel from @eckert_early_2022 through 2016 and splice in Census API data from 2017 onward for NAICS 321991 (Manufactured Home Manufacturing).
-->

**NBER-CES Manufacturing Industry Database.** The NBER-CES database provides annual data on employment, value added, shipments, materials costs, capital stocks, and total factor productivity for all U.S. manufacturing industries at the six-digit NAICS level from 1958 to 2018 [@becker_nber-ces_2021]. Value added is deflated using the industry-specific shipments price deflator, and the four-factor TFP index accounts for labor, capital, energy, and materials inputs.

# Results

## Physical output per employee

Figure \ref{fig:output-pemp} plots units of housing output per employee for manufactured housing. MH shipments per worker averaged above five units per employee through the mid-1990s, then fell sharply to roughly 2.5 units by the mid-2000s.

\begin{figure}[htbp]
  \centering
  \caption{Physical output per employee}\label{fig:output-pemp}
  \includegraphics[width=\textwidth]{output/output_pemp.pdf}
  \begin{flushleft}
  \begin{footnotesize}
  \emph{  Notes:} MH placements and shipments per employee. Fisher placements are a price-weighted aggregate of single- and double-wide placements.
  
  \emph{  Source:} Census MHS and NBER-CES Manufacturing Industry Database.
  \end{footnotesize}
  \end{flushleft}
\end{figure}

This decline in physical output is partly the consequence of large and rapid changes in demand. Financing for MH collapsed in the early 2000s, eliminating the lowest-income buyers and shifting industry output to satisfy the remaining customers, with better credit and demand for larger, higher-quality units. The share of double-wide placements rose from 50\% of units in 1996 to over 75\% in 2003.

I partly adjust for this shift by constructing a price-weighted Fisher aggregate of single- and double-wide placements per employee. This measure accounts for the shift in the mix of units over time by weighting the quantity of single- and double-wide placements by their prices. Importantly, it cannot capture quality improvements within unit types. The Fisher aggregate shows a similar post-2000 decline, though the drop is slightly less severe.

## Real value added per employee

Figure \ref{fig:va-pemp} shows real value added per employee from the NBER-CES database. In contrast to the physical output measure, labor productivity shows a long upward trend since 1958: from a base of \$22,000, real value added per worker roughly tripled over the next forty years to \$63,000 (1997 dollars). Post-2000, value-added stagnated but did not fall, and by the late 2010s value added per employee remained near its peak.

\begin{figure}[htbp]
  \centering
  \caption{Real value added per employee}\label{fig:va-pemp}
  \includegraphics[width=\textwidth]{output/va_pemp.pdf}
  \begin{flushleft}
  \begin{footnotesize}
  \emph{  Notes:} Value added deflated by shipments price index (1997 =
  1.0). Comparison series are aggregates for other NAICS 321 (wood product manufacturing) industries.
  
  \emph{  Source:} NBER-CES Manufacturing Industry Database.
  \end{footnotesize}
  \end{flushleft}
\end{figure}

At the same time, however, the industry performed much worse than comparable manufacturing sectors. Wood product manufacturing industries grew steadily through the 2000s, ending the 2010s with nearly double the real value added per employee of MH despite starting at a similar level in the 1990s.

The most likely explanation for the divergence between raw output and value-added measures is that the composition of output shifted towards higher-quality, more expensive units after 1999.

## Total factor productivity

Figure \ref{fig:tfp} plots the NBER-CES four-factor TFP index, which adjusts for labor, capital, energy, and materials inputs, for manufactured housing and Domar-weighted aggregates of other manufacturing industries.[^2] The story is quite similar to value added: MH TFP rose steadily between 1960 and 1999, then declined precipitously to 0.54 by 2013. The partial recovery to 0.65 by 2016 still leaves TFP well below its level in 1960.

\begin{figure}[htbp]
  \centering
  \caption{Total factor productivity}\label{fig:tfp}
  \includegraphics[width=\textwidth]{output/tfp.pdf}
  \begin{flushleft}
  \begin{footnotesize}
  \emph{  Notes:} Four-factor TFP index using labor, capital, energy, and
  materials inputs. Base year 1997 = 1.0. Comparison series are
  Domar-weighted aggregates of annual industry TFP growth for
  other NAICS 321 (wood product manufacturing) industries.

  \emph{  Source:} NBER-CES Manufacturing Industry Database.
  \end{footnotesize}
  \end{flushleft}
\end{figure}

By contrast, other wood product manufacturing industries show no break in trends around 2000. MH's productivity collapse was not part of a broad manufacturing phenomenon.

[^2]: Aggregate TFP series for comparison groups are constructed following @domar_measurement_1961. For each group, the annual TFP growth rate is a weighted average of constituent industries' four-factor TFP growth rates, where the weight on each industry is its lagged gross output (shipments) as a share of the group's lagged aggregate value added. These Domar weights sum to greater than one, reflecting the fact that an industry's productivity gain raises the effective output of downstream users of its products. The weighted growth rates are cumulated from a base of 1.0 in 1997.

The juxtaposition of Figures \ref{fig:va-pemp} and \ref{fig:tfp} implies that labor productivity recovered only through capital deepening: firms invested in more capital per worker, but the efficiency with which they combine all inputs deteriorated dramatically. Manufactured housing factories, despite their controlled environment, standardized processes, and federal regulation, have not escaped the forces holding down construction productivity.

# Discussion

The TFP collapse after 1998 coincides almost exactly with the demand shock that hit manufactured housing when the subprime chattel-lending channel dried up. MH shipments fell from roughly 375,000 units per year at their late-1990s peak to fewer than 80,000 by the mid-2000s, a massive decline from which the industry has never recovered. One interpretation of the TFP decline is that it reflects lost economies of scale rather than technological regress.

The scale interpretation has both within-plant and market-level dimensions. Within each factory, high fixed costs — the plant itself, jigs, tooling, and quality-control infrastructure — must be spread over output. When volumes collapsed, factories that once operated at efficient scale were left with excess capacity, mechanically depressing measured productivity. But the geographic fragmentation of the industry compounds this problem. Transport costs for finished manufactured homes are steep (about \$13--14 per mile), so each factory serves a limited radius [@jensen_manufactured_2024]. Unlike a typical manufacturing industry, MH producers cannot respond to falling demand by consolidating into fewer, larger plants: a factory in Alabama cannot absorb the customers of a shuttered plant in Oregon. Some regional markets may simply be unable to sustain a factory at efficient scale, with no prospect of consolidation.

The severity of the demand shock also makes it unlikely that standard reallocation forces offset the productivity decline. In a Melitz-style framework, negative demand shocks should induce the least productive firms to exit, raising average productivity among survivors. The fact that MH TFP fell sharply despite substantial industry contraction suggests that the loss of scale economies dominated any cleansing effect from the exit of low-productivity plants.

A lack of scale economies may also explain the poor performance of site-built construction. @damico_why_2024 argue that fragmented local regulations prevent large, efficient builders from producing standardized homes on large greenfield sites, a mode of production that was historically more common and which contributed to the industry's productivity growth in the years after World War II.

While manufactured housing managed to achieve substantial scale economies before 1999, the industry appears unlikely to ever regain its former size. Economics of scale in home-building remain elusive. For both site-built and manufactured homes, structural features of the industry -- regulatory fragmentation, high transportation costs, and a secular decline in demand due to falling fertility -- limit the size of the market, prevent learning-by-doing, and raise the cost of housing.

# References
