# Cheat-sheet Docker

**Voer telkens onderstaande commando's uit met `sudo`**
```

sudo docker run -td --name webserver -p 80:80 httpd

docker ps
docker images
docker network ls
docker network inspect <id>
sudo docker port <container-name>
sudo docker rm <id>

Commando's uitvoeren in container:
sudo docker exec -it <container-name> /bin/bash
```