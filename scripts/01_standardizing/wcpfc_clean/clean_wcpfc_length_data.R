################################################################################
# Clean WCPFC length data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script cleans length data from the WCPFC. It selects for tunas measured
# using UF at a 5x5 degree resolution.
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)

length_data <- read_csv("data/raw/wcpfc/length_data/wcpfc_length_data.csv")

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

gear_lookup <- c(
  L = "longline",
  S = "purse_seine",
  P = "pole_line",
  H = "handline_large",
  K = "handline_small",
  T = "troll",
  R = "ringnet"
)

tuna_length <- length_data |>
  filter(
    astrat == "5",             # 5x5 grid only
    sp_id %in% tuna_species,   # tuna only
    len_code == "UF",          # tuna use UF
    lstrat %in% c(1, 2)) |>    # remove 5 cm bins

  mutate(
    rfmo = "wcpfc",

    # temporal
    year = as.integer(yr),
    month = ifelse(tstrat == "M", as.integer(mon), NA_integer_),
    quarter = as.integer(qtr),

    # spatial
    lat = parse_and_center(lat, offset = 2.5),
    lon = parse_and_center(lon, offset = 2.5),

    # categorical
    species = sp_id,
    gear = recode(gr, !!!gear_lookup, .default = NA_character_),

    # length data
    length_cm = as.integer(len),
    length_bin = as.integer(lstrat),
    freq = as.integer(freq),
  ) |>

  uncount(freq) |> # one row per measurement

  select(
    rfmo, lon, lat,
    year, quarter, month, tstrat, gear,
    species,
    length_cm, length_bin
  )

# EXPORT #######################################################################
saveRDS(tuna_length, "data/output/wcpfc_length_data.rds")
