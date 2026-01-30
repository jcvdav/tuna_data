# RFMO Tuna Catch and Effort Data

## Overview
This project focuses on developing a standardized pipeline to compile, clean, 
and restructure tuna catch and effort datasets from multiple Regional Fisheries
Management Organizations (RFMOs). 

## RFMOs Included
- **[IATTC](https://www.iattc.org/en-us/Data/Public-domain)** – Inter-American Tropical Tuna Commission data
- **[ICCAT](https://www.iccat.int/en/accesingdb.HTML)** – International Commission for the Conservation of Atlantic Tunas (task 2 data)
- **[IOTC](https://iotc.org/data/datasets)** – Indian Ocean Tuna Commission data
- **[WCPFC](https://www.wcpfc.int/public-domain-aggregated-catcheffort-data)** – Western and Central Pacific Fisheries Commission data

## Repository Structure

- `data/`:
    - `data/raw`: contains original datasets retrieved from RFMOs
    - `data/processed`: 
- `scripts/`:
    - `scripts/01_processing`:
    - `scripts/02_analysis`:
    - `scripts/03_content`:
- `results/`:
    - `results/figures`
    - `results/img`:
    - `results/tab`:

## Raw catch and effort data sets by RFMO

### IATTC
##### Source: https://www.iattc.org/en-us/Data/Public-domain
##### File path under: `data/raw/iattc`

| Gear          | Spatial | Temporal       | Organized by     | Species           | Measurement type      | Base path                                       | Dataset                   | Metadata                        |
|---------------|---------|----------------|------------------|-------------------|-----------------------|-------------------------------------------------|---------------------------|---------------------------------|
| pole and line | 1°×1°   | year and month | flag             | tuna              | -                     | `month_1deg_poleline_flag/PublicLPTuna`         | `PublicLPTunaFlag.csv`    | `LPTuna-Atun.pdf`               |
| purse seine   | 1°×1°   | year and month | flag             | tuna              | -                     | `month_1deg_purseseine/PublicPSTuna`            | `PublicPSTunaFlag.csv`    | `PSTuna-Atun.pdf`               |
| purse seine   | 1°×1°   | year and month | set type         | tuna              | -                     | `month_1deg_purseseine/PublicPSTuna`            | `PublicPSTunaSetType.csv` | `PSTuna-Atun.pdf`               |
| longline      | 5°×5°   | year and month | flag or set type | tuna and billfish | metric tons           | `month_5deg_longline_flag/PublicLLTunaBillfish` | `PublicLLTunaBillfishMt`  | `LLTunaBillfish-AtunPicudo.pdf` |
| longline      | 5°×5°   | year and month | flag or set type | tuna and billfish | number of individuals | `month_5deg_longline_flag/PublicLLTunaBillfish` | `PublicLLTunaBillfishNum` | `LLTunaBillfish-AtunPicudo.pdf` |

### ICCAT
##### Source: https://www.iccat.int/en/accesingdb.HTML
##### File path under: `data/raw/iccat`

| Gear  | Spatial         | Temporal | Organized by   | Species | Measurement type | Base path                                                      | Dataset                                 | Metadata             |
|-------|-----------------|----------|----------------|---------|------------------|----------------------------------------------------------------|-----------------------------------------|----------------------|
| multi | 1°×1° and 5°×5° | month    | flag           | multi   | -                | `month_multigear_flag`                                         | `t2ce_detailedCatalogue.csv`            | `iccat/t2ce-ENG.pdf` |
| multi | 1°×1° and 5°×5° | month    | operation mode | multi   | -                | `month_multigear_flag_operationmode/t2ce_PS1991-2023_bySchool` | `t2ce_ETRO-PS1991-2023_bySchool_v1.csv` | `iccat/t2ce-ENG.pdf` |

### IOTC
##### Source: https://iotc.org/data/datasets
##### File path under: `data/raw/iotc`

| Gear                     | Spatial         | Temporal | Organized by | Species | Measurement type | Base path                                        | Dataset  | Metadata                                                                                                   |
|--------------------------|-----------------|----------|--------------|---------|------------------|--------------------------------------------------|----------|------------------------------------------------------------------------------------------------------------|
| Purse seine and longline | 1°×1° and 5°×5° | month    | catch        | multi   | -                | `month_multigear/IOTC-DATASETS-2025-10-13-CEALL` | `CA_RAW` | `iotc/IOTC-DATASETS-2025-10-13-CE-Reference_1950-2024/IOTC-DATASETS-2025-10-13-CE-Reference_1950-2024.csv` |
| Purse seine and longline | 1°×1° and 5°×5° | month    | effort       | multi   | -                | `month_multigear/IOTC-DATASETS-2025-10-13-CEALL` | `EF_RAW` | `iotc/IOTC-DATASETS-2025-10-13-CE-Reference_1950-2024/IOTC-DATASETS-2025-10-13-CE-Reference_1950-2024.csv` |

### WCPFC
##### Source: https://www.wcpfc.int/sustainability/scientific-data/wcpfc-public-domain-aggregated-catcheffort-data-download-page
##### File path under: `data/raw/wcpfc`

| Gear          | Spatial | Temporal         | Organized by | Species | Measurement type | Base path                                                      | Dataset                                 | Metadata                  |
|---------------|---------|------------------|--------------|---------|------------------|----------------------------------------------------------------|-----------------------------------------|---------------------------|
| purse seine   | 1°×1°   | year and month   | -            | multi   | -                | `month_1deg_purseseine/WCPFC_S_PUBLIC_BY_YY_MM_1x1`            | `WCPFC_S_PUBLIC_BY_YY_MM_1x1.csv`       | `Purse_seine.pdf`         |
| drift net     | 5°×5°   | year and month   | -            | multi   | -                | `month_5deg_driftnet/WCPFC_G_PUBLIC_BY_YR_MON_2`               | `WCPFC_G_PUBLIC_BY_YR_MON.csv`          | `GN_Public_by_YR_MON.pdf` |
| longline      | 5°×5°   | year and month   | -            | multi   | -                | `month_5deg_longline/WCPFC_L_PUBLIC_BY_YY_MM`                  | `WCPFC_L_PUBLIC_BY_YY_MM.csv`           | `Longline.pdf`            |
| longline      | 5°×5°   | year and month   | flag         | multi   | -                | `month_5deg_longline_flag/WCPFC_L_PUBLIC_BY_YY_MM_FLAG`        | `WCPFC_L_PUBLIC_BY_YY_MM_FLAG.csv`      | `Longline.pdf`            |
| pole and line | 5°×5°   | year and month   | -            | multi   | -                | `month_5deg_poleline/WCPFC_P_PUBLIC_BY_YY_MM`                  | `WCPFC_P_PUBLIC_BY_YY_MM.csv`           | `Pole_and_line.pdf`       |
| purse seine   | 5°×5°   | year and month   | -            | multi   | -                | `month_5deg_purseseine/WCPFC_S_PUBLIC_BY_YY_MM`                | `WCPFC_S_PUBLIC_BY_YY_MM.csv`           | `Purse_seine.pdf`         |
| pole and line | 1°×1°   | year and quarter | flag         | multi   | -                | `quarter_1deg_poleline/WCPFC_P_PUBLIC_BY_YY_QTR_FLAG_1x1`      | `WCPFC_P_PUBLIC_BY_YY_QTR_FLAG_1x1.csv` | `Pole_and_line.pdf`       |
| purse seine   | 1°×1°   | year and quarter | flag         | multi   | -                | `quarter_1deg_purseseine_flag/WCPFC_S_PUBLIC_BY_YY_QTR_FLAG_0` | `WCPFC_S_PUBLIC_BY_YY_QTR_FLAG.csv`     | `Purse_seine.pdf`         |
| longline      | 5°×5°   | year and quarter | flag         | multi   | -                | `quarter_5deg_longline_flag/WCPFC_L_PUBLIC_BY_YY_QTR_FLAG`     | `WCPFC_L_PUBLIC_BY_YY_QTR_FLAG.csv`     | `Longline.pdf`            |
| purse seine   | 5°×5°   | year and quarter | flag         | multi   | -                | `quarter_5deg_purseseine_flag/WCPFC_S_PUBLIC_BY_YY_QTR_FLAG`   | `WCPFC_S_PUBLIC_BY_YY_QTR_FLAG.csv`     | `Purse_seine.pdf`         |
| longline      | 5°×5°   | year             | flag         | multi   | -                | `year_5deg_longline_flag/WCPFC_L_PUBLIC_BY_YY_FLAG_1`          | `WCPFC_L_PUBLIC_BY_YY_FLAG.csv`         | `Longline.pdf`            |
| purse seine   | 5°×5°   | year             | flag         | multi   | -                | `year_5deg_purseseine_flag/WCPFC_S_PUBLIC_BY_YY_FLAG`          | `WCPFC_S_PUBLIC_BY_YY_FLAG.csv`         | `Purse_seine.pdf`         |


## Cleaned catch and effort data sets by RFMO

### IATTC
##### Source: https://www.iattc.org/en-us/Data/Public-domain
##### File path under: `data/clean/iattc`

### ICCAT
##### Source: https://www.iccat.int/en/accesingdb.HTML
##### File path under: `data/clean/iccat`



### IOTC
##### Source: https://iotc.org/data/datasets
##### File path under: `data/clean/iotc`

### WCPFC
##### Source: https://www.wcpfc.int/sustainability/scientific-data/wcpfc-public-domain-aggregated-catcheffort-data-download-page
##### File path under: `data/clean/wcpfc


