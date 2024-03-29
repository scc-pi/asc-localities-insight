# HEADER ---------------------
# Description: Create a spreadsheet with indicators in, at the locality, ward & 
#              neighbourhood level i.e. one table for each.
# Author: Laurie Platt
# NOTE: Code is inefficient in terms of both number of lines and the time it
#       takes to run. Efficient though in terms of how quickly it was written!
#       Not something to copy and paste though.

# SETUP -------------------------
library(tidyverse); library(fs); library(writexl); library(sf)

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
  "Projects/AdultSocialCare/ASC_SNA/data")

# Name of the file with the ASC locality boundaries
asc_localities_sf_file <- "sf_asc_localities.rds"

# Name of the file we're going to create 
sli_areas_file <- "sli_areas.xlsx"

# READ & TRANSFORM --------------------

# Get a list of CSV files
theme_csv_files <- dir_ls(sli_data_folder, glob = "*.csv") %>% 
  basename()

## ASC localities ------

# Get the ASC locality boundaries with cross-references to LACs
df_asc_ca_lkup <- read_rds(str_c(map_data_folder,
                                  "/", asc_localities_sf_file)) %>% 
  as_tibble() %>% 
  select(ca_name, asc_name)

# We need an empty data frame for the subsequent to add to
df_sli_asc <- tibble()

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
  df_sli_asc <- bind_rows(df_sli_asc, df_theme)
}

# A column for each measure
df_sli_asc <- df_sli_asc %>% 
  select(-theme) %>% 
  pivot_wider(names_from = measure) %>% 
  left_join(df_asc_ca_lkup, by = c("area" = "ca_name")) %>% 
  relocate(asc_name, .before = 1) %>% 
  select(-area) %>% 
  rename(area = asc_name) %>% 
  arrange(area)

## Wards ------

# We need an empty data frame for the subsequent to add to
df_sli_ward <- tibble()

# Cumulate SLI data from each theme export
for (theme_file in theme_csv_files) {
  
  # Get the theme name from the filename
  theme_name <- str_split(theme_file, "_")[[1]][1]
  
  # Read and transform exported data for each theme 
  df_theme <- read_csv(str_c(sli_data_folder, "/", theme_file)) %>% 
    rename(area_type = 1, area = 2) %>% 
    filter(area_type == "Sheffield Wards") %>% 
    mutate(theme = theme_name, .after = area) %>% 
    select(-area_type) %>% 
    pivot_longer(!c(area, theme), names_to = "measure")
  
  # Add each theme's data to a single data frame 
  df_sli_ward <- bind_rows(df_sli_ward, df_theme)
}

# A column for each measure
df_sli_ward <- df_sli_ward %>% 
  select(-theme) %>% 
  pivot_wider(names_from = measure)

## Neighbourhoods ------

# We need an empty data frame for the subsequent to add to
df_sli_neighbourhood <- tibble()

# Cumulate SLI data from each theme export
for (theme_file in theme_csv_files) {
  
  # Get the theme name from the filename
  theme_name <- str_split(theme_file, "_")[[1]][1]
  
  # Read and transform exported data for each theme 
  df_theme <- read_csv(str_c(sli_data_folder, "/", theme_file)) %>% 
    rename(area_type = 1, area = 2) %>% 
    filter(area_type == "Sheffield Neighbourhoods") %>% 
    mutate(theme = theme_name, .after = area) %>% 
    select(-area_type) %>% 
    pivot_longer(!c(area, theme), names_to = "measure")
  
  # Add each theme's data to a single data frame 
  df_sli_neighbourhood <- bind_rows(df_sli_neighbourhood, df_theme)
}

# A column for each measure
df_sli_neighbourhood <- df_sli_neighbourhood %>% 
  select(-theme) %>% 
  pivot_wider(names_from = measure)

# WRITE -------------------------

# Write the different tables to a single spreadsheet
write_xlsx(list(ASC = df_sli_asc,
                Ward = df_sli_ward,
                Neighbourhood = df_sli_neighbourhood), 
           str_c(map_data_folder, "/", sli_areas_file))