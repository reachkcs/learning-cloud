#!/usr/bin/python3
import os
import re
import shutil
import sys
from datetime import datetime, timedelta

# Directory to check
base_dir = "/home/devops/nominis_pg_logs"

# Date format and regex pattern
date_format = "%Y-%m-%d"
folder_pattern = re.compile(r"^\d{4}-\d{2}-\d{2}$")

def is_date_folder(folder_name):
    """Check if the folder name matches the YYYY-MM-DD format."""
    if not folder_pattern.match(folder_name):
        return False
    try:
        datetime.strptime(folder_name, date_format)
        return True
    except ValueError:
        return False

def main(days):
    if not os.path.exists(base_dir):
        print(f"Directory {base_dir} does not exist.")
        return

    # Calculate the threshold date based on the input days
    threshold_date = datetime.now() - timedelta(days=days)

    for folder_name in os.listdir(base_dir):
        folder_path = os.path.join(base_dir, folder_name)

        if os.path.isdir(folder_path) and is_date_folder(folder_name):
            folder_date = datetime.strptime(folder_name, date_format)

            print(f"Checking folder: {folder_path}")
            if folder_date < threshold_date:
                print(f"\tRemoving folder: {folder_path}")
                shutil.rmtree(folder_path)  # Remove the folder and its contents

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: ./cleanup_aurora_postgres_logs.py <days>")
        sys.exit(1)

    try:
        days = int(sys.argv[1])
        if days < 0:
            raise ValueError("Days cannot be negative.")
    except ValueError as e:
        print(f"Invalid input for days: {e}")
        sys.exit(1)

    main(days)

