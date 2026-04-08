###############################
# Main functions
###############################

.PHONY: all clean iattc iccat wcpfc


iattc: \
	$(PROC_IATTC)iattc_year_1deg_purseseine_flag.rds

iccat: \
	$(PROC_ICCAT)iccat_year_1deg_purseseine_flag.rds

wcpfc: \
	$(PROC_WCPFC)wcpfc_year_1deg_purseseine_flag.rds

###############################
# IATTC
###############################

RAW_IATTC = data/raw/iattc/
ST_IATTC = scripts/01_standardizing/iattc_clean/
PROC_IATTC = data/processed/iattc/

# Month
$(PROC_IATTC)iattc_month_1deg_purseseine.rds: \
	$(ST_IATTC)clean_iattc_month_1deg_purseseine.R \
	$(RAW_IATTC)month_1deg_purseseine_flag/month_1deg_purseseine_flag.csv
	Rscript $(<)

# Year
$(PROC_IATTC)iattc_year_1deg_purseseine.rds: \
	$(ST_IATTC)aggregate_monthly_to_year_iattc_1deg_purseseine.R \
	$(PROC_IATTC)iattc_month_1deg_purseseine.rds
	Rscript $(<)

# Year flag
$(PROC_IATTC)iattc_year_1deg_purseseine_flag.rds: \
	$(ST_IATTC)aggregate_monthly_to_year_iattc_1deg_purseseine_flag.R \
	$(RAW_IATTC)month_1deg_purseseine_flag/month_1deg_purseseine_flag.csv
	Rscript $(<)

###############################
# ICCAT
###############################

RAW_ICCAT  = data/raw/iccat/
ST_ICCAT   = scripts/01_standardizing/iccat_clean/
PROC_ICCAT = data/processed/iccat/

# Data converter
$(RAW_ICCAT)ms_database_all/iccat_database.rds: \
	$(ST_ICCAT)convert_iccat_mdb_to_rds.R \
	$(RAW_ICCAT)ms_database_all/ms_database_all.mdb
	Rscript $(<)

# Cleaned data
## Month
$(PROC_ICCAT)iccat_month_1deg_purseseine.rds: \
	$(ST_ICCAT)clean_iccat_month_1deg_purseseine.R \
	$(RAW_ICCAT)ms_database_all/ms_database_all.mdb
	Rscript $<

## Year
$(PROC_ICCAT)iccat_year_1deg_purseseine.rds: \
	$(ST_ICCAT)clean_iccat_year_1deg_purseseine.R \
	$(RAW_ICCAT)ms_database_all/ms_database_all.mdb
	Rscript $<

## Year flag
$(PROC_ICCAT)iccat_year_1deg_purseseine_flag.rds: \
	$(ST_ICCAT)clean_iccat_year_1deg_purseseine_flag.R \
	$(RAW_ICCAT)ms_database_all/ms_database_all.mdb
	Rscript $<

###############################
# WCPFC
###############################

RAW_WCPFC  = data/raw/wcpfc/
ST_WCPFC   = scripts/01_standardizing/wcpfc_clean/
PROC_WCPFC = data/processed/wcpfc/

# Month
$(PROC_WCPFC)wcpfc_month_1deg_purseseine.rds: \
	$(ST_WCPFC)clean_wcpfc_month_1deg_purseseine.R \
	$(RAW_WCPFC)month_1deg_purseseine/month_1deg_purseseine.csv
	Rscript $<

# Year
$(PROC_WCPFC)wcpfc_year_1deg_purseseine.rds: \
	$(ST_WCPFC)aggregate_monthly_to_year_wcpfc_1deg_purseseine.R \
	$(PROC_WCPFC)wcpfc_month_1deg_purseseine.rds
	Rscript $<

# Year flag
$(PROC_WCPFC)wcpfc_year_1deg_purseseine_flag.rds: \
	$(ST_WCPFC)aggregate_quarter_to_year_wcpfc_1deg_flag.R \
	$(RAW_WCPFC)quarter_1deg_purseseine_flag/quarter_1deg_purseseine_flag_old.csv
	Rscript $<


###############################
# Bind data
###############################

DATA_BIND = data/processed/01_bound/
PROC_BIND = scripts/02_processing/01_bind_data/
PROC_RFMO = data/processed/

# Month
$(DATA_BIND)allrfmo_month_1deg_purseseine.rds: \
	$(PROC_BIND)bind_monthly_1deg_purseseine.R \
	$(PROC_IATTC)iattc_month_1deg_purseseine.rds \
	$(PROC_ICCAT)iccat_month_1deg_purseseine.rds \
	$(PROC_WCPFC)wcpfc_month_1deg_purseseine.rds
	Rscript $<

# Year
$(DATA_BIND)allrfmo_year_1deg_purseseine.rds: \
	$(PROC_BIND)bind_yearly_1deg_purseseine.R \
	$(PROC_IATTC)iattc_year_1deg_purseseine.rds \
	$(PROC_ICCAT)iccat_year_1deg_purseseine.rds \
	$(PROC_WCPFC)wcpfc_year_1deg_purseseine.rds
	Rscript $<

# Year flag
$(DATA_BIND)allrfmo_year_1deg_purseseine_flag.rds: \
	$(PROC_BIND)bind_yearly_1deg_purseseine_flag.R \
	$(PROC_IATTC)iattc_year_1deg_purseseine_flag.rds \
	$(PROC_ICCAT)iccat_year_1deg_purseseine_flag.rds \
	$(PROC_WCPFC)wcpfc_year_1deg_purseseine_flag.rds
	Rscript $<

# Detect overlap month
$(DATA_BIND)monthly_overlap_cells.rds: \
	$(PROC_BIND)detect_overlaps.R \
	$(DATA_BIND)allrfmo_month_1deg_purseseine.rds
	Rscript $<

# Detect overlap year
$(DATA_BIND)yearly_overlap_cells.rds: \
	$(PROC_BIND)detect_overlaps.R \
	$(DATA_BIND)allrfmo_year_1deg_purseseine.rds
	Rscript $<

# Detect overlap year flag
$(DATA_BIND)yearly_flag_overlap_cells.rds: \
	$(PROC_BIND)detect_overlaps.R \
	$(DATA_BIND)allrfmo_year_1deg_purseseine_flag.rds
	Rscript $<

###############################
# Harmonize data
###############################

PROC_HARM = scripts/02_processing/02_harmonize_data/
OUT = data/output/

$(OUT)allrfmo_month_1deg_purseseine.rds: \
	$(PROC_HARM)harmonize_monthly_1deg_purseseine_data.R \
	$(DATA_BIND)allrfmo_month_1deg_purseseine.rds \
	$(DATA_BIND)monthly_overlap_cells.rds
	Rscript $<

$(OUT)allrfmo_year_1deg_purseseine.rds: \
	$(PROC_HARM)harmonize_yearly_1deg_purseseine_data.R \
	$(DATA_BIND)allrfmo_year_1deg_purseseine.rds \
	$(DATA_BIND)yearly_overlap_cells.rds
	Rscript $<

$(OUT)allrfmo_year_1deg_purseseine_flag.rds: \
	$(PROC_HARM)harmonize_yearly_1deg_purseseine_flag.R \
	$(DATA_BIND)allrfmo_year_1deg_purseseine_flag.rds \
	$(DATA_BIND)yearly_flag_overlap_cells.rds
	Rscript $<

###############################
# TOP-LEVEL TARGETS
###############################

all: \
	$(OUT)allrfmo_month_1deg_purseseine.rds \
	$(OUT)allrfmo_year_1deg_purseseine.rds \
	$(OUT)allrfmo_year_1deg_purseseine_flag.rds

iattc:
	$(MAKE) $(PROC_IATTC)iattc_year_1deg_purseseine_flag.rds

iccat:
	$(MAKE) $(PROC_ICCAT)iccat_year_1deg_purseseine_flag.rds

wcpfc:
	$(MAKE) $(PROC_WCPFC)wcpfc_year_1deg_purseseine_flag.rds
