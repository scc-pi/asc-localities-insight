# HEADER ---------------------
# Description: Create a spreadsheet of SLI (Sheffield Local Insight) measures.
#              Used to define what to include in the dashbaord.
# Author: Laurie Platt

# SETUP -------------------------
library(tidyverse); library(writexl)

## Local variables --------------

# Location of data we're using for maps
map_data_folder <- str_c(
  "S:/Public Health/Policy Performance Communications/Business Intelligence/",
  "Projects/AdultSocialCare/ASC_SNA/demographics/data")

# Name of the file with the SLI data (from asc_sli_etl.R)
asc_sli_file <- "df_asc_sli.rds"

# Name of the spreadsheet we're going to create 
sli_measures_file <- "sli_measures.xlsx"

# READ --------------------------

# Get the ASC SLI data
df_asc_sli <- read_rds(str_c(map_data_folder, "/", asc_sli_file)) 

# TRANSFORM ---------------------

# Get a list of Local Insight measures and themes
# (that are available for ASC localities)
df_sli_measures <- df_asc_sli %>%
  select(theme, measure) %>%
  unique() %>% 
  mutate(include = "")

# WRITE -------------------------

write_xlsx(df_sli_measures, sli_measures_file)