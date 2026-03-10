################################################################################
# Clean IATTC purse seine monthly data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script processes raw purse seine tuna catch and effort data from the
# IATTC at a 1 degree monthly resolution.
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)

## Load data -------------------------------------------------------------------
ps_tuna <- read_csv("data/raw/iattc/month_1deg_purseseine/PublicPSTuna/PublicPSTunaFlag.csv") |>
  clean_names()

## Clean data ------------------------------------------------------------------
ps_tuna_clean <- ps_tuna |>
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
    effort_day = NA_real_,                          # Placeholder for effort in days
    catch_tot = catch_skj + catch_alb + catch_bet,  # Total catch across the three species
    rfmo = "iattc"
  ) |>
  select(
    rfmo, lon, lat, year, month,
    effort_set, effort_day,
    catch_tot, catch_skj, catch_alb, catch_bet
  )

# EXPORT #######################################################################

saveRDS(ps_tuna_clean, "data/processed/iattc/iattc_month_1deg_purseseine.rds")
