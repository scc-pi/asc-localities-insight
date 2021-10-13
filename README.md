# Sheffield Adult Social Care localities insight  

Dashboard: [scc-pi.github.io/asc-localities-insight](https://scc-pi.github.io/asc-localities-insight/)

Project board: [github.com/scc-pi/asc-localities-insight/projects/1](https://github.com/scc-pi/asc-localities-insight/projects/1)  

The purpose is to provide some baseline statistics and mapping around Sheffield's ASC (Adult Social Care) localities for the [ASC strategic needs analysis project](https://github.com/scc-pi/ASC_SNA).  

SLI ([Sheffield Local Insight](https://sheffield.communityinsight.org/)) is used to obtain the data. An API for SLI is estimated to be available August 2022. Until then, the data for a bespoke dashboard is exported manually for each SLI theme e.g. population. To create a bespoke dashboard to export you need an [SLI login](https://local.communityinsight.org/login/).

SLI is geared towards providing information one area at a time. This dashboard is geared towards comparing the ASC localities against each other.

There are 7 ASC localities and they are identical to the Local Area Committees which are already on SLI.

The process is:
1. `asc_sli_etl.R` prepares the SLI data  
1. `asc_localities_etl.R` prepares the ASC locality boundary data  
1. `sli_measures.xls` is used to specify which themes and measures to include  
1. `asc_sli_dashboard.Rmd` produces the [flexdashboard](https://pkgs.rstudio.com/flexdashboard/) HTML file  

It will not take the inclusion of too many measures to make the HTML file too big and slow it down. If a lot of measures need to be included it would be better as a [Shiny](https://shiny.rstudio.com/) dashboard, and because the data is publicly available it could be hosted on [shinyapps.io](https://www.shinyapps.io/).

The code in this repo is largely derived from:  
- [Let’s Make a Map in R](https://medium.com/@traffordDataLab/lets-make-a-map-in-r-7bd1d9366098) blog by Trafford Data Lab (February 2018)  
- [Dynamically Rendered Flexdashboard Pages Using RMarkdown Childs](https://somtom.github.io/post/using-dynamically-rendered-r-markdown-childs-for-reports/) blog by SOMTOM (January 2019)  

A similar debt is owed to the books [R for Data Science](https://r4ds.had.co.nz/) and [Geocomputation with R](https://geocompr.robinlovelace.net/).