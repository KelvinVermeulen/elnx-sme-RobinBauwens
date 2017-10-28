#!/bin/bash
INPUT=../doc/avalon-employees.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
while read Number GivenName Surname Username Title Unit Gender StreetAddress Postcode City Country CountryFull TelephoneNumber Birthday
do
        echo "- name: $Username"
        echo "  comment: $GivenName $Surname $Title"
        echo "  password: $(openssl passwd -salt 2 -1 $City)"
        echo "  shell: /sbin/nologin"
        echo "  groups: $Unit"
done < $INPUT
IFS=$OLDIFS
