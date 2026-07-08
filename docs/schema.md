# Schéma de données — European Soccer Database

Le fichier source est une base **SQLite** unique (`database.sqlite`) contenant 7 tables.

## Country
| colonne | type | description |
|---|---|---|
| id | int (PK) | identifiant pays |
| name | text | nom du pays |

## League
| colonne | type | description |
|---|---|---|
| id | int (PK) | identifiant ligue |
| country_id | int (FK → Country.id) | pays de la ligue |
| name | text | nom de la ligue (ex: "England Premier League") |

## Team
| colonne | type | description |
|---|---|---|
| id | int (PK) | identifiant interne |
| team_api_id | int | identifiant API (utilisé dans Match) |
| team_fifa_api_id | int | identifiant FIFA |
| team_long_name | text | nom complet |
| team_short_name | text | nom court |

## Team_Attributes
Attributs tactiques par équipe et par date (buildUpPlaySpeed, chanceCreationPassing, defencePressure, etc.), reliés via `team_api_id`.

## Player
| colonne | type | description |
|---|---|---|
| id | int (PK) | identifiant interne |
| player_api_id | int | identifiant API |
| player_name | text | nom du joueur |
| birthday | date | date de naissance |
| height | float | taille (cm) |
| weight | float | poids (lbs) |

## Player_Attributes
Attributs FIFA par joueur et par date : `overall_rating`, `potential`, `crossing`, `finishing`, `dribbling`, `stamina`, `strength`, attributs gardien (`gk_diving`, etc.), reliés via `player_api_id`.

## Match
Table centrale. Colonnes clés :
- `id`, `country_id`, `league_id`, `season`, `stage`, `date`
- `match_api_id`, `home_team_api_id`, `away_team_api_id`
- `home_team_goal`, `away_team_goal`
- `home_player_1..11`, `away_player_1..11` (identifiants joueurs alignés)
- positions `home_player_X1..11`, `home_player_Y1..11` (formation)
- événements bruts au format XML : `goal`, `shoton`, `shotoff`, `foulcommit`, `card`, `cross`, `corner`, `possession`
- cotes de paris de ~10 bookmakers (`B365H/D/A`, `BWH/D/A`, `IWH/D/A`, etc.)

## Relations clés pour les JOINs

```
Country.id       = League.country_id
League.id        = Match.league_id
Team.team_api_id = Match.home_team_api_id / away_team_api_id
Player.player_api_id = Player_Attributes.player_api_id
Team.team_api_id = Team_Attributes.team_api_id
```

> Ce document sera complété/corrigé une fois le fichier réel inspecté (types exacts, valeurs manquantes, etc.).
