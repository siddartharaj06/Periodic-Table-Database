#!/bin/bash

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit 0
fi

search=$(printf '%s' "$1" | sed "s/'/''/g")
query="SELECT 'The element with atomic number ' || e.atomic_number || ' is ' || e.name || ' (' || e.symbol || '). It''s a ' || t.type || ', with a mass of ' || p.atomic_mass || ' amu. ' || e.name || ' has a melting point of ' || p.melting_point_celsius || ' celsius and a boiling point of ' || p.boiling_point_celsius || ' celsius.' FROM elements e JOIN properties p ON p.atomic_number = e.atomic_number JOIN types t ON t.type_id = p.type_id WHERE e.atomic_number::text = '$search' OR e.symbol = '$search' OR e.name = '$search';"

result=$(psql -X -qAt -h localhost -U postgres -d periodic_table -v search="$1" -c "$query")

if [[ -z "$result" ]]; then
  echo "I could not find that element in the database."
else
  echo "$result"
fi
