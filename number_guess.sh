#!/bin/bash

PSQL_GAME="psql -X --username=freecodecamp --dbname=games --tuples-only -c"

#asking for name
echo "Enter your username:" 
read NAME
#checking if palyer exists in database
PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name = $NAME")
if [[ -z $PLAYER_ID ]]
then 
  #inserting user to database
  INSERT_PLAYER=$($PSQL "INSERT INTO players(name) VALUES('$NAME') | sed's/ / /'g")
  #printing welcome message
  echo "Welcome, $NAME! It looks like this is your first time here."
else
  #getting info about user
  GAMES_PLAYED=$($PSQL "SELECT COUNT(game_id) FROM games_info WHERE player_id = $PLAYER_ID")
  BEST_GAME=$($PSQL "SELECT MAX(number_of_guesses) FROM games_info")
  #printing welcome message
  echo "Welcome back, $NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi