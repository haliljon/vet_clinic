/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
    id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY NOT NULL,
    name varchar(100) NOT NULL,
    date_of_birth date NOT NULL,
    escape_attempts int NOT NULL,
    neutered boolean NOT NULL,
    weight_kg decimal NOT NULL
);
ALTER TABLE animals ADD species varchar(100) NOT NULL;

CREATE Table owners (
    id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY NOT NULL,
    full_name varchar(100) NOT NULL,
    age int NOT NULL
);

CREATE Table species (
    id int PRIMARY KEY GENERATED ALWAYS AS IDENTITY NOT NULL,
    name varchar(100) NOT NULL
);

ALTER TABLE animals DROP COLUMN species;
ALTER TABLE animals ADD species_id int;
ALTER TABLE animals ADD FOREIGN KEY (species_id) REFERENCES species(id);
ALTER TABLE animals ADD owner_id int;
ALTER TABLE animals ADD FOREIGN KEY (owner_id) REFERENCES owners(id);

