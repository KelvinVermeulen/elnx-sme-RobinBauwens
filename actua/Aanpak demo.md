# Aanpak demo

23/01/18 09:00

1. Ga naar `C:\Users\TEMP\Documents\GitHub\School - huidig\elnx-sme-RobinBauwens` binnen Git Bash en voer `vagrant up` uit (het kan zijn dat je dit commando tweemaal moet uitvoeren omwille van de router).
2. Start, **nadat alles staat**, `ws001` op; dit doen we pas later aangezien deze (virtuele) computer nog (dynamische) IP-adressen moet toegewezen krijgen.
3. Ga naar `C:\Users\TEMP\Documents\GitHub\School - huidig\elnx-sme-RobinBauwens\actua` en voer volgende commando's uit:

```
vagrant destroy dockerhost
vagrant up dockerhost --provision
vagrant ssh
```
4. Hierna starten we de verschillende containers op:
    - Het eerst commando start een single `httpd` (Apache) webcontainer op waarbij poort 80 van de host gebruikt zal worden voor poort 80 van de webcontainer. Deze container bevat enkel de default-website "It works!"/. *Deze staat default al op poort 80 maar we gaan dit nog eens specifiek meegeven.*
    - We gaan, naast de defaultpagina, een nieuw HTML-project toevoegen. Hiervoor gaan we de directory `public-html` die alle HTML, CSS en andere code bevat voor de intranet-website verplaatsen naar `/actua/dockerhost-sandbox`.

```
sudo docker run -td --name webserver -p 80:80 httpd
cd /vagrant
sudo docker cp public-html/. webserver:usr/local/apache2/htdocs/public-html
```

5. Surf naar volgende websites:
    - http://172.16.0.10:80
    - http://172.16.0.10/public-html/
    - https://172.16.0.10:9090/
6. We kunnen nu zien dat er een container `webserver` aan het draaien is op poort 80. We gebruiken dus niet het IP-adres maar wel de poort van de host (hier: de VM `inside.avalon.lan`). Het IP-adres ligt ook in een ander netwerksegment (`172.16.0.0/16` en `172.17.0.0/16`).
7. Laat de pagina met "Containers" openstaan. Nu gaan we verder met meerdere containers (mutli-container applications met `docker-compose`).

```
docker images
docker ps
docker port dockeractualiteit_proxy_1
```



