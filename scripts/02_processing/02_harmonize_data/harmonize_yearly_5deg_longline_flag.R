################################################################################
# Harmonize purse seine monthly, 1x1 degree data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This script harmonizes longline data from the bound dataset (IATTC,
# ICCAT, and WCPFC) to resolve overlapping cells between IATTC and WCPFC.
# The RFMO with higher catch and effort reported was kept. If the reporting was
# the same the data from WCPFC was kept. Some overlaps may still exist between
# IATTC and ICCAT.
#
# The output is the final monthly harmonized monthly, 5x5 degree dataset with
# flag data.
#
################################################################################

# SET UP #######################################################################

# Load packages ----------------------------------------------------------------
library(tidyverse)
library(sf)
library(rnaturalearth)

# Load data --------------------------------------------------------------------

yearly_bound <- readRDS("data/processed/01_bound/allrfmo_year_5deg_longline_flag.rds")
yearly_overlap_cells <- readRDS("data/processed/01_bound/yearly_flag_overlap_cells_longline.rds")

# Load spatial data ------------------------------------------------------------

countries <- ne_countries(
  scale = "medium",
  returnclass = "sf"
)

# PROCESSING ###################################################################

# Harmonize --------------------------------------------------------------------
yearly_flag <- yearly_bound |>

  # Mark overlapping cells
  left_join(
    yearly_overlap_cells |> mutate(overlap = TRUE),
    by = c("lat", "lon", "year")
  ) |>

  group_by(lat, lon, year, flag) |>

  # Avoid NA warnings
  mutate(
    max_mt  = if (all(is.na(catch_tot_mt)))  NA_real_ else max(catch_tot_mt,  na.rm = TRUE),
    max_n = if (all(is.na(catch_tot_n))) NA_real_ else max(catch_tot_n, na.rm = TRUE)
  ) |>

  # Keep:
  #   - all non-overlap rows
  #   - rows with highest MT
  #   - if MT ties, rows with highest N
  filter(
    is.na(overlap) |
      (!is.na(max_mt)  & catch_tot_mt  == max_mt) |
      ( is.na(max_mt)  & !is.na(max_n) & catch_tot_n == max_n)
  ) |>

  # If still tied, keep WCPFC
  slice_max(rfmo == "wcpfc") |>

  ungroup() |>
  select(-overlap, -max_mt, -max_n)

# Remove points that fall on land ----------------------------------------------

yearly_flag_final <- yearly_flag |>
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

saveRDS(yearly_flag_final, "data/output/allrfmo_year_5deg_longline_flag.rds")

