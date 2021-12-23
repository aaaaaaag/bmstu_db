\t
\a
\o /deals.json
SELECT ROW_TO_JSON(d) FROM deals d;

\o /items.json
SELECT ROW_TO_JSON(i) FROM items i;

\o /buyers.json
SELECT ROW_TO_JSON(b) FROM buyers b;

\o /sellers.json
SELECT ROW_TO_JSON(s) FROM sellers s;

\o /organization.json
SELECT ROW_TO_JSON(o) FROM organization o;

\o /legal_form.json
SELECT ROW_TO_JSON(lf) FROM legal_form lf;
\t
\a
