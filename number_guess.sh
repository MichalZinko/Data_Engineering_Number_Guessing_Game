#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
BEGINING () {

  if [[ $1 ]]
  then
    echo "$1"
  fi
  #asking for name
  echo  "Enter your username:" 
  read USERNAME
  #checking if palyer exists in database
  if [[ ${#USERNAME} -gt 22 ]]
  then
    BEGINING "Username has to be shorter than 22 characters"
  fi

  if [[ ${#USERNAME} == 0 ]]
  then
    BEGINING "Username can't be empty"
  fi
  
  PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name = '$USERNAME'")
  if [[ -z $PLAYER_ID ]]
  then 
    #inserting user to database
    INSERT_PLAYER=$($PSQL "INSERT INTO players(name) VALUES('$USERNAME')")
    #printing welcome message
    echo "Welcome, $USERNAME! It looks like this is your first time here."
  else
    #getting info about user
    GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games_info WHERE player_id = $PLAYER_ID")
    BEST_GAME=$($PSQL "SELECT MIN(number_of_guesses) FROM games_info")
    #printing welcome message
    echo "Welcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi
}

GAME () {
  if [[ $1 ]]
  then
    echo "$1"
  else
    #ask player for number
    echo "Guess the secret number between 1 and 1000:"
  fi

  read PLAYER_NUMBER
  #checking if input is number
  if [[ ! $PLAYER_NUMBER =~ ^[0-9]+$ ]]
  then
    GAME "That is not an integer, guess again:"
  #checking if input is lower then secret_number
  elif [[ $PLAYER_NUMBER -lt $SECRET_NUMBER ]]
  #checking if input is lower then secret_number
  then
    NUMBER_OF_GUESSES=$(($NUMBER_OF_GUESSES+1))
    GAME "It's higher than that, guess again:"
  #checking if input is lower then secret_number
  elif [[ $PLAYER_NUMBER -gt $SECRET_NUMBER ]]
  then
    NUMBER_OF_GUESSES=$(($NUMBER_OF_GUESSES+1))
    GAME "It's lower than that, guess again:"
  #checking if input is correct
  elif [[ $PLAYER_NUMBER -eq $SECRET_NUMBER ]]
  then
    PLAYER_ID=$($PSQL "SELECT player_id FROM players WHERE name = '$USERNAME'")
    NUMBER_OF_GUESSES=$(($NUMBER_OF_GUESSES+1))
    INSERTING_GAME_SCORE=$($PSQL "INSERT INTO games_info(player_id, number_of_guesses) VALUES($PLAYER_ID, $NUMBER_OF_GUESSES)")
    echo "You guessed it in $NUMBER_OF_GUESSES tries. The secret number was $SECRET_NUMBER. Nice job!"
    exit 0
  fi
}

BEGINING
#generating secret number
SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))
# create variable for amount of tries
NUMBER_OF_GUESSES=0
GAME 