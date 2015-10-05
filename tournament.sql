-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use them.
--
-- Database Review Criteria:
-- -------------------------
-- Meaningful names for tables and columns
-- No unnecessary tables or columns
-- Columns are the proper data type
-- Views used to make queries more concise (Extra Credit)
-- Properly specified primary and foreign keys (Extra Credit)
--
--
-- Quick Database Model Representation:
-- ------------------------------------
-- player (id**: SERIAL, name: TEXT)
-- tournament (id**: SERIAL, name: TEXT, start_date: DATE)
-- match (id**: SERIAL, player_id_1*: INT, player_id_2*: INT,
--  tournament_id*: INT, match_start: TIMESTAMP)
-- match_result (match_id**: INT, player_id**: INT, result: TEXT)
-- player_standing (player_id**: INT, tournament_id**: INT, points_total: INT,
--  bye_count: INT)



-- used during development to ensure clean start
DROP DATABASE IF EXISTS tournament;
-- DROP TABLE IF EXISTS player,
--  tournament,
--  match,
--  match_result,
--  player_standing
--  CASCADE;

CREATE DATABASE tournament;
\c tournament;

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
  player_id_1 INT REFERENCES player NOT NULL,
  player_id_2 INT REFERENCES player NOT NULL,
  tournament_id INT REFERENCES tournament NOT NULL,
  match_start TIMESTAMP NOT NULL
);

CREATE TABLE match_result(
  match_id INT REFERENCES match NOT NULL,
  player_id INT REFERENCES player NOT NULL,
  result TEXT NOT NULL,
  PRIMARY KEY (match_id, player_id)
);

CREATE TABLE player_standing(
  player_id INT REFERENCES player NOT NULL,
  tournament_id INT REFERENCES tournament NOT NULL,
  points_total INT NOT NULL,
  bye_count INT NOT NULL,
  PRIMARY KEY (player_id, tournament_id)
);
