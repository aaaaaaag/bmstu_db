\t
\a
\o /deals.json
SELECT ROW_TO_JSON(d) FROM deals d;

\t
\a
\o /items.json
SELECT ROW_TO_JSON(i) FROM items i;

\t
\a
\o /buyers.json
SELECT ROW_TO_JSON(b) FROM buyers b;

\t
\a
\o /sellers.json
SELECT ROW_TO_JSON(s) FROM sellers s;

\t
\a
\o /organization.json
SELECT ROW_TO_JSON(o) FROM organization o;

\t
\a
\o /legal_form.json
SELECT ROW_TO_JSON(lf) FROM legal_form lf;
