PRAGMA foreign_keys = ON;

CREATE TABLE organism (
    organism_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT UNIQUE NOT NULL
);

CREATE TABLE protein (
    accession     TEXT PRIMARY KEY,
    entry_name    TEXT,
    protein_name  TEXT,
    length        INTEGER,
    function_text TEXT,
    organism_id   INTEGER REFERENCES organism(organism_id)
);

CREATE TABLE keyword (
    keyword_id INTEGER PRIMARY KEY AUTOINCREMENT,
    keyword    TEXT UNIQUE NOT NULL
);

CREATE TABLE protein_keyword (
    accession  TEXT    REFERENCES protein(accession),
    keyword_id INTEGER REFERENCES keyword(keyword_id),
    PRIMARY KEY (accession, keyword_id)
);

CREATE INDEX idx_protein_org ON protein(organism_id);
CREATE INDEX idx_pk_keyword  ON protein_keyword(keyword_id);