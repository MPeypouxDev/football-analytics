"""
Phase 1 - Etape 1 & 2
Charge database.sqlite (depuis data/raw/) et affiche un premier inventaire :
tables disponibles, schéma de chaque table, nombre de lignes.

Usage:
    python src/01_load_and_explore.py
"""

import sqlite3
from pathlib import Path

DB_PATH = Path(__file__).resolve().parent.parent / "data" / "raw" / "database.sqlite"


def main():
    if not DB_PATH.exists():
        print(f"[!] Fichier introuvable : {DB_PATH}")
        print("    -> Place le fichier 'database.sqlite' dans data/raw/")
        return

    conn = sqlite3.connect(DB_PATH)
    cursor = conn.cursor()

    # Liste des tables
    cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
    tables = [row[0] for row in cursor.fetchall()]
    print(f"Tables trouvées ({len(tables)}) : {tables}\n")

    for table in tables:
        cursor.execute(f"PRAGMA table_info({table});")
        columns = cursor.fetchall()
        cursor.execute(f"SELECT COUNT(*) FROM {table};")
        row_count = cursor.fetchone()[0]

        print(f"--- {table} ({row_count} lignes) ---")
        for col in columns:
            # col: (cid, name, type, notnull, dflt_value, pk)
            print(f"    {col[1]:<25} {col[2]}")
        print()

    conn.close()


if __name__ == "__main__":
    main()
