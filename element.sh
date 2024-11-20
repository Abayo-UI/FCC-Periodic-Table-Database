#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
ARGUMENT=$1


ELEMENT_INFO_BY_ATOMIC_NUMBER(){
   if [[ -z $NEW_ARGUMENT ]]
    then
     echo "I could not find that element in the database."
   else
   NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number = $NEW_ARGUMENT;")
   SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number = $NEW_ARGUMENT;")
   TYPE=$($PSQL "SELECT types.type FROM types FULL JOIN properties USING(type_id) WHERE atomic_number = $NEW_ARGUMENT;")
   MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number = $NEW_ARGUMENT;")
   MELTING_POINT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number = $NEW_ARGUMENT;")
   BOILING_POINT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number = $NEW_ARGUMENT;")
   echo "The element with atomic number $NEW_ARGUMENT is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING_POINT celsius and a boiling point of $BOILING_POINT celsius."
   fi
}

ARGUMENT_CONVERTER(){
  if [[ $ARGUMENT =~ ^[0-9].* ]]
   then
    NEW_ARGUMENT=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = '$ARGUMENT';")
    ELEMENT_INFO_BY_ATOMIC_NUMBER
  elif [[ $ARGUMENT =~ ^[A-Z]([a-z])?$ ]]
   then 
     NEW_ARGUMENT=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ARGUMENT';")
     ELEMENT_INFO_BY_ATOMIC_NUMBER
   elif [[ $ARGUMENT =~ ^[A-Z].+ ]]
   then
     NEW_ARGUMENT=$($PSQL "SELECT atomic_number FROM elements WHERE name = '$ARGUMENT';")
     ELEMENT_INFO_BY_ATOMIC_NUMBER
   elif [[ -z $ARGUMENT ]]
   then 
    echo "Please provide an element as an argument."
   else 
    echo "I could not find that element in the database."
  fi
}

ARGUMENT_CONVERTER
   
