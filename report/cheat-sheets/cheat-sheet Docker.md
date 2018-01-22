# Cheat-sheet Docker

### Algemeen
**Voer telkens onderstaande commando's uit met `sudo` (tenzij je de VM provisioning hebt uitgevoerd, zie `dockerhost.sh`)**

```
sudo docker ps
sudo docker images
sudo docker network ls
sudo docker network inspect <id>
sudo docker port <container-name>
sudo docker stop <container-name>
sudo docker rm <container-id>
sudo docker rm <id>

Commando's uitvoeren in container:
sudo docker exec -it <container-name> /bin/bash
```

### Single container
Uitvoeren van Docker image zonder `Dockerfile`:

Poorten: Host:Container
```
sudo docker run -td --name webserver -p 80:80 httpd
```

Als de container hapert:
```
sudo docker stop webserver
sudo docker rm webserver
```

Verplaatsen van bestanden naar Docker container:
```
sudo docker cp public-html/. webserver:usr/local/apache2/htdocs/public-html
```


### Multiple containers:
**Voer ofwel `scale` ofwel `up` uit, niet beide!**

```
sudo docker-compose build
sudo docker-compose scale web=5 proxy=1

Ofwel:

sudo docker-compose build
sudo docker-compose up -d
```

Als de containers haperen:
```
sudo docker-compose stop
```

### Apache Benchmark
```
sudo dnf install httpd-tools
ab -n 5000 -c 10 http://172.16.0.10/        Let op "/"!
```


## Bronnen

- [Apache Benchmark + Docker-compose HA-proxy](https://blog.hypriot.com/post/docker-compose-nodejs-haproxy/)
- [docker-compose up -d](https://www.linux.com/learn/introduction-docker-compose-tool-multi-container-applications)
- [Install Apache Benchmark](https://serverfault.com/questions/514401/how-to-install-apache-benchmark-on-centos)
- [Docker scale](https://docs.docker.com/v17.09/compose/reference/scale/)
- [Docker httpd](https://hub.docker.com/_/httpd/)
- [Best practices](https://docs.docker.com/engine/userguide/eng-image/dockerfile_best-practices/#add-or-copy)
- [Kopiëren bestanden naar Docker container (ipv via Dockerfile te werken)](https://stackoverflow.com/questions/22907231/copying-files-from-host-to-docker-container)
