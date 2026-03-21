# manufactured-productivity

## County Business Patterns Data

Data downloaded from https://www.fpeckert.me/cbp/ on 3/20/2026.

Abstract:
The County Business Patterns data published by the US Census Bureau track employment by county and industry from 1946 to the present. Two features of the data limit their usefulness to researchers: (1) employment for the majority of county-industry cells is suppressed to protect confidentiality, and (2) industry classifications change over time. We address both issues. First, we develop a linear programming method that exploits the large set of adding-up constraints implicit in the hierarchical arrangement of the data to impute missing employment. Second, we provide concordances to map all data to a consistent set of industry codes. Finally, we construct a user-friendly, 1975 to 2018 county-level panel that classifies industries according to a consistent set of 2012 NAICS codes in all years.

The NAICS long panel records employment at the most detailed industry-county level of aggregation possible. The sum of all observations in this panel represents the national total. For reasons explained in detail in our working paper, it is not always possible to assign employment to a six-digit NAICS code. In these cases, the employment is attributed to a more aggregate code, e.g., 11////.   

We note that unlike in the raw CBP data and the text, where we describe codes such as 11//// as a root that contains the sum of all codes that are more detailed than 11////, that is not what codes of this form represent in the long panel. Instead, the roots in this dataset contain the remainder of 11//// employment that we could not assign to a more disaggregated NAICS code.  Users can obtain the total 11//// employment by summing employment over all codes that start with 11.

NB: Census changed the way the CBP data are reported starting in 2017. For these years, Census now perturbs cells with small employment counts, making these data fundamentally different from earlier periods. We do not impute data in those years since there are no missing cells in the data. We nevertheless appended 2017 and 2018 to the panel for completeness. Note that the 2017 and 2018 data are reported on a NAICS2017 basis.