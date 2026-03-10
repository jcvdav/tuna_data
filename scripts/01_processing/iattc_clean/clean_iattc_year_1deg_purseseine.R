################################################################################
# Clean IATTC purse seine yearly data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script processes raw purse seine tuna catch and effort at the monthly
# resolution and aggregates it to a yearly, 1 degree resolution
#
################################################################################

# SET UP #######################################################################

library(tidyverse)
library(janitor)

## Load data -------------------------------------------------------------------
ps_tuna <- read_csv("data/raw/iattc/month_1deg_purseseine/PublicPSTuna/PublicPSTunaFlag.csv") |>
  clean_names()

## Clean and aggregate to yearly -----------------------------------------------
iattc_year <- ps_tuna |>
  rename(
    year = year,
    month = month,
    lat = lat_c1,
    lon = lon_c1,
    effort_set = num_sets,
    catch_skj = skj,
    catch_alb = alb,
    catch_bet = bet
  ) |>
  mutate(
    catch_tot = catch_skj + catch_alb + catch_bet,
    effort_day = NA_real_,     # IATTC does not report days
    rfmo = "iattc"
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
saveRDS(iattc_year, "data/processed/iattc/iattc_year_1deg_purseseine.rds")
