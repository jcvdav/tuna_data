################################################################################
# Clean IATTC longline monthly data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script processes raw longline tuna catch and effort data from the
# IATTC at a 5 degree monthly resolution with flag ID to the yearly level.
#
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)
library(janitor)

## Load data -------------------------------------------------------------------
ll_raw <- readRDS("data/raw/iattc/month_5deg_longline_flag/month_5deg_longline_flag_merged.rds")

# PROCESSING ###################################################################

ll_month <- ll_raw |>
  rename(
    year = Year,
    month = Month,
    flag = Flag,
    effort_hooks = Hooks,
    lat = LatC5,
    lon = LonC5
  ) |>

  # Clean flag codes (IATTC already uses ISO-3)
  mutate(
    flag = case_when(
      flag == "Other" ~ NA_character_,
      TRUE ~ flag
    )
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
    rfmo, flag, lon, lat, year, month,
    effort_hooks,
    catch_tot_mt, catch_tot_n,
    catch_bet_mt, catch_bet_n,
    catch_alb_mt, catch_alb_n,
    catch_yft_mt, catch_yft_n
  )

ll_year <- ll_month |>
  # Group by cell, flag, and year
  group_by(rfmo, flag, lon, lat, year) |>

  # Sum effort and catch across months
  summarize(
    effort_hooks = sum(effort_hooks, na.rm = TRUE),

    catch_tot_mt = sum(catch_tot_mt, na.rm = TRUE),
    catch_tot_n  = sum(catch_tot_n,  na.rm = TRUE),

    catch_bet_mt = sum(catch_bet_mt, na.rm = TRUE),
    catch_bet_n  = sum(catch_bet_n,  na.rm = TRUE),

    catch_alb_mt = sum(catch_alb_mt, na.rm = TRUE),
    catch_alb_n  = sum(catch_alb_n,  na.rm = TRUE),

    catch_yft_mt = sum(catch_yft_mt, na.rm = TRUE),
    catch_yft_n  = sum(catch_yft_n,  na.rm = TRUE),

    .groups = "drop"
  ) |>

  # Remove rows where all species are NA or all zero
  filter(
    !if_all(c(catch_bet_mt, catch_alb_mt, catch_yft_mt,
              catch_bet_n, catch_alb_n, catch_yft_n), is.na),
    !if_all(c(catch_bet_mt, catch_alb_mt, catch_yft_mt,
              catch_bet_n, catch_alb_n, catch_yft_n), ~ .x == 0)
  ) |>

  # Final column order
  select(
    rfmo, flag, lon, lat, year,
    effort_hooks,
    catch_tot_mt, catch_tot_n,
    catch_bet_mt, catch_bet_n,
    catch_alb_mt, catch_alb_n,
    catch_yft_mt, catch_yft_n
  )

# EXPORT #######################################################################
saveRDS(ll_year, "data/processed/iattc/iattc_year_5deg_longline_flag.rds")
