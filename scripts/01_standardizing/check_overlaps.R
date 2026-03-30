# Load packages ----------------------------------------------------------------
library(tidyverse)
library(lubridate)
library(mapview)
library(sf)

# Load data --------------------------------------------------------------------
# Yearly data
yearly <- readRDS("data/output/allrfmo_year_1deg_purseseine.rds") |>
  filter(rfmo %in% c("wcpfc", "iattc"))

# Monthly data
monthly <- readRDS("data/output/allrfmo_month_1deg_purseseine.rds") |>
  filter(rfmo %in% c("wcpfc", "iattc"))

# Find overlaps ----------------------------------------------------------------
# Detect yearly overlaps
yearly_overlap <- yearly |>
  group_by(lat, lon, year) |>
  filter(n_distinct(rfmo) == 2) |>   # keep only cells where both RFMOs reported
  ungroup()

# Summary table of overlapping cells per year
yearly_overlap_summary <- yearly_overlap |>
  group_by(year) |>
  summarise(n_cells = n_distinct(paste(lat, lon)), .groups = "drop")

# Detect monthly overlaps
monthly_overlap <- monthly |>
  group_by(lat, lon, year, month) |>
  filter(n_distinct(rfmo) == 2) |>
  ungroup()

# Summary table of monthly overlaps
monthly_overlap_summary <- monthly_overlap |>
  group_by(year, month) |>
  summarise(n_cells = n_distinct(paste(lat, lon)), .groups = "drop")

# Results ----------------------------------------------------------------------
# Yearly
yearly_overlap_summary

# Monthly
monthly_overlap_summary

# Determine if reporting is similar --------------------------------------------

# Aggregate yearly overlaps by RFMO
yearly_ts <- yearly_overlap |>
  group_by(year, rfmo) |>
  summarise(
    total_catch = sum(catch_tot, na.rm = TRUE),
    total_effort = sum(effort_set, na.rm = TRUE),
    .groups = "drop"
  )

# Plot catch over years
ggplot(yearly_ts, aes(x = year, y = total_catch, color = rfmo)) +
  geom_line(size = 1.2) +
  labs(
    title = "Yearly Overlap",
    x = "Year",
    y = "Total Catch (tons)",
    color = "RFMO"
  ) +
  theme_minimal()

# Plot effort over years
ggplot(yearly_ts, aes(x = year, y = total_effort, color = rfmo)) +
  geom_line(size = 1.2) +
  labs(
    title = "Yearly Overlap",
    x = "Year",
    y = "Total Effort (days or sets)",
    color = "RFMO"
  ) +
  theme_minimal()

# Aggregate monthly overlaps by RFMO
monthly_ts <- monthly_overlap |>
  mutate(date = make_date(year, month, 1)) |>   # first day of the month
  group_by(date, rfmo) |>
  summarise(
    total_catch = sum(catch_tot, na.rm = TRUE),
    total_effort = sum(effort_set, na.rm = TRUE),
    .groups = "drop"
  )

# Plot monthly catch over time
ggplot(monthly_ts, aes(x = date, y = total_catch, color = rfmo)) +
  geom_line(size = 1.2) +
  labs(
    title = "Monthly Overlap",
    x = "Date",
    y = "Total Catch (tons)",
    color = "RFMO"
  ) +
  theme_minimal()

# Plot monthly effort over time
ggplot(monthly_ts, aes(x = date, y = total_effort, color = rfmo)) +
  geom_line(size = 1.2) +
  labs(
    title = "Monthly Overlap",
    x = "Date",
    y = "Total Effort (days or sets)",
    color = "RFMO"
  ) +
  theme_minimal()

# Visualize overlapping cells --------------------------------------------------

# Convert year data to sf
yearly_sf <- yearly_overlap |>
  distinct(lat, lon) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326)

# Map
mapview(yearly_sf,
        legend = FALSE)

# Convert month data to sf
monthly_sf <- monthly_overlap |>
  distinct(lat, lon) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326)

# Map with plain points, no legend
mapview(monthly_sf,
        legend = TRUE)
