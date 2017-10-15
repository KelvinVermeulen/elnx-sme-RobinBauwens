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

- Staan alle IP-adressen en subnetmasks correct (todo: aan te vullen met VirtualBox adapters: DG, IP-adressen etc.)
- Staat de default gateway voor de netwerkinterface juist?
- Staat de DNS-server voor de netwerkinterface juist?

## 4. Checklist transport layer

- Traceroute

## 5. Checklist session layer

- SSH

## 6 & 7. Checklist presentation & application layer

- `/etc/resolv.conf`


## SELinux

- `sudo resolvecon -R .` indien je een nieuw bestand aanmaakt in een andere directory (permissies worden niet aangepast bij `mv`)


TODO: 
- Aan te vullen met hoe op te lossen, welke commando's te controleren
- Notities vrijdag 13/10/17 (les troubleshooting)

## Checklist network configuration

1. Is the IP-adress correct? `ip a`
2. Is the router/default gateway correct? `ip r -n`
3. Is a DNS-server available? `cat /etc/resolv.conf`


## Bronnen

- [Zaken op te letten](https://everythingsysadmin.com/dumb-things-to-check.html)




