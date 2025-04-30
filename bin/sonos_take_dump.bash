#!/bin/bash 

export PGHOST=temp-prod-clone-for-staging-refresh-cluster.cluster-c4oeaf4nqbcg.us-east-1.rds.amazonaws.com
export PGPORT=5432
export PGUSER=postgres
export PGDATABASE=postgres
export DUMP_LOC=/postgres

#for SCHEMA in prod_roc 
#for SCHEMA in prod_wso2_api prod_wso2_reg prod_wso2_usr
#for SCHEMA in prod_sms_obj prod_wso2_api prod_wso2_reg prod_wso2_usr
for SCHEMA in prod_sms_obj
do
  echo "`date`: Taking dump of ${SCHEMA}"
  export DUMP_FILE=${DUMP_LOC}/${SCHEMA}.dump
  export LOG_FILE=${DUMP_LOC}/log/${SCHEMA}_dump.log
  pg_dump -v -Z0 -j 15 -h ${PGHOST} -d ${PGDATABASE} -U ${PGUSER} -n ${SCHEMA} -Fd -f ${DUMP_FILE} > ${LOG_FILE} 2>&1
  echo "`date`: Done with dump of ${SCHEMA}. Dump file is ${DUMP_FILE} "
done

