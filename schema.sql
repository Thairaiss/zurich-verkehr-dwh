-- ============================================
-- schema.sql | Struktur des Data Warehouse
-- Die Tabellen selbst werden von load.py (pandas) erstellt.
-- Hier definieren wir Schluessel und Indizes.
-- Einmalig ausfuehren (nach dem load.py-Lauf).
-- ============================================

-- Primaerschluessel: jede Station eindeutig ueber id1
ALTER TABLE standorte ADD PRIMARY KEY (id1);

-- Fremdschluessel: jede Messung muss zu einer echten Station gehoeren
ALTER TABLE messungen
    ADD CONSTRAINT fk_messung_standort
    FOREIGN KEY (fk_standort) REFERENCES standorte (id1);

-- Indizes fuer schnellere Joins und Zeitfilter
CREATE INDEX idx_messungen_standort ON messungen (fk_standort);
CREATE INDEX idx_messungen_datum    ON messungen (datum);