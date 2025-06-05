run_pg_db_size_check() {
  local SOURCE_FILE=$1
  local CLUSTER_NAME=$2

  source ~/.bashrc
  cd /Users/schiambaram.ctr/KCS/scripts/learning-cloud/bin || return

  source "$SOURCE_FILE"
  set -x
  python3 ./pg_db_size.py --host "${PGHOST}" --port "${PGPORT}" --name "${PGDATABASE}" --user "${PGUSER}" --password "${PGPASSWORD}" --clustername ${CLUSTER_NAME}
  set +x
}

run_pg_db_size_check ~/KCS/prod/prod-ods ODS
run_pg_db_size_check ~/KCS/prod/prod-dcm DCM
run_pg_db_size_check ~/KCS/prod/prod-rhdb RHDB

