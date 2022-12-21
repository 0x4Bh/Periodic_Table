#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  # Check the argument($1) if it exists as atomic_number, symbol, or name
  ATOMIC_NUMBER=$1
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    :
  elif [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]
  then
    SYMBOL=$1
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'")
  else
    NAME=$1
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME'") 
  fi
  if [[ ! -z $ATOMIC_NUMBER ]]
  then
    echo "$($PSQL "SELECT name,symbol,type,atomic_mass,melting_point_celsius,boiling_point_celsius FROM elements left join properties using(atomic_number) left join types using(type_id) WHERE atomic_number=$ATOMIC_NUMBER")" | while read NAME BAR SYMBOL BAR TYPE BAR ATOMIC_MASS BAR MELTING_POINT BAR BOILING_POINT
    do
      if [[ ! -z $NAME ]]
      then
        echo -e "The element with atomic number $(echo $ATOMIC_NUMBER | sed -E 's/ //g') is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
      else
        echo I could not find that element in the database.
      fi
    done
  else
    echo I could not find that element in the database.
  fi
fi
