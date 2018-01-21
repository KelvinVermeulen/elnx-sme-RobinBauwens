# Cheat-sheet Docker

**Voer telkens onderstaande commando's uit met `sudo`**
```
Algemeen:

docker ps
docker images
docker network ls
docker network inspect <id>
sudo docker port <container-name>
sudo docker stop <container-name>
sudo docker rm <container-id>
sudo docker rm <id>

Commando's uitvoeren in container:

sudo docker exec -it <container-name> /bin/bash

Installatie Apache Benchmark:

sudo dnf install httpd-tools
ab -n 5000 -c 10 http://172.16.0.10/        Let op "/"!


Single container:

sudo docker run -td --name webserver -p 80:80 httpd

Multiple containers:


```

## Bronnen

- [Apache Benchmark + Docker-compose HA-proxy](https://blog.hypriot.com/post/docker-compose-nodejs-haproxy/)