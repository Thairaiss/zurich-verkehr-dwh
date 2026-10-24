import pandas as pd

df = pd.read_csv("data/messungen_2024.csv")
df["DATUM"] = pd.to_datetime(df["DATUM"])      # Text → echtes Datum
df = df.drop(columns=["OST", "NORD"])          # redundante Koordinaten weg
df.columns = df.columns.str.lower()            # Spalten klein
print(df.info())