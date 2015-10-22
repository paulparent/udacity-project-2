/* 
  Table definitions for the tournament project

  Database Review Criteria:
  -------------------------
  * Meaningful names for tables and columns
  * No unnecessary tables or columns
  * Columns are the proper data type
  * Views used to make queries more concise (Extra Credit)
  * Properly specified primary and foreign keys (Extra Credit)

  Quick Database Model Representation:
  ------------------------------------
  player (id**: SERIAL, name: TEXT)
  tournament (id**: SERIAL, name: TEXT, start_date: DATE)
  match (id**: SERIAL, player_id_1*: INT, player_id_2*: INT,
  tournament_id*: INT, match_start: TIMESTAMP)
  match_result (match_id**: INT, player_id**: INT, result: TEXT)
  player_standing (player_id**: INT, tournament_id**: INT, points_total: INT,
    bye_count: INT)
*/

-- ensure clean start
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament;

-- enumerate types of match results to ensure data integrity
CREATE TYPE result_type AS ENUM ('Win', 'Loss', 'Draw', 'Bye');

CREATE TABLE player(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL
);

CREATE TABLE tournament(
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  start_date DATE NOT NULL
);

CREATE TABLE match(
  id SERIAL PRIMARY KEY,
  player_id_1 INT REFERENCES player ON DELETE CASCADE NOT NULL,
  player_id_2 INT REFERENCES player ON DELETE CASCADE NOT NULL,
  tournament_id INT REFERENCES tournament ON DELETE CASCADE NOT NULL,
  match_start TIMESTAMP NOT NULL
);

CREATE TABLE match_result(
  match_id INT REFERENCES match ON DELETE CASCADE NOT NULL,
  player_id INT REFERENCES player ON DELETE CASCADE NOT NULL,
  result result_type NOT NULL,
  PRIMARY KEY (match_id, player_id)
);

CREATE TABLE player_standing(
  player_id INT REFERENCES player ON DELETE CASCADE NOT NULL,
  tournament_id INT REFERENCES tournament ON DELETE CASCADE NOT NULL,
  points_total INT NOT NULL,
  bye_count INT NOT NULL,
  PRIMARY KEY (player_id, tournament_id)
);

CREATE VIEW player_wins AS
  SELECT p.id, p.name, COUNT(r.result) AS "total wins"
  FROM player p
    LEFT JOIN match_result r ON p.id = r.player_id
  WHERE r.result = 'Win'
  GROUP BY p.id
  ORDER BY COUNT(r.result) DESC;

CREATE VIEW player_matches AS
  SELECT p.id, p.name, COUNT(r.result) AS "total matches"
  FROM player p
    LEFT JOIN match_result r ON p.id = r.player_id
  GROUP BY p.id
  ORDER BY COUNT(r.result) DESC;

CREATE VIEW current_standings AS
  SELECT pm.id, pm.name, COALESCE(pw."total wins", 0) AS "total wins", pm."total matches"
  FROM player_matches pm
    LEFT JOIN player_wins pw ON pm.id = pw.id
  ORDER BY "total wins" DESC;

INSERT INTO tournament (id, name, start_date) VALUES (1, 'No Tournament Specified', '2015-01-01');

/******************************
 TEST DATA to Populate Database 
 ******************************/
INSERT INTO tournament (id, name, start_date) VALUES (2, 'Run the Jewels', '2015-10-15');

INSERT INTO player (id, name) VALUES (1, 'Paul');
INSERT INTO player (id, name) VALUES (2, 'RLW');
INSERT INTO player (id, name) VALUES (3, 'JZ');
INSERT INTO player (id, name) VALUES (4, 'ABro');

INSERT INTO match (id, player_id_1, player_id_2, tournament_id, match_start) 
  VALUES (1, 1, 2, 2, '2015-10-15 12:34:56');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (1, 1, 'Win');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (1, 2, 'Loss');

INSERT INTO match (id, player_id_1, player_id_2, tournament_id, match_start)
  VALUES (2, 1, 3, 2, '2015-10-15 12:34:56');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (2, 1, 'Win');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (2, 3, 'Loss');

INSERT INTO match (id, player_id_1, player_id_2, tournament_id, match_start)
  VALUES (3, 1, 4, 2, '2015-10-15 12:34:56');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (3, 1, 'Win');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (3, 4, 'Loss');

INSERT INTO match (id, player_id_1, player_id_2, tournament_id, match_start)
  VALUES (4, 2, 1, 2, '2015-10-15 12:34:56');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (4, 2, 'Win');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (4, 1, 'Loss');

INSERT INTO match (id, player_id_1, player_id_2, tournament_id, match_start)
  VALUES (5, 2, 3, 2, '2015-10-15 12:34:56');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (5, 2, 'Win');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (5, 3, 'Loss');

INSERT INTO match (id, player_id_1, player_id_2, tournament_id, match_start)
  VALUES (6, 2, 4, 2, '2015-10-15 12:34:56');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (6, 2, 'Win');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (6, 4, 'Loss');

INSERT INTO match (id, player_id_1, player_id_2, tournament_id, match_start)
  VALUES (7, 3, 1, 2, '2015-10-15 12:34:56');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (7, 3, 'Win');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (7, 1, 'Loss');

INSERT INTO match (id, player_id_1, player_id_2, tournament_id, match_start)
  VALUES (8, 3, 2, 2, '2015-10-15 12:34:56');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (8, 3, 'Win');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (8, 2, 'Loss');

INSERT INTO match (id, player_id_1, player_id_2, tournament_id, match_start)
  VALUES (9, 3, 4, 2, '2015-10-15 12:34:56');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (9, 3, 'Win');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (9, 4, 'Loss');

INSERT INTO match (id, player_id_1, player_id_2, tournament_id, match_start)
  VALUES (10, 4, 1, 2, '2015-10-15 12:34:56');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (10, 4, 'Win');
INSERT INTO match_result (match_id, player_id, result)
  VALUES (10, 1, 'Loss');
