#!/usr/bin/python3 

import json
import psycopg2
from tabulate import tabulate
import os
import argparse

pgdatabase = os.getenv('PGDATABASE') 
if not dbname: 
    print("Please define PGDATABASE environment variable and retry")
    sys.exit()

pgport = os.getenv('PGPORT') 
if not dbname: 
    print("Please define PGPORT environment variable and retry")
    sys.exit()

pgpassword = os.getenv('PGPASSWORD') 
if not dbname: 
    print("Please define PGPASSWORD environment variable and retry")
    sys.exit()

pghost = os.getenv('PGHOST') 
if not dbname: 
    print("Please define PGHOST environment variable and retry")
    sys.exit()

pguser = os.getenv('PGUSER') 
if not dbname: 
    print("Please define PGUSER environment variable and retry")
    sys.exit()

parser = argparse.ArgumentParser(description="Load JSON dump into PostgreSQL table.")
parser.add_argument("--json_dump_file", required=True, help="Path to the JSON dump file")
parser.add_argument("--table_name", required=True, help="Name of the PostgreSQL table to load data into")

args = parser.parse_args()

# Command-line parameters
json_dump_file = args.json_dump_file
table_name = args.table_name

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname=pgdatabase,
    user=pguser,
    password=pgpassword,
    host=pghost,
    port=pgport
)
cursor = conn.cursor()

# Load JSON data

# Read and parse multiple JSON objects
count = 0
with open(json_dump_file, 'r') as file:
    for line in file:
        record = json.loads(line)
        print(json.dumps(record, indent=1))

        cursor.execute(
            f"INSERT INTO {table_name} (id,user_id,user_profile_id,story_id,action,note,created_at,updated_at,ipaddress,activity_completion_id) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s)",
            (record['id'],record['user_id'],record['user_profile_id'],record['story_id'],record['action'],record['note'],record['created_at'],record['updated_at'],record['ipaddress'],record['activity_completion_id'])
        )
        count += 1
        if count % 1000 == 0:
          print(f"Committing {count}...")
          # Commit 
          conn.commit()

print(f"Total number of rows inserted: {count}")

# Close
cursor.close()
conn.close()

