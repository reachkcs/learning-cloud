#!/bin/bash
. ~/.bashrc
source ../../../nominis-bashrc

DT=$(date +"%Y%m%d")
DIR=/tmp
BACKUP_FN_SQL="${DIR}/pg_staging_dump_${DT}.sql"
echo "Creating the dump file: ${BACKUP_FN_SQL}. Please wait..."

pg_dump -U ${PGUSER_STAGE} -h ${PGHOST} -p ${PGPORT} -d ${PG_STAGING_DB} -F p -f ${BACKUP_FN_SQL}

echo "Done!"

exit 0

