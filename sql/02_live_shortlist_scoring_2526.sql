USE moneyballton;

SELECT 
    `('player', '')` AS player_name,
    `('league', '')` AS current_league,
    `('age', '')` AS age,
    `('Playing Time', 'Min')` AS minutes,
    `('Per 90 Minutes', 'G+A-PK')` AS raw_npg_a_90,
    
    -- 1. Context Adjusted Production
    CASE 
        WHEN `('league', '')` IN ('ENG-Premier League', 'ESP-La Liga', 'ITA-Serie A') THEN `('Per 90 Minutes', 'G+A-PK')` * 1.00
        WHEN `('league', '')` IN ('FRA-Ligue 1', 'POR-Primeira Liga') THEN `('Per 90 Minutes', 'G+A-PK')` * 0.85
        WHEN `('league', '')` IN ('NED-Eredivisie') THEN `('Per 90 Minutes', 'G+A-PK')` * 0.75
        ELSE `('Per 90 Minutes', 'G+A-PK')` * 0.80 
    END AS context_score,

    -- 2. Stage 3 Composite Score
    ROUND((
        -- Context Multiplier
        CASE 
            WHEN `('league', '')` IN ('ENG-Premier League', 'ESP-La Liga', 'ITA-Serie A') THEN `('Per 90 Minutes', 'G+A-PK')` * 1.00
            WHEN `('league', '')` IN ('FRA-Ligue 1', 'POR-Primeira Liga') THEN `('Per 90 Minutes', 'G+A-PK')` * 0.85
            WHEN `('league', '')` IN ('NED-Eredivisie') THEN `('Per 90 Minutes', 'G+A-PK')` * 0.75
            ELSE `('Per 90 Minutes', 'G+A-PK')` * 0.80 
        END
        * 
        -- Age Runway Multiplier
        CASE 
            WHEN `('age', '')` <= 19 THEN 1.15
            WHEN `('age', '')` = 20 THEN 1.10
            WHEN `('age', '')` = 21 THEN 1.05
            ELSE 1.00
        END
        *
        -- Current Opportunity Multiplier
        CASE 
            WHEN `('Playing Time', 'Min')` >= 2500 THEN 1.10
            WHEN `('Playing Time', 'Min')` >= 2000 THEN 1.05
            ELSE 1.00
        END
    ), 4) AS composite_score

FROM fbref_raw_2526
WHERE `('age', '')` <= 23
  AND `('Playing Time', 'Min')` >= 1200
  AND `('pos', '')` IN ('MF,FW', 'FW,MF')
ORDER BY composite_score DESC;