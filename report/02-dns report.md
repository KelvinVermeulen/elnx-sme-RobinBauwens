# Enterprise Linux Lab Report

- Student name: 
- Github repo: <https://github.com/HoGentTIN/elnx-USER.git>

Describe the goals of the current iteration/assignment in a short sentence.

## Test plan


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
    - bertvv.bind
```
3. Vervolgens voegen we onderstaande code toe (minimale variabelen) bij `pu001.yml`:
```
---

bind_zone_master_server_ip: 192.0.2.10
bind_zone_name: "avalon.lan"
bind_zone_networks:
  - '192.0.2'
  - '172.16'
bind_zone_name_servers:
  - ns1
  - ns2
bind_zone_hosts:
- name: pu001
  ip: 192.0.2.10
  aliases: ns1
- name: pu002
  ip: 192.0.2.11
  aliases: ns2
- name: pu003
  ip: 192.0.2.20
  aliases: mail
- name: pu004
  ip: 192.0.2.50
  aliases: www
- name: r001
  ip: 192.0.2.254
  aliases:  gw
- name: pr001
  ip: 172.16.0.2
  aliases: dhcp
- name: pr002
  ip: 172.16.0.3
  aliases: directory
- name: pr010
  ip: 172.16.0.10
  aliases: inside
- name: pr011
  ip: 172.16.0.11
  aliases: files

  bind_listen_ipv4:
    - any
  bind_allow_query:
    - any
```

## Test report



## Resources
