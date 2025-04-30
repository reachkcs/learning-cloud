#!/bin/bash

export PGHOST=tfnr-stg-ods-perf-cluster-16-cluster.cluster-cmnsfh0drurl.us-west-2.rds.amazonaws.com
export PGPORT=5432
export PGUSER=postgres
export PGDATABASE=postgres
export DUMP_LOC=/postgres

#for SCHEMA in prod_sms_obj prod_wso2_api prod_wso2_reg prod_wso2_usr
#for SCHEMA in prod_sms_obj
#for SCHEMA in prod_roc
#for SCHEMA in prod_wso2_api prod_wso2_reg prod_wso2_usr
for SCHEMA in prod_sms_obj
do
  export DUMP_FILE=${DUMP_LOC}/${SCHEMA}.dump
  export LOG_FILE=${DUMP_LOC}/log/${SCHEMA}_restore.log
  echo "`date`: Restoring ${SCHEMA} using the  dump ${DUMP_FILE}"

  pg_restore -v -j 15 -h ${PGHOST} -d ${PGDATABASE} -U ${PGUSER} -F d ${DUMP_FILE} > ${LOG_FILE} 2>&1

  echo "`date`: Done with restoring of ${SCHEMA}. Dump file is ${DUMP_FILE}"
done
