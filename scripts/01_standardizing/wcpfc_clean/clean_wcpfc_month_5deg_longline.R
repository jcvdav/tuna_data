################################################################################
# Clean WCPFC purse seine data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script processes raw longline tuna catch and effort data from the
# WCPFC at the month, 5 degree level.
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)
library(stringr)

## Load data -------------------------------------------------------------------

month_5deg_raw <- read_csv("data/raw/wcpfc/month_5deg_longline/month_5deg_longline.csv") |>
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

clean <- month_5deg_raw |>
  rename(
    year = yy,
    month = mm,
    effort_hooks = hhooks # hundreds of hooks
  ) |>

  # Convert SW corner to center
  mutate(
    lat = parse_and_center(lat5, offset = 2.5),   # Convert corner to center
    lon = parse_and_center(lon5, offset = 2.5),

    # Species specific catch in mt
    catch_bet_mt = bet_c,
    catch_alb_mt = alb_c,
    catch_yft_mt = yft_c,

    # Species specific catch in numbers
    catch_bet_n = bet_n,
    catch_alb_n = alb_n,
    catch_yft_n = yft_n,

    # Total catch (metric tons + numbers)
    catch_tot_mt = rowSums(across(c(catch_bet_mt, catch_alb_mt, catch_yft_mt)), na.rm = TRUE),
    catch_tot_n = rowSums(across(c(catch_bet_n, catch_alb_n, catch_yft_n)), na.rm = TRUE),

    rfmo = "wcpfc"
  ) |>

  # Remove rows where all three species are NA or all zero
  filter(
    !if_all(c(catch_bet_mt, catch_alb_mt, catch_yft_mt,
              catch_bet_n, catch_alb_n, catch_yft_n), is.na),
    !if_all(c(catch_bet_mt, catch_alb_mt, catch_yft_mt,
              catch_bet_n, catch_alb_n, catch_yft_n), ~ .x == 0)
  ) |>

  # Can rearrange if needed
  select(
    rfmo, lon, lat, year, month,
    effort_hooks,
    catch_tot_mt, catch_tot_n,
    catch_bet_mt, catch_bet_n,
    catch_alb_mt, catch_alb_n,
    catch_yft_mt, catch_yft_n
  )

# EXPORT #######################################################################
saveRDS(clean, "data/processed/wcpfc/wcpfc_month_5deg_longline.rds")
