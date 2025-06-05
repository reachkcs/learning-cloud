import psycopg2
import os
from datetime import datetime
import argparse


# Set up argument parser
parser = argparse.ArgumentParser(description="Database connection parameters")

parser.add_argument("--host", dest="DB_HOST", required=True, help="Database host")
parser.add_argument("--port", dest="DB_PORT", required=True, help="Database port")
parser.add_argument("--name", dest="DB_NAME", required=True, help="Database name")
parser.add_argument("--user", dest="DB_USER", required=True, help="Database user")
parser.add_argument("--password", dest="DB_PASSWORD", required=True, help="Database password")
parser.add_argument("--clustername", dest="CLUSTER_NAME", required=True, help="Cluster name")

# Parse arguments
args = parser.parse_args()

# Assign values
DB_HOST = args.DB_HOST
DB_PORT = args.DB_PORT
DB_NAME = args.DB_NAME
DB_USER = args.DB_USER
DB_PASSWORD = args.DB_PASSWORD
CLUSTER_NAME = args.CLUSTER_NAME

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

        print(datetime.now().strftime('%Y-%m-%d %H:%M:%S'), CLUSTER_NAME, result[0], result[1], result[2], sep='\t')

        cur.close()
        conn.close()
    except Exception as e:
        print("Error:", e)

if __name__ == "__main__":
    get_db_size()
