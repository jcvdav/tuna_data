
RAW_IATTC=data/raw/iattc/
PROC_IATTC=data/processed/iattc/
ST_IATTC=scripts/01_standardizing/iattc_clean/


$(PROC_IATTC)iattc_month_1deg_purseseine.rds: $(ST_IATTC)clean_iattc_month_1deg_purseseine.R $(RAW_IATTC)month_1deg_purseseine_flag/month_1deg_purseseine_flag.csv
	Rscript $(<)
