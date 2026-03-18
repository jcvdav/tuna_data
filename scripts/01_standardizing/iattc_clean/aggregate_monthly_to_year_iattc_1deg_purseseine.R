################################################################################
# Clean IATTC purse seine yearly data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This script takes cleaned purse seine tuna catch and effort at the monthly,
# 1x1 degree resolution and aggregates it to a yearly, 1x1 degree degree resolution.
#
################################################################################

# SET UP #######################################################################

library(tidyverse)

## Load data -------------------------------------------------------------------
iccat <- readRDS("data/processed/iattc/iattc_month_1deg_purseseine.rds")

## Clean and aggregate to yearly -----------------------------------------------
iattc_year <- iccat |>
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
