################################################################################
# Clean WCPFC purse seine data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script processes raw purse seine tuna catch and effort data from the
# WCPFC at various spatial and temporal resolutions.
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)
library(stringr)

## Load data -------------------------------------------------------------------

month_1deg_raw <- read_csv("data/raw/wcpfc/month_1deg_purseseine/WCPFC_S_PUBLIC_BY_YY_MM_1x1/WCPFC_S_PUBLIC_BY_YY_MM_1x1.csv") |>
  clean_names()

month_5deg_raw <- read_csv("data/raw/wcpfc/month_5deg_purseseine/WCPFC_S_PUBLIC_BY_YY_MM/WCPFC_S_PUBLIC_BY_YY_MM.csv") |>
  clean_names()

quarter_1deg_flag_raw <- read_csv("data/raw/wcpfc/quarter_1deg_purseseine_flag/WCPFC_S_PUBLIC_BY_YY_QTR_FLAG_0/WCPFC_S_PUBLIC_BY_YY_QTR_FLAG.csv") |>
  clean_names()
colnames(quarter_1deg_flag_raw)

quarter_5deg_flag_raw <- read_csv("data/raw/wcpfc/quarter_5deg_purseseine_flag/WCPFC_S_PUBLIC_BY_YY_QTR_FLAG/WCPFC_S_PUBLIC_BY_YY_QTR_FLAG.csv") |>
  clean_names()

year_5deg_flag_raw <- read_csv("data/raw/wcpfc/year_5deg_purseseine_flag/WCPFC_S_PUBLIC_BY_YY_FLAG/WCPFC_S_PUBLIC_BY_YY_FLAG.csv") |>
  clean_names()

## Build function to clean and center lat/lon variables ------------------------

### 1° grid → offset = 0.5°
### 5° grid → offset = 2.5°

parse_and_center <- function(x, offset = 0) {
  x <- trimws(x)
  val <- str_extract(x, "[0-9.]+") |> as.numeric()
  sign <- ifelse(str_detect(x, "[SW]$"), -1, 1)
  val * sign + offset
}

## Clean data ------------------------------------------------------------------
### month, 1 deg, no flag
month_1deg_clean <- month_1deg_raw |>
  rename(
    year = yy,
    month = mm,
    effort_day = days
  ) |>
  # Convert SW corner to center
  mutate(
    lat = parse_and_center(lat1, offset = 0.5),   # Convert SW corner to center
    lon = parse_and_center(lon1, offset = 0.5),
    effort_set = rowSums(across(
      c(sets_una, sets_log, sets_dfad, sets_afad, sets_oth)), na.rm = TRUE),   # Total sets across all set types
    catch_skj = rowSums(across(
      c(skj_c_una, skj_c_log, skj_c_dfad, skj_c_afad, skj_c_oth)), na.rm = TRUE),  # Species specific catches
    catch_bet = rowSums(across(
      c(bet_c_una, bet_c_log, bet_c_dfad, bet_c_afad, bet_c_oth)), na.rm = TRUE),
    catch_alb = 0,  # ALB not reported in WCPFC PS data
    catch_tot = catch_skj + catch_bet + catch_alb
  ) |>
  select(
    lon, lat, year, month,
    effort_set, effort_day,
    catch_tot, catch_skj,
    catch_alb, catch_bet
  )

### month, 5 deg, no flag
month_5deg_clean <- month_5deg_raw |>
  rename(
    year = yy,
    month = mm,
    effort_day = days
  ) |>
  # Convert SW corner to center
  mutate(
    lat = parse_and_center(lat5, offset = 2.5),   # Convert SW corner to center
    lon = parse_and_center(lon5, offset = 2.5),
    effort_set = rowSums(across(
      c(sets_una, sets_log, sets_dfad, sets_afad, sets_oth)), na.rm = TRUE), # Total sets across all set types
    catch_skj = rowSums(across(
      c(skj_c_una, skj_c_log, skj_c_dfad, skj_c_afad, skj_c_oth)), na.rm = TRUE),  # Species specific catches
    catch_bet = rowSums(across(
      c(bet_c_una, bet_c_log, bet_c_dfad, bet_c_afad, bet_c_oth)), na.rm = TRUE),
    catch_alb = 0,  # ALB not reported in WCPFC PS data
    catch_tot = catch_skj + catch_bet + catch_alb
  ) |>
  select(
    lon, lat, year, month,
    effort_set, effort_day,
    catch_tot, catch_skj,
    catch_alb, catch_bet
  )

### quarter, 1 deg, flag --- ISSUE ##
quarter_1deg_flag_clean <- quarter_1deg_flag_raw |>
  rename(
    year = yy,
    quarter = qtr,
    effort_day = days
  ) |>
  # Convert SW corner to center
  mutate(
    lat = parse_and_center(lat1, offset = 0.5),   # Convert SW corner to center
    lon = parse_and_center(lon1, offset = 0.5),
    effort_set = rowSums(across(
      c(sets_una, sets_log, sets_dfad, sets_afad, sets_oth)), na.rm = TRUE),  # Total sets across all set types
    catch_skj = rowSums(across(
      c(skj_c_una, skj_c_log, skj_c_dfad, skj_c_afad, skj_c_oth)), na.rm = TRUE),  # Species specific catches
    catch_bet = rowSums(across(
      c(bet_c_una, bet_c_log, bet_c_dfad, bet_c_afad, bet_c_oth)), na.rm = TRUE),
    catch_alb = 0,  # ALB not reported in WCPFC PS data
    catch_tot = catch_skj + catch_bet + catch_alb
  ) |>
  select(
    lon, lat, year, quarter,
    effort_set, effort_day,
    catch_tot, catch_skj,
    catch_alb, catch_bet
  )

### quarter, 5 deg, flag
quarter_5deg_flag_clean <- quarter_5deg_flag_raw |>
  rename(
    year = yy,
    quarter = qtr,
    effort_day = days
  ) |>
  # Convert SW corner to center
  mutate(
    lat = parse_and_center(lat5, offset = 2.5),   # Convert SW corner to center
    lon = parse_and_center(lon5, offset = 2.5),
    effort_set = rowSums(across(
      c(sets_una, sets_log, sets_dfad, sets_afad, sets_oth)), na.rm = TRUE),  # Total sets across all set types
    catch_skj = rowSums(across(
      c(skj_c_una, skj_c_log, skj_c_dfad, skj_c_afad, skj_c_oth)), na.rm = TRUE),  # Species specific catches
    catch_bet = rowSums(across(
      c(bet_c_una, bet_c_log, bet_c_dfad, bet_c_afad, bet_c_oth)), na.rm = TRUE),
    catch_alb = 0,  # ALB not reported in WCPFC PS data
    catch_tot = catch_skj + catch_bet + catch_alb
  ) |>
  select(
    lon, lat, year, quarter,
    effort_set, effort_day,
    catch_tot, catch_skj,
    catch_alb, catch_bet
  )

### year, 5 deg, flag
year_5deg_flag_clean <- year_5deg_flag_raw |>
  rename(
    year = yy,
    effort_day = days
  ) |>
  # Convert SW corner to center
  mutate(
    lat = parse_and_center(lat5, offset = 2.5),   # Convert SW corner to center
    lon = parse_and_center(lon5, offset = 2.5),
    effort_set = rowSums(across(
      c(sets_una, sets_log, sets_dfad, sets_afad, sets_oth)), na.rm = TRUE),  # Total sets across all set types
    catch_skj = rowSums(across(
      c(skj_c_una, skj_c_log, skj_c_dfad, skj_c_afad, skj_c_oth)), na.rm = TRUE),  # Species specific catches
    catch_bet = rowSums(across(
      c(bet_c_una, bet_c_log, bet_c_dfad, bet_c_afad, bet_c_oth)), na.rm = TRUE),
    catch_alb = 0,  # ALB not reported in WCPFC PS data
    catch_tot = catch_skj + catch_bet + catch_alb
  ) |>
  select(
    lon, lat, year,
    effort_set, effort_day,
    catch_tot, catch_skj,
    catch_alb, catch_bet
  )
view(year_5deg_flag_clean)

# EXPORT #######################################################################

saveRDS(month_1deg_clean, "data/processed/wcpfc/wcpfc_month_1deg_purseseine.rds")
saveRDS(month_5deg_clean, "data/processed/wcpfc/wcpfc_month_5deg_purseseine.rds")
saveRDS(quarter_1deg_flag_clean, "data/processed/wcpfc/wcpfc_quarter_1deg_purseseine_flag.rds")
saveRDS(quarter_5deg_flag_clean, "data/processed/wcpfc/wcpfc_quarter_5deg_purseseine_flag.rds")
saveRDS(year_5deg_flag_clean, "data/processed/wcpfc/wcpfc_year_5deg_purseseine_flag.rds")
