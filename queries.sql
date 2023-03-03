/*Queries that provide answers to the questions from all projects.*/

SELECT * from animals WHERE name LIKE '%mon%';
SELECT * from animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';
SELECT * from animals WHERE neutered = true and escape_attempts < 3;
SELECT * from animals WHERE name='Agumon' or name='Pikachu';
SELECT name, escape_attempts from animals WHERE weight_kg > 10.5;
SELECT * from animals WHERE neutered = true;
SELECT * from animals WHERE name!='Gabumon';
SELECT * from animals WHERE weight_kg BETWEEN 10.4 and 17.3;

BEGIN;
UPDATE animals SET species='unspecified';
SELECT * from animals;
ROLLBACK;

BEGIN;
UPDATE animals SET species='digimon' WHERE name LIKE '%mon%';
UPDATE animals SET species='pokemon' WHERE species IS NULL;
COMMIT;
SELECT * from animals;

BEGIN;
DELETE FROM animals;
SELECT * from animals;
ROLLBACK;
SELECT * from animals;

BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
SELECT * from animals;
SAVEPOINT svpnt_1;

UPDATE animals SET weight_kg=weight_kg*(-1);
SELECT * from animals;
ROLLBACK TO svpnt_1;
SELECT * from animals;
UPDATE animals SET weight_kg=weight_kg*(-1) WHERE weight_kg < 0;
SELECT * from animals;
COMMIT;

SELECT COUNT(*) from animals;
SELECT COUNT(*) from animals WHERE escape_attempts = 0;
SELECT AVG(weight_kg) from animals;
SELECT neutered, MAX(escape_attempts) from animals GROUP BY neutered;
SELECT species, MIN(weight_kg), MAX(weight_kg) from animals GROUP BY species;
SELECT species, AVG(escape_attempts) from animals WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY species;

-------------------JOIN-------------------------
SELECT owners.full_name, animals.name from owners INNER JOIN animals ON owners.id = animals.owner_id WHERE owners.full_name = 'Melody Pond';

SELECT animals.name, species.name from animals INNER JOIN species ON animals.species_id = species.id WHERE species.name = 'pokemon';

SELECT owners.full_name, animals.name from owners LEFT JOIN animals ON owners.id = animals.owner_id;

SELECT species.name, COUNT(animals.name) from species INNER JOIN animals ON species.id = animals.species_id GROUP BY species.name;

SELECT owners.full_name, species.name, animals.name from owners INNER JOIN animals ON owners.id = animals.owner_id INNER JOIN species ON animals.species_id = species.id WHERE owners.full_name = 'Jennifer Orwell' AND species.name = 'digimon';

SELECT owners.full_name, animals.name, animals.escape_attempts from owners INNER JOIN animals ON owners.id = animals.owner_id WHERE animals.escape_attempts =0 AND owners.full_name='Dean Winchester';

SELECT owners.full_name, COUNT(animals.name) from owners INNER JOIN animals ON owners.id = animals.owner_id GROUP BY owners.full_name ORDER BY COUNT(animals.name) DESC LIMIT 1;