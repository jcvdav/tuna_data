################################################################################
# Clean WCPFC purse seine data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# ISSUE: Data set at 5 degree resolution, not 1 degree (current script
# is using older version at 1 degree)
#
# This R script processes raw purse seine tuna catch and effort data from the
# WCPFC at the quarter, 1 degree level with flag ID.
#
################################################################################

# SET UP #######################################################################

library(tidyverse)
library(stringr)
library(janitor)
library(countrycode)

## Load data -------------------------------------------------------------------

quarter_1deg_flag_raw <- read_csv(
  "data/raw/wcpfc/quarter_1deg_purseseine_flag/WCPFC_S_PUBLIC_BY_YY_QTR_FLAG_0/WCPFC_S_PUBLIC_BY_1x1_QTR_FLAG_old.CSV"
) |> clean_names()

## Build function to clean and center lat/lon variables ------------------------

parse_and_center <- function(x, offset = 0) {
  x <- trimws(x)
  val <- str_extract(x, "[0-9.]+") |> as.numeric()
  sign <- ifelse(str_detect(x, "[SW]$"), -1, 1)
  val * sign + offset
}

## Clean data ------------------------------------------------------------------

wcpfc_quarter_1deg_purseseine_flag_clean <- quarter_1deg_flag_raw |>
  rename(
    year = yy,
    quarter = qtr,
    flag = flag_id,          # <-- keep flag
    effort_day = days
  ) |>
  mutate(
    # Convert SW corner to center
    lat = parse_and_center(lat_short, offset = 0.5),
    lon = parse_and_center(lon_short, offset = 0.5),

    # Convert ISO-2 → ISO-3 (keep NA as NA)
    flag = countrycode(flag, "iso2c", "iso3c",
                       custom_match = c("SU" = "SUN")),

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

    catch_alb = 0,

    catch_yft = rowSums(across(
      c(yft_c_una, yft_c_log, yft_c_dfad, yft_c_afad, yft_c_oth)), na.rm = TRUE),

    rfmo = "wcpfc"
  ) |>
  mutate(
    catch_tot = rowSums(across(c(catch_skj, catch_alb, catch_bet,catch_yft)), na.rm = TRUE)
  ) |>
  filter(
    !if_all(c(catch_skj, catch_alb, catch_bet, catch_yft), is.na),   # remove rows where all are NA
    !if_all(c(catch_skj, catch_alb, catch_bet, catch_yft), ~ .x == 0) # remove rows where all are 0
  ) |>
  select(
    rfmo, flag, lon, lat, year,
    effort_set, effort_day,
    catch_tot, catch_skj,
    catch_alb, catch_bet, catch_yft
  )

# EXPORT #######################################################################

saveRDS(wcpfc_quarter_1deg_purseseine_flag_clean, "data/processed/wcpfc/wcpfc_year_1deg_purseseine_flag.rds")
