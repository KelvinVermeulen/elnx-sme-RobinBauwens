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

## Report

### Phase 1: Link Layer (TCP/IP)

#### Controleren van netwerkhardware (kabels/poorten)

Met volgend commando controleren we of de kabels insteken en werken (verbonden interfaces), de stroom aanstaat, etc.

`ip link`

We verwachten dat `enp0s3` en `enp0s8` (en `lo`) aanstaan (niet exacte output, minder relevante informatie weggelaten):

```
1: lo: <LOOPBACK,UP,LOWER_UP> ...
2: enp0s3: <BROADCAST,MULTICAST,UP,LOWER_UP> ... state UP ...
3: enp0s8: <BROADCAST,MULTICAST,UP,LOWER_UP> ... state UP ...
```

Hiernaast controleren we ook of de instellingen in VirtualBox correct zijn: het IP-adres moet `192.168.56.42` zijn.


### Phase 2: Internet/Network Layer (TCP/IP)

In deze laag controleren we volgende zaken:

- IP-adres & subnetmask
- Default gateway
- DNS-server

#### IP-adressen en subnetmasks 
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

#### DNS-server
Via `cat /etc/resolv.conf` kunnen we dit nagaan.
We verwachten volgende uitvoer:




### Phase 3: Transport Layer (TCP/IP)

### Phase 4: Application Layer (TCP/IP)


...

## End result



## Resources

List all sources of useful information that you encountered while completing this assignment: books, manuals, HOWTO's, blog posts, etc.

[DNS-server](https://unix.stackexchange.com/questions/28941/what-dns-servers-am-i-using)
[Aanpassen `ip route`](https://www.cyberciti.biz/faq/howto-linux-configuring-default-route-with-ipcommand/)