\o
\t off
\pset format aligned

DROP TABLE IF EXISTS LegalFormJSON;
DROP TABLE IF EXISTS tmp;

create table if not exists LegalFormJSON(
	id INT NULL,
    name TEXT NOT NULL,
    commission REAL NOT NULL
);

CREATE TABLE tmp (
    data json
);
\copy tmp from '/legal_form.json';

INSERT INTO LegalFormJSON(id, name, commission)
select
  (data->>'id')::INT,
  (data->>'name'),
  (data->>'commission')::REAL
FROM tmp;

select * from LegalFormJSON;
