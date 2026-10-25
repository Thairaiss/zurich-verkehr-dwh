# Mini Data Warehouse – Zürich Velo- & Fussverkehr

Ein Mini Data Warehouse, das Zürcher Velo und Fussverkehrsdaten per ETL (Eingabe, Transform, Load) Pipeline in eine PostgreSQL-Datenbank lädt und auswertet.

## Ziel
Warum habe ich das gebaut? Was lerne/zeige ich?

Ich wollte etwas um ETL erstmal zu lernen und anzuwenden und dabei auch noch SQL und Datenbanken repetieren

## Datenquelle

Daten von [Open Data Zürich](https://data.stadt-zuerich.ch) (Lizenz CC0):

- [Automatische Fussgänger- und Velozählung – Viertelstundenwerte](https://data.stadt-zuerich.ch/dataset/ted_taz_verkehrszaehlungen_werte_fussgaenger_velo) → `messungen_2024.csv`
- [Standorte der automatischen Fuss- und Velozählungen](https://data.stadt-zuerich.ch/dataset/geo_standorte_der_automatischen_fuss__und_velozaehlungen) → `standorte.csv`

(Standorte-Datei über ein Export Formular herunterladen, einfach gesamten Datensatzu und Format CSV wählen zum nachkreieren)


## Architektur
Der Weg der Daten:

CSV → Python (ETL) → PostgreSQL → SQL-Auswertungen

## Datenmodell

Ein einfaches Star-Schema aus zwei Tabellen:

**`standorte`** (Dimension – ~175 Zählstellen)

| Spalte | Bedeutung |
|--------|-----------|
| `id1` | Eindeutige ID der Station (**Primary Key**) |
| `bezeichnung` | Name der Zählstelle (z.B. "Langstrasse") |
| `richtung_in` / `richtung_out` | Fahrtrichtungen |
| ... | weitere Metadaten (Koordinaten, Korrekturfaktor …) |

**`messungen`** (Fakten – 918'210 Viertelstundenwerte 2024)

| Spalte | Bedeutung |
|--------|-----------|
| `fk_standort` | Verweis auf `standorte.id1` (**Foreign Key**) |
| `datum` | Zeitpunkt der Messung (TIMESTAMP) |
| `velo_in` / `velo_out` | gezählte Velos je Richtung |
| `fuss_in` / `fuss_out` | gezählte Fussgänger je Richtung (oft NULL – nicht jede Station zählt Fussverkehr) |

**Beziehung:** `messungen.fk_standort → standorte.id1` – jede Messung gehört zu genau einer Station.

## Setup

**Voraussetzungen:** Docker Desktop, Python 3

1. Repository klonen:
   ```bash
   git clone https://github.com/Thairaiss/zurich-verkehr-dwh.git
   cd zurich-verkehr-dwh

2. Daten herunterladen (siehe Datenquelle) und als data/messungen_2024.csv und data/standorte.csv ablegen.

3. PostgreSQL-Datenbank starten:
   ```bash
   docker compose up -d

4. Virtuelle Umgebung erstellen und Pakete installieren:
   ```bash
    python -m venv .venv
    .venv\Scripts\activate
    pip install -r requirements.txt

5. ETL ausführen (lädt die CSVs in die Datenbank):
   ```bash
    python load.py

6. Schlüssel/Indizes anlegen und Analysen ausführen – in die DB einsteigen mit:
   ```bash
    docker exec -it dwh-postgres psql -U tim -d dwh

7. und dort die Statements aus schema.sql bzw. analysen.sql ausführen.

## Was ich gelernt habe

ETL:

Begriff höre ich zum ersten Mal und das Konzept ist recht easy. Erinnert mich wie Eingabe Verarbeitung Ausgabe, nur halt angepasst auf Datenbanken.

NULL ≠ 0:

Ein NULL Wert ist nicht das gleiche wie 0, es bedeutet lediglich es hat **noch** keinen Wert vorhanden und bedeutet **nicht** der Wert ist

PostgreSQL:

Hab mehr mit anderen SQL gearbeitet, deswegen war es mal auch schön etwas Kleines mit Postgres zu machen und Postgres spezifische befehle zu verwenden wie VIEWS oder DATE_TRUNC und EXTRACT.