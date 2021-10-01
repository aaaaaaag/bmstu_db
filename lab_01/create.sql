
create type sex_type as enum ('male', 'female');
create type country_type as enum ('Russia', 'USA', 'China', 'Germany');
create type color_type as enum ('Red', 'Green', 'Blue', 'Yellow', 'Black', 'White');

create table legal_form(
    id SERIAL PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    commission REAL NOT NULL
);

create table organization(
    id SERIAL PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    reg_date timestamp NOT NULL,
    office_address TEXT,
    legal_form_id INT, FOREIGN KEY (legal_form_id) REFERENCES legal_form (id)
);

create table sellers(
    id SERIAL PRIMARY KEY NOT NULL,
    first_name TEXT NOT NULL,
    second_name TEXT NOT NULL,
    sex sex_type,
    rating smallint,
    country country_type NOT NULL,
    organization_id INT, FOREIGN KEY (organization_id) REFERENCES organization (id),
    CHECK(rating > 0 and rating < 6)
);

create table buyers(
    id SERIAL PRIMARY KEY NOT NULL,
    first_name TEXT NOT NULL,
    second_name TEXT,
    sex sex_type,
    country country_type NOT NULL,
    rating smallint,
    age int,
    CHECK (rating > 0 and rating < 6)
);
create table items(
    id SERIAL PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    weight INT NOT NULL,
    price REAL NOT NULL,
    color color_type,
    guarantee_years INT NOT NULL,
    owner_id INT, FOREIGN KEY (owner_id) REFERENCES sellers (id),
    CHECK (guarantee_years > 0)
);

create table deals(
    id SERIAL PRIMARY KEY NOT NULL,
    seller_id INT, FOREIGN KEY (seller_id) REFERENCES sellers (id),
    buyer_id INT, FOREIGN KEY (buyer_id) REFERENCES buyers (id),
    sold_item_id INT, FOREIGN KEY (sold_item_id) REFERENCES items (id),
    date timestamp NOT NULL,
    has_delivery boolean NOT NULL,
    set_buyer_rating smallint,
    CHECK (date BETWEEN '2020-03-26 00:00:01' AND '2022-01-21 00:00:01' AND
           set_buyer_rating > 0 AND set_buyer_rating < 6)
);
