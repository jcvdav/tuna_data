################################################################################
# Clean WCPFC purse seine data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script processes raw purse seine tuna catch and effort at the monthly
# resolution and aggregates it to a yearly, 1 degree resolution.
#
################################################################################
# SET UP #######################################################################

library(tidyverse)
library(stringr)
library(janitor)

## Load data -------------------------------------------------------------------

month_1deg_raw <- read_csv(
  "data/raw/wcpfc/month_1deg_purseseine/WCPFC_S_PUBLIC_BY_YY_MM_1x1/WCPFC_S_PUBLIC_BY_YY_MM_1x1.csv"
) |>
  clean_names()

## Build function to clean and center lat/lon variables ------------------------

parse_and_center <- function(x, offset = 0) {
  x <- trimws(x)
  val <- str_extract(x, "[0-9.]+") |> as.numeric()
  sign <- ifelse(str_detect(x, "[SW]$"), -1, 1)
  val * sign + offset
}

# PROCESSING ###################################################################

wcpfc_year <- month_1deg_raw |>
  rename(
    year = yy,
    month = mm,
    effort_day = days
  ) |>
  mutate(
    # Convert SW corner to center
    lat = parse_and_center(lat1, offset = 0.5),
    lon = parse_and_center(lon1, offset = 0.5),

    # Total sets across all set types
    effort_set = rowSums(across(
      c(sets_una, sets_log, sets_dfad, sets_afad, sets_oth)
    ), na.rm = TRUE),

    # Species-specific catches
    catch_skj = rowSums(across(
      c(skj_c_una, skj_c_log, skj_c_dfad, skj_c_afad, skj_c_oth)
    ), na.rm = TRUE),

    catch_bet = rowSums(across(
      c(bet_c_una, bet_c_log, bet_c_dfad, bet_c_afad, bet_c_oth)
    ), na.rm = TRUE),

    catch_alb = 0,  # ALB not reported in WCPFC PS data

    catch_tot = catch_skj + catch_bet + catch_alb,

    rfmo = "wcpfc",

    # Remove effort when no focal species caught
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
  select(
    rfmo, lon, lat, year,
    effort_set, effort_day,
    catch_tot, catch_skj,
    catch_alb, catch_bet
  )

# EXPORT #######################################################################

saveRDS(wcpfc_year, "data/processed/wcpfc/wcpfc_year_1deg_purseseine.rds")
