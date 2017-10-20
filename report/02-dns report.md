# Enterprise Linux Lab Report

- Student name: 
- Github repo: <https://github.com/HoGentTIN/elnx-USER.git>

Describe the goals of the current iteration/assignment in a short sentence.

## Test plan

1. Ga naar je working directory van het Github-project.
2. Verwijder de VM met `vagrant destroy -f pu001` indien deze bestaat. Je zou status `not created` moeten krijgen. Doe hetzelfde voor `pu002`.
3. Voer `vagrant up pu001` uit. Doe hetzelfde voor `pu002`.
4. Log in op de server met `vagrant ssh pu001` en voer de testen uit (`vagrant/test/runbats.sh`). Doe hetzelfde voor `pu002`.
Je zou volgende output moeten krijgen (voor `pu001`:

    ```
    [robin@pu001]$ sudo /vagrant/test/runbats.sh
     Running test /vagrant/test/pu001/masterdns.bats
     ✓ The `dig` command should be installed
     ✓ The main config file should be syntactically correct
     ✓ The forward zone file should be syntactically correct
     ✓ The reverse zone files should be syntactically correct
     ✓ The service should be running
     ✓ Forward lookups public servers
     ✓ Forward lookups private servers
     ✓ Reverse lookups public servers
     ✓ Reverse lookups private servers
     ✓ Alias lookups public servers
     ✓ Alias lookups private servers
     ✓ NS record lookup
     ✓ Mail server lookup
     ✓ Mail server lookup

    13 tests, 0 failures
    ```


- `/etc/resolv.conf` zou alle DNS-records moeten bevatten van alle systemen (binnen het netwerk).

## Procedure/Documentation

1. We voegen volgende code toe aan `vagrant-hosts.yml`:
```
- name: pu001
  ip: 192.0.2.10
- name: pu002
  ip: 192.0.2.11
```
2. Hiernaast voegen we ook bij de master playbook `site.yml` volgende code toe:
```
- hosts: pu001
  roles:
    - bertvv.rh-base
    - bertvv.bind
- hosts: pu002
  roles:
    - bertvv.rh-base # niet vergeten!
    - bertvv.bind
```
3. Vervolgens voegen we onderstaande code toe (minimale variabelen) bij `pu001.yml`:
```
---
allow_services:
  - dns

bind_listen_ipv4:
  - any
bind_allow_query:
  - any

bind_zone_networks:
  - '192.0.2'
  - '172.16'
bind_zone_name: 'avalon.lan'
bind_zone_master_server_ip: 192.0.2.10
bind_zone_name_servers:
  - pu001
  - pu002
bind_zone_hosts:
- name: pu001
  ip: 192.0.2.10
  aliases: 
    - ns1
- name: pu002
  ip: 192.0.2.11
  aliases: 
    - ns2
- name: pu003
  ip: 192.0.2.20
  aliases: 
    - mail
- name: pu004
  ip: 192.0.2.50
  aliases: 
    - www
- name: r001
  ip: 192.0.2.254
  aliases: 
    - gw
- name: pr001
  ip: 172.16.0.2
  aliases: 
    - dhcp
- name: pr002
  ip: 172.16.0.3
  aliases: 
    - directory
- name: pr010
  ip: 172.16.0.10
  aliases: 
    - inside
- name: pr011
  ip: 172.16.0.11
  aliases: 
    - files
bind_zone_mail_servers:
    - name: pu003
      preference: 10
```

Hierin staat alle informatie voor de master-DNS, toelating voor DNS als service, etc.

Hierna moeten we ook de DNS configureren voor de slave-DNS (**exclusief zone_mail_servers en zone_hosts**):

```
---
allow_services:
  - dns

bind_listen_ipv4:
  - any
bind_allow_query:
  - any

bind_zone_networks:
  - '192.0.2'
  - '172.16'
bind_zone_name: 'avalon.lan'
bind_zone_master_server_ip: 192.0.2.10
bind_zone_name_servers:
  - pu001
  - pu002
  # identiek zelfde als pu001.yml, enkel bind_zone_hosts en bind_zone_mail_servers verwijderen


```

## Test report

- `aliases: ns1` werkt niet, gebruik volgende code:

```
aliases:
-ns1
```

## Resources
