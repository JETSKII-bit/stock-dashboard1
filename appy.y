import pandas as pd
import numpy as np
from datetime import datetime, timedelta

# Simulated stock data
items = ['Bread', 'Milk', 'Rice', 'Soap', 'Sugar', 'Tea', 'Salt', 'Oil']
categories = ['Food', 'Beverage', 'Grain', 'Toiletries', 'Sweetener', 'Beverage', 'Spices', 'Cooking']

np.random.seed(42)
stock_data = pd.DataFrame({
    'Item Name': items,
    'Category': categories,
    'Quantity': np.random.randint(5, 100, size=len(items)),
    'Unit Price (R)': np.round(np.random.uniform(10, 50, size=len(items)), 2),
    'Last Restocked': pd.to_datetime("2024-05-01") + pd.to_timedelta(np.random.randint(1, 10, size=len(items)), unit="D"),
    'Daily Sales Rate': np.round(np.random.uniform(1, 10, size=len(items)), 1)
})

stock_data['Predicted Days Left'] = (stock_data['Quantity'] / stock_data['Daily Sales Rate']).round(1)
stock_data['Restock Alert'] = stock_data['Predicted Days Left'] < 7

# Console-based version for environments without Streamlit
print("\n📦 Local Business Stock Dashboard")
print("\nCurrent Inventory:")
print(stock_data.to_string(index=False))

print("\n📉 Low Stock Alerts:")
low_stock = stock_data[stock_data['Restock Alert']]
if not low_stock.empty:
    print("Items running low and need restocking:")
    print(low_stock[['Item Name', 'Quantity', 'Predicted Days Left']].to_string(index=False))
else:
    print("All items are sufficiently stocked.")

# Bar chart alternative (text-based)
print("\n📊 Inventory Overview:")
for _, row in stock_data.iterrows():
    print(f"{row['Item Name']}: {'█' * (row['Quantity'] // 2)} ({row['Quantity']} units)")

# Restock simulation
print("\n🔄 Restock Simulation")
print("Items:", ', '.join(items))
item_to_restock = input("Enter an item to restock: ")
if item_to_restock in items:
    try:
        additional_stock = int(input("Enter number of units to add: "))
        idx = stock_data[stock_data['Item Name'] == item_to_restock].index[0]
        stock_data.at[idx, 'Quantity'] += additional_stock
        stock_data.at[idx, 'Last Restocked'] = datetime.now()
        stock_data.at[idx, 'Predicted Days Left'] = (stock_data.at[idx, 'Quantity'] / stock_data.at[idx, 'Daily Sales Rate']).round(1)
        stock_data.at[idx, 'Restock Alert'] = stock_data.at[idx, 'Predicted Days Left'] < 7
        print(f"\nRestocked {additional_stock} units of {item_to_restock}.")
        print(stock_data.to_string(index=False))
    except ValueError:
        print("Invalid input for stock quantity.")
else:
    print("Item not found in inventory.")
