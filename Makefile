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

all: normalize
	psql $(DB_NAME) -U postgres -f $(DOIT_SCRIPT)

master:
	@cat $(CREATE_MASTER_SCRIPT) >> $(DOIT_SCRIPT)

import: master
	# Can't use sql/0002-import-csv.sql directly because we need to
	# replace the full path to the CSV file
	@echo "copy master_plan from \
	'$(CSV_FILE)' with delimiter ',' header csv;" >> $(DOIT_SCRIPT)

normalize: import
	@cat $(CREATE_LOOKUPS_SCRIPT) >> $(DOIT_SCRIPT)
	@cat $(CREATE_EVENTS_SCRIPT) >> $(DOIT_SCRIPT)
	@cat $(NORMALIZE_SCRIPT) >> $(DOIT_SCRIPT)

clean:
	@rm -rf $(DOIT_SCRIPT)
