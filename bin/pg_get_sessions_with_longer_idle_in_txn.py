#!/usr/bin/env python3

import os
import sys
import psycopg2
import csv

QUERY = """
SELECT to_char(now(), 'MM/DD/YY HH24:MI:SS') AS run_time,
       pid,
       usename,
       datname,
       client_addr,
       application_name,
       backend_start,
       xact_start,
       now() - xact_start AS duration,
       now() AS current_tm,
       state,
       query
FROM pg_stat_activity
WHERE state = 'idle in transaction'
  AND now() - xact_start > interval '30 minutes'
ORDER BY duration DESC;
"""

def main():
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <output_file>")
        sys.exit(1)

    output_file = sys.argv[1]

    # Read connection info from environment
    conn_params = {
        "host": os.getenv("PGHOST"),
        "port": os.getenv("PGPORT", "5432"),
        "user": os.getenv("PGUSER"),
        "password": os.getenv("PGPASSWORD"),
        "dbname": os.getenv("PGDATABASE"),
    }

    try:
        conn = psycopg2.connect(**conn_params)
        cur = conn.cursor()
        cur.execute(QUERY)
        rows = cur.fetchall()
        colnames = [desc[0] for desc in cur.description]

        # Append output
        file_exists = os.path.isfile(output_file)
        with open(output_file, "a", newline="", encoding="utf-8") as f:
            writer = csv.writer(f)
            if not file_exists:  # write header only once
                writer.writerow(colnames)
            writer.writerows(rows)

        print(f"Query results appended to {output_file}")

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)
    finally:
        if 'cur' in locals():
            cur.close()
        if 'conn' in locals():
            conn.close()

if __name__ == "__main__":
    main()

