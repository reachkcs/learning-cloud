#!/usr/bin/python3
import pandas as pd
import matplotlib.pyplot as plt

# Sample DataFrame (replace with your actual data)
data = {
    'Date': ['2025-01-01', '2025-02-01', '2025-03-01'],
    'Table size in GB': [10, 12, 15],
    'Index size in GB': [3, 4, 5],
    'Total size in GB': [13, 16, 20]
}
df = pd.DataFrame(data)
df['Date'] = pd.to_datetime(df['Date'])

# Plot
plt.figure(figsize=(10, 6))
plt.plot(df['Date'], df['Table size in GB'], label='Table Size (GB)')
plt.plot(df['Date'], df['Index size in GB'], label='Index Size (GB)')
plt.plot(df['Date'], df['Total size in GB'], label='Total Size (GB)')
plt.xlabel('Date')
plt.ylabel('Size in GB')
plt.title('Database Size Growth Over Time')
plt.legend()
plt.grid(True)
plt.tight_layout()
plt.show()
