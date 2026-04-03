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
# Note: Decimals appear in earlier reporting.
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)

## Load data -------------------------------------------------------------------
ps_tuna <- read_csv("data/raw/iattc/month_1deg_purseseine_flag/PublicPSTuna/PublicPSTunaFlag.csv") |>
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
    catch_bet = bet,
    catch_yft = yft
  ) |>
  mutate(
    effort_day = NA_real_,  # Placeholder for effort in days
    rfmo = "iattc"
  ) |>
  # Total catch across the three species (sums if NAs exist)
  mutate(
    catch_tot = rowSums(across(c(catch_skj, catch_alb, catch_bet, catch_yft)), na.rm = TRUE)
  ) |>
  # Remove all NA or all 0 species rows
  filter(
    !if_all(c(catch_skj, catch_alb, catch_bet, catch_yft), is.na),        # remove rows where all are NA
    !if_all(c(catch_skj, catch_alb, catch_bet, catch_yft), ~ .x == 0)    # remove rows where all are 0
  ) |>
  select(
    rfmo, lon, lat, year, month,
    effort_set, effort_day,
    catch_tot, catch_skj, catch_alb, catch_bet, catch_yft
  )

# EXPORT #######################################################################

saveRDS(ps_tuna_clean, "data/processed/iattc/iattc_month_1deg_purseseine.rds")
