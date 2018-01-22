# Aanpak demo

23/01/18 09:00

1. Voer volgende commando's uit, binnen Git Bash, om de SME-infrastructuur op te zetten. *Het kan zijn dat je dit commando tweemaal moet uitvoeren omwille van de router.*
```
cd "C:\Users\TEMP\Documents\GitHub\School - huidig\elnx-sme-RobinBauwens"  vagrant up
```
2. Start, **nadat alles staat**, `ws001` op (via VirtualBox met GUI); dit doen we pas later aangezien deze (virtuele) computer nog (dynamische) IP-adressen moet toegewezen krijgen.
3. Voer hierna volgende commando's uit om de VM's te vernietigen en opnieuw op te zetten:
```
cd "/c/Users/TEMP/Documents/GitHub/School - huidig/elnx-sme-RobinBauwens/actua/dockerhost-sandbox"
vagrant destroy dockerhost
vagrant up dockerhost --provision
vagrant ssh
```
4. Hierna starten we een webcontainer op:
    - Het eerst commando start een single `httpd` (Apache) webcontainer op waarbij poort 80 van de host gebruikt zal worden voor poort 80 van de webcontainer. Deze container bevat enkel de default-website "It works!"/. *Deze staat default al op poort 80 maar we gaan dit nog eens specifiek meegeven.*
    - We gaan, naast de defaultpagina, een nieuw HTML-project toevoegen. Hiervoor gaan we de directory `public-html` die alle HTML, CSS en andere code bevat voor de intranet-website verplaatsen naar `/actua/dockerhost-sandbox`. Het derde commando zal dan deze directory kopiëren naar de webcontainer.

```
sudo docker run -td --name webserver -p 80:80 httpd
cd /vagrant
sudo docker cp public-html/. webserver:usr/local/apache2/htdocs/public-html
```
5. Surf naar volgende websites (`172.16.0.10` kan je vervangen door `inside.avalon.lan`):
    - http://172.16.0.10:80
    - http://172.16.0.10/public-html/
    - https://172.16.0.10:9090/
6. We kunnen nu zien dat er een container `webserver` aan het draaien is op poort 80. We gebruiken dus niet het IP-adres maar wel de poort van de host (hier: de VM `inside.avalon.lan`). Het IP-adres ligt ook in een ander netwerksegment (`172.16.0.0/16` en `172.17.0.0/16`).
7. Laat de pagina met "Containers" openstaan. Nu gaan we verder met meerdere containers (multi-container applications met `docker-compose`). Voer volgende commando's uit:
```
cd /vagrant/provisioning/files/docker-actualiteit
sudo docker-compose build
sudo docker-compose up -d

sudo docker-compose stop
sudo docker-compose scale web=5 proxy=1
```
8. Surf naar volgende website:
    - http://172.16.0.10:8000/

9. Hierna kunnen we Apache Benchmark downloaden en uitvoeren om beide soorten (1 container en meerdere containers) te testen:
```
sudo dnf install -y httpd-tools
ab -n 5000 -c 10 http://172.16.0.10:80/        
ab -n 5000 -c 10 http://172.16.0.10:8000/      
```
10. Open `webserver`-container in Cockpit en bekijk het requests-venster (logs) van `webserver`, voer hierna volgend commando uit:
```
ab -n 1000 -c 10 http://172.16.0.10:80/
```

```
docker images
docker ps
docker port webserver
docker port dockeractualiteit_proxy_1
docker stats
docker logs webserver       (idem als log-venster van Cockpit/Dashboard)
```

## Samenvatting poorten
- http://172.16.0.10:80/ = Default website Docker Apache `httpd`
- http://172.16.0.10:9090/ = Cockpit/Dashboard
- http://172.16.0.10/public-html/ = Custom HTML-project
- http://172.16.0.10:8000/ = Meerdere `Nginx` webcontainers

Tijd om alles op te zetten: ongeveer 12 min 20 seconden.

Doel = isoleren van processen (hier: webprocessen en deze integreren in de SME-opdracht)

1 proces per container.
`FROM`=parentimage, dockerfiles builden maakt een image-tree en dit maakt de containers.

Container is block bovenop OS, Windows moet bvb een VM genaamd `boot2docker` aanmaken om Docker-containers te kunnen uitvoeren.

Docker-compose is voor multi-container Docker applicaties.