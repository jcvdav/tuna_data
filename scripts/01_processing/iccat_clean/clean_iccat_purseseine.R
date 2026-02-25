################################################################################
# Clean ICCAT purse seine data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script processes raw purse seine tuna catch and effort data from the
# ICCAT at the 1 degree, monthly level.
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)

## Load data -------------------------------------------------------------------
data <- readRDS("data/raw/iccat/ms_database_all/t2ce_20260130/ICCAT_database.rds") |>
  (\(x) x$t2ce)() |>
  clean_names()

## Build function to center lat/lon from SW corner

center_iccat <- function(lat, lon, quad_id) {
  lat_sign <- case_when(
    quad_id %in% c(1, 4) ~  1,   # NE, NW
    quad_id %in% c(2, 3) ~ -1    # SE, SW
  )
  lon_sign <- case_when(
    quad_id %in% c(1, 2) ~  1,   # NE, SE
    quad_id %in% c(3, 4) ~ -1    # SW, NW
  )

  tibble(
    lat = lat_sign * lat + 0.5,
    lon = lon_sign * lon + 0.5
  )
}

# PROCESSING ###################################################################

## Clean data ------------------------------------------------------------------
iccat <- data |>
  filter(gear_grp_code == "PS",
         square_type_code == "1x1",
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
    rfmo = "iccat",
    # Convert catches to metric tons, change numeric counts to NA
    catch_skj = case_when(
      catch_unit == "kg" ~ catch_skj / 1000,
      catch_unit == "nr" ~ NA_real_
    ),
    catch_alb = case_when(
      catch_unit == "kg" ~ catch_alb / 1000,
      catch_unit == "nr" ~ NA_real_
    ),
    catch_bet = case_when(
      catch_unit == "kg" ~ catch_bet / 1000,
      catch_unit == "nr" ~ NA_real_
      ),
    catch_tot = catch_skj + catch_bet + catch_alb,
    # Standardize effort
    effort_set = case_when(
      eff1type == "NO.SETS" ~ eff1,
      eff2type == "NO.SETS" ~ eff2,
      TRUE ~ NA_real_
    ),
    effort_day = case_when(
      eff1type == "D.FISH" ~ eff1,
      eff2type == "D.FISH" ~ eff2,
      TRUE ~ NA_real_
    ),
    effort_set = if_else(catch_tot == 0, 0, effort_set),  # Remove effort when focus species not caught
    effort_day = if_else(catch_tot == 0, 0, effort_day)
  ) |>
select(
  rfmo, lon, lat, year, month,
  effort_set, effort_day,
  catch_tot, catch_skj,
  catch_alb, catch_bet
)

# EXPORT #######################################################################
saveRDS(iccat, "data/processed/iccat/iccat_month_1deg_purseseine.rds")
