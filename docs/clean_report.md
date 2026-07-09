# Rapport de nettoyage des données - Phase 2

## Objectif

Nettoyer les 3 tables principales du dataset(`Player_Attributes`, `Match`, `Team_Attributes`) sur la base de l'audit qualité réalisé en Phase 1 (voir `sql/01_exploration_audit.sql`), et les rendre exploitables pour les phase suivantes.

## Méthode

1. Chargement de chaque table depuis `data/raw/database.sqlite` via pandas
2. Conversion de la colonne `date` (stockée en `TEXT` dans la base) en type `datetime` pandas
3. Vérification de la présence des données antérieures à 2008
4. Traitement des valeurs manquantes identifiées lors de l'audit SQL
5. Export de chaque table nettoyée en CSV dans `data/processed/`

## Détail par table

### `Plyaer_Attributes`

| Etape | Lignes | Détail |
| ----- | ------ | ------ |
|Chargement brut | 183 978 | - |
| Exclusion année 2007 | 167 840 | 16 138 lignes retirées. Hors périmètre du dataset (2008-2016) |
| Suppression overall_rating` manquant | **167 740** | 100 lignes retirées. Ces `NULL` étaient répartis sur plusieurs saisons - suppression sans risque de biais significatif. |

**Décision de nettoyage :** suppression plutôt qu'imputation, justifiée par : 
- Une proportion de valeurs manquantes faibles (0,1% après filtrage)
- Une répartition homogène dans le temps

Fichier de sorti : `data/processed/player_attributes_clean.csv`

### `Match`

| Etape | Lignes | Détail |
| ----- | ------ | ------ |
| Chargement brut | 25 979 | - |
| Vérification année < 2008 | 25979 | 0 ligne hors périmètre |
| Valeurs manquantes (`home_team_goal`, `league_id`) | 25 979 | 0 valeur manquante (vérifié en phase 1, SQL)|
| Doublons (équipe domicile + extérieur + date) | 25 979 | 0 doublon (vérifié en phase 1) |
| Scores négatifs | 25 979 | 0 valeur aberrante (vérifié en phase 1) |

**Décision de nettoyage :** aucune modification nécessaire

Fichier de sorti : `data/processed/match_clean.csv`

### `Team_Attributes`

| Etape | Lignes | Détail |
| ----- | ------ | ------ |
| Chargement brut | 1 458 | - |
| Vérification année < 2008 - 1 458 | 0 ligne hors périmètre |
| Valeurs manquantes (`buildUpPlaySpeed`, `chanceCreationPassing`, `defencePressure`) | 1 458 | 0 valeur manquante (vérifié en phase 1) |

**Décision de nettoyage :** aucune modification nécessaire

Fichier de sorti : `data/processed/team_attributes_clean.csv`

## Tables non retraitées

`Player`, `Team`, `League`, `Country` n'ont pas fait l'objet d'un nettoyage pandas dédié : déjà audité en phase 1 (0 doublon, 0 valeur aberrante), table de petite taille (11 à 11 060 lignes), et ne contiennent pas de colonne `date` nécessitant un filtrage. Elles sont considérées propre en l'état et seront lues depuis `database.sqlite`

## Résumé

| Table | Lignes brutes | Lignes finales | Fichier |
| ----- | ------------- | -------------- | ------- |
| `Player_Attributes`| 183 978 | 167 740 | `data/processed/player_attributes_clean.csv` |
| `Match`| 25 979 | 25 979 | `data/processed/match_clean.csv` |
| `Team_Attributes` | 1 458 | 1 458 | `data/processed/team_attributes_clean.csv` |

## Notebook associé

Le détail des manipulations est disponible dans `notebooks/01_clean.ipynb`.