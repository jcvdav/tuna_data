

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------

library(tidyverse)
library(mapview)

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
