DB_NAME=enceladus
DATA_DIR=${CURDIR}/data
SQL_DIR=${CURDIR}/sql
CREATE_MASTER_SCRIPT=$(SQL_DIR)/0001-create-master-db.sql
CSV_FILE=$(DATA_DIR)/master_plan.csv
IMPORT_SCRIPT=$(SQL_DIR)/0002-import.sql
CREATE_EVENTS_SCRIPT=$(SQL_DIR)/0004-create-events-table.sql
CREATE_LOOKUPS_SCRIPT=$(SQL_DIR)/0003-create-lookups.sql
NORMALIZE_SCRIPT=$(SQL_DIR)/0005-normalize.sql
OUTPUT_DIR=${CURDIR}/build
DOIT_SCRIPT=$(OUTPUT_DIR)/doit.sql
INMS_CSV=$(DATA_DIR)/inms.csv
INMS_ARCHIVE=$(DATA_DIR)/inms.csv.xz
INMS_SCRIPT=$(SQL_DIR)/0007-inms-import.sql
IMPORT_INMS_SCRIPT=$(OUTPUT_DIR)/inms.sql

all: normalize-mp inms
	psql $(DB_NAME) -U postgres -f $(DOIT_SCRIPT)

masterplan:
	@cat $(CREATE_MASTER_SCRIPT) > $(DOIT_SCRIPT)

# Can't use sql/0002-import-csv.sql directly because we need to
# replace the full path to the CSV file
import-mp: masterplan
	@echo "copy import.master_plan from \
	'$(CSV_FILE)' with delimiter ',' header csv;" >> $(DOIT_SCRIPT)

normalize-mp: import-mp
	@cat $(CREATE_LOOKUPS_SCRIPT) >> $(DOIT_SCRIPT)
	@cat $(CREATE_EVENTS_SCRIPT) >> $(DOIT_SCRIPT)
	@cat $(NORMALIZE_SCRIPT) >> $(DOIT_SCRIPT)

inms: normalize-mp
# don't extract csv if it already exists
ifeq ("$(wildcard $(INMS_CSV))","")
	@unxz --keep $(INMS_ARCHIVE)
endif
# postgres wants absolute paths
# $$ is a litteral $ for make
	sed -e "s|^from '.*'$$|from '$(INMS_CSV)'|" $(INMS_SCRIPT) >> $(DOIT_SCRIPT)

clean:
	@rm -rf $(DOIT_SCRIPT)
	@rm -rf $(INMS_CSV)
