################################################################################
# Clean IATTC longline monthly data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script processes raw longline tuna catch and effort data from the
# IATTC that was divided between catch numbers and weight, and combiens them into
# a single dataset
#
################################################################################
# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)

## Load data -------------------------------------------------------------------
iattc_mt <- read_csv("data/raw/iattc/month_5deg_longline_flag/month_5deg_longline_flag_mt.csv")

iattc_num <- read_csv("data/raw/iattc/month_5deg_longline_flag/month_5deg_longline_flag_num.csv")

## Join datasets ---------------------------------------------------------------

# IATTC reports into two separate files, see metadata in `data/raw/iattc/month_5deg_longline_flag`
# for explanation

# Identify keys
keys <- c("Year","Month","Flag","LatC5","LonC5","Hooks")

# Build numbers subtable
num_sub <- iattc_num |>
  select(all_of(keys), ends_with("n"))

# Built mt subtable
mt_sub <- iattc_mt |>
  select(all_of(keys), ends_with("mt"))

# Join
iattc_merged <- full_join(num_sub, mt_sub, by = keys)

## Checks ##
all.equal(iattc_num[keys], iattc_mt[keys])
# True = keys the same

# duplicates
num_sub <- iattc_num |> select(all_of(keys), ends_with("n"))
mt_sub  <- iattc_mt  |> select(all_of(keys), ends_with("mt"))

merged <- full_join(num_sub, mt_sub, by = keys)
nrow(merged) == nrow(iattc_num)
# True = join did not create duplicates

# lost info
all.equal(
  merged |> select(ends_with("n")),
  num_sub |> select(ends_with("n"))
)
# True = all number data preserved

all.equal(
  merged |> select(ends_with("mt")),
  mt_sub |> select(ends_with("mt"))
)
# true = all mt data preserved

# id rows where both units exist
merged <- merged |>
  mutate(row_id = row_number())

both_units <- merged |>
  mutate(
    has_num = rowSums(across(ends_with("n")), na.rm = TRUE) > 0,
    has_mt  = rowSums(across(ends_with("mt")), na.rm = TRUE) > 0
  ) |>
  filter(has_num & has_mt)

# check these rows match across files
# For rows with both units, numbers must come from num file
all(both_units$ALBn == iattc_num$ALBn[both_units$row_id])

# And weights must come from mt file
all(both_units$ALBmt == iattc_mt$ALBmt[both_units$row_id])

# Both true

# Test single unit rows merged correctly
only_num <- merged |>
  filter(
    rowSums(across(ends_with("n")), na.rm = TRUE) > 0 &
      rowSums(across(ends_with("mt")), na.rm = TRUE) == 0
  )

all.equal(
  iattc_num[keys][rownames(only_num), ],
  iattc_mt[keys][rownames(only_num), ]
)
# True

only_mt <- merged |>
  filter(
    rowSums(across(ends_with("n")), na.rm = TRUE) == 0 &
      rowSums(across(ends_with("mt")), na.rm = TRUE) > 0
  )
all.equal(
  iattc_num[keys][rownames(only_mt), ],
  iattc_mt[keys][rownames(only_mt), ]
)
# True


# EXPORT #######################################################################

saveRDS(iattc_merged, "data/raw/iattc/month_5deg_longline_flag/month_5deg_longline_flag_merged.rds")
