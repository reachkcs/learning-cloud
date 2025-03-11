#!/bin/bash

. ~/.bashrc

export DT=$(date -d "yesterday" +"%Y-%m-%d")
export SDIR="/home/devops/scripts"
cd ${SDIR}/devops-scripts/python
CMD="./download_aurora_postgres_logs.py --date ${DT}"
echo "Running <${CMD}> to download PG logs for yesterday"
${CMD}
exit 0
