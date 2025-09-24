#!/usr/bin/python3

import os
import psycopg2
import pandas as pd

def get_db_connection():
    try:
        conn = psycopg2.connect(
            host=os.getenv("PGHOST", "localhost"),
            port=int(os.getenv("PGPORT", 5432)),
            dbname=os.getenv("PGDATABASE"),
            user=os.getenv("PGUSER"),
            password=os.getenv("PGPASSWORD")
        )
        return conn
    except Exception as e:
        raise RuntimeError(f"Database connection failed: {e}")

def get_table_index_sizes(conn):
    query = """
        SELECT
            schemaname || '.' || relname AS table_name,
            pg_size_pretty(pg_table_size(relid)) AS table_size,
            pg_size_pretty(pg_indexes_size(relid)) AS index_size,
            pg_size_pretty(pg_total_relation_size(relid)) AS total_size,
            pg_table_size(relid) AS table_size_bytes,
            pg_indexes_size(relid) AS index_size_bytes,
            pg_total_relation_size(relid) AS total_size_bytes
        FROM pg_catalog.pg_statio_user_tables
        ORDER BY pg_total_relation_size(relid) DESC;
    """
    with conn.cursor() as cur:
        cur.execute(query)
        rows = cur.fetchall()

    df = pd.DataFrame(rows, columns=[
        'table_name', 'table_size', 'index_size', 'total_size',
        'table_size_bytes', 'index_size_bytes', 'total_size_bytes'
    ])
    return df

def main():
    output_dir = input("Enter the folder path to save the reports: ").strip()
    
    if not output_dir:
        print("No folder specified. Exiting.")
        return

    if not os.path.exists(output_dir):
        try:
            os.makedirs(output_dir)
            print(f"Created directory: {output_dir}")
        except Exception as e:
            print(f"Failed to create directory: {e}")
            return

    txt_path = os.path.join(output_dir, "postgres_table_index_sizes.txt")
    csv_path = os.path.join(output_dir, "postgres_table_index_sizes.csv")

    try:
        conn = get_db_connection()
        df = get_table_index_sizes(conn)

        # Write plain text report
        with open(txt_path, 'w') as f:
            f.write("Table and Index Sizes (Descending by Total Size):\n\n")
            f.write(df[['table_name', 'table_size', 'index_size', 'total_size']].to_string(index=False))

        # Write CSV report
        df.to_csv(csv_path, index=False)

        print(f"\nReports saved successfully to:\n  {txt_path}\n  {csv_path}")
    except Exception as e:
        print(f"Error: {e}")
    finally:
        if 'conn' in locals() and conn:
            conn.close()

if __name__ == "__main__":
    main()
