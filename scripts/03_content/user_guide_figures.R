# SET UP #######################################################################

## Load packages ---------------------------------------------------------------

library(tidyverse)
library(mapview)
library(cowplot)

## Load data -------------------------------------------------------------------

month_1deg_ps <- readRDS("data/output/allrfmo_month_1deg_purseseine.rds")
month_5deg_ll_flag <- readRDS("data/output/allrfmo_month_5deg_longline_flag.rds")
month_5deg_ll <- readRDS("data/output/allrfmo_month_5deg_longline.rds")
year_1deg_ps_flag <- readRDS("data/output/allrfmo_year_1deg_purseseine_flag.rds")
year_1deg_ps <- readRDS("data/output/allrfmo_year_1deg_purseseine.rds")
year_5deg_ll <- readRDS("data/output/allrfmo_year_5deg_longline.rds")
year_5deg_ll_flag <- readRDS("data/output/allrfmo_year_5deg_longline_flag.rds")

# PROCESSING ###################################################################

# Put datasets into a list ----------------------------------------------------

datasets <- list(
  month_1deg_ps = month_1deg_ps,
  month_5deg_ll_flag = month_5deg_ll_flag,
  month_5deg_ll = month_5deg_ll,
  year_1deg_ps_flag = year_1deg_ps_flag,
  year_1deg_ps = year_1deg_ps,
  year_5deg_ll = year_5deg_ll,
  year_5deg_ll_flag = year_5deg_ll_flag
)

# Obtain coverage range for main table

coverage <- map_dfr(datasets, ~{
  data.frame(
    start = min(.x$year, na.rm = TRUE),
    end = max(.x$year, na.rm = TRUE),
    n = nrow(.x)
  )
}, .id = "dataset")

coverage


# Sum catch total in mt for each dataset ---------------------------------------

catch_totals <- map_dbl(datasets, ~{
  if ("catch_tot" %in% names(.x)) {
    sum(.x$catch_tot, na.rm = TRUE)
  } else if ("catch_tot_mt" %in% names(.x)) {
    sum(.x$catch_tot_mt, na.rm = TRUE)
  } else {
    NA_real_
  }
})

catch_totals

# Annual observation counts by RFMO ############################################

# Create plotting function ----------------------------------------------------

plot_rfmo_counts <- function(data, title = "Observation Counts by RFMO") {

  ggplot(data, aes(x = year, fill = rfmo)) +
    geom_bar(color = "white", linewidth = 0.2) +

    scale_fill_manual(
      values = c(
        "iccat" = "#005F73",
        "iattc" = "#0A9396",
        "wcpfc" = "#94D2BD"
      ),
      labels = c(
        "iccat" = "ICCAT",
        "iattc" = "IATTC",
        "wcpfc" = "WCPFC"
      )
    ) +

    labs(
      title = "Observation Counts by RFMO",
      x = "Year",
      y = "Number of Observations (rows)",
      fill = "RFMO"
    ) +

    theme_bw(base_size = 12) +
    theme(
      plot.title = element_text(size = 14),
      legend.position = "right",
      panel.grid.minor = element_blank()
    )
}


# Generate plots for all datasets ---------------------------------------------

plots <- lapply(names(datasets), function(x) {

  plot_rfmo_counts(
    datasets[[x]],
    title = gsub("_", " ", x)
  )

})

# Keep dataset names attached to plots
names(plots) <- names(datasets)


# View individual plots -------------------------------------------------------

plots$month_1deg_ps
plots$month_5deg_ll_flag
plots$year_1deg_ps


# Save all plots --------------------------------------------------------------

for (name in names(plots)) {

  ggsave(
    filename = paste0("results/figures/rfmo_observations/", name, "_rfmo_counts.png"),
    plot = plots[[name]],
    width = 8,
    height = 5,
    dpi = 300
  )
}

# Plot species data availability as bar charts -------------------------------

plot_species_availability <- function(data,
                                      title = "Data Availability by Species") {
  # Id species catch columns
  species_cols <- names(data)[grepl("^catch_", names(data))]

  # Calculate data availability by species and year
  availability <- data |>
    select(year, all_of(species_cols)) |>
    pivot_longer(
      cols = all_of(species_cols),
      names_to = "species",
      values_to = "catch"
    ) |>
    # Clean species names
    mutate(
      species = gsub("catch_", "", species)
    ) |>
    filter(!is.na(catch) & catch > 0) |>
    # Count number of available records for each species-year
    group_by(year, species) |>
    summarise(
      n_records = n(),
      .groups = "drop"
    )

  # Create individual bar plots for each species
  species_plots <- availability |>
    split(availability$species) |>
    map(~{
      ggplot(.x, aes(year, n_records)) +
        geom_col(fill = "#0A9396") +
        labs(
          title = toupper(.x$species[1]),
          x = NULL,
          y = "Records"
        ) +
        theme_bw(base_size = 10) +
        theme(
          plot.title = element_text(size = 11),
          axis.text.x = element_text(angle = 45, hjust = 1),
          panel.grid.minor = element_blank()
        )
    })
  # Combine species plots into one figure
  combined <- plot_grid(
    plotlist = species_plots,
    ncol = 2
  )
}

# Generate plot for all datasets
species_plots <- lapply(names(datasets), function(x) {

  plot_species_availability(
    datasets[[x]],
    title = gsub("_", " ", x)
  )

})

# Keep dataset names attached to plots
names(species_plots) <- names(datasets)

# View plots
species_plots$month_1deg_ps
species_plots$year_5deg_ll

# Save plots
for (name in names(species_plots)) {

  ggsave(
    filename = paste0(
      "results/figures/species_availability/",
      name,
      "_species_availability.png"
    ),
    plot = species_plots[[name]],
    width = 8,
    height = 5,
    dpi = 300
  )
}

