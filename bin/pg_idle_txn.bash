run_pg_idle_txn_check() {
  local SOURCE_FILE=$1
  local CLUSTER_NAME=$2

  source ~/.bashrc
  cd /Users/schiambaram.ctr/KCS/scripts/learning-cloud/bin || return

  source "$SOURCE_FILE"
  python3 ./pg_idle_txn.py --host "${PGHOST}" --port "${PGPORT}" --name "${PGDATABASE}" --user "${PGUSER}" --password "${PGPASSWORD}" --clustername ${CLUSTER_NAME}
}

run_pg_idle_txn_check ~/KCS/prod/prod-ods ODS

