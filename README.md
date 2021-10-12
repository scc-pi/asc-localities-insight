# Sheffield Adult Social Care localities insight.  

Dashboard: [scc-pi.github.io/asc-localities-insight](https://scc-pi.github.io/asc-localities-insight/)

The purpose is to provide some baseline statistics and mapping around Sheffield's ASC (Adult Social Care) localities for the [ASC strategic needs analysis project](https://github.com/scc-pi/ASC_SNA).  

SLI ([Sheffield Local Insight](https://sheffield.communityinsight.org/)) is used to obtain the data. An API for SLI is estimated to be available August 2022. Until then, the data for a bespoke dashboard is exported manually for each SLI theme e.g. population. To create a bespoke dashboard to export you need an [SLI login](https://local.communityinsight.org/login/).

There are 7 ASC localities and they are identical to the Local Area Committees which are already on SLI.

The process is:
1. `asc_sli_etl.R` prepares the SLI data  
1. `asc_localities_etl.R` prepares the ASC locality boundary data  
1. `sli_measures.xls` is used to specify which themes and measures to include  
1. `asc_sli_dashboard.Rmd` produces the [flexdashboard](https://pkgs.rstudio.com/flexdashboard/) HTML file  