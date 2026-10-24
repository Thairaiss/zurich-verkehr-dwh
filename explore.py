import pandas as pd

df = pd.read_csv('data/messungen_2024.csv')

print("--- Form ( Zeilen, Spalten ---")
print(df.shape)

print("\n--- Erste 5 Zeilen ---")
print(df.head())

print("\n--- Spalten & Datentypen ---")
print(df.info())
