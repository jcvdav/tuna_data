################################################################################
# Harmonize purse seine yearly, 1x1 degree flag data
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

# Load data --------------------------------------------------------------------
yearly_flag_bound <- readRDS("data/processed/01_bound/allrfmo_year_1deg_purseseine_flag.rds")
yearly_overlap_cells <- readRDS("data/processed/01_bound/yearly_flag_overlap_cells.rds")

# PROCESSING ###################################################################
# Harmonize --------------------------------------------------------------------
yearly_flag_final <- yearly_flag_bound |>

  # Mark overlapping cells
  left_join(yearly_overlap_cells |> mutate(overlap = TRUE),
            by = c("lat", "lon", "year")) |>

  group_by(lat, lon, year, flag) |>

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

# EXPORT #######################################################################
saveRDS(yearly_flag_final, "data/output/allrfmo_year_1deg_purseseine_flag.rds")
