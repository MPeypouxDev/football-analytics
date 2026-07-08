-- Phase 1 : Audit de la qualité des données
-- Base : data/raw/database.sqlite (European Soccer Database)

-- 1. Ligues avec leur pays associé
SELECT League.name AS league_name, Country.name AS country_name
FROM League
JOIN Country ON League.country_id = Country.id;

-- 2. Moyenne de buts marqués par match, par saison
SELECT Match.season, AVG(Match.home_team_goal + Match.away_team_goal) AS avg_goals
FROM Match
GROUP BY Match.season;

-- 3. Classement complet par équipe
SELECT Team.team_long_name AS team_name,
    SUM(goals_for) AS   total_buts_marques,
    SUM(goals_against) AS total_buts_encaisses,
    COUNT(*) AS nb_matchs,
    SUM(points) AS points
FROM (
    SELECT home_team_api_id AS team_id, home_team_goal AS goals_for, away_team_goal AS goals_against,
        CASE
            WHEN home_team_goal > away_team_goal THEN 3
            WHEN home_team_goal = away_team_goal THEN 1
            ELSE 0
        END AS points
    FROM Match
    UNION ALL
    SELECT away_team_api_id AS team_id, away_team_goal AS goals_for, home_team_goal AS goals_against,
        CASE
            WHEN away_team_goal > home_team_goal THEN 3
            WHEN away_team_goal = home_team_goal THEN 1
            ELSE 0
        END AS points
    FROM Match
) AS all_matches
JOIN Team ON all_matches.team_id = Team.team_api_id
GROUP BY all_matches.team_id
ORDER BY points DESC;

-- 4. Valeurs manquantes : scores de match
-- Résultat obtenu : 0
SELECT COUNT(*)
FROM Match
WHERE home_team_goal IS NULL;

-- 5. Valeurs manquantes : note globale des joueurs
-- Résulat obtenu : 836 / 183978 (~ 0.45%)
SELECT COUNT(*)
FROM Player_Attributes
WHERE overall_rating IS NULL;

-- 6. Valeurs manquantes : league_id des matchs
-- Résulat obtenu : 0
SELECT COUNT(*)
FROM Match
WHERE league_id IS NULL;

-- 7. Doublons de matchs
-- Résulat obtenu : 0 ligne -> aucun doublon
SELECT home_team_api_id, away_team_api_id, date, COUNT(*) AS nb_occurrences
FROM Match
GROUP BY home_team_api_id, away_team_api_id, date
HAVING COUNT(*) > 1;

-- 8. Scores aberrants : négatifs
-- Résulat obtenu : 0 ligne
SELECT home_team_goal, away_team_goal
FROM Match
WHERE home_team_goal < 0 OR away_team_goal < 0;

-- 9. Tailles de joueurs aberrantes
-- Résulat obtenu : 0 ligne
SELECT height
FROM Player
WHERE height > 210 OR height < 150;

-- 10. Cohérence du format de la colonne date
-- Résultat obtenu : une seule longueur trouvée -> format homogène
SELECT LENGTH(date) AS longueur, COUNT(*) AS nb_lignes
FROM Match
GROUP BY LENGTH(date);

-- 11. Cohérence du format de la colonne season
-- Résulat obtenu : toutes au format "XXXX/XXXX"
SELECT DISTINCT season
FROM Match
ORDER BY season;

-- 12. Valeurs manquantes sur les attributs tactiques d'équipe
-- Résultat obtenu : 0 NULL sur les 3 colonnes testées
SELECT
    SUM(CASE WHEN buildUpPlaySpeed IS NULL THEN 1 ELSE 0 END) AS null_speed,
    SUM(CASE WHEN chanceCreationPassing IS NULL THEN 1 ELSE 0 END) AS null_passing_creation,
    SUM(CASE WHEN defencePressure IS NULL THEN 1 ELSE 0 END) AS null_defence
FROM Team_Attributes;
