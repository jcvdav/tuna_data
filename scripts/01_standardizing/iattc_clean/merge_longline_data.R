################################################################################
# Merge IATTC longline monthly data
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This R script processes raw longline tuna catch and effort data from the
# IATTC that was divided between catch numbers and weight, and combines them into
# a single dataset.
#
# IATTC reports into two separate files, see metadata in `data/raw/iattc/month_5deg_longline_flag`
# for explanation
#
################################################################################
# SET UP #######################################################################

## Load packages ---------------------------------------------------------------
library(tidyverse)

## Load data -------------------------------------------------------------------
iattc_mt <- read_csv("data/raw/iattc/month_5deg_longline_flag/month_5deg_longline_flag_mt.csv")

iattc_num <- read_csv("data/raw/iattc/month_5deg_longline_flag/month_5deg_longline_flag_num.csv")

## Join datasets ---------------------------------------------------------------

# Identify keys
keys <- c("Year","Month","Flag","LatC5","LonC5","Hooks")

# Build subtables
num_sub <- iattc_num |>
  select(all_of(keys), ends_with("n"))

mt_sub <- iattc_mt |>
  select(all_of(keys), ends_with("mt"))

# ---------------------------------------------------------------------------
# NOTE FOR FUTURE DATA UPDATES
#
# The IATTC longline data are split into two files:
#   (1) catch in numbers (…n)
#   (2) catch in metric tons (…mt)
#
# These two files are *intended* to have identical spatial–temporal keys:
#   Year, Month, Flag, LatC5, LonC5, Hooks
#
# Because of this, we currently use full_join() to merge the two datasets.
#
# However, before updating this dataset or re-running the pipeline with new
# IATTC releases, **verify that the keys still match perfectly**.
#
# A quick check:
#
# all.equal(iattc_mt[, c("Year","Month","Flag","LatC5","LonC5")], # should be true
#          iattc_num[, c("Year","Month","Flag","LatC5","LonC5")])
#
#   inner_join(num_sub, mt_sub, by = keys)  # should have same nrow as
#   left_join(num_sub, mt_sub,  by = keys)  # and
#   full_join(num_sub, mt_sub,  by = keys)
#
# If all three joins return the same number of rows, the key structure is
# consistent and full_join() is safe.
#
# ---------------------------------------------------------------------------

# Join
iattc_merged <- full_join(num_sub, mt_sub, by = keys)

# ---------------------------------------------------------------------------
# FIX REPORTING LOGIC FOR SPECIES WITH BOTH NUMBERS AND METRIC TONS
#
# IATTC longline data reports catch in two separate files:
#   - one for numbers (…n)
#   - one for metric tons (…mt)
#
# A value of "0" in these files does NOT always mean "zero catch".
#   • 0 in BOTH files (n = 0, mt = 0)  → TRUE ZERO CATCH
#   • 0 in ONE file but >0 in the other → NOT REPORTED in that unit
#       (should be NA, not 0)
#   • NA in BOTH files → species not reported at all
#
# ---------------------------------------------------------------------------

# Identify all species prefixes
species <- names(iattc_merged) |>
  str_extract("^[A-Z]{3}(?=n$|mt$)") |>
  na.omit() |>
  unique()

for (sp in species) {

  n <- paste0(sp, "n")   # numbers column name
  m <- paste0(sp, "mt")  # metric tons column name

  # Skip if one of the pair is missing for some reason
  if (!all(c(n, m) %in% names(iattc_merged))) next

  n_val <- as.numeric(iattc_merged[[n]])
  m_val <- as.numeric(iattc_merged[[m]])

  # numbers = 0, mt > 0  → numbers not reported → set numbers to NA
  n_missing <- !is.na(n_val) & !is.na(m_val) & n_val == 0 & m_val > 0

  # mt = 0, numbers > 0 → mt not reported → set mt to NA
  m_missing <- !is.na(m_val) & !is.na(n_val) & m_val == 0 & n_val > 0

  n_val[n_missing] <- NA_real_
  m_val[m_missing] <- NA_real_

  iattc_merged[[n]] <- n_val
  iattc_merged[[m]] <- m_val
}

## Checks ######################################################################
all.equal(iattc_num[keys], iattc_mt[keys])
# True = keys the same

# duplicates

nrow(iattc_merged) == nrow(iattc_num)
# True = join did not create duplicates

# check lost info
all.equal(
  iattc_merged |> select(ends_with("n")),
  num_sub |> select(ends_with("n"))
)
# True = all number data preserved

all.equal(
  iattc_merged |> select(ends_with("mt")),
  mt_sub |> select(ends_with("mt"))
)
# true = all mt data preserved

# id rows where both units exist
iattc_merged <- iattc_merged |>
  mutate(row_id = row_number())

both_units <- iattc_merged |>
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
only_num <- iattc_merged |>
  filter(
    rowSums(across(ends_with("n")), na.rm = TRUE) > 0 &
      rowSums(across(ends_with("mt")), na.rm = TRUE) == 0
  )

all.equal(
  iattc_num[keys][rownames(only_num), ],
  iattc_mt[keys][rownames(only_num), ]
)
# True

only_mt <- iattc_merged |>
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

