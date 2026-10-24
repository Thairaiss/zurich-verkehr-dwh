from sqlalchemy import create_engine
import pandas as pd

engine = create_engine("postgresql+psycopg2://tim:dev_passwort_123@localhost:5432/dwh")

# --- Standorte ---
standorte = pd.read_csv("data/standorte.csv", encoding="utf-8-sig")
standorte.columns = standorte.columns.str.lower()
standorte.to_sql("standorte", con=engine, if_exists="replace", index=False)
print(f"Standorte geladen: {len(standorte)} Zeilen")

# --- Messungen ---
messungen = pd.read_csv("data/messungen_2024.csv")
messungen["DATUM"] = pd.to_datetime(messungen["DATUM"])
messungen = messungen.drop(columns=["OST", "NORD"])
messungen.columns = messungen.columns.str.lower()
messungen.to_sql("messungen", con=engine, if_exists="replace",
                 index=False, chunksize=5000, method="multi")

print(f"Messungen geladen: {len(messungen)} Zeilen")