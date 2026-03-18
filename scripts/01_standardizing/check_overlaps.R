library(tidyverse)

yearly <- readRDS("data/processed/allrfmo_year_1deg_purseseine.rds") |>
  group_by(lat, lon) |>
  summarise(n_rfmo = n_distinct(rfmo), .groups = "drop")|>
  filter(n_rfmo > 1) |>
  mutate(
    lat = sprintf("%.1f", lat),
    lon = sprintf("%.1f", lon)
    )
yearly

monthly <- readRDS("data/processed/allrfmo_month_1deg_purseseine.rds") |>
  select(rfmo, lat, lon) |>
  distinct() |>
  group_by(lat, lon) |>
  summarise(n_rfmo = n_distinct(rfmo),
            rfmos = paste(rfmo),
            .groups = "drop")|>
  filter(n_rfmo > 1) |>
  mutate(
    lat = sprintf("%.1f", lat),
    lon = sprintf("%.1f", lon)
  ) |>
  st_as_sf(coords = c("lon", "lat"), crs = 4326)

mapview(monthly)


ggplot(monthly, aes(x = as.numeric(lon), y = as.numeric(lat))) +
  geom_tile(aes(fill = n_rfmo)) +
  scale_fill_viridis_c() +
  coord_fixed() +
  labs(
    x = "Longitude",
    y = "Latitude",
  ) +
  theme_minimal()
