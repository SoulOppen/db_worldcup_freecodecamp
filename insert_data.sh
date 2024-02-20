#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
REMOVEDATA="$($PSQL "TRUNCATE TABLE games, teams")"
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != 'year' ]]
  then
    RESULT_WINNER="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    if [[ -z $RESULT_WINNER ]]
    then
      INSERT_WINNER="$($PSQL "INSERT INTO teams(name) VALUES ('$WINNER') ")"
      RESULT_WINNER="$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")"
    fi
    RESULT_OPPONENT="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    if [[ -z $RESULT_OPPONENT ]]
    then
      INSERT_OPPONENT="$($PSQL "INSERT INTO teams(name) VALUES ('$OPPONENT') ")"
      RESULT_OPPONENT="$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")"
    fi
    INSERT_GAME="$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES ($YEAR,'$ROUND','$RESULT_WINNER','$RESULT_OPPONENT',$WINNER_GOALS,$OPPONENT_GOALS) ")"
  fi
done