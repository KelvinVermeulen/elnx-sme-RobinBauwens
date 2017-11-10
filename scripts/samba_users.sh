#!/bin/bash
INPUT=../doc/avalon-employees.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
sed 1d $INPUT | while read Number GivenName Surname Username Title Unit Gender StreetAddress Postcode City Country CountryFull TelephoneNumber Birthday
do
	echo "  - name: $Username"
	#echo "    password: $(echo $Username | rev)"
	echo "    password: $(echo $Username)"
done < $INPUT
IFS=$OLDIFS
