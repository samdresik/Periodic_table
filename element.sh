#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

#if no input is provided: 
if [[ -z $1 ]]
  then
  echo Please provide an element as an argument.
  exit
fi

#check if the argument provided is an atomic number or a string: 
if [[ $1 =~ ^[1-9]+$ ]]
  then
    ARGUMENT_RESULT=$($PSQL "SELECT atomic_number, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1 ")
 else
    ARGUMENT_RESULT=$($PSQL "SELECT atomic_number, types.type, atomic_mass, melting_point_celsius, boiling_point_celsius, symbol, name FROM properties JOIN elements USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1' ")
fi

#if element not found:
if [[ -z $ARGUMENT_RESULT ]]
  then
    echo -e "I could not find that element in the database."
  exit
fi

echo $ARGUMENT_RESULT | while IFS=" |" read ATOMIC_NUMBER TYPE MASS MELTING_POINT BOILING_POINT SYMBOL NAME
do
  echo -e "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
done
