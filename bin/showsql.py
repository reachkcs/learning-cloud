#!/usr/bin/python3

import os
import sys
import subprocess

# Define the directory containing SQL files
SDIR = os.getenv("TOOLS_DIR")
if not SDIR:
    print("Error: TOOLS_DIR environment variable is not set.")
    exit(1)

SQL_DIR = os.path.join(SDIR, "sql")
TEMP_DIR = "/tmp"
print(f"SDIR: {SDIR}")
print(f"SQL Directory: {SQL_DIR}")

def list_sql_files(directory, filter_str=None):
    """List all .sql files in the given directory, optionally filtered by a string."""

    if not os.path.isdir(directory):
        print(f"Directory not found: {directory}")
        return []

    files = [f for f in os.listdir(directory) if f.endswith(".sql")]
    if filter_str:
        files = [f for f in files if filter_str.lower() in f.lower()]

    return files

def display_menu(files):
    """Display a menu of SQL files."""
    print("\nAvailable SQL Scripts:")
    for idx, file in enumerate(files, start=1):
        print(f"{idx}. {file}")
    print("0. Exit")

def run_sql_file(file_path):
    """Run the selected SQL file using the psql client and save output to a file."""
    output_file = os.path.join(TEMP_DIR, os.path.basename(file_path).replace(".sql", ".out"))
    try:
        print(f"\nRunning SQL script: {file_path}")
        with open(file_path, "r") as sql_file:
            sql_content = sql_file.read()

        result = subprocess.run(
            #["psql", "-f", file_path],
            ["psql", "-v", "ON_ERROR_STOP=1", "-f", file_path],
            capture_output=True,
            text=True
        )

        with open(output_file, "w") as out_file:
            out_file.write("--- SQL Script ---\n")
            out_file.write(sql_content + "\n\n")
            out_file.write("--- SQL Execution Result ---\n")
            out_file.write(result.stdout)

        if result.returncode != 0:
            out_file.write("\n--- SQL Execution Error ---\n")
            out_file.write(result.stderr)
            print(f"\nError details saved to {output_file}")
            print("\n--- SQL Execution Result ---")
            print(result.stderr)
        else:
            print(f"\nOutput saved to {output_file}")
            print("\n--- SQL Execution Output ---")
            print(result.stdout)

    except FileNotFoundError:
        print("Error: psql client not found. Ensure it is installed and in your PATH.")

def main():
    """Main program to list, select, and run SQL scripts."""
    # Get the filter string from command-line arguments (if provided)
    filter_str = sys.argv[1] if len(sys.argv) > 1 else None

    sql_files = list_sql_files(SQL_DIR, filter_str)
    if not sql_files:
        print("No SQL files found matching the filter." if filter_str else "No SQL files found in the directory.")
        return

    while True:
        display_menu(sql_files)
        choice = input("\nSelect an option (0 to exit): ")

        if choice == "0":
            print("Exiting...")
            break

        try:
            choice = int(choice)
            if 1 <= choice <= len(sql_files):
                selected_file = os.path.join(SQL_DIR, sql_files[choice - 1])
                run_sql_file(selected_file)
            else:
                print("Invalid choice. Please try again.")
        except ValueError:
            print("Invalid input. Please enter a number.")

if __name__ == "__main__":
    main()

