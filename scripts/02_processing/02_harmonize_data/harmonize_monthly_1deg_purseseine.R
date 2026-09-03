################################################################################
# Harmonize purse seine monthly, 1x1 degree data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This script harmonizes purse seine tuna data from the bound dataset (IATTC,
# ICCAT, and WCPFC) to resolve overlapping cells between IATTC and WCPFC.
# The RFMO with higher catch and effort reported was kept. If the reporting was
# the same the data from WCPFC was kept. Some overlaps may still exist between
# IATTC and ICCAT.
#
# The output is the final monthly harmonized monthly, 1x1 degree dataset.
#
#
################################################################################

# SET UP #######################################################################

# Load packages ----------------------------------------------------------------
library(tidyverse)
library(sf)
library(rnaturalearth)

# Load data --------------------------------------------------------------------

monthly_bound <- readRDS("data/processed/01_bound/allrfmo_month_1deg_purseseine.rds")
monthly_overlap_cells <- readRDS("data/processed/01_bound/monthly_overlap_cells_purseseine.rds")

# Load spatial data ------------------------------------------------------------

countries <- ne_countries(
  scale = "medium",
  returnclass = "sf"
)

# PROCESSING ###################################################################

# Harmonize --------------------------------------------------------------------
monthly <- monthly_bound |>

  # Mark overlapping cells
  left_join(monthly_overlap_cells |> mutate(overlap = TRUE),
            by = c("lat", "lon", "year", "month")) |>

  group_by(lat, lon, year, month) |>

  # Avoid NA warnings
  mutate(
    max_catch  = if (all(is.na(catch_tot)))  NA_real_ else max(catch_tot,  na.rm = TRUE),
    max_effort = if (all(is.na(effort_set))) NA_real_ else max(effort_set, na.rm = TRUE)
  ) |>

  # Keep:
  #   - all non-overlap rows
  #   - rows with highest catch
  #   - if catch ties, rows with highest effort
  filter(
    is.na(overlap) |
      (!is.na(max_catch)  & catch_tot  == max_catch) |
      ( is.na(max_catch)  & !is.na(max_effort) & effort_set == max_effort)
  ) |>

  # If still tied, keep WCPFC
  slice_max(rfmo == "wcpfc") |>

  ungroup() |>
  select(-overlap, -max_catch, -max_effort)

# Remove points that fall on land ----------------------------------------------

monthly_final <- monthly |>
  st_as_sf(
    coords = c("lon", "lat"),
    crs = 4326,
    remove = FALSE
  ) |>
  filter(
    lengths(st_within(geometry, countries)) == 0
  ) |>
  st_drop_geometry()

# EXPORT #######################################################################

saveRDS(monthly_final, "data/output/allrfmo_month_1deg_purseseine.rds")

