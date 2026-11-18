-- Q1: Top 10 keywords
SELECT k.keyword, COUNT(*) AS proteins
FROM keyword k JOIN protein_keyword pk USING (keyword_id)
GROUP BY k.keyword ORDER BY proteins DESC LIMIT 10;

-- Q2: Longest proteins
SELECT accession, protein_name, length FROM protein ORDER BY length DESC LIMIT 10;

-- Q3: Size categories
SELECT CASE WHEN length < 200 THEN 'small'
            WHEN length < 600 THEN 'medium'
            ELSE 'large' END AS size_class,
       COUNT(*) AS n, ROUND(AVG(length), 1) AS avg_len
FROM protein GROUP BY size_class;

-- Q4: Top keywords excluding the administrative tag
SELECT k.keyword, COUNT(*) AS proteins
FROM keyword k JOIN protein_keyword pk USING (keyword_id)
WHERE k.keyword <> 'Reference proteome'
GROUP BY k.keyword ORDER BY proteins DESC LIMIT 10;

-- Q5: Kinase count (uses the view)
SELECT COUNT(*) FROM v_kinases;

-- Q6: Longest 3 proteins per keyword (window function)
SELECT keyword, protein_name, length, rnk FROM (
  SELECT k.keyword, p.protein_name, p.length,
         RANK() OVER (PARTITION BY k.keyword ORDER BY p.length DESC) AS rnk
  FROM protein p
  JOIN protein_keyword pk ON p.accession = pk.accession
  JOIN keyword k ON k.keyword_id = pk.keyword_id
  WHERE k.keyword IN ('Kinase', 'Receptor', 'Transcription')
) WHERE rnk <= 3;

-- Q7: Kinases with a solved 3D structure
SELECT p.accession, p.protein_name
FROM protein p
JOIN protein_keyword pk1 ON p.accession = pk1.accession
JOIN keyword k1 ON k1.keyword_id = pk1.keyword_id AND k1.keyword = 'Kinase'
JOIN protein_keyword pk2 ON p.accession = pk2.accession
JOIN keyword k2 ON k2.keyword_id = pk2.keyword_id AND k2.keyword = '3D-structure';