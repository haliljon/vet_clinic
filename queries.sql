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

-------------------Many-to-many-------------------------


SELECT animals.name, vets.name, visits.date_of_visit from animals INNER JOIN visits ON animals.id = visits.animal_id INNER JOIN vets ON vets.id = visits.vet_id WHERE vets.name = 'William Tatcher' ORDER BY visits.date_of_visit DESC LIMIT 1;

SELECT COUNT(DISTINCT animals.name), vets.name from vets INNER JOIN visits ON vets.id = visits.vet_id INNER JOIN animals ON animals.id = visits.animal_id WHERE vets.name = 'Stephanie Mendez' GROUP BY vets.name;

SELECT vets.name, species.name from vets LEFT JOIN specializations ON vets.id = specializations.vet_id INNER JOIN species ON species.id = specializations.species_id;

SELECT animals.name, vets.name, visits.date_of_visit from animals INNER JOIN visits ON animals.id = visits.animal_id INNER JOIN vets ON vets.id = visits.vet_id WHERE vets.name = 'Stephanie Mendez' AND visits.date_of_visit BETWEEN '2020-04-01' AND '2020-08-30';

SELECT animals.name, COUNT(animals.name) from animals INNER JOIN visits ON animals.id = visits.animal_id INNER JOIN vets ON vets.id = visits.vet_id GROUP BY animals.name ORDER BY COUNT(animals.name) DESC LIMIT 1;

SELECT animals.name, vets.name, visits.date_of_visit from animals INNER JOIN visits ON animals.id = visits.animal_id INNER JOIN vets ON vets.id = visits.vet_id WHERE vets.name = 'Maisy Smith' ORDER BY visits.date_of_visit ASC LIMIT 1;

SELECT animals.name, vets.name, visits.date_of_visit from animals INNER JOIN visits ON animals.id = visits.animal_id INNER JOIN vets ON vets.id = visits.vet_id  ORDER BY visits.date_of_visit DESC LIMIT 1;

SELECT COUNT(*) FROM visits JOIN animals ON visits.animal_id = animals.id JOIN vets ON visits.vet_id = vets.id LEFT JOIN specializations ON specializations.species_id = animals.species_id AND specializations.vet_id = vets.id WHERE specializations.vet_id IS NULL;

SELECT species.name, COUNT(species.name) from species INNER JOIN animals ON species.id = animals.species_id INNER JOIN visits ON animals.id = visits.animal_id INNER JOIN vets ON vets.id = visits.vet_id WHERE vets.name = 'Maisy Smith' GROUP BY species.name ORDER BY COUNT(species.name) DESC LIMIT 1;


-------------------Audit-------------------------
CREATE INDEX animal_ids_asc ON visits (animal_id ASC);
explain analyze SELECT COUNT(*) FROM visits where animal_id = 4;
-------------------previuos exection time: 1411.533 current: 0.041ms-------------------------

CREATE INDEX vet_ids_asc ON visits (vet_id ASC);
EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;

CREATE INDEX email_id ON owners (email ASC);
EXPLAIN ANALYZE SELECT * FROM owners where email = 'owner_18327@mail.com';