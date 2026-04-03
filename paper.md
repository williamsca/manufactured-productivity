---
title: "Productivity in Manufactured Housing"
author:
- name: Colin Williams
  affiliation: University of Virginia
  email: chv7bg@virginia.edu
date: March 2026
abstract:
bibliography: manufactured-productivity.bib
thanks: I am grateful to Tyler Pullen and Sean Roberts for their thoughtful feedback on an early draft of this essay.
tags: ['housing', 'productivity']
---

Aggregate data point to a large and decades-long decline in U.S. construction sector productivity. Value added per worker in 2020 was roughly 40 percent below its 1970 level, a remarkably poor record for a major sector [@goolsbee_strange_2023]. Conversely, in manufacturing industries where goods can be produced in factories, productivity has risen substantially over time [@potter_origins_2025].

What about manufactured housing? 

There are many site-specific explanations for the construction productivity puzzle: fragmented local building codes that prevent standardization, cumbersome land-assembly processes, unpredictable weather, and the complex coordination of multiple subcontractors on a job site [@damico_why_2024]. These explanations motivate popular remedies, such as standardizing building codes, creating government land banks, or streamlining permitting, that share a common premise: the problem lies in the idiosyncratic interface between the builder and the building site.

Manufactured housing offers a clean test of this premise. None of these site-specific frictions apply to the production of manufactured homes, which are assembled indoors on factory lines, regulated by a single federal code since 1976, and shipped as finished units. Crucially, the productivity measures I study — output, value added, and TFP from the NBER-CES database — are measured at the factory gate, reflecting the prices and quantities of homes as they leave the plant. They do not include land acquisition, permitting, site preparation, or installation. If manufactured housing nonetheless exhibits poor productivity, then site-specific explanations are at best incomplete, and the same forces that depress construction productivity must also operate inside the factory.

At the same time, manufactured housing shares many features with site-built construction that are less often discussed. Both sectors are subject to severe demand volatility. Both face high transportation costs that fragment the market geographically, limiting scale. And both rely on a labor force that is increasingly disconnected from the methods and talent pools of modern manufacturing. These shared features make the comparison especially informative.

I start by studying physical output measures. The story is grim: manufactured housing (MH) shipments per employee fell by roughly half between the mid-1990s and the mid-2000s and have never fully recovered. In terms of raw output, MH productivity appears dismal.

Units per worker, however, treats every home equally: a small single-wide counts the same as a large double-wide. After the demand collapse of the early 2000s wiped out the low-end chattel-lending market, the remaining buyers demanded larger, higher-quality units. When the product mix shifts toward more expensive homes, units per worker can fall even as dollar-valued productivity holds steady. To better account for quality, I turn to real value added per employee, from the NBER-CES database, to measure the dollar value the industry adds per worker, adjusted for inflation and net of materials costs.[^2]

This series tells a slightly different story: labor productivity grew steadily from the late 1950s through the 1990s, then stagnated after 2000 rather than collapsing outright. The divergence between falling units per worker and flat value added per worker is consistent with a composition shift toward larger, more expensive homes. At the same time, however, value added in similar wood product manufacturing industries continued to grow, suggesting that something specific to the MH industry caused its relative stagnation.

[^2]: The NBER-CES deflator is based on the Producer Price Index for manufactured housing, which tracks prices for specific product categories over time. It is not hedonic, so within-product quality improvements — better insulation or appliances at a given price point — are not recognized as output gains. To the extent that such improvements occurred, real value added understates true performance.

Measures of total factor productivity (TFP), which strip out the contribution of capital along with other inputs, suggest an even starker post-2000 collapse. After years of moderate growth, the NBER-CES TFP index for the MH sector fell by over 40\% between 1999 and 2015, a stark divergence from related manufacturing industries.

Manufactured homes are not immune to the construction productivity puzzle. Indeed, they appear to have performed even worse than site-built construction, especially after 2000. This finding is significant because all of the standard site-specific explanations — fragmented building codes, land-use regulation, permitting delays — are absent from the factory floor. The forces holding down MH productivity must therefore operate through other channels: demand volatility, geographic fragmentation, and the industry's failure to adopt modern production methods.

# Data

I combine two data sources to construct a national panel of manufactured housing productivity from 1958 to 2018.

**Census Manufactured Housing Survey (MHS).** The MHS provides annual counts of manufactured home shipments and placements, average sales prices by unit type (single-wide and double-wide), and state-level shipment detail. The shipments series extends back to 1959.

<!--
**County Business Patterns (CBP).** I use the harmonized CBP panel from @eckert_early_2022 through 2016 and splice in Census API data from 2017 onward for NAICS 321991 (Manufactured Home Manufacturing).
-->

**NBER-CES Manufacturing Industry Database.** The NBER-CES database provides annual data on employment, value added, shipments, materials costs, capital stocks, and total factor productivity for all U.S. manufacturing industries at the six-digit NAICS level from 1958 to 2018 [@becker_nber-ces_2021]. Value added is deflated using the industry-specific shipments price deflator, and the four-factor TFP index accounts for labor, capital, energy, and materials inputs.

# Results

## Physical output per employee

I first examine units of housing output per employee for manufactured housing. MH shipments per worker averaged above five units per employee through the mid-1990s, then fell sharply to roughly 2.5 units by the mid-2000s.

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

I adjust for this shift by constructing a price-weighted Fisher aggregate of single- and double-wide placements per employee. This measure accounts for the shift in the mix of units over time by weighting the quantity of single- and double-wide placements by their prices. Importantly, it cannot capture quality improvements within unit types. The Fisher aggregate shows a similar post-2000 decline, though the drop is slightly less severe.

Beyond the shift toward double-wides, several other forces may depress measured physical output per worker. First, the scope of in-house production appears to have expanded over time. Many factories now build their own cabinetry and other components in-house rather than purchasing prefabricated inputs — a change that adds labor to the factory payroll (reducing units per worker) even as it lowers total cost by eliminating supplier markups. Second, the shift toward double-wide homes introduces its own inefficiencies. Double-section homes are typically built with a "wet" side (containing plumbing and electrical) and a "dry" side, which move in parallel along the assembly line. Because the wet side requires substantially more labor, the dry-side station carries slack, and the overall line speed is dictated by the slower station. This bottleneck reduces throughput per worker *in the factory* even as it economizes on installation labor at the site.

## Real value added per employee

I turn next to a measure of real value added per employee from the NBER-CES database. In contrast to the physical output measure, labor productivity shows a long upward trend since 1958: from a base of \$22,000, real value added per worker roughly tripled over the next forty years to \$63,000 (1997 dollars). Post-2000, value-added stagnated but did not fall, and by the late 2010s value added per employee remained near its peak.

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

At the same time, however, the industry performed much worse than comparable manufacturing sectors. Wood product manufacturing industries grew steadily through the 2000s, ending the 2010s with nearly double the real value added per employee of MH despite starting at a similar level in the 1990s.\footnote{Falling input prices, such as lumber, could in principle affect measured real value added per worker. However, other wood product manufacturing industries faced the same input price changes, so this force alone cannot explain the MH-specific divergence.}

The most likely explanation for the divergence between raw output and value-added measures is that the composition of output shifted towards higher-quality, more expensive units. Several forces drove this shift. The federal HUD code has grown substantially more stringent over the past two decades, with successive rounds of stricter energy-efficiency, wind-resistance, and thermal standards that require more labor and materials per unit. These code changes raised the minimum quality of every manufactured home, adding labor content even when the basic floor plan was unchanged. At the same time, the loss of the low-end chattel-lending market after 2000 pushed surviving producers toward higher-specification products for buyers who could qualify for conventional financing. More recently, the industry has developed "CrossMod" homes — manufactured units built to standards comparable to site-built housing, with features like pitched roofs, permanent foundations, and drywall interiors — that are eligible for appraisal as real property. These quality improvements are real but largely invisible to the PPI-based deflator, which tracks fixed product categories and does not adjust for within-category upgrades.

## Total factor productivity

Finally, I plot the NBER-CES four-factor TFP index, which adjusts for labor, capital, energy, and materials inputs, for manufactured housing and Domar-weighted aggregates of other manufacturing industries.[^3] The story is quite similar to value added: MH TFP rose steadily between 1960 and 1999, then declined precipitously to 0.54 by 2013. The partial recovery to 0.65 by 2016 still leaves TFP well below its level in 1960.

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

[^3]: Aggregate TFP series for comparison groups are constructed following @domar_measurement_1961. For each group, the annual TFP growth rate is a weighted average of constituent industries' four-factor TFP growth rates, where the weight on each industry is its lagged gross output (shipments) as a share of the group's lagged aggregate value added. These Domar weights sum to greater than one, reflecting the fact that an industry's productivity gain raises the effective output of downstream users of its products. The weighted growth rates are cumulated from a base of 1.0 in 1997.

The juxtaposition of the figures above implies that labor productivity recovered only through capital deepening: firms invested in more capital per worker, but the efficiency with which they combine all inputs deteriorated dramatically. Manufactured housing factories, despite their controlled environment, standardized processes, and federal regulation, have not escaped the forces holding down construction productivity.

# Discussion

The TFP collapse after 1998 coincides almost exactly with the demand shock that hit manufactured housing when the subprime chattel-lending channel dried up. MH shipments fell from roughly 375,000 units per year at their late-1990s peak to fewer than 80,000 by the mid-2000s, a massive decline from which the industry has never recovered. One interpretation of the TFP decline is that it reflects lost economies of scale rather than technological regress.

The scale interpretation has both within-plant and market-level dimensions. Within each factory, high fixed costs — the plant itself, jigs, tooling, and quality-control infrastructure — must be spread over output. When volumes collapsed, factories that once operated at efficient scale were left with excess capacity, mechanically depressing measured productivity. But the geographic fragmentation of the industry compounds this problem. Transport costs for finished manufactured homes are steep (about \$13--14 per mile), so each factory serves a limited radius [@jensen_manufactured_2024]. Unlike a typical manufacturing industry, MH producers cannot respond to falling demand by consolidating into fewer, larger plants: a factory in Alabama cannot absorb the customers of a shuttered plant in Oregon. Some regional markets may simply be unable to sustain a factory at efficient scale, with no prospect of consolidation.

The severity of the demand shock also makes it unlikely that standard reallocation forces offset the productivity decline. In a Melitz-style framework, negative demand shocks should induce the least productive firms to exit, raising average productivity among survivors. The fact that MH TFP fell sharply despite substantial industry contraction suggests that the loss of scale economies dominated any cleansing effect from the exit of low-productivity plants.

Scale losses alone, however, cannot fully explain the MH productivity record. The industry has also been remarkably slow to adopt production methods that are standard in other manufacturing sectors. Most MH factories still rely on hand tools and manual assembly; CNC machines are present in some plants but remain the exception. Few factories use software to manage production flows — many still track units along the line with paper — and none, to my knowledge, employ digital-twin approaches to coordinate design and manufacturing. Assembly lines are typically single-line configurations with no satellite stations, so a bottleneck at any point holds up the entire plant. Factories generally run all stations fully staffed whenever the line is operating, carrying substantial slack labor rather than dynamically reallocating workers to stations with the heaviest workload. These are not technologically frontier problems; they are failures to adopt basic industrial-engineering practices that have been routine elsewhere for decades.

The industry's insularity likely contributes to this stagnation. There is little movement of talent between MH and other manufacturing sectors, limiting the diffusion of knowledge about modern production methods. Leadership tenure within the industry is long, and few younger entrants bring experience from outside. The labor force has also changed: experienced line workers from the industry's peak years have retired, and factories increasingly hire on the basis of low hourly cost rather than skill. The geographic isolation of MH plants — disproportionately located in rural areas, far from the agglomerations where manufacturing knowledge tends to accumulate and diffuse — compounds the problem. The Marshallian externalities that drive productivity growth in clustered industries — labor pooling, supplier specialization, and knowledge spillovers — are largely absent.

These industry-specific forces shed light on the broader construction productivity puzzle. @damico_why_2024 argue that fragmented local regulations prevent large, efficient site-builders from producing standardized homes on large greenfield sites, a mode of production that was historically more common and which contributed to the industry's productivity growth in the years after World War II. But the MH evidence suggests that removing regulatory barriers to scale is not sufficient: even within a controlled factory environment, with a single federal building code and no permitting or land-assembly frictions, the industry has failed to adopt basic process improvements. The implication is that the construction productivity puzzle reflects not just site-specific regulatory barriers but a deeper set of forces — demand volatility, geographic fragmentation, and the resulting failure to attract talent and investment in process innovation — that operate across both site-built and factory-built housing.

The scale interpretation does, however, have a silver lining. If part of the post-2000 productivity collapse reflects lost volume rather than permanent technological regress, then factories *can* be efficient — they just need demand. Reforms to titling and financing — for example, making manufactured homes eligible for conventional mortgage products — could expand the buyer pool and set off a virtuous cycle: higher volumes would lower unit costs, which would lower prices, which would attract additional buyers at the margin. Because the industry is likely operating on the steep portion of its average cost curve, even modest demand increases could yield disproportionate productivity gains.

The geographic structure of the industry, however, limits how far this logic can run. Because high transport costs confine each factory to a limited radius, national demand growth must translate into *regionally distributed* demand growth to restore scale at individual plants. Full recovery to 1990s volumes appears unlikely given secular headwinds — falling fertility, regulatory fragmentation, and the permanent loss of the subprime chattel-lending channel. And as the evidence here suggests, restoring volume alone may not be sufficient without also modernizing production methods and attracting the talent to implement them. For both site-built and manufactured homes, structural features of the industry limit the size of the market, prevent learning-by-doing, and raise the cost of housing.

# References