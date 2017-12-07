# Enterprise Linux Lab Report - Troubleshooting

- Student name: Robin Bauwens
- Class/group: TIN-TI-3B (Gent)

## Instructions

- Write a detailed report in the "Report" section below (in Dutch or English)
- Use correct Markdown! Use fenced code blocks for commands and their output, terminal transcripts, ...
- The different phases in the bottom-up troubleshooting process are described in their own subsections (heading of level 3, i.e. starting with `###`) with the name of the phase as title.
- Every step is described in detail:
    - describe what is being tested
    - give the command, including options and arguments, needed to execute the test, or the absolute path to the configuration file to be verified
    - give the expected output of the command or content of the configuration file (only the relevant parts are sufficient!)
    - if the actual output is different from the one expected, explain the cause and describe how you fixed this by giving the exact commands or necessary changes to configuration files
- In the section "End result", describe the final state of the service:
    - copy/paste a transcript of running the acceptance tests
    - describe the result of accessing the service from the host system
    - describe any error messages that still remain

Om "problemen" met de toetsenbordindeling te vermijden gebruik dan één van volgende commando's (werkt enkel indien `ssh` toegelaten wordt op poort 22):
-  `vagrant ssh <machinenaam>`
-  `ssh <ip-adres> -l vagrant`

**Opmerking:** `dig` werd ook geïnstalleerd op het hostsysteem om DNS-queries te kunnen sturen naar de VM (om de DNS-functionaliteit te testen).

Naamgeving:
- `BIND`: DNS Server in Red Hat ELNX
- `named`: DNS-service
- `DNS`: aka `nameserver`

## Report

### Phase 1: Link Layer (TCP/IP)

#### Controleren van netwerkhardware (kabels/poorten)
De kabels moeten aangesloten zijn (en de juiste netwerkadapters gebruikt worden). Meestal 1 NAT en 1 Host-Only adapter (let hierbij op voor `Name` en nummer van Ethernet Adapter).

Met volgend commando controleren we of de kabels insteken en werken (verbonden interfaces), de stroom aanstaat, etc.

`ip link`

We verwachten dat `enp0s3` (NAT) en `enp0s8` (Host-Only adapter) (en `lo`) aanstaan (niet exacte output, minder relevante informatie weggelaten):

```
1: lo: <LOOPBACK,UP,LOWER_UP> ...
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> ... state UP ...
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> ... state UP ...
```

De output die gegenereerd wordt is als volgt:

```

```

*Resultaat*: De instellingen zijn ..., alle interfaces hebben state UP.


Hiernaast controleren we ook of de instellingen in VirtualBox correct zijn:. Dit controleren we manueel in VirtualBox zelf bij `Preferences` -> `Network`.

*Resultaat:*

### Phase 2: Internet/Network Layer (TCP/IP)

In deze laag controleren we volgende zaken:

- IP-adres & subnetmask
- Default gateway
- DNS-server

#### IP-adressen en subnetmasks 

Zorg er eerst voor dat het IP-adres van je hostmachine in hetzelfde subnet ligt als die van de VM.
Het IP-adres van `enp0s8` dient `192.168.56.42` te zijn (dit is VirtualBox Host-Only Ethernet Adapter #3 bij mijn instellingen).

Zorg er ook voor dat de firewall van je systeem (hier: Windows Firewall) Echoaanvragen (ICMP) toelaat.

Via `ip address` testen we de configuratie (ook hier zijn delen weggelaten).
We verwachten volgende uitvoer:

```
ip address
1: lo: <LOOPBACK,UP,LOWER_UP> 
   inet 127.0.0.1/8 scope host lo
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> state UP 
    inet 10.0.2.15/24 brd 10.0.2.255 scope global dynamic enp0s3
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> state UP 
    inet 192.168.56.42/24 brd 192.168.56.255 scope global enp0s8
```

Indien hier zaken ontbreken/afwijken, kunnen we deze wijzigen in `/etc/sysconfig/network-scripts/ifcfg-IFACE` (met IFACE: `enp0s3` of `enp0s8`) met een teksteditor zoals `vi`. Vergeet ook niet om `network.service` te herstarten met `sudo systemctl restart network.service`.

De output die gegenereerd wordt is als volgt:

```

```
*Resultaat:* 

<!--
Het aanpassen van de netwerkconfiguratie hoeft niet aangezien we de juiste instellingen toegekregen krijgen.
-> `enp0s8` heeft als IP-adres `192.168.56.42/24` (via Vagrant) en `enp0s3` heeft `10.0.2.15/24`. Dit is in orde.
-->

#### Default gateway
Via `ip route` kunnen we dit nagaan.
We verwachten volgende uitvoer:

```
ip route
default via 10.0.2.2 dev enp0s3 proto static metric 100
10.0.2.0/24 dev enp0s3 proto kernel scope link src 10.0.2.15 metric 100
192.168.56.0/24 dev enp0s8 proto kernel scope link src 192.168.56.42 metric 100
```

Indien hier zaken ontbreken/afwijken, kunnen we dit toevoegen met `ip route add default via 10.0.2.2` en verwijderen met `ip route delete 192.168.56.0/24 dev enp0s8`.

De output die gegenereerd wordt is als volgt:

```

```

*Resultaat*:

<!--
We stellen vast dat er een entry teveel in de config van `ip route` staat, we verwijderen deze met volgend commando:

```
[vagrant@nginx network-scripts]$ ip r
default via 10.0.2.2 dev enp0s3  proto static  metric 100
10.0.2.0/24 dev enp0s3  proto kernel  scope link  src 10.0.2.15  metric 100
169.254.0.0/16 dev enp0s8  scope link  metric 1003
192.168.56.0/24 dev enp0s8  proto kernel  scope link  src 192.168.56.42
[vagrant@nginx network-scripts]$ sudo ip route delete 169.254.0.0/16 dev enp0s8
[vagrant@nginx network-scripts]$ ip route
default via 10.0.2.2 dev enp0s3  proto static  metric 100
10.0.2.0/24 dev enp0s3  proto kernel  scope link  src 10.0.2.15  metric 100
192.168.56.0/24 dev enp0s8  proto kernel  scope link  src 192.168.56.42
```
-->

Hierna herstarten we beide netwerkservices met `sudo systemctl restart network.service` en `sudo systemctl restart NetworkManager.service` om zeker te zijn dat de netwerkinstellingen correct zijn.

De routeringsinstellingen zijn nu correct.

#### DNS-server
Via `cat /etc/resolv.conf` kunnen we dit nagaan.
We verwachten (ongeveer) volgende uitvoer: `nameserver 10.0.2.3` moet zeker aanwezig zijn aangezien dit een VM is met VirtualBox (met NAT):

```
cat /etc/resolv.conf
# Generated by NetworkManager
search home
nameserver 10.0.2.3
options single-request-reopen
```

We gaan in dit bestand geen aanpassingen maken.

<!--
Vergeet ook hier `network.service` niet eens te herstarten! 
-->

De output die gegenereerd wordt is als volgt:

```

```

*Resultaat*:

<!--
We zien dat de nameserver correct ingesteld is, hier hoeven we dus niets aan te passen.
-->

#### LAN-connectiviteit nagaan

Indien vorige stappen opgelost/correct geconfigureerd zijn, dan kunnen we de default gateway en een andere host op het LAN pingen. Hiernaast zou DNS name resolution ook geen problemen mogen geven.

Volgende commando's zouden dus probleemloze uitvoer moeten geven (indien pings toegelaten zijn en `dig` geïnstalleerd is op de VM):

```
dig www.google.com @10.0.2.3 +short             Gebruik DNS-server van VirtualBox
ping www.google.com
```

**Opmerking:** `dig` staat niet geïnstalleerd en pings worden niet doorgelaten op het schoolnetwerk. We zullen de internetconnectie testen door `bind-utils` te installeren.

```
sudo yum install bind-utils
```

We pingen eens naar de hostmachine (bekijk IP-adres in Windows via `ipconfig`) en naar de DG/DNS-server (van VirtualBox):
```
ping xxx.xxx.xxx.xxx
ping 10.0.2.2
ping 10.0.2.3
```

Ook dit lukt naar de andere kant (Host naar VM; vanuit `cmd` van Windows):
```
ping 192.168.56.42
```

### Phase 3: Transport Layer (TCP/IP)

In deze laag controleren we volgende zaken:

#### Draaien de services?

----
**Opmerking: Alvorens de service op te starten:**

Het kan zijn dat er configuratieproblemen zijn, dit dienen we te controleren in de applicatielaag alhoewel er ook nu al naar verwezen kan worden (zie p34 `syllabus-elnx.pdf`: 3.7.2 DNS troubleshooting).

- Gebruik `sudo named-checkconf /etc/named.conf` om de configuratie van de DNS-server na te gaan. Als er geen fouten zijn in de configuratie, dan zal de uitvoer leeg zijn.

De output die gegenereerd wordt is als volgt:

```

```

*Resultaat*:

- Gebruik volgende commando's (met andere argumenten; op de master DNS-server) om de zonebestanden te controleren. We verwachten volgende uitvoer (voor andere configuratie):

```
$ sudo named-checkzone avalon.lan /var/named/avalon.lan
zone avalon.lan/IN: loaded serial 17102010
OK

[vagrant@pu001 ~]$ sudo named-checkzone 16.172.in-addr.arpa /var/named/16.172.in-addr.arpa
zone 16.172.in-addr.arpa/IN: loaded serial 17102010
OK
```

De output die gegenereerd wordt is als volgt:

```

```

*Resultaat*:


- Foutboodschappen bekijken:

```
$ sudo rndc querylog on
$ sudo journalctl -l -f -u named.service
```

Hiernaast is het ook handig om `bind-tools` te installeren (dit vond normaal al plaats in de vorige laag): `sudo yum install bind-tools` Enkele commando's om de DNS-server te testen:

```
nslookup www.hogent.be                          IP-adres van www.hogent.be
nslookup www.hogent.be 8.8.8.8                  Met specifieke DNS-server

dig www.hogent.be                               Zoals nslookup, met meer informatie
dig +short www.hogent.be                        Samengevat
dig +short @8.8.8.8 www.hogent.be               Samengevat, met specifieke DNS-server

dig +short NS hogent.be                         Authorative name server voor hogent.be
dig +short AAAA download.fedoraproject.org      IPv6 adres van download.fedoraproject.org

dig +short -x 195.130.131.1                     Reverse lookup
---
$ nslookup www.hogent.be
Server: 195.130.131.1                           Server die antwoordt
Address: 195.130.131.1\#53

Non-authoritative answer:                       Non-authorative: deze server is niet verantwoordelijk voor hogent.be-domein
Name: www.hogent.be                             Server die overeenkomt met www.hogent.be
Address: 178.62.144.90                          

```

Indien `bind-utils` niet geïnstalleerd is, gebruik dan onderstaand commando:

```
$ getent ahosts www.google.com
216.58.208.228  STREAM www.google.com
216.58.208.228  DGRAM
216.58.208.228  RAW
2a00:1450:4007:80e::2004 STREAM
2a00:1450:4007:80e::2004 DGRAM
2a00:1450:4007:80e::2004 RAW
```
----

We verwachten volgende uitvoer (dit wijkt sowieso deels af van de werkelijkheid, wat belangrijk is, is dat de state op active-running staat):

```
[vagrant@DNSServer etc]$ sudo systemctl status named
● named.service - Berkeley Internet Name Domain (DNS)
   Loaded: loaded (/usr/lib/systemd/system/named.service; enabled; vendor preset: disabled)
   Active: active (running) since Sun 2017-12-03 20:01:43 UTC; 24min ago
  Process: 1145 ExecStart=/usr/sbin/named -u named -c ${NAMEDCONF} $OPTIONS (code=exited, sta
tus=0/SUCCESS)
  Process: 1131 ExecStartPre=/bin/bash -c if [ ! "$DISABLE_ZONE_CHECKING" == "yes" ]; then /u
sr/sbin/named-checkconf -z "$NAMEDCONF"; else echo "Checking of zone files is disabled"; fi (
code=exited, status=0/SUCCESS)
 Main PID: 1152 (named)
   CGroup: /system.slice/named.service
           └─1152 /usr/sbin/named -u named -c /etc/named.conf
```

Indien hier de service niet draait, kunnen we dit aanpassen met `sudo systemctl start <service>` en `sudo systemctl enable <service>` (met `<service>` natuurlijk vervangen met een service (zoals `named`).


De output die gegenereerd wordt is als volgt:

```

```

*Resultaat*:



<!--
We stellen vast dat de service niet draait op de VM, we corrigeren dit met volgende commando's:
```
[vagrant@nginx network-scripts]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: inactive (dead)
[vagrant@nginx network-scripts]$ sudo systemctl start nginx
sJob for nginx.service failed because the control process exited with error code. See "systemctl status nginx.service" and "journalctl -xe" for details.
```

We merken op dat dit niet lukt, we gaan dus best de logbestanden bekijken van nginx. We krijgen volgende uitvoer:

```
[vagrant@nginx network-scripts]$ sudo journalctl -u nginx
-- Logs begin at vr 2017-10-27 07:32:55 UTC, end at vr 2017-10-27 07:52:00 UTC. --
okt 27 07:51:17 nginx systemd[1]: Starting The nginx HTTP and reverse proxy server...
okt 27 07:51:17 nginx nginx[3312]: nginx: [emerg] BIO_new_file("/etc/pki/tls/certs/nigxn.pem"
okt 27 07:51:17 nginx nginx[3312]: nginx: configuration file /etc/nginx/nginx.conf test faile
okt 27 07:51:17 nginx systemd[1]: nginx.service: control process exited, code=exited status=1
okt 27 07:51:17 nginx systemd[1]: Failed to start The nginx HTTP and reverse proxy server.
okt 27 07:51:17 nginx systemd[1]: Unit nginx.service entered failed state.
okt 27 07:51:17 nginx systemd[1]: nginx.service failed.
```

Er zijn blijkbaar fouten in de configuratiebestanden van de DNS-service `named`. Dit wordt pas later behandeld op de applicatielaag.
-->


#### Draaien de services op de juiste poorten (e.g. 53 of 953 voor DNS)?
We verwachten (ongeveer) volgende uitvoer (gefilterd op `named`):

```
[vagrant@DNSServer etc]$ sudo ss -tulpn | grep named
udp    UNCONN     0      0      192.0.2.10:53                    *:*                   users:(("named",pid=1152,fd=514))
udp    UNCONN     0      0      10.0.2.15:53                    *:*                   users:(("named",pid=1152,fd=513))
udp    UNCONN     0      0      127.0.0.1:53                    *:*                   users:(("named",pid=1152,fd=512))
udp    UNCONN     0      0       ::1:53                   :::*                   users:(("named",pid=1152,fd=515))
tcp    LISTEN     0      10     192.0.2.10:53                    *:*                   users:(("named",pid=1152,fd=23))
tcp    LISTEN     0      10     10.0.2.15:53                    *:*                   users:(("named",pid=1152,fd=22))
tcp    LISTEN     0      10     127.0.0.1:53                    *:*                   users:(("named",pid=1152,fd=21))
tcp    LISTEN     0      128    127.0.0.1:953                   *:*                   users:(("named",pid=1152,fd=25))
tcp    LISTEN     0      10      ::1:53                   :::*                   users:(("named",pid=1152,fd=24))
tcp    LISTEN     0      128     ::1:953                  :::*                   users:(("named",pid=1152,fd=26))
```

<!--
(Ook zou er een entry moeten zijn voor `:::443` voor nginx.)

**Opmerking: om ook HTTPS toe te laten, zetten we dit uit commentaar in `/etc/nginx/nginx.conf`.**


Dit is nog niet het geval, simpelweg omdat nginx nog niet draait omwille van configuratiefouten:
-->


De output die gegenereerd wordt is als volgt:

```

```

*Resultaat*:

#### Worden de services toegelaten door de firewall?
We verwachten (ongeveer) volgende uitvoer:

```
[vagrant@DNSServer etc]$ sudo firewall-cmd --list-all
public (active)
  target: default
  icmp-block-inversion: no
  interfaces: enp0s3 enp0s8
  sources:
  services: ssh dhcpv6-client dns
  ports:
  protocols:
  masquerade: no
  forward-ports:
  source-ports:
  icmp-blocks:
  rich rules:
```

Indien hier een service niet toegelaten is door de firewall, kunnen we volgende commando's gebruiken:
`sudo firewall-cmd --add-service=<service>.service --permanent`  en `sudo firewall-cmd --add-service=<service>.service`.

De output die gegenereerd wordt is als volgt:

```

```

*Resultaat*:


De zone dient ook `public` te zijn voor beide interfaces:

```
[vagrant@pu001 ~]$ sudo firewall-cmd --get-active-zones
public
  interfaces: enp0s3 enp0s8
```

De output die gegenereerd wordt is als volgt:

```

```

*Resultaat*:


Vergeet ook niet om de firewall eens te herstarten met `sudo systemctl restart firewalld`.

#### Bereikbaarheid via `nmap`
Om de bereikbaarheid te testen (vanaf een andere host) kan je volgende commando's gebruiken:

```
[vagrant@DNSSlave ~]$ sudo nmap -sS -p 53,953 192.168.56.42

Starting Nmap 6.40 ( http://nmap.org ) at 2017-12-07 18:55 UTC
Nmap scan report for 192.168.56.42
Host is up (-1500s latency).
PORT    STATE  SERVICE
53/tcp  open   domain
953/tcp closed rndc

Nmap done: 1 IP address (1 host up) scanned in 0.06 seconds
```

De output die gegenereerd wordt is als volgt:

```

```

*Resultaat*:

### Phase 4: Application Layer (TCP/IP)
#### Configuratie (BIND)
In de applicatielaag checken we vooral de configuratie(bestanden van de services).

TIP: open een nieuw terminalvenster en volg alle veranderingen van een service met `sudo journalctl -f -u SERVICE.service` of `sudo tail -f /var/log/httpd/error_log` voor `httpd`.

De logging van BIND gaat naar `var/log/messages` (verdwenen in Fedora).

We controleren eerst of`bind` en `bind-utils` geïnstalleerd zijn, `lwresd` hoeft niet geïnstalleerd te zijn:

```
yum list installed bind
yum info bind

yum list installed bind-utils
yum info bind-utils
```

We gaan de configuratie van BIND na met volgend commando.
We verwachten geen uitvoer bij dit commando:

```
sudo named-checkconf
```

De output die gegenereerd wordt is als volgt:

```

```

*Resultaat*:


TIP: De paden waar de (configuratie)bestanden van BIND zich bevinden zijn de volgende:

##### Paden:

<details> 
  <summary>Hoofdconfiguratie (adminrechten!) </summary>
    
```
[vagrant@DNSMaster etc]$ sudo cat /etc/named.conf
//
// named.conf
//
// Ansible managed
//
options {
  listen-on port 53 { any; };
  listen-on-v6 port 53 { ::1; };
  directory   "/var/named";
  dump-file   "/var/named/data/cache_dump.db";
  statistics-file "/var/named/data/named_stats.txt";
  memstatistics-file "/var/named/data/named_mem_stats.txt";
  allow-query     { any; };

  recursion no;

  rrset-order { order random; };

  dnssec-enable yes;
  dnssec-validation yes;
  dnssec-lookaside auto;

  /* Path to ISC DLV key */
  bindkeys-file "/etc/named.iscdlv.key";

  managed-keys-directory "/var/named/dynamic";

  pid-file "/run/named/named.pid";
  session-keyfile "/run/named/session.key";
};

logging {
  channel default_debug {
    file "data/named.run";
    severity dynamic;
    print-time yes;
  };
};

include "/etc/named.root.key";
include "/etc/named.rfc1912.zones";

zone "avalon.lan" IN {
  type master;
  file "avalon.lan";
  notify yes;
  allow-update { none; };
};

zone "2.0.192.in-addr.arpa" IN {
  type master;
  file "2.0.192.in-addr.arpa";
  notify yes;
  allow-update { none; };
};
zone "16.172.in-addr.arpa" IN {
  type master;
  file "16.172.in-addr.arpa";
  notify yes;
  allow-update { none; };
};
```

```
[vagrant@DNSSlave etc]$ sudo cat /etc/named.conf
//
// named.conf
//
// Ansible managed
//
options {
  listen-on port 53 { any; };
  listen-on-v6 port 53 { ::1; };
  directory   "/var/named";
  dump-file   "/var/named/data/cache_dump.db";
  statistics-file "/var/named/data/named_stats.txt";
  memstatistics-file "/var/named/data/named_mem_stats.txt";
  allow-query     { any; };

  recursion no;

  rrset-order { order random; };

  dnssec-enable yes;
  dnssec-validation yes;
  dnssec-lookaside auto;

  /* Path to ISC DLV key */
  bindkeys-file "/etc/named.iscdlv.key";

  managed-keys-directory "/var/named/dynamic";

  pid-file "/run/named/named.pid";
  session-keyfile "/run/named/session.key";
};

logging {
  channel default_debug {
    file "data/named.run";
    severity dynamic;
    print-time yes;
  };
};

include "/etc/named.root.key";
include "/etc/named.rfc1912.zones";

zone "avalon.lan" IN {
  type slave;
  masters { 192.0.2.10; };
  file "slaves/avalon.lan";
};

zone "2.0.192.in-addr.arpa" IN {
  type slave;
  masters { 192.0.2.10; };
  file "slaves/2.0.192.in-addr.arpa";
};
zone "16.172.in-addr.arpa" IN {
  type slave;
  masters { 192.0.2.10; };
  file "slaves/16.172.in-addr.arpa";
};
```
</details>

- `/etc/named.conf` als je `bind-chroot` hebt geïnstalleerd

<details> 
  <summary>Andere configuratie (adminrechten!) </summary>

```
[root@DNSMaster named]# ls
16.172.in-addr.arpa   avalon.lan  dynamic   named.empty      named.loopback
2.0.192.in-addr.arpa  data        named.ca  named.localhost  slaves
```

```
[root@DNSSlave named]# ls
data  dynamic  named.ca  named.empty  named.localhost  named.loopback  slaves
```
</details>

- `/var/named` (enkel als `root` bereikbaar)

[Klik hier](https://github.com/HoGentTIN/elnx-sme-RobinBauwens/blob/solution/report/named.md) om de inhoud van deze bestanden te zien.

We gaan dus enkele zaken veranderen in `/etc/named.conf` met een teksteditor zoals `vi`, vergeet ook niet om adminrechten mee te geven!


<!--
We merken hier op dat HTTPS verkeer niet zal lukken aangezien de poort hiervoor op 8443 staat ipv 443.


```

```

We kunnen de syntax nogmaals checken via volgend commando:

```
sudo named-checkconf
```

Blijkbaar bestaat `/etc/pki/tls/certs/nigxn.pem` niet of kan nginx hier niet aan. Dit is ook logisch, want nginx werd verkeerd geschreven.

We corrigeren `nigxn.pem` naar `nginx.pem` en voeren de syntax checker uit.

```
[vagrant@nginx private]$ sudo vi /etc/nginx/nginx.conf
[vagrant@nginx private]$ sudo nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

We moeten ook PHP hebben om deze server te laten werken, we controleren dit en zien dat PHP niet geïnstalleerd is, we lossen dit op met volgende commando's:
```
[vagrant@nginx certs]$ php -v
-bash: php: opdracht niet gevonden
[vagrant@nginx certs]$ which php
/usr/bin/which: no php in (/usr/local/bin:/usr/bin:/usr/local/sbin:/usr/sbin:/home/vagrant/.local/bin:/home/vagrant/bin)
[vagrant@nginx certs]$ sudo yum install php
...
(Na de installatie)
[vagrant@nginx certs]$ php -v
PHP 5.4.16 (cli) (built: Nov  6 2016 00:29:02)
Copyright (c) 1997-2013 The PHP Group
Zend Engine v2.4.0, Copyright (c) 1998-2013 Zend Technologies
[vagrant@nginx certs]$ which php
/usr/bin/php
```
Hier wordt er ook impliciet getest op internetverbinding.
-->

<!--
#### Verwijderen Apache

We merken op dat Apache geïnstalleerd is, dit mag niet het geval zijn dus verwijderen we deze.
-->
<!--
```
[vagrant@nginx ~]$ sudo yum list installed httpd
Geïnstalleerde pakketten
httpd.x86_64                          2.4.6-67.el7.centos.6                          @updates
[vagrant@nginx ~]$ sudo yum remove httpd
Oplossen van afhankelijkheden
-- Transactiecontrole uitvoeren

...

Verwijderd:
  httpd.x86_64 0:2.4.6-67.el7.centos.6

Afhankelijkheid verwijderd:
  apr.x86_64 0:1.4.8-3.el7                            apr-util.x86_64 0:1.5.2-6.el7
  httpd-tools.x86_64 0:2.4.6-67.el7.centos.6          mailcap.noarch 0:2.1.41-2.el7
  php.x86_64 0:5.4.16-42.el7                          php-cli.x86_64 0:5.4.16-42.el7

Compleet!
```

-->


<!--

```
#### Configuratie PHP

We kunnen controleren of PHP geïnstalleerd is met volgende commando's:
Verwacht uitvoer (ongeveer):

```
php -v
PHP 5.4.16 (cli) (built: Nov  6 2016 00:29:02)
Copyright (c) 1997-2013 The PHP Group
Zend Engine v2.4.0, Copyright (c) 1998-2013 Zend Technologies

which php
/usr/bin/php
```
-->


#### Bestandspermissies
We bekijken of alle bestandspermissies kloppen adhv van [dit voorbeeld](https://github.com/HoGentTIN/elnx-sme-RobinBauwens/blob/solution/report/named.md).

#### SELinux
We voeren volgend commando uit om na te gaan of SELinux wel degelijk aanstaat (op `enforcing`).
We verwachten deze uitvoer:

```
getenforce
Enforcing
```

Als we dit uitvoeren, krijgen we ook effectief deze uitvoer.

<!--
Indien deze niet op `enforcing` staat, kunnen we dit aanpassen met `setenforce Enforcing`. Om dit permanent te maken dienen we het bestand `/etc/sysconfig/selinux` aan te passen met een teksteditor naar keuze.
-->


Voor `named` hebben we 2 SELinux-booleans (deze mogen op `off` staan):

```
[vagrant@pu001 ~]$ getsebool -a | grep named
named_tcp_bind_http_port --> off
named_write_master_zones --> off
```

<!--
Als we de booleans van SELinux opvragen, stellen we vast dat `httpd_can_network_connect -- off` op "off" staat. Dit corrigeren we door volgende commando's in te geven:

```
[vagrant@nginx ~]$ sudo setsebool httpd_can_network_connect 1
[vagrant@nginx ~]$ sudo setsebool httpd_can_network_connect 1 -P
```

Ook moeten we ervoor zorgen dat de context voor de (configuratie)bestanden (en keys) wel degelijk juist is, we kunnen dit controleren met `ls -Z`. Dit kunnen we dan oplossen door `sudo resolvecon -R .` uit te voeren in `/etc/pki/tls`.

Dit lost nog altijd niets op, dus bekijken we de uitvoer van `ls -Z` nog eens grondig:

```
[vagrant@nginx certs]$ ls -Z
lrwxrwxrwx. root root system_u:object_r:cert_t:s0      ca-bundle.crt -> /etc/pki/ca-trust/extracted/pem/tls-ca-bundle.pem
lrwxrwxrwx. root root system_u:object_r:cert_t:s0      ca-bundle.trust.crt -> /etc/pki/ca-trust/extracted/openssl/ca-bundle.trust.crt
-rwxr-xr-x. root root system_u:object_r:bin_t:s0       make-dummy-cert
-rw-r--r--. root root system_u:object_r:cert_t:s0      Makefile
-rw-r--r--. root root unconfined_u:object_r:cert_t:s0  nginx.pem
```

We merken op dat `nginx.pem` `unconfined_u:object_r:cert_t:s0` is ipv `system_u ...`. Dit mag niet het geval zijn, we lossen dit op met volgende commando's.

We proberen volgend commando eens (met `-F`):
```
[vagrant@nginx certs]$ sudo restorecon -vF nginx.pem
restorecon reset /etc/pki/tls/certs/nginx.pem context unconfined_u:object_r:cert_t:s0->system_u:object_r:cert_t:s0
```

Hierna restarten we de server eens met `sudo reboot`.

...

We hebben alles doorlopen en nu kunnen we terugkeren naar de ...laag om `named` op te starten.


## Opnieuw doorlopen (TCP/IP)

### Phase 3: Transport Layer (TCP/IP) (2)

We voeren volgende commando's uit om de service te starten:

```
[vagrant@nginx private]$ sudo systemctl start nginx
[vagrant@nginx private]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
   Active: active (running) since vr 2017-10-27 08:46:20 UTC; 7s ago
  Process: 2766 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
  Process: 2763 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
  Process: 2761 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
 Main PID: 2769 (nginx)
   CGroup: /system.slice/nginx.service
           ├─2769 nginx: master process /usr/sbin/nginx
           ├─2770 nginx: worker process
           └─2771 nginx: worker process
```

Als we de pagina bezoeken, dan lukt dit maar we krijgen een foutmelding "Access denied".


### Phase 4: Application Layer (TCP/IP)

Als we via `sudo tail -f /var/log/messages` dit controleren krijgen we volgende uitvoer:
`pid=1942 comm="php-fpm" name="index.php" dev="dm-0" ino=67141778 scontext=system_u:system_r:httpd_t:s0 tcontext=system_u:object_r:user_home_t:s0 tclass=file`

We voeren eens `ls -Z` uit in `/etc/share/nginx/html/` en we krijgen volgende uitvoer:
```
[vagrant@nginx html]$ ls -Z
-rw-r--r--. root root system_u:object_r:usr_t:s0       404.html
-rw-r--r--. root root system_u:object_r:usr_t:s0       50x.html
-rw-r--r--. root root system_u:object_r:usr_t:s0       index.html
-rw-r--r--. root root system_u:object_r:user_home_t:s0 index.php
-rw-r--r--. root root system_u:object_r:usr_t:s0       nginx-logo.png
-rw-r--r--. root root system_u:object_r:usr_t:s0       poweredby.png
```

We merken hier op dat index.php niet helemaal juist is (deze staat nog op `user_home_t:s0` dit lossen we op met volgende commando:
```
[vagrant@nginx html]$ sudo restorecon -v index.php
restorecon reset /usr/share/nginx/html/index.php context system_u:object_r:user_home_t:s0->system_u:object_r:usr_t:s0
```
-->

## End result


```

```

### Extra:
Uitvoer controle poorten, draaiende service, uitvoeren van `dig` op hostsysteem met verwijzing `@192.168.56.42` naar domein/zone etc.:

```
$ dig @192.168.56.42 ns1.example.com +short
testbindmaster.example.com.
192.168.56.53
$ dig @192.168.56.42 example.com www.example.com +short
web.example.com.
192.168.56.20
192.168.56.21
$ dig @192.168.56.42 MX example.com +short
10 mail.example.com.
```

**Opmerking**: Het is mogelijk dat `+short` niet ondersteund wordt voor Windows dig.


## Resources

List all sources of useful information that you encountered while completing this assignment: books, manuals, HOWTO's, blog posts, etc.

- [Basic troubleshooting commands EL](https://bertvv.github.io/presentation-el7-basics/)

- [DNS Red Hat ELNX](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/ch-dns_servers)

- [named conf](https://www.cyberciti.biz/tips/howto-linux-unix-check-dns-file-errors.html)

- [DNS-server](https://unix.stackexchange.com/questions/28941/what-dns-servers-am-i-using)

- [Aanpassen `ip route`](https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/)

- Bert Van Vreckem: ELNX Syllabus

- [Ansible bind role bertvv](https://github.com/bertvv/ansible-role-bind)

- [Installed packages](https://serverfault.com/questions/558936/how-to-accurately-check-if-package-is-installed-in-yum)

- [Configuring BIND](https://www.digitalocean.com/community/tutorials/how-to-configure-bind-as-a-private-network-dns-server-on-centos-7)

- [BIND Configuration Files](https://www.centos.org/docs/2/rhl-rg-en-7.2/s1-bind-configuration.html)

- [Troubleshooting guide](https://bertvv.github.io/linux-network-troubleshooting/)

- [BIND logging](http://www.zytrax.com/books/dns/ch7/logging.html)

- [DNS extra info](http://www.tldp.org/HOWTO/DNS-HOWTO-5.html)

- [Port scanner nmap layer](https://stackoverflow.com/questions/47210759/which-layer-in-the-osi-model-does-a-network-scan-work-on)

- [Configuratie firewall](https://www.digitalocean.com/community/tutorials/how-to-set-up-a-firewall-using-firewalld-on-centos-7)

- [Check whether package is installed](https://unix.stackexchange.com/questions/122681/how-can-i-tell-whether-a-package-is-installed-via-yum-in-a-bash-script)

- [Remove package yum](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/6/html/Deployment_Guide/sec-Removing.html)
