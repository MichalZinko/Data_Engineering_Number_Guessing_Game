#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=postgres"
PSQL_GAME="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

$PSQL -lqt | cut -d \| -f 1 | grep -qw number_guess
GAMES_DATABASE_EXISTANCE=$?
if [[ $GAMES_DATABASE_EXISTANCE == 0 ]]
then 
  DELETE_DATABASE=$($PSQL -t --no-align -c "DROP DATABASE number_guess")
fi
#palyer_id
#player_name
#amount of games
#number of guesses 

CREATING_DATABASE=$($PSQL -t --no-align -c "CREATE DATABASE number_guess")
CREATING_PLAYER_TABLE=$($PSQL_GAME "CREATE TABLE players(player_id SERIAL PRIMARY KEY NOT NULL, name VARCHAR(50) NOT NULL)")
CREATING_GAMES_TABLE=$($PSQL_GAME "CREATE TABLE games_info(game_id SERIAL PRIMARY KEY NOT NULL, player_id INT NOT NULL, number_of_guesses INT NOT NULL, FOREIGN KEY (player_id) REFERENCES players(player_id))")

