#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
echo "Enter your username:"
read USER

USERNAME=$($PSQL "SELECT username FROM gameData WHERE username='$USER'")

if [[ -z $USERNAME ]]
then
  USER_PSQL=$($PSQL "INSERT INTO gameData VALUES('$USER',0,0)")
  echo "Welcome, $USER! It looks like this is your first time here."
else
  GAMES_PLAYED=$($PSQL "SELECT games_played FROM gameData WHERE username='$USER'")
  BEST_GAME=$($PSQL "SELECT best_game FROM gameData WHERE username='$USER'")
  echo "Welcome back, $USER! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
fi

RANDOM_NUMBER=$((1 + $RANDOM % 1000))
GUESS=0
echo "Guess the secret number between 1 and 1000:"
read USER_GUESS

while [[ $USER_GUESS -ne $RANDOM_NUMBER ]]
do
  if ! [[ "$USER_GUESS" =~ ^-?[0-9]+$ ]]
  then
    echo "That is not an integer, guess again:"
  elif [[ $USER_GUESS -lt $RANDOM_NUMBER ]]
  then
    echo "It's higher than that, guess again:"
  else
    echo "It's lower than that, guess again:"
  fi
  read USER_GUESS
  GUESS=$((GUESS + 1))
done

GUESS=$((GUESS + 1))
# Update games_played
ADDED_GAMES=$($PSQL "UPDATE gameData SET games_played=$((GAMES_PLAYED + 1)) WHERE username='$USER'")

# Update best_game if this game is better
if [[ $GUESS -lt $BEST_GAME || $BEST_GAME -eq 0 ]]
then
ADDED_BEST=$($PSQL "UPDATE gameData SET best_game=$GUESS WHERE username='$USER'")
fi
echo "You guessed it in $GUESS tries. The secret number was $RANDOM_NUMBER. Nice job!"


