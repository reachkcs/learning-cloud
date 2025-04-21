#!/usr/bin/bash
export SCHEMA=$1

if [ -z ${SCHEMA} ];then
    echo "USAGE: $0 <schema name>"
    exit 0
fi

echo "Taking dump of schema ${SCHEMA}"
set -x
pg_dump -v -Z0 -j 15 -h temp-prod-clone-for-staging-refresh-cluster.cluster-c4oeaf4nqbcg.us-east-1.rds.amazonaws.com -d postgres -U postgres -n ${SCHEMA} -Fd -f ${SCHEMA}.dump > ${SCHEMA}.log 2>&1
echo "Done taking dump of schema ${SCHEMA}"
