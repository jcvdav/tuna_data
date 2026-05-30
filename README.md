# RFMO Tuna Catch and Effort Data

## Overview
This project develops a standardized pipeline to compile, clean, and 
restructure tuna catch and effort datasets from multiple Regional Fisheries
Management Organizations (RFMOs). 

## RFMOs Included
- **[IATTC](https://www.iattc.org/en-us/Data/Public-domain)** – Inter-American Tropical Tuna Commission data
- **[ICCAT](https://www.iccat.int/en/accesingdb.HTML)** – International Commission for the Conservation of Atlantic Tunas (task 2 data)
- **[IOTC](https://iotc.org/data/datasets)** – Indian Ocean Tuna Commission data
- **[WCPFC](https://www.wcpfc.int/public-domain-aggregated-catcheffort-data)** – Western and Central Pacific Fisheries Commission data

## Repository Structure

- `data/`:
    - `data/raw`: contains original datasets retrieved from RFMOs
    - `data/processed`: contains cleaned data from various RFMOs in a standardized format
      - `processed/01_bound`: contains bound RFMO data sets at various resolutions
    - `data/output`: contains harmonized RFMO datasets
- `scripts/`:
    - `scripts/01_standardizing`: contains scripts that clean RFMO data 
    - `scripts/02_processing`: 
      - `02_processing/01_bind_data`: contains scripts that bind RFMO data and detect overlapping cells
      - `02_processing/02_harmonize_data`: contains scripts that harmonize RFMO data
    - `scripts/03_content`:
- `results/`:
    - `results/figures`
    - `results/img`:
    - `results/tab`:


## Defined variables in cleaned data for catch and effort

| Variables        | Description                                       |
|------------------|---------------------------------------------------|
| `rfmo`           | Related RFMO                                      |
| `flag`           | Flag code in ISO 3166-1 alpha-3 (excluding `SUN`) |
| `lon`            | Longitude of fishing activity                     |
| `lat`            | Latitude of the fishing activity                  |
| `year`           | Year of record                                    |
| `month`          | Month of record                                   |
| `effort_set`     | Number of fishing sets                            |
| `effort_day`     | Number of fishing days                            |
| `effort_t_hooks` | Thousands of hooks                                |
| `catch_tot`      | Total catch (mt)                                  |
| `catch_skj`      | Catch of skipjack tuna (mt)                       |
| `catch_alb`      | Catch of albacore tuna (mt)                       |
| `catch_bet`      | Catch of bigeye tuna (mt)                         |
| `catch_yft`      | Catch of yellowfin tuna (mt)                      |

## Additional variables specific to length datasets

| `tstrat`     | Temporal stratification                                      |
|--------------|--------------------------------------------------------------|
| `gear`       | Gear type                                                    |
| `species`    | Tuna species                                                 |
| `length_cm`  | Fish length in centimeters                                   |
| `length_bin` | Length class/bin in cm based on interval (e.g., 1,2 cm bins) |

## Harmonized datasets
##### File path under: [data/output](data/output)
| Gear        | Spatial | Temporal | By flag | RFMOs Included      | Dataset                                 |
|-------------|---------|----------|---------|---------------------|-----------------------------------------|
| purse seine | 1°×1°   | month    | no      | IATTC, ICCAT, WCPFC | `allrfmo_month_1deg_purseseine.rds`     |
| purse seine | 1°×1°   | year     | no      | IATTC, ICCAT, WCPFC | `allrfmo_year_1deg_purseseine.rds`      |
| purse seine | 1°×1°   | year     | yes     | IATTC, ICCAT, WCPFC | `allrfmo_year_1deg_purseseine_flag.rds` |
| longline    | 5°×5°   | month    | no      | IATTC, ICCAT, WCPFC | `allrfmo_month_5deg_longline.rds`       |
| longline    | 5°×5°   | month    | yes     | IATTC, ICCAT, WCPFC | `allrfmo_month_5deg_longline_flag.rds`  |
| longline    | 5°×5°   | year     | no      | IATTC, ICCAT, WCPFC | `allrfmo_year_5deg_longline.rds`        |
| longline    | 5°×5°   | year     | yes     | IATTC, ICCAT, WCPFC | `allrfmo_year_5deg_longline_flag.rds`   |

## Cleaned catch and effort data sets by RFMO

### IATTC
##### File path under: [data/processed/iattc](data/processed/iattc)
| Gear        | Spatial | Temporal | By flag | Dataset                               | Dataset                                 |
|-------------|---------|----------|---------|---------------------------------------|-----------------------------------------|
| purse seine | 1°×1°   | month    | no      | `iattc_month_1deg_purseseine.rds`     | `allrfmo_month_1deg_purseseine.rds`     |
| purse seine | 1°×1°   | year     | no      | `iattc_year_1deg_purseseine.rds`      | `allrfmo_year_1deg_purseseine.rds`      |
| purse seine | 1°×1°   | year     | yes     | `iattc_year_1deg_purseseine_flag.rds` | `allrfmo_year_1deg_purseseine_flag.rds` |
| longline    | 5°×5°   | month    | no      | `iattc_month_5deg_longline.rds`       | `allrfmo_month_5deg_longline.rds`       |
| longline    | 5°×5°   | month    | yes     | `iattc_month_5deg_longline_flag.rds`  | `allrfmo_month_5deg_longline_flag.rds`  |
| longline    | 5°×5°   | year     | no      | `iattc_year_5deg_longline.rds`        | `allrfmo_year_5deg_longline.rds`        |
| longline    | 5°×5°   | year     | yes     | `iattc_year_5deg_longline_flag.rds`   | `allrfmo_year_5deg_longline_flag.rds`   |

### ICCAT
##### File path under: [data/processed/iccat](data/processed/iccat)
| Gear        | Spatial | Temporal | By flag | Dataset                               |
|-------------|---------|----------|---------|---------------------------------------|
| purse seine | 1°×1°   | month    | no      | `iccat_month_1deg_purseseine.rds`     |
| purse seine | 1°×1°   | year     | no      | `iccat_year_1deg_purseseine.rds`      |
| purse seine | 1°×1°   | year     | yes     | `iccat_year_1deg_purseseine_flag.rds` |
| longline    | 5°×5°   | month    | no      | `iccat_month_5deg_longline.rds`       |
| longline    | 5°×5°   | month    | yes     | `iccat_month_5deg_longline_flag.rds`  |
| longline    | 5°×5°   | year     | no      | `iccat_year_5deg_longline.rds`        |
| longline    | 5°×5°   | year     | yes     | `iccat_year_5deg_longline_flag.rds`   |

### IOTC
##### File path under: [data/processed/iotc](data/processed/iotc)

### WCPFC
##### File path under: [data/processed/wcpfc](data/processed/wcpfc)
| Gear        | Spatial | Temporal | By flag | Dataset                                  |
|-------------|---------|----------|---------|------------------------------------------|
| purse seine | 1°×1°   | month    | no      | `wcpfc_month_1deg_purseseine.rds`        |
| purse seine | 5°×5°   | month    | no      | `wcpfc_month_5deg_purseseine.rds`        |
| purse seine | 1°×1°   | quarter  | yes     | `wcpfc_quarter_1deg_purseseine_flag.rds` |
| purse seine | 5°×5°   | quarter  | no      | `wcpfc_quarter_5deg_purseseine.rds`      |
| purse seine | 1°×1°   | year     | yes     | `wcpfc_year_1deg_purseseine_flag.rds`    |
| purse seine | 1°×1°   | year     | no      | `wcpfc_year_1deg_purseseine.rds`         |
| purse seine | 5°×5°   | year     | no      | `wcpfc_year_5deg_purseseine.rds`         |
| longline    | 5°×5°   | month    | no      | `wcpfc_month_5deg_longline.rds`          |
| longline    | 5°×5°   | month    | yes     | `wcpfc_month_5deg_longline_flag.rds`     |
| longline    | 5°×5°   | quarter  | yes     | `wcpfc_quarter_5deg_longline_flag.rds`   |
| longline    | 5°×5°   | year     | yes     | `wcpfc_year_5deg_longline_flag.rds`      |

## Raw catch and effort data sets by RFMO (Last updated January 2026)

### IATTC
##### Source: https://www.iattc.org/en-us/Data/Public-domain
##### File path under: [data/raw/iattc](data/raw/iattc)

| Gear          | Spatial | Temporal | Organized by | Measurement type      | Species           | Base path                  | Dataset                             | Metadata                        |
|---------------|---------|----------|--------------|-----------------------|-------------------|----------------------------|-------------------------------------|---------------------------------|
| pole and line | 1°×1°   | month    | flag         | metric tons           | tuna              | `month_1deg_poleline_flag` | `month_1deg_poleline_flag.csv`      | `LPTuna-Atun.pdf`               |
| purse seine   | 1°×1°   | month    | flag         | metric tons           | tuna              | `month_1deg_purseseine`    | `month_1deg_purseseine_flag.csv`    | `PSTuna-Atun.pdf`               |
| purse seine   | 1°×1°   | month    | set type     | metric tons           | tuna              | `month_1deg_purseseine`    | `month_1deg_purseseine_settype.csv` | `PSTuna-Atun.pdf`               |
| longline      | 5°×5°   | month    | flag         | metric tons           | tuna and billfish | `month_5deg_longline_flag` | `month_5deg_longline_flag_mt.csv`   | `LLTunaBillfish-AtunPicudo.pdf` |
| longline      | 5°×5°   | month    | flag         | number of individuals | tuna and billfish | `month_5deg_longline_flag` | `month_5deg_longline_flag_num.csv`  | `LLTunaBillfish-AtunPicudo.pdf` |

### ICCAT
##### Source: https://www.iccat.int/en/accesingdb.HTML
##### File path under: [data/raw/iccat](data/raw/iccat)
##### Additional metadata can be found [here](https://www.iccat.int/en/stat_codes.html)
| Gear  | Spatial         | Temporal | Organized by            | Measurement type | Species | Base path                            | Dataset                                   | Metadata       |
|-------|-----------------|----------|-------------------------|------------------|---------|--------------------------------------|-------------------------------------------|----------------|
| multi | 1°×1° and 5°×5° | multi    | flag                    | -                | multi   | `month_multigear_flag`               | `month_multigear_flag.xlsx`               | `t2ce-ENG.pdf` |
| multi | 1°×1° and 5°×5° | multi    | flag and operation mode | -                | multi   | `month_multigear_flag_operationmode` | `month_multigear_flag_operationmode.xlsx` | `t2ce-ENG.pdf` |
| multi | 1°×1° and 5°×5° | multi    | multi                   | -                | multi   | `ms_database_all`                    | `iccat_database.rds`                      | `t2ce-ENG.pdf` |
| multi | 1°×1° and 5°×5° | multi    | multi                   | -                | multi   | `ms_database_all`                    | `ms_database_all.mdb`                     | `t2ce-ENG.pdf` |

### IOTC
##### Source: https://iotc.org/data/datasets
##### File path under: [data/raw/iotc](data/raw/iotc)

| Gear                     | Spatial         | Temporal | Organized by | Measurement type | Species | Base path                                        | Dataset  | Metadata                                                                                                   |
|--------------------------|-----------------|----------|--------------|------------------|---------|--------------------------------------------------|----------|------------------------------------------------------------------------------------------------------------|
| Purse seine and longline | 1°×1° and 5°×5° | month    | catch        | -                | multi   | `month_multigear/IOTC-DATASETS-2025-10-13-CEALL` | `CA_RAW` | `iotc/IOTC-DATASETS-2025-10-13-CE-Reference_1950-2024/IOTC-DATASETS-2025-10-13-CE-Reference_1950-2024.csv` |
| Purse seine and longline | 1°×1° and 5°×5° | month    | effort       | -                | multi   | `month_multigear/IOTC-DATASETS-2025-10-13-CEALL` | `EF_RAW` | `iotc/IOTC-DATASETS-2025-10-13-CE-Reference_1950-2024/IOTC-DATASETS-2025-10-13-CE-Reference_1950-2024.csv` |

### WCPFC
##### Source: https://www.wcpfc.int/sustainability/scientific-data/wcpfc-public-domain-aggregated-catcheffort-data-download-page
##### File path under: [data/raw/wcpfc](data/raw/wcpfc)
##### Length data under: [data/raw/wcpfc/length_data](data/raw/wcpfc/legnth_data)

| Gear          | Spatial | Temporal | Organized by | Measurement type                      | Species  | Base path                      | Dataset                            | Metadata                  |
|---------------|---------|----------|--------------|---------------------------------------|----------|--------------------------------|------------------------------------|---------------------------|
| purse seine   | 1°×1°   | month    | -            | metric tons                           | tuna     | `month_1deg_purseseine`        | `month_1deg_purseseine.csv`        | `Purse_seine.pdf`         |
| drift net     | 5°×5°   | month    | -            | metric tons and number of individuals | albacore | `month_5deg_driftnet`          | `month_5deg_driftnet.csv`          | `GN_Public_by_YR_MON.pdf` |
| longline      | 5°×5°   | month    | -            | metric tons and number of individuals | multi    | `month_5deg_longline`          | `month_5deg_longline.csv`          | `Longline.pdf`            |
| longline      | 5°×5°   | month    | flag         | metric tons and number of individuals | multi    | `month_5deg_longline_flag`     | `month_5deg_longline_flag.csv`     | `Longline.pdf`            |
| pole and line | 5°×5°   | month    | -            | metric tons                           | multi    | `month_5deg_poleline`          | `month_5deg_poleline.csv`          | `Pole_and_line.pdf`       |
| purse seine   | 5°×5°   | month    | -            | metric tons                           | tuna     | `month_5deg_purseseine`        | `month_5deg_purseseine.csv`        | `Purse_seine.pdf`         |
| pole and line | 1°×1°   | quarter  | -            | metric tons                           | tuna     | `quarter_1deg_poleline`        | `quarter_1deg_poleline.csv`        | `Pole_and_line.pdf`       |
| purse seine   | 1°×1°   | quarter  | flag         | metric tons                           | tuna     | `quarter_1deg_purseseine_flag` | `quarter_1deg_purseseine_flag.csv` | `Purse_seine.pdf`         |
| longline      | 5°×5°   | quarter  | flag         | metric tons and number of individuals | multi    | `quarter_5deg_longline_flag`   | `quarter_5deg_longline_flag.csv`   | `Longline.pdf`            |
| purse seine   | 5°×5°   | quarter  | flag         | metric tons                           | tuna     | `quarter_5deg_purseseine_flag` | `quarter_5deg_purseseine_flag.csv` | `Purse_seine.pdf`         |
| longline      | 5°×5°   | year     | flag         | metric tons and number of individuals | multi    | `year_5deg_longline_flag`      | `year_5deg_longline_flag.csv`      | `Longline.pdf`            |
| purse seine   | 5°×5°   | year     | flag         | metric tons                           | tuna     | `year_5deg_purseseine_flag`    | `year_5deg_purseseine_flag.csv`    | `Purse_seine.pdf`         |
