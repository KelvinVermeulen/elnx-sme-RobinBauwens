# Enterprise Linux Lab Report

- Student name: Robin Bauwens
- Github repo: <https://github.com/HoGentTIN/elnx-sme-RobinBauwens/tree/solution>

Installeren van Samba voor de (publieke) fileserver met Vagrant en Ansible.

## Test plan

How are you going to verify that the requirements are met? The test plan is a detailed checklist of actions to take, including the expected result for each action, in order to prove your system meets the requirements. Part of this is running the automated tests, but it is not always possible to validate *all* requirements throught these tests.

- De gebruikers moeten toegang hebben tot de shares waarop ze effectief lees- en/of schrijfrechten hebben.
- We loggen in als een andere gebruiker en we moeten kunnen zien wat er allemaal in de homedirectory zit van de andere gebruiker (via `smbclient`).
- De gebruikers dienen lid te zijn van de groepen/business units waartoe ze behoren.
- Alle testscripts dienen te slagen.
- Een willekeurige gebruiker kan bestanden van andere gebruikers (binnen die business unit) aanpassen.
- Iedere gebruiker kan zijn eigen homefolder aanpassen op de fileserver.

## Procedure/Documentation

1. We voegen `pr011` toe bij `site.yml`, we geven deze de rollen van `rh-base` en `samba`. ![Git Bash](img/03/1.PNG)
2. Hierna voegen we `pr011` ook toe bij `vagrant-hosts.yml`, we geven de server `172.16.0.11` als IP-adres. ![Git Bash](img/03/2.PNG)
3. Voor deze role hebben we enkele gebruikers en groepen nodig, deze voegen we toe bij de `rh-base`-role. Ook moeten de paswoorden geëncrypteerd zijn, dit doen we op dezelfde manier als in de eerste opdracht. Om het werk te vergemakkelijken heb ik een script geschreven om automatisch de gebruikers te genereren door het uitlezen van het .csv-bestand. De uitvoer van het script kan je direct kopiëren en plakken naar `pr011.yml` (behalve `shell` bij `it`). Het paswoord van de gebruikers is telkens de gebruikersnaam van de persoon.

```
#!/bin/bash
INPUT=../doc/avalon-employees.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
sed 1d $INPUT | while read Number GivenName Surname Username Title Unit Gender StreetAddress Postcode City Country CountryFull TelephoneNumber Birthday
do
        echo "- name: $Username"
        echo "  comment: '$GivenName $Surname $Title'"
        echo "  password: $(openssl passwd -salt 2 -1 $Username)"
        echo "  shell: /sbin/nologin"
        echo "  groups:"
    echo "    - $Unit"
    echo "    - public"
done < $INPUT
IFS=$OLDIFS
```

Ook een kleine scriptje om de gebruikersnamen en paswoorden eruit te halen:
```
#!/bin/bash
INPUT=../doc/avalon-employees.csv
OLDIFS=$IFS
IFS=,
[ ! -f $INPUT ] && { echo "$INPUT file not found"; exit 99; }
sed 1d $INPUT | while read Number GivenName Surname Username Title Unit Gender StreetAddress Postcode City Country CountryFull TelephoneNumber Birthday
do
    echo "  - name: $Username"
    echo "    password: $(echo $Username)"
done < $INPUT
IFS=$OLDIFS
```
4. Voeg dit allemaal toe in `pr011.yml` bij `rhbase_users` en `samba_users`. Voeg bij `all.yml` ook zeker `it` toe als groep bij je eigen gebruikersnaam. Ook bij `pr011.yml` voegen we volgende toe:
```
  - name: robin
    password: testpassword
```
5. Vergeet ook niet om de `samba` en `dns` als toegelaten services te configuren op de firewall. ![Firewall all.yml](img/03/5.PNG)
6. Hierna maken we ook de groepen aan in `all.yml`. ![Groepen all.yml](img/03/6.PNG)
7. Vervolgens maken we ook de gebruikers aan die later ook voor Samba gebruikt zullen worden. Deze dienen allemaal lid te zijn van de groep `public` en van de business unit(s) waartoe de gebruiker behoort. Het paswoord moet een gehasht-paswoord zijn, ook mogen de gebruikers van `it` geen beperking op het inloggen krijgen (dit wordt niet behandeld in het generatiescript). ![Voorbeeld gebruikers](img/03/7.PNG)
8. We voegen ook de configuratie van Samba toe, dit bevat o.a. de NetBIOS-naam en workgroup, ondersteuning voor WINS, het toegankelijk maken van de home directories, printers niet gedeeld worden, geen symlinks gemaakt worden in `/var/www/html` en de logbestanden geplaatst worden in `/var/log/samba.log`. ![Samba-config pr011.yml](img/03/8.PNG)


Describe *in detail* how you completed the assignment, with main focus on the "manual" work. It is of course not necessary to copy/paste your code in this document, but you can refer to it with a hyperlink.

Make sure to write clean Markdown code, so your report looks good and is clearly structured on Github.

## Test report

The test report is a transcript of the execution of the test plan, with the actual results. Significant problems you encountered should also be mentioned here, as well as any solutions you found. The test report should clearly prove that you have met the requirements.

## Resources

List all sources of useful information that you encountered while completing this assignment: books, manuals, HOWTO's, blog posts, etc.

- [Lezen .csv BASH](https://www.cyberciti.biz/faq/unix-linux-bash-read-comma-separated-cvsfile/)
- [Delete first line while reading](https://stackoverflow.com/questions/9633114/unix-script-to-remove-the-first-line-of-a-csv-file)
- [Reverse string `rev`](https://stackoverflow.com/questions/11461625/reverse-the-order-of-characters-in-a-string)
- [Config SMB](https://www.samba.org/samba/docs/man/manpages-3/smb.conf.5.html)
- [Role SMB](https://github.com/bertvv/ansible-role-samba)
- [Role VSFTPD](https://github.com/bertvv/ansible-role-vsftpd)