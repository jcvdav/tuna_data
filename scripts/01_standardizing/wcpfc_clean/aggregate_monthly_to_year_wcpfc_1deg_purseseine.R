################################################################################
# Clean WCPFC purse seine data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script processes cleaned purse seine tuna catch and effort at a 1x1 degree
# monthly resolution from the WCPFC and aggregates it to 1x1 degree yearly resolution.
#
#
# Note: Some earlier reportings of catch and effort show up as decimals.
#
################################################################################
# SET UP #######################################################################

library(tidyverse)

## Load data -------------------------------------------------------------------

wcpfc <- readRDS("data/processed/wcpfc/wcpfc_month_1deg_purseseine.rds")

# PROCESSING ###################################################################

wcpfc_year <- wcpfc |>
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
  select(
    rfmo, lon, lat, year,
    effort_set, effort_day,
    catch_tot, catch_skj,
    catch_alb, catch_bet
  )

# EXPORT #######################################################################

saveRDS(wcpfc_year, "data/processed/wcpfc/wcpfc_year_1deg_purseseine.rds")
