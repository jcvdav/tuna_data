################################################################################
# Build ICCAT yearly data set
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script processes raw purse seine tuna catch and effort data from
# ICCAT at the 1 degree, yearly level.
#
################################################################################

# SET UP #######################################################################

library(tidyverse)
library(janitor)

## Load data -------------------------------------------------------------------
data <- readRDS("data/raw/iccat/ms_database_all/t2ce_20260130/ICCAT_database.rds") |>
  (\(x) x$t2ce)() |>
  clean_names()

## Build function to center lat/lon from SW corner
center_iccat <- function(lat, lon, quad_id) {
  lat_sign <- case_when(
    quad_id %in% c(1, 4) ~  1,
    quad_id %in% c(2, 3) ~ -1
  )
  lon_sign <- case_when(
    quad_id %in% c(1, 2) ~  1,
    quad_id %in% c(3, 4) ~ -1
  )

  tibble(
    lat = lat_sign * lat + 0.5,
    lon = lon_sign * lon + 0.5
  )
}

# PROCESSING ###################################################################

iccat_year <- data |>
  filter(
    gear_grp_code == "PS",
    square_type_code == "1x1",
    d_set_type_id == ".w",     # Filter for weights only
    time_period_id < 13        # Filter for monthly data only
  ) |>
  rename(
    year = year_c,
    month = time_period_id,
    catch_skj = skj,
    catch_alb = alb,
    catch_bet = bet
  ) |>
  mutate(
    # Create variable that centers points using function
    centered = center_iccat(lat, lon, quad_id),
    lat = centered$lat,
    lon = centered$lon,
    # Name data set
    rfmo = "iccat",
    # Convert catches to metric tons, change numeric counts to NA
    catch_skj = catch_skj / 1000,
    catch_alb = catch_alb / 1000,
    catch_bet = catch_bet / 1000,
    catch_tot = catch_skj + catch_bet + catch_alb,
    # Standardize effort
    effort_set = case_when(
      eff1type == "NO.SETS" ~ eff1,
      eff2type == "NO.SETS" ~ eff2,
      TRUE ~ NA_real_
    ),
    effort_day = case_when(       # Must be updated to match WCPFC definition
      eff1type == "D.FISH" ~ eff1,
      eff2type == "D.FISH" ~ eff2,
      TRUE ~ NA_real_
    ),
    effort_set = if_else(catch_tot == 0, 0, effort_set),
    effort_day = if_else(catch_tot == 0, 0, effort_day)
  ) |>
  group_by(rfmo, lon, lat, year) |>
  summarise(
    effort_set = sum(effort_set, na.rm = TRUE),
    effort_day = sum(effort_day, na.rm = TRUE),
    catch_tot  = sum(catch_tot,  na.rm = TRUE),
    catch_skj  = sum(catch_skj,  na.rm = TRUE),
    catch_alb  = sum(catch_alb,  na.rm = TRUE),
    catch_bet  = sum(catch_bet,  na.rm = TRUE),
    .groups = "drop"
  ) |>
  arrange(year, lat, lon) |>
  select(
    rfmo, lon, lat, year,
    effort_set, effort_day,
    catch_tot, catch_skj,
    catch_alb, catch_bet
  )

# EXPORT #######################################################################
saveRDS(iccat_year, "data/processed/iccat/iccat_year_1deg_purseseine.rds")

