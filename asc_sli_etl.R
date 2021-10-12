# HEADER ---------------------
# Description: Get data from SLI (Sheffield Local Insight) for ASC localities
#              https://sheffield.communityinsight.org/
# Author: Laurie Platt

# SETUP -------------------------
library(tidyverse)

# Disable use of scientific notation
options(scipen=999)

## Local input variables --------------

# Location of the data exported from SLI (Sheffield Local Insight)
sli_data_folder <- str_c(
  "S:/Public Health/Policy Performance Communications/Business Intelligence/",
  "Projects/AdultSocialCare/ASC_SNA/demographics/SLI bespoke dashboard export")

# Name of the file with population data exported from Local Insight
population_file <- "population_dashboard.csv"

## Local output variables --------------

# Name of the file with deprivation data exported from Local Insight
deprivation_file <- "deprivation_dashboard.csv"

# Location of data we're using for maps
map_data_folder <- str_c(
  "S:/Public Health/Policy Performance Communications/Business Intelligence/",
  "Projects/AdultSocialCare/ASC_SNA/demographics/data")

# Name of the file we're going to create 
asc_sli_file <- "df_asc_sli.rds"

# READ --------------------------

# Get the population data we've exported manually from Local Insight
df_population <- read_csv(str_c(sli_data_folder, "/", population_file)) %>% 
  rename(area_type = 1, area = 2) %>% 
  filter(area_type == "Local Area Committees") 

# Get the deprivation data we've exported manually from Local Insight
df_deprivation <- read_csv(str_c(sli_data_folder, "/", deprivation_file)) %>% 
  rename(area_type = 1, area = 2) %>% 
  filter(area_type == "Local Area Committees")

# TRANSFORM ---------------------

# Filter the rows and columns we need
df_population <- df_population %>% 
  filter(area_type == "Local Area Committees") %>% 
  mutate(theme = "population", .after = area) %>% 
  select(-area_type) %>% 
  pivot_longer(!c(area, theme), names_to = "measure")

# Same as above but for deprivation - TODO: change to a loop
df_deprivation <- df_deprivation %>% 
filter(area_type == "Local Area Committees") %>% 
  mutate(theme = "deprivation", .after = area) %>% 
  select(-area_type) %>% 
  pivot_longer(!c(area, theme), names_to = "measure")

# Combine data for all themes
df_asc_sli <- bind_rows(df_population, df_deprivation)

# WRITE -------------------------

# Write the SLI ASC localities data to a folder so we can quickly use it in R
write_rds(df_asc_sli, str_c(map_data_folder, "/", asc_sli_file))