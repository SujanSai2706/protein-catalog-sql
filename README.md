# Human Protein Catalog Explorer (SQL)

A relational database of 20,429 reviewed human proteins from UniProt,
built with SQLite and Python, and analysed with SQL.

## Data
UniProtKB, reviewed human proteins (organism_id:9606), downloaded 18 Nov 2026.

## Schema
Four tables: organism, protein, keyword, and protein_keyword
(a bridge table for the many-to-many link between proteins and keywords).
Indexes on protein.organism_id and protein_keyword.keyword_id.

## Files
- schema.sql: table definitions
- load.py: loads the UniProt TSV into SQLite
- queries.sql: analysis queries

## Findings
- 20,429 proteins and 720 distinct keywords; 230,647 protein-keyword links.
- 52% of proteins are medium-sized (200-599 aa), 30% large, 18% small.
- Titin is the longest protein at 34,350 aa.
- 625 proteins carry the Kinase keyword.
- 451 of the 625 kinases (72%) have an experimentally solved 3D structure.
- 88% have mass-spectrometry evidence, 52% have alternative splicing,
  and 44% have a solved 3D structure.
- The keyword index turns lookups from a full scan into an index search.

## Skills shown
Schema design, many-to-many modelling, ETL with Python/pandas, joins,
aggregation, CASE, window functions, views, indexing.