# Cheat sheets and checklists

- Student name: Robin Bauwens
- [Github repo](https://github.com/HoGentTIN/elnx-sme-RobinBauwens)
<!--
## Basic commands


| Task                | Command |
| :---                | :---    |
| Query IP-adress(es) | `ip a`  |


## Git workflow


Simple workflow for a personal project without other contributors:

| Task                                         | Command                   |
| :---                                         | :---                      |
| Current project status                       | `git status`              |
| Select files to be committed                 | `git add FILE...`         |
| Commit changes to local repository           | `git commit -m 'MESSAGE'` |
| Push local changes to remote repository      | `git push`                |
| Pull changes from remote repository to local | `git pull`                |
-->

## TCP/IP

## 1. Checklist network access (physical + data link) layer

- Ben je op de juiste VM bezig?
- Zitten alle **kabels** in (VirtualBox: Network -> Adapter x -> Cable Connected/Enable Network Adapter checkboxes)?
- Juiste interfaces (NAT & Host-Only Adapter)?


```
ip link
```


## 2. Checklist internet layer

`IP-adressering & Subnetmask`, `Default gateway` en `DNS`

- Staan alle IP-adressen en subnetmasks correct?
- Staat de default gateway voor de netwerkinterface juist? + pingen naar DG
- Staat de DNS-server voor de netwerkinterface juist?


Virtualbox:
* NAT: `10.0.2.15/8`
* Host-Only: `192.168.56.101` - ` 192.168.56.254/24`

* DG: `10.0.2.2`
* DNS: `10.0.2.3`

```
ip address
ip route
route -n

cat /etc/sysconfig/network-scripts/ifcfg-IFACE
cat /etc/resolv.conf
```


### Extra:

- Kan je de DG bereiken (via ping)?
- Kan je de DNS-server bereiken?

 ```
 dig
 nslookup
 host
 ```
 
### Kan je andere hosts binnen het LAN bereiken?

- enp0s3
- enp0s8


## 3. Checklist transport layer

`Firewall`, `Poorten` en `Services op poorten`

- Draaien de services?
- Draaien de services op de juiste poorten (80 in plaats van 8080 voor HTTP en 443 voor HTTPS)?
- Worden de services toegelaten door de firewall?


```
sudo systemctl status SERVICE
sudo ss -tulpn
sudo ps -ef


cat /etc/services
```

<!-- - Traceroute -->

```
sudo systemctl status httpd.service
sudo systemctl start httpd.service
sudo systemctl enable httpd.service

sudo firewall-cmd --list-all
sudo firewall-cmd --add-service=httpd.service --permanent
sudo firewall-cmd --add-port=80/tcp --permanent
sudo systemctl restart firewalld

cat /var/log/messages    (hoofdlog)

sudo iptables -L -n -v
```
<!---
#### Van buitenaf

```
nmap -A -T4
namp -sS -sU
```
-->

## 4. Checklist application layer

`Configuratie`

*Vergeet ook niet om service te herstarten!*

```
sudo journalctl -f -u httpd.service
sudo systemctl restart httpd.service
-> Open een nieuwe terminal voor ieder commando om veranderingen te zien

sudo tail -f /var/log/httpd/error_log

cat /etc/httpd/httpd.d
```

- Web: `apachectl configtest`
- Fileserver: `testparm`
- DNS: `named-checkconf`
- DNS: `named-checkzone`


## SELinux

**Indien je een nieuw bestand aanmaakt in een andere directory (permissies worden niet aangepast bij `mv`)**

``` 
sudo resolvecon -R .

cat /var/log/audit/audit.log
```

## Logfiles

```
cat /var/log/messages
cat /var/log/audit/audit.log
cat /var/log/httpd/error_log
cat /var/log/samba/*
cat /var/log/vsftpd/*
```

## VirtualBox configuraties

- NAT-interface: `10.0.2.15/8`
- Host-only interface: `192.168.56.X`


## NetworkManager

```

dig www.hogent.be @a.b.c.d +short

```

## Tips

### No route to host:

- Internetlaag
- Probleem met IP-configuratie

### Connection refused

- Transportlaag
- Service draait niet, firewall, etc.

### Unable to resolve host

- Internet-/applicatielaag
- DNS-server niet beschikbaar

### Error 404

- Applicatielaag
- URL verkeerd, Apache configuratie



TODO: 
- Aan te vullen met hoe op te lossen, welke commando's te controleren
- Notities vrijdag 13/10/17 (les troubleshooting)
- Connectie met hostsysteem


## Bereikbaarheid

`sudo nmap -sS -p 80,443 192.0.2.50` *te testen*
`wget 192.0.2.50/wordpress`

## Checklist network configuration

1. Is the IP-adress correct? `ip a`
2. Is the router/default gateway correct? `ip r -n`
3. Is a DNS-server available? `cat /etc/resolv.conf`

- Role name: bind, service: named -> DNS   `/etc/named.conf`


## Bronnen

- [Zaken op te letten](https://everythingsysadmin.com/dumb-things-to-check.html)
- [Screencast troubleshooting](https://www.youtube.com/watch?v=ciXpmDwJKOM&feature=youtu.be)



