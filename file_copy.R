# HEADER ---------------------
# Description:  Copy output files from a local folder to a network folder
#               to  share with the rest of the team
# Author: Laurie Platt


# asc_sli_dashboard.html ----
fs::file_copy(
  "asc_sli_dashboard.html",
  stringr::str_c(
    "S:/Public Health/Policy Performance Communications/",
    "Business Intelligence/Projects/AdultSocialCare/ASC_SNA/output/",
    "asc_sli_dashboard.html"),
  overwrite = TRUE)
