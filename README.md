# Analyse et Prédiction de Performances Football

Projet data en 6 phases : SQL/Python > nettoyage > visualisation > Machine Learning > dashboard Power BI > documentation.

## Dataset

**European Soccer Database** (Kaggle, hugomathien) — https://www.kaggle.com/datasets/hugomathien/soccer

- +25 000 matchs, +10 000 joueurs, ~300 équipes
- 11 pays européens, saisons 2008/2009 à 2015/2016
- Attributs joueurs/équipes issus de FIFA (EA Sports)
- Cotes de paris (jusqu'à 10 bookmakers)

Format source : fichier SQLite unique (`database.sqlite`) contenant 7 tables :
`Country`, `League`, `Team`, `Team_Attributes`, `Player`, `Player_Attributes`, `Match`.

## Structure du projet

```
football-analytics/
├── data/
│   ├── raw/            # fichier(s) source tel quel (jamais modifié)
│   └── processed/      # données nettoyées, exports CSV/DB
├── sql/                # scripts SQL (schéma, requêtes d'analyse)
├── notebooks/          # notebooks Jupyter (exploration, ML)
├── src/                # scripts Python réutilisables (pipeline, features, modèles)
├── dashboards/          # exports/config Power BI
└── docs/                # documentation technique et guides
```

## Avancement

- [x] Phase 1 — Fondations (récupération dataset, chargement SQL, requêtes de base)
- [x] Phase 2 — Nettoyage & qualité
- [ ] Phase 3 — Analyse & visualisation
- [ ] Phase 4 — Machine Learning
- [ ] Phase 5 — Dashboard Power BI
- [ ] Phase 6 — Documentation finale

## Setup

```bash
pip install -r requirements.txt
```