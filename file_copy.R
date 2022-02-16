# HEADER ---------------------
# Description:  Copy output files from a local folder to a network folder
#               to  share with the rest of the team
# Author: Laurie Platt
# Note: The common paths aren't set as variables, so that the file copy/update
#       can be done running a single line of code.

# TO S:\PH\PPC\BI\Projects... ----

# asc_sli_dashboard.html ----
fs::file_copy(
  "asc_sli_dashboard.html",
  stringr::str_c(
    "S:/Public Health/Policy Performance Communications/",
    "Business Intelligence/Projects/AdultSocialCare/ASC_SNA/output/",
    "asc_sli_dashboard.html"),
  overwrite = TRUE)


# TO S:\BI Team\ASC-SNA ----

## asc_sli_dashboard.html ----
fs::file_copy(
  "asc_sli_dashboard.html",
  stringr::str_c(
    "S:/BI Team/ASC-SNA/",
    "asc_sli_dashboard.html"),
  overwrite = TRUE)
