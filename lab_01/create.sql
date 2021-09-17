create type sex_type as enum ('male', 'female');
create type country_type as enum ('Russia', 'USA', 'China', 'Germany');
create type rating_type as enum ('1', '2', '3', '4', '5');
create type color_type as enum ('Red', 'Green', 'Blue', 'Yellow', 'Black', 'White');

create table sellers(
    id SERIAL PRIMARY KEY NOT NULL,
    first_name TEXT NOT NULL,
    second_name TEXT NOT NULL,
    sex sex_type,
    rating rating_type,
    country country_type NOT NULL
);

create table buyers(
    id SERIAL PRIMARY KEY NOT NULL,
    first_name TEXT NOT NULL,
    second_name TEXT,
    sex sex_type,
    country country_type NOT NULL,
    age INT
);
create table items(
    id SERIAL PRIMARY KEY NOT NULL,
    name TEXT NOT NULL,
    weight INT NOT NULL,
    price INT NOT NULL,
    color color_type,
    guarantee_years INT NOT NULL,
    CHECK (guarantee_years > 0 AND price > 0 AND weight > 0)
);

create table deals(
    id SERIAL PRIMARY KEY NOT NULL,
    seller_id INT, FOREIGN KEY (seller_id) REFERENCES sellers (id),
    buyer_id INT, FOREIGN KEY (buyer_id) REFERENCES buyers (id),
    sold_item_id INT, FOREIGN KEY (sold_item_id) REFERENCES items (id),
    date timestamp NOT NULL,
    has_delivery boolean NOT NULL,
    set_buyer_rating rating_type
);
