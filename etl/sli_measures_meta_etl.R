# HEADER ---------------------
# Description: Get the metadata for the SLI measures.
#              Used to reference source data in the dashboard.
# Author: Laurie Platt

# SETUP -------------------------
library(tidyverse); library(readxl); library(janitor)

## Local input variables --------

# Name of the spreadsheet listing the ASC SLI measures (in working directory)
sli_measures_file <- "sli_measures.xlsx"

# Location of the SLI meta file
sli_meta_folder <- str_c(
  "S:/Public Health/Policy Performance Communications/Business Intelligence/",
  "Projects/AdultSocialCare/ASC_SNA/demographics")

# Name of the file from SLI admin with the metadata for the measures
sli_meta_file <- "SLI_ind_metadata.csv"

## Local output variables -------

# Location of data we're using for maps
map_data_folder <- str_c(
  "S:/Public Health/Policy Performance Communications/Business Intelligence/",
  "Projects/AdultSocialCare/ASC_SNA/demographics/data")

# Name of file we're going to create
sli_measure_with_meta_file <- "df_sli_measure_with_meta.rds"

# READ --------------------------

# Get the ASC SLI measures
df_sli_measure <- read_xlsx(sli_measures_file)

# Get the SLI metadata
df_sli_meta <- read_csv(str_c(sli_meta_folder, "/", sli_meta_file)) 

# TRANSFORM ---------------------

# Repair some wayward encoding in the SLI metadata
df_sli_meta <- df_sli_meta %>% 
  clean_names() %>% 
  mutate(name = map_chr(name, ~str_replace(.x, "Â£", "£"))) %>% 
  mutate(date = map_chr(date, ~str_replace(.x, "â€“", "-"))) %>% 
  mutate(source = map_chr(source, ~str_replace(.x, "Â©", "©"))) %>% 
  mutate(description = map_chr(description, ~str_replace(.x, "Â£", "£"))) %>% 
  mutate(description = map_chr(description, ~str_replace(.x, "â€™", "'")))

# Join the metadata to the list of measures 
df_sli_measure_with_meta <- df_sli_measure %>% 
  left_join(df_sli_meta, by = c("measure" = "name"))

# Note: join isn't 100%
df_sli_measure_no_meta <- df_sli_measure_with_meta %>% 
  filter(is.na(source))
  
# WRITE -------------------------

# Write the SLI ASC localities data to a folder so we can quickly use it in R
write_rds(df_sli_measure_with_meta, 
          str_c(map_data_folder, "/", sli_measure_with_meta_file))
