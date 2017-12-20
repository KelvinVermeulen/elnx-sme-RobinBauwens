# Cheat sheet

Hou in dit bestand de belangrijkste commando's bij die je tegenkomt, zodat je die snel kan terugvinden. Steek structuur in het bestand en let op een [correct gebruik van Markdown](https://help.github.com/articles/getting-started-with-writing-and-formatting-on-github/) zodat het overzichtelijk blijft. Voor inspiratie en motivatie voor het bijhouden van dit soort cheat sheets, ga eens kijken naar <https://github.com/bertvv/cheat-sheets/>.

## Vim survival guide

- Bij opstarten van Vim kom je terecht in *normal mode*.
- Als je tekst wil invoeren moet je naar *insert mode*.

| Taak                       | Commando |
| :---                       | :---     |
| Normal mode -> insert mode | `i`      |
| Insert mode -> normal mode | `<Esc>`  |
| Opslaan                    | `:w`     |
| Opslaan en afsluiten       | `:wq`    |
| Afsluiten zonder opslaan   | `:q!`    |

## Hoofdstuk 1: Installatie

| Taak                       | Commando |
| :---                       | :---     |
| Software installeren       | `dnf`    |
| Print working directory    | `pwd`    |
| Toon ID                    | `id`     |
| Toon homedirectory            |  `echo $HOME` |
| Gebruiker toevoegen [Met sudo] |   `sudo useradd user1`|
| Verander password user1    |  `sudo passwd user1`|
| Groep toevoegen                          |  `groupadd group1`|
| Gebruiker toevoegen aan secundaire groep |    ` usermod -aG group2 user1`|
| Gebruiker toevoegen aan meerdere secundaire groep |    ` usermod -a -G group1,group2 username`|
| Inloggen als gebruiker jack              |      `su - jack`  |
| Gebruiker **correct** verwijderen        |   `sudo userdel -r user` |
| Groep verwijderen                        |    `sudo groupdel group` |
| Gebruiker blokkeren van het systeem      |     `sudo usermod -L user`    |
| Gebruiker deblokkeren van het systeem      |     `sudo usermod -U user`    |
| Gebruiker toevoegen, aanmaken homedir (-m), naam geven (-d), beschrijving geven (-c), shell verandert (-s)      |     `useradd -m -d /home/yanina -c "yanina wickmayer" -s /bin/bash yanina`    |
| Vervaldatum zetten | `chage -l paul` |

**Scheiden van commando's: cmd1 ; cmd2**

**Zie commentaar H3: Werken met doorlopende tekst: oef 2!**

## Hoofdstuk 2: Verkenning

| Taak                       | Commando |
| :---                       | :---     |
| Configuratiebestanden van een command (bvb: passwd)|      `man 5 passwd`    |
| Huidige datum (en tijd, etc...)                    |      `date`            |
| Toon inhoud huidige directory                      |      `ls`              |
| CMD-geschiedenis                                   |      `history`         |
| Locatie van manual pages                           |      `manpath`         |
| Aanmaken van directory  (-p om pad mee te geven)   |      `mkdir -p /tmp/tijdelijk`    |
| Verwijderen van directory                          |      `rmdir /tmp/tijdelijk`    |
| Verander huidige directory                         |      `cd `     |
| Toon boomstructuur                                 |      `tree`    |
| Aanmaken nieuw (hidden) bestand                           |      `touch .file`    |
| Verwijderen bestand   (-r voor onderliggende bestanden) |      `rm file`    |
| Kopieer bestand: van, naar (-r voor non-textbestanden)                           |      `cp file1 file2`    |
| Kopieer meerdere bestanden (laatste argument moet directory zijn) | `cp file42 file42.copy SinkoDeMayo dir42/ `|
| Kopieer alles in dir naar dir2 **let op `/`**                       |      `cp -r dir dir2/`    |
| Hernoem/verplaats bestand                            |      `mv file1 f/`    |
| Meerdere verplaatsen                            |      `mv file1 file2 f/h`    |
| Aanmaken file1-file19                            |      `for i in {1..19}; do touch "file${i}"; done `    |
| Bestanden beginnend met file, gevolgd door één letterteken tonen                        |      `ls file?`    |
| Bestanden beginnend met file, niet gevolgd door een 1 tonen                          |      `ls file[!1]`    |
| Harde link (naar, naam)                          |      `ln`    |
| Symbolische link                       |      `ln -s`    |
| Archiveren                           |      `tar -cf linux.tar.bz2 linux/`    |
| List content archief                           |      `tar -tf linux.tar.bz2`    |
| Archief uitpakken                           |      `tar -xf linux.tar.bz2`    |


## Hoofdstuk 3: Tekst
**Zie VIM shortcuts**

**Schrijf aanpassingen weg naar nieuw bestand! Deze passen het originele bestand niet aan!**

**Verschil join & paste**

Join: beide bestanden hebben een gemeenschappelijke kolom (+ gesorteerd)
Paste: geen gemeenschappelijke kolom (+ niet gesorteerd)

[Voorbeeld join](http://www.thegeekstuff.com/2009/10/file-manipulation-examples-using-tac-rev-paste-and-join-unix-commands/)

| Taak                       | Commando |
| :---                       | :---     |
| Verwijderen                |      `sed`    |
| Uppercase <-> Lowercase    |      `tr`    |
| Eigen formattering (eventueel eerst met paste/join)  |      `awk`    |
| Filteren/isoleren/opzoeken van patronen  |      `grep`    |
```
sed "s/REGEX/REPLACEWITH/g" file (s: substitute, g: global -> alle lijnen)
```
| Taak                       | Commando |
| :---                       | :---     |
| Kolommen eruithalen        |      `cut -d" " -f2,3 landenkentekens.txt > landenkentekens2.txt` (-d: delimiter, -f: field)    |
| Tonen inhoud bestand       |      `cat file.txt`    |
| Achteraan tekst toevoegen  |      `echo "Italië I" >> landenkentekens2.txt`    |
| Sorteren op bepaalde kolom (hier: kolom 2) |      `sort -k2  landenkentekens2.txt > gesorteerdeautokentekens.txt` (-k: key)   |
| Zoeken/filteren en opslaan van RegEx      | `grep -E -o "([0-9]{1,3}[.]){3}[0-9]{1,3}[/][0-9]{1,3}" ip.txt ` (-E: RegEx, -o: only) |
| Aantal regels tellen       |      `wc file.txt`    |
| Maximum 50 karakters in 1 regel |`fmt -w 50 lorem.txt` (-w: width)    |
| Regelnummers toevoegen     |      `nl lorem.txt`    |
| Lege regels verwijderen    |      `sed '/^$/d' lijst.txt`    |
| `.` en `,` verwijderen     |      `sed 's/[.,]//g' lijstIndWoord2.txt`    |
| Woorden sorteren           |      `sort lijst.txt > newList.txt`    |
| Zet alle hoofdletters om naar kleine letters | `tr [:upper:] [:lower:] < newList.txt > newList2.txt` (van newList naar newList2; tr= translate)  |
| Tel alle unieke woorden    | `uniq -c file.txt` **Alles naar lower-/uppercase eerst!** of: `uniq -ic`    |
| Gesorteerde lijst van gebruikers met een UID groter dan 1000 (eigen formattering) | `awk -F: '{if($3>1000) {printf"%s\n",$1}}' /home/robinbauwens/ilnx-RobinBauwens/labos/labo3/passwd` (-F: Field separator)    |
| awk 2 | `awk -F: '($3>1000) {printf"%s\n",$1}' /etc/passwd` |
| Meerdere bestanden samenvoegen met speciale formattering | Gebruik paste en dan awk (zit dan in hetzelfde bestand (en lijnregel; scheiden van kolommen hoeft niet per se dan -> paste is met delimiter \t) |
| Zoeken naar string in file |      `grep "string" file`    |
| Sorteren en behoud alfabetische sortering  |      `sort -rns lijstNr.txt`    |
| Genereren 6 paswoorden  |      `apg -n 6 users.txt > newpass.txt`    |
| Werken met delimiters en `awk` | `awk '{printf "\"%s\";\"%s\"\n",$1,$2}' newusers.txt > newusers.csv`|
| `awk` met `|` en `grep` | `grep "bash" passwd | awk -F : '{printf "%s:%s:%s\n",$1,$3,$6}'` |

-> gebruik -s (stable): sortering over meerdere kolommen.

Als je meerdere taken wilt uitvoeren en je moet bestandsnaam nog meegeven -> werken met pipe ("|")

`$ cat test.txt | tr '[a-z]' '[A-Z]'`


## Hoofdstuk 4: Webserver

**httpd wordt omgezet naar httpd.srevice**

**Mogelijke fouten**
- Firewall blokkeert (eigen) toegang naar webserver.
- Configuratiebestanden laten toegang van anderen niet toe.
- Service is niet opgestart.
- Webserver werd niet gerestart na toevoegen nieuwe service.
- Geen gebruiker toegevoegd in PHPMyAdmin.


| Taak                       | Commando   |
| :---                       | :---       |
| Controleren status service |      `sudo systemctl status httpd`    |
| Controleren status poortnummers   |      `netstat -tl` (t= TCP, l= Listening   |
| Controleren door opvragen processen   |      `ps -ef | grep "httpd"`    |
| Starten van een service                          |      `sudo systemctl start httpd.service`    |
| Bekijken NIC's en IP-adressen **afgeraden**                          |      `ifconfig`    |
| Bekijken NIC's en IP-adressen                           |      `ip a`    |
| Opstarten firewall                     |      `sudo systemctl start firewalld`    |
| Start firewall op na iedere boot                           |      `sudo systemctl enable firewalld`    |
| Bekijk firewall via CMD            |      `sudo firewall-cmd --list-all`    |
| Sta service toe in firewall via CMD   |      `sudo firewall-cmd --add-service=http --permanent` (permanent= zoals enable)    |
| Installatie MySQL (MariaDB)                           |      `mysql_secure_installation`    |
| Nakijken service MariaDB                           |      `sudo systemctl status mariadb.service`    |
| Locatie configbestanden (sudo-rechten nodig)                          |      `/etc/httpd/conf.d`    |
| Bekijken route, default gateway,...                           |      `sudo traceroute -T www.google.com`    |
| Opzoeken ip-address van een domeinnaam                           |      `nslookup www.hogent.be`    |
| Configbestand DNS-servers                           |      `/etc/resolv.conf`    |
| Instellingenbestand netwerkinterfaces               |      `/etc/networks`    |
| Testen of PC bereikbaar is (met ICMP)                          |      `ping eenIP-address`    |
| Draaiende services                           |      `ss -tln`    |
| Locatie logbestanden                         |      `/var/log/`    |
| Bekijk algemene systeemlogs                  |      `journalctl`    |
| Bekijk nieuwe logs in algemene systeemlogs   |      `journalctl -f`    |
| Bekijk nieuwe logs in bepaald netwerkservice |      `journalctl -u NetworkManager | tail -5`    |
| Logbestand opgevraagde webpagina's           |      `/etc/httpd/logs/access_log`    |





## Hoofdstuk 5: Bestandspermissies

| Taak                       | Commando |
| :---                       | :---     |
| Umask (neemt al deze rechten af)                |      `umask`    |
| Symbolische permissies                   |      `ls -l`    |
| Octale waarden                             |      `stat -c "%a %n" * `    |
| Verander rechten (octaal) v.e. directory                          |      `chmod 700 folder/`    |
| Wegschrijven                  |      `echo 'echo "Waarschuwing: eigendom van ${USER}!"' > vanmij`    |
| Uitvoeren bestand (via pad altijd)                            |      `./execBestand`    |
| Verander rechten (symbolisch) v.e. bestand                            |      `chmod g+rwx,o+rwx vanmij`    |
| Zoek bestand met ingestelde SUID-permissie + schrijf uitvoer en fouten weg   |      `find / -perm -4000 > suidBestanden.txt 2> foutBestanden.txt`    |
| SetUID                           |      `chmod u+s directory/`    |
| SetGID                           |      `chmod g+s directory/`    |
| Set restricted deletion (= sticky bit)  |      `chmod +t directory/`    |
| `user` eigenaar maken van directory `directory/`    |      `chown user directory/`    |
| `group` eigenaar maken van directory `directory/`    |      `chgrp group directory/`    |
| Verander de groepseigenaar van alle nieuwe bestanden/directories naar de groepseigenaar van `directory/` |      `chmod g+s directory/`    |
| Gebruikers mogen elkaars bestanden niet kunnen verwijderen       |      `chmod +t directory/`    |


## Hoofdstuk 6: Scripts

| Taak                       | Commando |
| :---                       | :---     |
| Bashversie tonen                           |   `echo $BASH_VERSION`     |
| Variabele maken  **geen spaties**          |   `pinguin="Tux"`     |
| Open een sub(bash)shell                 |   `bash`     |
| Tonen actieve shells                           |   `ps`     |
| Tonen hiërarchie shells (12345 = PID)               |   `pstree 12345`     |
| Tonen hiërarchie shells (nummeriek)                           |   `echo $SHLVL`     |
| Sluiten huidige shell                           |   `exit`     |
| Lokale variabele globaal maken voor onderliggende subshells                           |   `export var`  (geen $var, is opvragen)   |
|  **Zie tabel shellvariabelen**                          |   `PATH, HISTSIZE, UID, HOME, HOSTNAME, LANG, USER, OSTYPE, PWD, MANPATH`|
| ShellCheck                           |   `shellcheck script.sh`     |
| Display a list of environment variables | `set`|
| Display a list of exported variables | `env`|
| Remove a variable from your shell environment (**no** `$`) | `unset myVar`|
| Script stoppen als instructie faalt          |   `set -o errexit `|
| Script stoppen bij gebruik van niet-gedefinieerde variabele         |   `set -o nounset` of `set -u`|
| Geen echo meer gebruiken in script          |   `cat << _EOF_ `|


- `${*}` alle parameters als één string
- `${@}` alle parameters als lijst van strings
- `${#}` aantal parameters


## Extra

| Taak                       | Commando |
| :---                       | :---     |
| Gebruikernaam opvragen |  `whoami` |
| Ingelogde gebruikers + wat ze doen opvragen |  `w` |
| Opvragen informatie hostnaam/IP Address                           |   `whois google.com` **geen www.**     |
| "Menselijkere beschrijving ls"          |   `ls -lh"`     |
| Verwijder onderliggende directories  **geen `-r`**       |   `rmdir -p dir1/dir2"`     |
| Beschrijving man-page          |   `whatis route`     |
| Voeg directory toe aan stack  > p83        |   `pushd /dir`|
| Verwijder directory van stack          |   `popd `|
| Nagaan type bestand          |   `file tekstbestand.txt `|
| Locatie "magic file" > p85          |   `/usr/share/file/magic `|
| Voeg timestamp 2016 december 17 (13u00) toe bij (aanmaken/bestaand) bestand          |   `touch -t 201612171300 file`|
| Verander naam meerdere bestanden    > p90      |   `rename 's/file/document/' *.png`|
| Create directory ~/etcbackup and copy all `*.conf` files from /etc into it.          |   `cp -r /etc/*.conf ~/etcbackup`|
| Hernoem `conf` naar `backup` bij alle `*.conf`           |   `rename conf backup *.conf `|
| Zoek doorheen man-pages met een string-zoekterm (comman -> commando)         |   `man -k comman `|
| Zoek doorheen man-pages met een string-zoekterm (comman -> commando)          |   `apropos comman `|
| Zoeken binnen man-pages           |   `/word`|
| Locatie meeste programma's zoals `/bin`,`/usr/bin`           |   ` PATH`|
| Ga naar vorige directory          |   `cd -`|
| Gedetailleerde info van specifieke directory          |   `ls -ld dir `|
| Toon alleen maar info over directories          |   `ls -d`|
| Toon pad van shell commando in PATH           |   `which`|
| Toon programma, broncode, man-page van commando           |   `whereis`|
| Zoek in huidige dir alle .mp3- bestanden         |   `find . -name \*.mp3`|
| Geef de volledige lijn als het 9de veld code 500 bevat            |   `awk '$9==500 {print $0}' `|
| Zoek naar de lijnen met tom of jerry           |   `awk '/tom|jerry/' /etc/passwd`|
| Extraheer 2de-7de karakter          |   `cut -c2-7 file.txt `|
| Zoek naar Williams (eerst tonen op scherm)          |   `cat file.txt | grep Williams  `|
| grep: Niet case sensitive           |   `grep -i `|
| grep: Alles behalve dit          |   `grep -v`|
| Toon eerste 15 regels           |   `head -15 `|
| join **zelf** (-o) kolommen opgeven   (-1 = 1e bestand,-2 = 2de bestand)          |   `join -o -1 2 -2 2 a.txt b.txt`|
| Permissies directory instellen bij creatie          |   `mkdir -m 700 myDir `|
| Tegelijk owner en group veranderen           |   `chown newOwner:newGroup file `|
| Inode info bekijken          |   `ls -i `|
| Inode info bekijken          |   `stat file`|
| Toon bestandstype           |   ` ls -F`|
| Zoeken          |   `locate `|
| `ln -s doelbestand linknaam`          |   ` `|
| Tekst in omgekeerde volgorde tonen          |   `tac`|
| Gaan doorheen tekst (heen en terug)        |   `less `|
| Gaan doorheen tekst (heen )           |   `more `|
| Toon op het scherm tot en met "stop"           |   `cat > hot.txt <<stop `|
| Zelf intypen via cat          |   `cat > count.txt (afbreken met CTRL + D `|
| Tonen inhoud in leesbare ASCII strings          |   `strings file.txt`|
| Manpage hiërarchie FHS         |   `man hier `|
| Bekijken toevoegingen op zelfde moment "volgen/follow"          |   `tail -f file.txt `|
| Tonen type commando          |   `type cat`|
| Tonen alle types commando (builtin heeft voorrang op external)       |   `type -a echo`|
| Creeëren alias          |   `alias l=ls `|
| Opvragen gemaakte aliassen           |   `alias l ll dog `|
| Verwijderen alias          |   `unalias l `|
| Commando in achtergrond draaien `&`          |   ` sleep 20 &`|
| Echo it worked when touch test42 works, and echo it failed when the touch failed. |   `touch test42 && echo it worked || echo it failed `|
| Execute cd /var and ls in an embedded shell. (kan ook met backtick ` ` |   `echo $(cd /var ; ls) `|
| Herhaal laatst gebruikte commando (bang bang)          |   ` !!`|
| Herhaal laatst gebruikte commando beginnend met deze karakters          |   `!tou `|
| Herhaal laatst gebruikte commando via lijnnummer vanuit history          |   `!42 `|
| Toon 5 laatst gebruikte commandos          |   `history 5 `|
| Vergelijk kolommen (links: alleen in 1e doc, midden= alleen in 2e doc, rechts: in allebei) |   `comm p188   `|
| Toon inhoud bestand in octalen          |   `od text.txt `|
| Toon ingelogde gebruikers op dit systeem          |   `who `|
| Put a sorted list of all bash users in bashusers.txt          |   `grep bash /etc/passwd | cut -d: -f1 | sort > bashusers.txt `|
| Make a list of all filenames in /etc that contain the string conf in their filename          |   `ls /etc | grep conf `|
| Find files of type file (not directory, pipe or etc.) that end in .conf          |   `find . -type f -name "*.conf" `|
| Kalender tonen          |   `cal 12 2016 `|
| Duur tonen van een commando          |   `time sleep 2 `|
| locate gebruikt updatedb om een bestand te zoeken in de index          |   `locate (en updatedb) `|
| Zoek woord dat eindigt op r          |   `grep "r$" text.txt `|
| Zoek woord dat begint met R          |   `grep "^R" text.txt `|
| Vervang 2 of 3 o's door een A          |   `sed 's/o\{2,3\}/A/' `|
| p224 **VIM**          |   ` `|
| p301 **gpasswd**          |   ` `|
| Out- en ErrStream schrijven naar een bestand          |   `find / > allfiles_and_errors.txt 2>&1 `|
| Behouden originele timestamp en permissies          |   `cp -p file1 dir `|
| Display the umask in octal and in symbolic form.       |   `umask; umask -S`|
| Set the umask to 077 (symbolic) | `umask -S u=rwx,go=` | 

```
[student@localhost ~]$ echo "\n"
\n
[student@localhost ~]$ echo -e "\n"
```

The ampersand is used to double the occurence of the found string
```
echo Sunday | sed 's/Sun/&&/'
SunSunday
echo Sunday | sed 's/day/&&/'
Sundayday
```

De 3de `o` is optioneel dankzij de `\?`
```
paul@debian7:~$ cat list2 | sed 's/ooo\?/A/'
ll
lol
lAl
lAl
```
**Op te letten:**

- Combineer `type`met `which`
- usermod: eerst groep, dan pas user
- Tonen != toon inhoud
- `mv some_file foo` : hernoemt bestand 
- `mv some_file foo/` : verplaatst bestand     
[Uitleg](http://unix.stackexchange.com/questions/50499/when-should-i-use-a-trailing-slash-on-a-directory)
- `echo *` toont alle bestanden, toont `*` als het leeg is en als je alleen dit teken wilt: `echo \*` of `echo '*'`

- shebang: `#! /bin/bash` -> **/**bin/bash
- `[` is een apart commando (bij if), zet er spaties naast/tussen.
- `home/dir/` -> laatste `/` kan cruciaal zijn! -> eerste / bij /home is niet nodig
- Delimiter awk: -F 
- Delimiter cut: -d
- `setUID/setGID/stickyBit` => `chmod 1777 file` (sticky bit activeren, of `+t`)
- Sticky bit= alleen eigenaar mag dit bestand verwijderen (commando: +t octaal: 1)
- SetGID= eigenaar directory wordt automatisch eigenaar van alle onderliggende bestanden (commando:g+s octaal: 2)
- SetUID= executable bestand wordt uitgevoerd met rechten eigenaar (commando: u+s octaal: 4)
- Is there another command besides cd to change directories ? -> pushd en popd
- `cat < text.txt`= toon de inhoud van text.txt op het scherm
- `grep x text.txt` == `cat text.txt | grep x`
- `grep -A1 x text.txt`= toon ook de volgende lijn van de gevonden string (idem dito bij `B1`)
- Niet altijd een delimiter (-F) nodig bij awk.
- Bij `awk`: `"`niet altijd direct sluiten, kan doorheen hele printf. (ook: eerst `'`, dan `"`)
- `su -` wijzigt de environment en je gaat automatisch naar de homedirectory van die gebruiker
- `usermod -L user`: Locking will prevent the user from logging on to the system with his password by putting a ! in front of the password in /etc/shadow.
- `passwd -d user` : Disabling with passwd will erase the password from /etc/shadow.
- Aanpassen umask -> chmod
- Eigenaar zonder lees-, schrijf- of execute-rechten kan nog altijd het bestand verwijderen en de bestandspermissies aanpassen.
- Anderen kunnen bestand verwijderen als ze schrijf- en execute-rechten hebben voor de **directory waar het bestand in zit** (setUID en setGID maakt niet uit), het gaat niet als sticky bit aanstaat!
- Geen write- en execute-rechten voor het bestand, wel (groep) voor de parent directory -> andere gebruiker mag bestanden in die map verwijderen (ook: sticky bit staat niet aan).
- Sticky bit geldt voor nieuwe bestanden!
- Niemand buiten root en eigenaar kan de bestandspermissies van een bestand/directory aanpassen.
- Ownership (chown) != permissions (setUID)

```
[student@localhost testdir]$ cat > test.txt << stop
> hallo
> dit
> is
> stop
```

```
[root@localhost srv]# ls -l
total 8
drwxr-xr-x. 4 root root 4096 18 dec 17:34 groep
drwxrwxrwx. 2 root root 4096 18 dec 17:55 test
[root@localhost srv]#cd test | ls -l
-rw-r--r--. 1 root root 0 18 dec 17:55 bestand

[root@localhost test]# su - alice
[alice@localhost ~]$ cd /srv/ | ls
groep  test
[alice@localhost srv]$ cd test/
[alice@localhost test]$ rm bestand
rm: remove write-protected regular empty file 'bestand'? y
[alice@localhost test]$ ls -l
total 0
```


**Todo:**


* Indelen Extra per hoofdstuk

* 2>&1 uitproberen

* `sed '/[,.]/d` testen

* `cat bestand.txt | tr '[a-z]' '[A-Z]' > newBestand.txt` testen

* Testen: ! aangevuld met enkele letters van een recent commando

* Ctrl-r en een deel van een recent commando

* groupmod (veranderen naam group)

* ln (-s), ls -d, < nog eens uitproberen

* Delimiter cut en awk voor ":" (of "" nodig is)

**Done:**

* Andere documentatie -> H2 -> usr/share/doc

* Uittesten {y} en (y) -> H3 -> Is goed, pas wel op voor verschillende keyboard layout (4= "1/4" ipv "{")!

* Oef 3 werken met doorlopende tekst: Sorteer op het aantal voorkomens en behoud de alfabetische sortering van de woorden -> H3
