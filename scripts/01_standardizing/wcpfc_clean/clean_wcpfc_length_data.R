################################################################################
# Clean WCPFC length data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script cleans length data from the WCPFC.
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)

length_data <- read_csv("data/raw/wcpfc/length_data/LF_PUBLIC/LF_PUBLIC.csv")

## Build function to clean and center lat/lon variables ------------------------

### 1° grid → offset = 0.5°
### 5° grid → offset = 2.5°

parse_and_center <- function(x, offset = 0) {
  x <- trimws(x)
  val <- str_extract(x, "[0-9.]+") |> as.numeric()
  sign <- ifelse(str_detect(x, "[SW]$"), -1, 1)
  val * sign + offset
}

# Clean data -------------------------------------------------------------------

tuna_species <- c("ALB", "BET", "SKJ", "YFT")

tuna_length <- length_data |>
  filter(astrat == "5") |>      # 5×5 grid only
  filter(sp_id %in% tuna_species) |>   # tuna only
  filter(len_code == "UF") |>   # tuna use UF

  mutate(
    rfmo = "wcpfc",

    # temporal
    year    = as.integer(yr),
    month   = ifelse(tstrat == "M", as.integer(mon), NA_integer_),
    quarter = as.integer(qtr),

    # spatial
    lat = parse_and_center(lat, offset = 2.5),
    lon = parse_and_center(lon, offset = 2.5),

    # other
    species     = sp_id,
    gear        = gr,
    length_cm   = as.integer(len),
    length_bin  = as.integer(lstrat),
    length_type = len_code,
    freq        = as.integer(freq),
  ) |>

  select(
    rfmo, lon, lat,
    year, quarter, month, gear,
    species,
    length_cm, length_bin, length_type, freq
  )

# EXPORT #######################################################################
saveRDS(tuna_length, "data/output/wcpfc_legth_data")
