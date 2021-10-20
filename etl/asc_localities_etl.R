# HEADER ---------------------
# Description: Get the ASC (Adult Social Care) locality boundaries from Portal.
#              Includes LAC (Local Area Community) cross-references.
# Note: Requires local ArcGIS Pro installation and license
# Author: Laurie Platt

# SETUP -------------------------
library(tidyverse); library(sf)

# Requires local ArcGIS Pro and license
library(arcgisbinding); arc.check_product() 

## Local variables --------------

# URL for ASC localities from the Council's Portal
asc_localities_url <- str_c(
  "https://sheffieldcitycouncil.cloud.esriuk.com/portal/sharing/servers/",
  "dbfe34dca2b242ea8c13bbdd3cfa632b/rest/services/AGOL/Boundaries/MapServer/2")

# Location of data we're using for maps
map_data_folder <- str_c(
  "S:/Public Health/Policy Performance Communications/Business Intelligence/",
  "Projects/AdultSocialCare/ASC_SNA/demographics/data")

# READ --------------------------

# Get ASC localities as simple features with WSG84 coordinates
sf_asc_localities <- arc.open(asc_localities_url) %>% 
  arc.select() %>% 
  arc.data2sf() %>% 
  st_transform(crs = 4326)

# TRANSFORM ---------------------

# Get X Y coordinates of ASC locality centroids [useful for geom_text()]
xy <- sf_asc_localities %>% 
  st_centroid() %>% 
  st_coordinates() %>% 
  as_tibble() 

# Add X Y coordinates to ASC locality data
sf_asc_localities <- sf_asc_localities %>% 
  bind_cols(xy) %>% 
  select(-starts_with("st_"))

# WRITE --------------------------

# Write the boundaries to a folder so we can quickly use them in R
write_rds(sf_asc_localities, 
          str_c(map_data_folder, "/sf_asc_localities.rds"))