#!/usr/bin/python3

import sys
import os
import json
from datetime import datetime, timedelta
import boto3
from botocore.exceptions import UnauthorizedSSOTokenError, TokenRetrievalError
from colorama import Fore, Style, init
from prettytable import PrettyTable
import subprocess
from datetime import datetime, timedelta
from pathlib import Path
import argparse

def generate_log_filenames(date_str):
    try:
        start_date = datetime.strptime(date_str, "%Y-%m-%d")
    except ValueError as e:
        print("Invalid date format. Please use 'YYYY-MM-DD'.")
        raise e
    
    current_time = datetime.now()
    log_filenames = []
    hour_range = 24
    if date_str == datetime.today().strftime('%Y-%m-%d'):
        hour_range = current_time.hour + 1
    for hour in range(0, hour_range):  # Include current hour
        timestamp = start_date + timedelta(hours=hour)
        log_file_name = f"error/postgresql.log.{timestamp.strftime('%Y-%m-%d-%H%M')}"
        log_filenames.append(log_file_name)

    return log_filenames

def get_date_from_args():
    parser = argparse.ArgumentParser(description="Accept a date in YYYY-MM-DD format or use the current date.")
    parser.add_argument(
        '--date',
        type=str,
        default=datetime.today().strftime('%Y-%m-%d'),
        help="Date in YYYY-MM-DD format (default is today's date)"
    )
    args = parser.parse_args()
    return args.date

def download_aurora_logs(db_instance_id, log_file_name, local_file_path):
    # Initialize the RDS client
    client = boto3.client('rds', region_name=aws_region)

    # Describe log files for the DB instance
    response = client.describe_db_log_files(
        DBInstanceIdentifier=db_instance_id
    )
    
    # Loop through the log files to find the correct one
    for log_file in response['DescribeDBLogFiles']:
        if log_file['LogFileName'] == log_file_name:            
            # Download the log file in chunks (as it's large)
            starting_token = None
            with open(local_file_path, 'w') as local_file:
                while True:
                    if starting_token:
                        # Download the log file portion
                        download_response = client.download_db_log_file_portion(
                            DBInstanceIdentifier=db_instance_id,
                            LogFileName=log_file_name,
                            Marker=starting_token
                        )
                    else:
                        download_response = client.download_db_log_file_portion(
                            DBInstanceIdentifier=db_instance_id,
                            LogFileName=log_file_name
                        )
                    
                    if not isinstance(download_response, dict):
                        raise TypeError(f"Expected response to be a dict, got {type(download_response)}")

                    local_file.write(download_response['LogFileData'])
                    
                    # Check if there are more portions to download
                    if not download_response.get('AdditionalDataPending', False):
                        break
                    starting_token = download_response.get('Marker')
            
            print(f"Log file '{log_file_name}' downloaded successfully to '{local_file_path}'")
            break
    else:
        print(f"Log file '{log_file_name}' not found.")

def check_for_errors(dir_path):
    import subprocess

    # Path to the Bash script
    scripts_dir=os.getenv('SDIR')

    if not scripts_dir:
        print("Please define NWORK_DIR environment variable and retry")
        sys.exit()

    script_path = f"{scripts_dir}/devops-scripts/bash/check_for_db_issues_in_logfiles.bash"

    # Call the script
    try:
        result = subprocess.run(
            ["bash", script_path] + [dir_path],  # Use "bash" to ensure the script is executed by Bash
            check=True,            # Raise an error if the script fails
            stdout=subprocess.PIPE, # Capture standard output
            stderr=subprocess.PIPE  # Capture standard error
        )

        # Print the output of the script
        print("Script output:", result.stdout.decode().strip())
    except subprocess.CalledProcessError as e:
        print("Script failed with error:", e.stderr.decode().strip())


#
# Main
#
aws_region = os.getenv('AWS_REGION')
if not aws_region:
    print("Please define AWS_REGION environment variable and retry")
    sys.exit()

db_instance_id = 'db-prod-2'

#day = datetime.today().strftime('%Y-%m-%d')
log_date = get_date_from_args()
#current_date = datetime.now().strftime("%Y-%m-%d")
log_files = generate_log_filenames(log_date)
home_dir = str(Path.home())
log_dir = home_dir+'/nominis_pg_logs'

# Create the folder if it does not exist
dir_path = os.path.join(log_dir, log_date)
if not os.path.exists(dir_path):
    print(f'Creating missing directory {dir_path}')
    os.makedirs(dir_path, exist_ok=True)

for log_file in log_files:
    local_log_file = f'{dir_path}/{log_file[6:]}'
    if os.path.exists(local_log_file):
        print(f'{local_log_file} exists. Skipping the download.')
    else:
        print(f'Downloading Aurora Postgres log {log_file} to local log file {local_log_file}')
        download_aurora_logs(db_instance_id, log_file, local_log_file)

check_for_errors(dir_path)
