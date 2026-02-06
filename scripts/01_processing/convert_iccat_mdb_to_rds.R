# ------------------------------------------------------------------------------
# For Mac Users:
# ------------------------------------------------------------------------------

# Load packages ----------------------------------------------------------------
pacman::p_load(
  here,
  Hmisc,
  tidyverse
)

# Load data --------------------------------------------------------------------
# Read the Microsoft access database
con <- mdb.get(file = here("data", "raw", "iccat", "ms_database_all", "t2ce_20260130", "t2ce_20260130web.mdb"))

# Export the data
saveRDS(object = con,
        file = here("data", "raw", "iccat", "ms_database_all", "t2ce_20260130", "ICCAT_database.rds"))

# ------------------------------------------------------------------------------
# For Windows Users:
# ------------------------------------------------------------------------------

# Load packages ----------------------------------------------------------------
pacman::p_load(
  here,
  tidyverse,
  DBI,
  odbc
)

# Load data --------------------------------------------------------------------
db_path <- here(
  "data", "raw", "iccat", "ms_database_all",
  "t2ce_20260130", "t2ce_20260130web.mdb"
)

con <- dbConnect(
  odbc::odbc(),
  .connection_string = paste0(
    "Driver={Microsoft Access Driver (*.mdb, *.accdb)};",
    "DBQ=", normalizePath(db_path), ";"
  )
)

# Filter out system tables
user_tables <- tables[!grepl("^MSys", tables)]
user_tables

# Read ICCAT tables into one object
iccat_data <- setNames(
  lapply(user_tables, dbReadTable, conn = con),
  user_tables
)

# Save file as .rds
saveRDS(
  iccat_data,
  here("data", "raw", "iccat", "ms_database_all", "t2ce_20260130", "ICCAT_database.rds")
)

