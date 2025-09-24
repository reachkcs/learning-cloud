#!/usr/bin/python3
import pandas as pd
import matplotlib.pyplot as plt
import re
from datetime import datetime

# Path to your log file
log_file = '/Users/schiambaram.ctr/KCS/logs/pg_db_size.cron.log'

# Storage for parsed rows
rows = []

# Helper: Extract number only, treat all as GB
def extract_size(size_str):
    match = re.match(r'([\d.]+)\s*(GB|MB)', size_str)
    return float(match.group(1)) if match else None

# Read and parse the log file
with open(log_file, 'r') as f:
    for line in f:
        if re.match(r'^\d{4}-\d{2}-\d{2}', line):  # Start with date
            parts = line.strip().split()
            if len(parts) >= 9:
                date_str = parts[0] + ' ' + parts[1]
                cluster = parts[2]
                table_size = parts[3] + ' ' + parts[4]
                index_size = parts[5] + ' ' + parts[6]
                total_size = parts[7] + ' ' + parts[8]
                if cluster == 'ODS':
                    try:
                        rows.append({
                            'Date': datetime.strptime(date_str, '%Y-%m-%d %H:%M:%S'),
                            'Cluster': cluster,
                            'Table (GB)': extract_size(table_size),
                            'Index (GB)': extract_size(index_size),
                            'Total (GB)': extract_size(total_size)
                        })
                    except Exception as e:
                        print(f"Skipping line due to error: {line}\n{e}")



# Convert to DataFrame
df = pd.DataFrame(rows)

# Plot size growth per cluster
print(f"Total rows parsed: {len(df)}")
print("DataFrame columns:", df.columns)
print(df.head())  # Show first few rows to inspect structure
clusters = df['Cluster'].unique()
for cluster in clusters:
    cluster_df = df[df['Cluster'] == cluster].sort_values('Date')
    plt.figure(figsize=(10, 6))
    plt.plot(cluster_df['Date'], cluster_df['Table (GB)'], label='Table Size (GB)')
    plt.plot(cluster_df['Date'], cluster_df['Index (GB)'], label='Index Size (GB)')
    plt.plot(cluster_df['Date'], cluster_df['Total (GB)'], label='Total Size (GB)')
    plt.xlabel('Date')
    plt.ylabel('Size (GB)')
    plt.title(f'Size Growth Over Time - Cluster: {cluster}')
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()
