CREATE DATABASE screenplays;

CREATE TABLE genres (
    id SERIAL PRIMARY KEY,
    name VARCHAR(300)
);

CREATE TABLE pitches (
    id SERIAL PRIMARY KEY,
    title VARCHAR(600),
    synopsis VARCHAR(600),
    genre VARCHAR(300),
    genre_id INTEGER,
    structural_element VARCHAR(400),
    film_comparison VARCHAR(400),
    views INTEGER,
    user_id INTEGER,
    created_at TIMESTAMP
);

    -- created_at datetime

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(400),
    email VARCHAR(400),
    password_digest VARCHAR(400),
    bio TEXT,
    country VARCHAR(400)
);

CREATE TABLE buyers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(400),
    email VARCHAR(400),
    password_digest VARCHAR(400),
    production_company VARCHAR(400),
    country VARCHAR(400)
);

-- CREATE TABLE country (
--     id SERIAL PRIMARY KEY,
--     name VARCHAR(200)
-- );

-- CREATE TABLE employment (
--     id SERIAL PRIMARY KEY,
--     type VARCHAR(200)
-- );