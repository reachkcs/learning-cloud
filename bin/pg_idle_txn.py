import psycopg2
import os
from datetime import datetime

# Read connection details from environment variables
DB_HOST = os.getenv("DB_HOST")
DB_NAME = os.getenv("DB_NAME")
DB_USER = os.getenv("DB_USER")
DB_PASSWORD = os.getenv("DB_PASSWORD")
DB_PORT = os.getenv("DB_PORT", 5432)
CLUSTER_NAME = os.getenv("CLUSTER_NAME", "unknown_cluster")

# Query to fetch idle-in-transaction sessions > 30 minutes
query = """
SELECT pid, usename, datname, client_addr, application_name, backend_start,
       xact_start, now() - xact_start AS duration, now() as current_tm,
       state, query
FROM pg_stat_activity
WHERE state = 'idle in transaction'
  AND now() - xact_start > interval '30 minutes'
ORDER BY duration DESC;
"""

def get_idle_in_txn():
    try:
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            database=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        cur = conn.cursor()
        cur.execute(query)
        results = cur.fetchall()

        # Print header
        print("timestamp\tcluster\tpid\tusename\tdatname\tclient_addr\tapplication_name\tbackend_start\txact_start\tduration\tcurrent_tm\tstate\tquery")

        for row in results:
            print(
                datetime.now().strftime('%Y-%m-%d %H:%M:%S'),
                CLUSTER_NAME,
                *[str(col) if col is not None else "" for col in row],
                sep='\t'
            )

        cur.close()
        conn.close()
    except Exception as e:
        print("Error:", e)

if __name__ == "__main__":
    get_idle_in_txn()

