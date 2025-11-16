#!/bin/bash

run_sql() {
  local table_name="$1"

  echo "Running pgstattuple() on table: $table_name"

  local start_epoch=$(date +%s)
  local start_ts=$(date '+%m/%d/%Y %H:%M:%S')

  SQL="SELECT * FROM pgstattuple('${table_name}');"
  SQL_FILE="/tmp/${table_name}.sql"
  echo "${SQL}" > "${SQL_FILE}"
  echo "SQL file: ${SQL_FILE}"
  cat "${SQL_FILE}"

  # prepare logs directory and file
  SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  LOG_DIR="${SCRIPT_DIR}/logs"
  mkdir -p "${LOG_DIR}"
  LOG_FILE="${LOG_DIR}/${table_name}.log"

  # capture psql output (CSV with header)
  tmp_out=$(mktemp)
  PGPASSWORD="${PGPASSWORD:-}" \
    psql --no-psqlrc --csv --host="$PGHOST" --port="$PGPORT" --username="$PGUSER" --dbname="$PGDATABASE" --command "$SQL" > "${tmp_out}" 2>&1

  local end_epoch=$(date +%s)
  local duration=$(( end_epoch - start_epoch ))
  local hours=$(( duration / 3600 ))
  local minutes=$(( (duration % 3600) / 60 ))
  local seconds=$(( duration % 60 ))
  # format duration as HH:MM:SS
  printf -v duration_hms "%02d:%02d:%02d" "$hours" "$minutes" "$seconds"

  # decide whether to include header (only when log does not exist or is empty)
  if [[ ! -s "${LOG_FILE}" ]]; then
    # include header: prefix first line with "start_time,duration,"
    awk -v st="$start_ts" -v dur="$duration_hms" 'NR==1{print "start_time,duration," $0; next} {print st "," dur "," $0}' "${tmp_out}" >> "${LOG_FILE}"
  else
    # skip header (remove first line) and prefix each data line with start_time,duration
    tail -n +2 "${tmp_out}" | awk -v st="$start_ts" -v dur="$duration_hms" '{print st "," dur "," $0}' >> "${LOG_FILE}"
  fi

  rm -f "${tmp_out}"

  echo "Start time : $(date -r "$start_epoch" '+%m/%d/%Y %H:%M:%S')"
  echo "End time   : $(date -r "$end_epoch" '+%Y-%m-%d %H:%M:%S')"
  echo "Duration   : ${hours} hours, ${minutes} minutes, ${seconds} seconds"
  echo
}

source ~/.bashrc

PG_SOURCE_FILE=~/KCS/prod/prod-ods
if [[ ! -f ${PG_SOURCE_FILE} ]]; then
  echo "Error: ${PG_SOURCE_FILE} file not found."
  exit 1
fi

source ${PG_SOURCE_FILE}

required_vars=(PGHOST PGPORT PGUSER PGDATABASE)
for var in "${required_vars[@]}"; do
if [[ -z "${!var:-}" ]]; then
echo "Error: Required environment variable $var is not set in prod-ods file."
  exit 1
fi
done

#run_sql prod_sms_obj.blg_nb_srch
#run_sql prod_sms_obj.blg_nb_srch_tfn
#run_sql prod_sms_obj.cr_cntc
run_sql prod_sms_obj.rqst_rspn