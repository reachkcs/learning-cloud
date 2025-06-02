import psycopg2
import os
from datetime import datetime

# Database connection parameters - update these with your credentials
DB_HOST = os.environ.get("PGHOST")
DB_PORT = os.environ.get("PGPORT")
DB_NAME = os.environ.get("PGDATABASE")
DB_USER = os.environ.get("PGUSER")
DB_PASSWORD = os.environ.get("PGPASSWORD")

query = """
SELECT
    pg_size_pretty(SUM(pg_table_size(schemaname || '.' || tablename))) AS total_table_size,
    pg_size_pretty(SUM(pg_indexes_size(schemaname || '.' || tablename))) AS total_indexes_size,
    pg_size_pretty(SUM(pg_total_relation_size(schemaname || '.' || tablename))) AS total_size
FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema');
"""

def get_db_size():
    try:
        # Connect to PostgreSQL
        conn = psycopg2.connect(
            host=DB_HOST,
            port=DB_PORT,
            dbname=DB_NAME,
            user=DB_USER,
            password=DB_PASSWORD
        )
        cur = conn.cursor()
        cur.execute(query)
        result = cur.fetchone()

        print(datetime.now().strftime('%Y-%m-%d %H:%M:%S'), result[0], result[1], result[2], sep='\t')

        cur.close()
        conn.close()
    except Exception as e:
        print("Error:", e)

if __name__ == "__main__":
    get_db_size()
