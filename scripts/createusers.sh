#!/bin/bash
INPUT=avalon-employees.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read Number GivenName Surname Username Title Unit Gender StreetAddress Postcode City Co
untry CountryFull TelephoneNumber Birthday
do
        echo "name: $Username"
        echo "comment: $GivenName $Surname $Title $Unit "
        echo "password: $(openssl passwd -salt 2 -1 test)"
done < $INPUT
IFS=$OLDIFS
