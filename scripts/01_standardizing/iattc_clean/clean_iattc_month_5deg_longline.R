################################################################################
# Clean IATTC longline monthly data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script processes raw longline tuna catch and effort data from the
# IATTC at a 5 degree monthly resolution.
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)

## Load data -------------------------------------------------------------------
ll_raw <- readRDS("data/raw/iattc/month_5deg_longline_flag/month_5deg_longline_flag_merged.rds")

# PROCESSING ###################################################################

clean <- ll_raw |>
  rename(
    year = Year,
    month = Month,
    lat = LatC5,
    lon = LonC5
  ) |>

  # Effort convert to 1000s of hooks
  mutate(
    effort_t_hooks = Hooks / 1000
  ) |>

  # Species-specific catch
  mutate(
    catch_bet_mt = BETmt,
    catch_alb_mt = ALBmt,
    catch_yft_mt = YFTmt,

    catch_bet_n = BETn,
    catch_alb_n = ALBn,
    catch_yft_n = YFTn,
  ) |>

  # Total catch
  mutate(
    catch_tot_mt = rowSums(across(c(catch_bet_mt, catch_alb_mt,
                                    catch_yft_mt)), na.rm = TRUE),
    catch_tot_n  = rowSums(across(c(catch_bet_n, catch_alb_n,
                                    catch_yft_n)), na.rm = TRUE),

    rfmo = "iattc"
  ) |>

  # Remove rows where all species are NA or all zero
  filter(
    !if_all(c(catch_bet_mt, catch_alb_mt, catch_yft_mt,
              catch_bet_n, catch_alb_n, catch_yft_n), is.na),
    !if_all(c(catch_bet_mt, catch_alb_mt, catch_yft_mt,
              catch_bet_n, catch_alb_n, catch_yft_n), ~ .x == 0)
  ) |>

  select(
    rfmo, lon, lat, year, month,
    effort_t_hooks,
    catch_tot_mt, catch_tot_n,
    catch_bet_mt, catch_bet_n,
    catch_alb_mt, catch_alb_n,
    catch_yft_mt, catch_yft_n
  )

# EXPORT #######################################################################
saveRDS(clean, "data/processed/iattc/iattc_month_5deg_longline.rds")
