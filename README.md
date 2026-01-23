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

## Catch and effort data sets by RFMO

### IATTC
Source: https://www.iattc.org/en-us/Data/Public-domain

| Gear         | Spatial | Temporal        | Organized by       | Species            | File Path                                                                  | New Internal File |
|--------------|---------|-----------------|--------------------|--------------------|---------------------------------------------------------------------------|-------------------|
| Pole and line | 1°×1°   | Year and month  | Flag               | Tuna               | `data/raw/iattc/month_1deg_poleline_flag/PublicLPTuna.zip`                |                   |
| Purse seine   | 1°×1°   | Year and month  | Flag or set type   | Tuna               | `data/raw/iattc/month_1deg_purseseine/PublicPSTuna.zip`                  |                   |
| Longline      | 5°×5°   | Year and month  | Flag or set type   | Tuna and billfish  | `data/raw/iattc/month_5deg_longline_flag/PublicLLTunaBillfish.zip`       |                   |


### ICCAT
Source: https://www.iccat.int/en/accesingdb.HTML

| Gear | Spatial              | Temporal | Organized by     | Species | File Path                                                                                         | New Internal File |
|------|----------------------|----------|------------------|---------|--------------------------------------------------------------------------------------------------|-------------------|
| Multi | 1°×1° and 5°×5°      | Month    | Flag             | Multi   | `data/raw/iccat/month_multigear_flag/t2ce_detailedCatalogue.csv`                                  |                   |
| Multi | 1°×1° and 5°×5°      | Month    | Operation mode   | Multi   | `data/raw/iccat/month_multigear_flag_operationmode/t2ce_PS1991-2023_bySchool.zip`                |                   |


### IOTC
Source: https://iotc.org/data/datasets

| Gear                     | Spatial              | Temporal | Organized by | Species | File Path                                                                    | New Internal File |
|--------------------------|----------------------|----------|--------------|---------|-----------------------------------------------------------------------------|-------------------|
| Purse seine and longline | 1°×1° and 5°×5°      | Month    | –            | Multi   | `data/raw/iotc/multigear/IOTC-DATASETS-2025-10-13-CEALL.zip`                  |                   |


### WCPFC
Source: https://www.wcpfc.int/sustainability/scientific-data/wcpfc-public-domain-aggregated-catcheffort-data-download-page

| Gear         | Spatial | Temporal           | Organized by | Species | File Path                                                                 | New Internal File |
|--------------|---------|--------------------|--------------|---------|---------------------------------------------------------------------------|-------------------|
| Purse seine  | 1°×1°   | Year and month     | –            | Multi   | `data/raw/wcpfc/month_1deg_purseseine/WCPFC_S_PUBLIC_BY_YY_MM_1x1`          |                   |
| Drift net    | 5°×5°   | Year and month     | –            | Multi   | `data/raw/wcpfc/month_5deg_driftnet/WCPFC_G_PUBLIC_BY_YR_MON_2.zip`         |                   |
| Longline     | 5°×5°   | Year and month     | –            | Multi   | `data/raw/wcpfc/month_5deg_longline/WCPFC_L_PUBLIC_BY_YY_MM.zip`            |                   |
| Longline     | 5°×5°   | Year and month     | Flag         | Multi   | `data/raw/wcpfc/month_5deg_longline_flag/WCPFC_L_PUBLIC_BY_YY_MM_FLAG.zip`  |                   |
| Pole and line| 5°×5°   | Year and month     | –            | Multi   | `data/raw/wcpfc/month_5deg_poleline/WCPFC_P_PUBLIC_BY_YY_MM.zip`             |                   |
| Purse seine  | 5°×5°   | Year and month     | –            | Multi   | `data/raw/wcpfc/month_5deg_purseseine/WCPFC_S_PUBLIC_BY_YY_MM.zip`           |                   |
| Pole and line| 1°×1°   | Year and quarter   | Flag         | Multi   | `data/raw/wcpfc/quarter_1deg_poleline/WCPFC_P_PUBLIC_BY_YY_QTR_FLAG_1x1.zip` |                   |
| Purse seine  | 1°×1°   | Year and quarter   | Flag         | Multi   | `data/raw/wcpfc/quarter_1deg_purseseine/WCPFC_S_PUBLIC_BY_YY_QTR_FLAG_0.zip` |                   |
| Longline     | 5°×5°   | Year and quarter   | Flag         | Multi   | `data/raw/wcpfc/quarter_5deg_longline_flag/WCPFC_L_PUBLIC_BY_YY_QTR_FLAG.zip`|                   |
| Purse seine  | 5°×5°   | Year and quarter   | Flag         | Multi   | `data/raw/wcpfc/quarter_5deg_purseseine_flag/WCPFC_S_PUBLIC_BY_YY_QTR_FLAG.zip`|                  |
| Longline     | 5°×5°   | Year               | Flag         | Multi   | `data/raw/wcpfc/year_5deg_longline_flag/WCPFC_L_PUBLIC_BY_YY_FLAG_1.zip`     |                   |
| Purse seine  | 5°×5°   | Year               | Flag         | Multi   | `data/raw/wcpfc/year_5deg_purseseine_flag/WCPFC_S_PUBLIC_BY_YY_FLAG.zip`     |                   |
