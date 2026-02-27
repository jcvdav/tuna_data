################################################################################
# Harmonize purse seine yearly, 1x1 degree data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This data harmonizes purse seine tuna data from IATTC, ICCAT, and WCPFC at the
# monthly, 1x1 degree level.
#
################################################################################

# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)

## Load data -------------------------------------------------------------------

# IATTC - Monthly only
iattc <- readRDS("data/processed/iattc/iattc_month_1deg_purseseine.rds")

# ICCAT - Multiple temporal resolutions in single data set
iccat <- readRDS("data/processed/iccat/iccat_month_1deg_purseseine.rds")

# WCPFC - Separate resolution data sets
wcpfc_monthly <- readRDS("data/processed/wcpfc/wcpfc_month_1deg_purseseine.rds")
wcpfc_quarterly <- read_csv("data/raw/wcpfc/quarter_1deg_purseseine_flag/WCPFC_S_PUBLIC_BY_YY_QTR_FLAG_0/WCPFC_S_PUBLIC_BY_YY_QTR_FLAG.csv")  # not cleaned yet (5x5 deg resolution instead 1x1)

# PROCESSING ###################################################################

## Bind data sets --------------------------------------------------------------

tuna_all_clean <- bind_rows
