################################################################################
# Microsoft Access Database to RDS Conversion
################################################################################
#
# Emily Rodriguez
# ecr108@miami.edu
#
# This script converts the ICCAT Microsoft Access database (.mdb) into an .rds file.
#
################################################################################

# Load packages ----------------------------------------------------------------
pacman::p_load(
  here,
  Hmisc,
  tidyverse,
  DBI,
  odbc
)

# Check system information
if (Sys.info()['sysname'] == "Darwin") {
  message("Running on a Mac system. Proceeding with Mac-specific code.")
} else if (Sys.info()['sysname'] == "Windows") {
  message("Running on a Windows system. Please run the Windows-specific code below.")
} else {
  stop("Unsupported operating system. This script is designed for Mac and Windows users only.")
}

# ------------------------------------------------------------------------------
# For Mac Users:
# ------------------------------------------------------------------------------

# Load data
con <- mdb.get(file = here("data", "raw", "iccat", "ms_database_all", "t2ce_20260130", "t2ce_20260130web.mdb"))

# Export the data
saveRDS(object = con,
        file = here("data", "raw", "iccat", "ms_database_all", "t2ce_20260130", "ICCAT_database.rds"))

# ------------------------------------------------------------------------------
# For Windows Users:
# ------------------------------------------------------------------------------

# Load data
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

# Select for tables
tables <- dbListTables(con)

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
