USE moneyballton;

CREATE OR REPLACE VIEW model_2_2021 AS
SELECT 
    `('player', '')` AS player_name,
    `('league', '')` AS discovery_league,
    `('age', '')` AS discovery_age,
    `('Playing Time', 'Min')` AS discovery_minutes,
    `('pos', '')` AS position,
    `('Per 90 Minutes', 'G+A-PK')` AS raw_npg_a_p90,
    -- Apply the League Strength Adjustment
    CASE 
        WHEN `('league', '')` IN ('ENG-Premier League', 'ESP-La Liga', 'ITA-Serie A') THEN `('Per 90 Minutes', 'G+A-PK')` * 1.00
        WHEN `('league', '')` IN ('FRA-Ligue 1', 'POR-Primeira Liga') THEN `('Per 90 Minutes', 'G+A-PK')` * 0.85
        WHEN `('league', '')` IN ('NED-Eredivisie') THEN `('Per 90 Minutes', 'G+A-PK')` * 0.75
        ELSE `('Per 90 Minutes', 'G+A-PK')` * 0.80 
    END AS model_2_score
FROM fbref_raw_2018_2024
WHERE `('season', '')` = '2021' 
  AND `('age', '')` <= 23
  AND `('Playing Time', 'Min')` >= 1200
  -- The Model 2 Candidate Universe: Hybrid Attackers Only
  AND `('pos', '')` IN ('MF,FW', 'FW,MF');
  
  SELECT 
    m2.player_name, 
    m2.position,
    m2.model_2_score, 
    -- The Patch: Only count minutes from non-development leagues
    COALESCE(MAX(
        CASE 
            WHEN f.`('league', '')` NOT IN ('NED-Eredivisie', 'POR-Primeira Liga', 'ENG-Championship') THEN f.`('Playing Time', 'Min')`
            ELSE 0 
        END
    ), 0) AS best_big5_minutes,
    CASE 
        WHEN MAX(
            CASE 
                WHEN f.`('league', '')` NOT IN ('NED-Eredivisie', 'POR-Primeira Liga', 'ENG-Championship') THEN f.`('Playing Time', 'Min')`
                ELSE 0 
            END
        ) >= 2000 THEN 'YES' 
        ELSE 'NO' 
    END AS is_big5_established
FROM model_2_2021 m2
LEFT JOIN fbref_raw_2018_2024 f 
    ON m2.player_name = f.`('player', '')`
    -- The Outcome Window for Cohort B
    AND f.`('season', '')` IN ('2122', '2223', '2324', '2425') 
GROUP BY 
    m2.player_name, 
    m2.position,
    m2.model_2_score
ORDER BY m2.model_2_score DESC
LIMIT 20;