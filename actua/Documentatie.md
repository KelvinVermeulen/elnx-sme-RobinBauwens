# Documentatie Docker intranet

## Stappenplan

In de SME-opdracht wordt IP-adres `172.16.0.10` met alias `inside` voorzien als intranet webserver. Volgende code voorziet dit:

```
- name: pr010
  ip: 172.16.0.10
  aliases: 
    - inside
```

De bedoeling is dat we de mogelijkheden van Nginx load-balancing testen binnen ons netwerk bij het surfen naar `inside.avalon.lan`.

Alle configuratie bevindt zich in `/actua`, clone eerst het [startproject van bertvv/docker-sandbox](https://github.com/bertvv/docker-sandbox) en plaats dit dan ook in `/actua`.

<!--
Zet de IP-instellingen goed: we maken een `ifcfg-enp0s8` aan in `/etc/sysconfig/network-scripts` (gebruik administratorrechten).

```
TYPE=Ethernet
BOOTPROTO=none
NAME=enp0s8
DEVICE=enp0s8
ONBOOT=yes
IPADDR=172.16.0.10
NETMASK=255.255.0.0
```
-->