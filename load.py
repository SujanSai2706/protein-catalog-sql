import sqlite3
import pandas as pd

df = pd.read_csv("uniprot.tsv", sep="\t")
df.columns = ["accession", "entry_name", "protein_name",
              "organism", "length", "keywords", "function_text"]

con = sqlite3.connect("proteins.db")

organisms = df["organism"].dropna().unique()
con.executemany("INSERT OR IGNORE INTO organism(name) VALUES (?)",
                [(o,) for o in organisms])
org_map = dict(con.execute("SELECT name, organism_id FROM organism"))

rows = []
for r in df.itertuples():
    rows.append((r.accession, r.entry_name, r.protein_name, r.length,
                 r.function_text, org_map.get(r.organism)))
con.executemany("INSERT OR IGNORE INTO protein VALUES (?,?,?,?,?,?)", rows)

for r in df.itertuples():
    if pd.isna(r.keywords):
        continue
    for kw in r.keywords.split(";"):
        kw = kw.strip()
        if not kw:
            continue
        con.execute("INSERT OR IGNORE INTO keyword(keyword) VALUES (?)", (kw,))
        kid = con.execute("SELECT keyword_id FROM keyword WHERE keyword = ?",
                          (kw,)).fetchone()[0]
        con.execute("INSERT OR IGNORE INTO protein_keyword VALUES (?,?)",
                    (r.accession, kid))

con.commit()

for t in ["organism", "protein", "keyword", "protein_keyword"]:
    n = con.execute("SELECT COUNT(*) FROM " + t).fetchone()[0]
    print(t, n)
con.close()