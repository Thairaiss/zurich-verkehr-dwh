-- ============================================
-- analysen.sql | Auswertungen des Velo-/Fussverkehrs
-- ============================================

-- View: Velo-Summe pro Station (wiederverwendbar)
CREATE OR REPLACE VIEW v_velo_pro_station AS
SELECT s.id1,
       s.bezeichnung,
       SUM(m.velo_in) + SUM(m.velo_out) AS velo_gesamt
FROM messungen m
JOIN standorte s ON m.fk_standort = s.id1
GROUP BY s.id1, s.bezeichnung;


-- Views auflisten
\dv

-- View anschauen (Top 10 Velo Stationen 2024)
SELECT * FROM v_velo_pro_station
ORDER BY velo_gesamt DESC NULLS LAST
LIMIT 10;


-- Veloverkehr pro Monat 2024 (saisonales Muster)
SELECT DATE_TRUNC('month', datum) AS monat,
       SUM(velo_in) + SUM(velo_out) AS velo_gesamt
FROM messungen
GROUP BY monat
ORDER BY monat;

-- Veloverkehr nach Tageszeit (Pendler-Stosszeiten)
SELECT EXTRACT(HOUR FROM datum) AS stunde,
       SUM(velo_in) + SUM(velo_out) AS velo_gesamt
FROM messungen
GROUP BY stunde
ORDER BY stunde;