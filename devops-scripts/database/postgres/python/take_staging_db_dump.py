#!/opt/anaconda3/bin/python3
import os
import subprocess
from datetime import datetime
import logging

# Configure logging
script_name = os.path.splitext(os.path.basename(__file__))[0]
log_file_name = f"/tmp/{script_name}.log"
#logging.basicConfig(level=logging.INFO, mode='w', format="%(asctime)s [%(levelname)s] %(message)s", handlers=[logging.FileHandler(log_file_name), logging.StreamHandler()])
logging.basicConfig(
    filename=log_file_name,
    filemode='w',  # Overwrite the log file each time
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

def dump_postgres_db(host, port, user, password, db_name):
    # Ensure the password is set
    if not password:
        logging.error("Environment variable PGPASSWORD is required")
        raise ValueError("Environment variable PGPASSWORD is required")

    date_str = datetime.now().strftime("%Y%m%d")
    dump_path = f"/tmp/dump_{db_name}_{date_str}.sql"

    command = [
        "pg_dump",
        f"--host={host}",
        f"--port={port}",
        f"--username={user}",
        "--format=plain",  # SQL dump
        "--no-owner",
        db_name
    ]
    
    try:
        logging.info(f"Starting database dump for '{db_name}' to '{dump_path}'")
        # Run pg_dump and write output to specified dump path
        env = os.environ.copy()
        with open(dump_path, "wb") as dump_file:
            subprocess.run(command, env=env, stdout=dump_file, check=True)
        logging.info(f"Database SQL dump successfully saved to '{dump_path}'")
    except subprocess.CalledProcessError as e:
        logging.error(f"Error occurred during dump: {e}")
        raise
    except Exception as e:
        logging.error(f"An unexpected error occurred: {e}")
        raise
    
# Main

host = os.environ.get("PGHOST", "localhost")  # Default to localhost if not set
port = os.environ.get("PGPORT", "5432")       # Default to 5432 if not set
user = os.environ.get("PGUSER_STAGE", "postgres")   # Default to 'postgres' if not set
password = os.environ.get("PGPASSWORD")       # Password is required, no default
db_name = os.environ.get("PG_STAGING_DB")       # Password is required, no default

dump_postgres_db(host, port, user, password, db_name)

