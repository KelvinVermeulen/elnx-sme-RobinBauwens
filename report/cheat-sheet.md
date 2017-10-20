# Cheat sheets and checklists

- Student name: Robin Bauwens
- [Github repo](https://github.com/HoGentTIN/elnx-sme-RobinBauwens)

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

## 1. Checklist physical layer

- Ben je op de juiste VM bezig?
- Zitten alle kabels in (VirtualBox: Network -> Adapter x -> Cable Connected/ Enable Network Adapter checkboxes)
- Juiste interfaces (NAT/Host-Only Adapter)

## 2. Checklist data link layer

- Draaien de services?
- Draaien de services op de juiste poorten (80 in plaats van 8080 voor HTTP en 443 voor HTPPS)
- Worden de services toegelaten door de firewall?

## 3. Checklist netwerk layer

`IP-adressering & Subnetmask`, `DNS` en `Default gateway` -> `Routing`

- Staan alle IP-adressen en subnetmasks correct (todo: aan te vullen met VirtualBox adapters: DG, IP-adressen etc.)
- Staat de default gateway voor de netwerkinterface juist? + pingen
- Staat de DNS-server voor de netwerkinterface juist?

```

ip a
ip r
/etc/resolv.conf

```


Configbestanden:

`/etc/sysconfig/network-scripts/ifcfg-*interface*`
- enp0s3
- enp0s8

## 4. Checklist transport layer

`Firewall`, `Poorten` en `Services op poorten`

- Traceroute

```

sudo systemctl status *service*
sudo systemctl start *service*
sudo systemctl enable *service*

sudo ss -tulpn
sudo firewall-cmd --list-all
sudo firewall-cmd --add-service=*service* --permanent
sudo firewall-cmd --add-port=*port*/tcp --permanent
sudo systemctl restart firewalld

```


Configbestanden:

`/etc/services`

## 5., 6. & 7.  Checklist presentation, application & session layer

`Configuratie`

- SSH


```

sudo journalctl -f -u *service*
sudo systemctl restart *service*
-> Open een nieuwe terminal voor ieder commando om veranderingen te zien

sudo tail -f /var/log/httpd/error_log

```

### Configbestanden

`/etc/httpd/httpd.d`

**Syntax checker Apache**: `apachectl configtest`

*Vergeet ook niet om service te herstarten!*

## SELinux

- `sudo resolvecon -R .` indien je een nieuw bestand aanmaakt in een andere directory (permissies worden niet aangepast bij `mv`)

## VirtualBox configuraties

- NAT-interface: `10.0.2.15/8`
- Host-only interface: `192.168.56.X`


## NetworkManager

```

dig www.hogent.be @a.b.c.d +short

```


TODO: 
- Aan te vullen met hoe op te lossen, welke commando's te controleren
- Notities vrijdag 13/10/17 (les troubleshooting)



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




