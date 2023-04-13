BEGIN;

CREATE TYPE gender as ENUM (
    'М', 'Ж'
    );

CREATE TYPE duration_unit as ENUM (
    'мин.',
    'час',
    'день',
    'месяц'
    );


CREATE TABLE planets (
    id SERIAL PRIMARY KEY,
    name TEXT
);

CREATE TABLE ships (
    id SERIAL PRIMARY KEY,
    name TEXT,
    action TEXT DEFAULT '-',
    action_duration INT DEFAULT 0,
    action_duration_unit duration_unit DEFAULT 'мин.'
);


CREATE TABLE mini_worlds (
    id SERIAL PRIMARY KEY,
    name TEXT,
    is_isolated BOOLEAN
);

CREATE TABLE properties (
    id SERIAL PRIMARY KEY,
    feel_foreign BOOLEAN
);

CREATE TABLE humans (
    id SERIAL PRIMARY KEY,
    name TEXT,
    surname TEXT,
    gender gender,
    age INT,
    ship_id INT REFERENCES ships(id),
    mini_world_id INT REFERENCES mini_worlds(id),
    property_id INT NOT NULL REFERENCES properties(id) UNIQUE
);

CREATE TABLE life_events (
    id SERIAL PRIMARY KEY,
    human_id INT NOT NULL REFERENCES humans(id),
    event TEXT,
    feel_foreign BOOLEAN
);

CREATE TABLE flights (
    id SERIAL PRIMARY KEY,
    ship_id INT NOT NULL REFERENCES ships(id) UNIQUE,
    destination INT NOT NULL REFERENCES planets(id),
    property_id INT NOT NULL REFERENCES properties(id),
    duration INT,
    duration_unit duration_unit
);

CREATE TABLE years_of_studying (
    id SERIAL PRIMARY KEY,
    property_id INT REFERENCES properties(id),
    number INT
);


CREATE TABLE institutions (
    id SERIAL PRIMARY KEY,
    planet_id INT NOT NULL references planets,
    name TEXT
);

CREATE TABLE semesters (
    year_of_study_id INT NOT NULL REFERENCES years_of_studying(id),
    institution_id INT NOT NULL REFERENCES institutions(id),
    CONSTRAINT semester_id PRIMARY KEY (year_of_study_id, institution_id)
);



INSERT INTO ships(name, action, action_duration, action_duration_unit) VALUES 
('Корабль', 'находится в полете', 30, 'день');

INSERT INTO ships(name) VALUES
('Анон 1'),
('Анон 2');

INSERT INTO planets(name) VALUES ('Луна'), ('Марс'), ('Земля'), ('Неизвестно');

INSERT INTO properties(feel_foreign) VALUES (true);

INSERT INTO mini_worlds(name, is_isolated) VALUES ('Дискавери', true);

INSERT INTO  years_of_studying(property_id, number)
VALUES
(1, 1),
(1, 2);

INSERT INTO institutions (planet_id, name)
VALUES (2, 'МТУ'), (3, 'ИТМО');

INSERT INTO semesters(year_of_study_id, institution_id)
VALUES (1, 1), (1, 2), (2, 2), (2, 1);

INSERT INTO flights (ship_id, destination, property_id, duration, duration_unit)
VALUES (2, 1, 1, null, null), (3, 2, 1, null, null), (1, 4, 1, 30, 'день');

INSERT INTO humans(name, surname, gender, age, ship_id, mini_world_id, property_id)
VALUES (
        'Дэвид',
        'Боумен',
        'М',
        '45',
        1,
        1,
        1
       );

INSERT INTO life_events(human_id, event, feel_foreign)
VALUES (1, 'Event 1', true), (1, 'Event 2', true), (1, 'Event 3', true);

COMMIT;
