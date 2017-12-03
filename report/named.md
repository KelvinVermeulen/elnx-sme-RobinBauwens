# DNS - Inhoud van `/var/named/`

**Enkel als `root`-gebruiker bereikbaar! Dit is enkel ter demonstratie want het is niet aangeraden om `root` te gebruiken.**

- `DNSMaster` = `pu001`
- `DNSSlave` = `pu002`

```
[root@DNSMaster named]# ls
16.172.in-addr.arpa   avalon.lan  dynamic   named.empty      named.loopback
2.0.192.in-addr.arpa  data        named.ca  named.localhost  slaves
```

```
[root@DNSSlave named]# ls
data  dynamic  named.ca  named.empty  named.localhost  named.loopback  slaves
```

## Reverse DNS (enkel op master-server) & domein record

**Deze bestanden bevinden zich ook op de slave-server op `/var/named/slaves/` maar deze zijn niet bedoeld om zichtbaar te zijn.**

```
[root@DNSMaster named]# cat 16.172.in-addr.arpa
; Hash: 31217c7a0fe868de8f30262f91a30b24 17102010
; Reverse zone file for avalon.lan
; Ansible managed
; vi: ft=bindzone

$TTL 1W
$ORIGIN 16.172.in-addr.arpa.

@ IN SOA pu001.avalon.lan. hostmaster.avalon.lan. (
  17102010
  1D
  1H
  1W
  1D )

                 IN  NS   pu001.avalon.lan.
                 IN  NS   pu002.avalon.lan.

2.0              IN  PTR  pr001.avalon.lan.
3.0              IN  PTR  pr002.avalon.lan.
10.0             IN  PTR  pr010.avalon.lan.
11.0             IN  PTR  pr011.avalon.lan.
```

```
[root@DNSMaster named]# cat 2.0.192.in-addr.arpa
; Hash: ccb90ac1db7360a9608eda75743396de 17102010
; Reverse zone file for avalon.lan
; Ansible managed
; vi: ft=bindzone

$TTL 1W
$ORIGIN 2.0.192.in-addr.arpa.

@ IN SOA pu001.avalon.lan. hostmaster.avalon.lan. (
  17102010
  1D
  1H
  1W
  1D )

                 IN  NS   pu001.avalon.lan.
                 IN  NS   pu002.avalon.lan.

10               IN  PTR  pu001.avalon.lan.
11               IN  PTR  pu002.avalon.lan.
20               IN  PTR  pu003.avalon.lan.
50               IN  PTR  pu004.avalon.lan.
254              IN  PTR  r001.avalon.lan.
```

```
[root@DNSMaster named]# cat avalon.lan
; Hash: 8bbceb8ae2e9b04d3580d7602411981d 17102010
; Zone file for avalon.lan
; Ansible managed

$ORIGIN avalon.lan.
$TTL 1W

@ IN SOA pu001.avalon.lan. hostmaster.avalon.lan. (
  17102010
  1D
  1H
  1W
  1D )

                     IN  NS     pu001.avalon.lan.
                     IN  NS     pu002.avalon.lan.

@                    IN  MX     10  pu003.avalon.lan.

pu001                IN  A      192.0.2.10
ns1                  IN  CNAME  pu001
pu002                IN  A      192.0.2.11
ns2                  IN  CNAME  pu002
pu003                IN  A      192.0.2.20
mail                 IN  CNAME  pu003
pu004                IN  A      192.0.2.50
www                  IN  CNAME  pu004
r001                 IN  A      192.0.2.254
gw                   IN  CNAME  r001
pr001                IN  A      172.16.0.2
dhcp                 IN  CNAME  pr001
pr002                IN  A      172.16.0.3
directory            IN  CNAME  pr002
pr010                IN  A      172.16.0.10
inside               IN  CNAME  pr010
pr011                IN  A      172.16.0.11
files                IN  CNAME  pr011
```

