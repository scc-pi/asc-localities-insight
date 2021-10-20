# HEADER ---------------------
# Description: Get data from SLI (Sheffield Local Insight) for ASC localities
#              https://sheffield.communityinsight.org/
# Author: Laurie Platt

# SETUP -------------------------
library(tidyverse); library(fs)

# Disable use of scientific notation
options(scipen=999)

## Local variables --------------

# Location of the data exported from SLI (Sheffield Local Insight)
sli_data_folder <- str_c(
  "S:/Public Health/Policy Performance Communications/Business Intelligence/",
  "Projects/AdultSocialCare/ASC_SNA/demographics/SLI bespoke dashboard export")

# Location of data we're using for maps
map_data_folder <- str_c(
  "S:/Public Health/Policy Performance Communications/Business Intelligence/",
  "Projects/AdultSocialCare/ASC_SNA/demographics/data")

# Name of the file we're going to create 
asc_sli_file <- "df_asc_sli.rds"

# READ & TRANSFORM --------------------

# Get a list of CSV files
theme_csv_files <- dir_ls(sli_data_folder, glob = "*.csv") %>% 
  basename()

# We need an empty data frame for the subsequent to add to
df_asc_sli <- tibble()

# Cumulate SLI data from each theme export
for (theme_file in theme_csv_files) {

  # Get the theme name from the filename
  theme_name <- str_split(theme_file, "_")[[1]][1]
  
  # Read and transform exported data for each theme 
  df_theme <- read_csv(str_c(sli_data_folder, "/", theme_file)) %>% 
    rename(area_type = 1, area = 2) %>% 
    filter(area_type == "Local Area Committees") %>% 
    mutate(theme = theme_name, .after = area) %>% 
    select(-area_type) %>% 
    pivot_longer(!c(area, theme), names_to = "measure")
  
  # Add each theme's data to a single data frame 
  df_asc_sli <- bind_rows(df_asc_sli, df_theme)
}

# WRITE -------------------------

# Write the SLI ASC localities data to a folder so we can quickly use it in R
write_rds(df_asc_sli, str_c(map_data_folder, "/", asc_sli_file))