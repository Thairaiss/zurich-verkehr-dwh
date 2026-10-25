S-- Top 10 Velo-Stationen 2024
SELECT s.bezeichnung,
       SUM(m.velo_in) + SUM(m.velo_out) AS velo_gesamt
FROM messungen m
JOIN standorte s ON m.fk_standort = s.id1
GROUP BY s.bezeichnung
ORDER BY velo_gesamt DESC NULLS LAST
LIMIT 10;

-- View: Velo-Summe pro Station (wiederverwendbar)
CREATE VIEW v_velo_pro_station AS
SELECT s.id1,
       s.bezeichnung,
       SUM(m.velo_in) + SUM(m.velo_out) AS velo_gesamt
FROM messungen m
JOIN standorte s ON m.fk_standort = s.id1
GROUP BY s.id1, s.bezeichnung;


-- Views auflisten
\dv

-- View anschauen
SELECT * FROM v_velo_pro_station
ORDER BY velo_gesamt DESC NULLS LAST;