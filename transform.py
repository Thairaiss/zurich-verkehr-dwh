import pandas as pd

df = pd.read_csv("data/messungen_2024.csv")

df["DATUM"] = pd.to_datetime(df["DATUM"])

df = df.drop(columns=["OST", "NORD"])
df.columns = df.columns.str.lower()


print(df.info())