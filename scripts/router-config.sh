#!/bin/vbash
source /opt/vyatta/etc/functions/script-template

configure

# Fix for error "INIT: Id "TO" respawning too fast: disabled for 5 minutes"
delete system console device ttyS0

#
# Basic settings
#
set system host-name 'Router'
#set service ssh port '22'
	# We gebruiken vagrant ssh dus niet hoeft nu niet per se

#
# IP settings
#

set interfaces ethernet eth0 address dhcp # 10.0.2.15/24
set interfaces ethernet eth0 description 'WAN LINK'

set interfaces ethernet eth1 address '192.0.2.254/24'
set interfaces ethernet eth1 description 'DMZ'

set interfaces ethernet eth2 address '172.16.255.254/16'
set interfaces ethernet eth2 description 'INTERNAL'


#
# Network Address Translation
#

set nat source rule 100 outbound-interface 'eth0'
set nat source rule 100 source address '172.16.0.0/16' # INTERNAL network
set nat source rule 100 translation address masquerade

set nat source rule 200 outbound-interface 'eth1'
set nat source rule 200 source address '172.16.0.0/16' # INTERNAL network
set nat source rule 200 translation address masquerade

#
# Time
#

set system time-zone Europe/Brussels
set sytem ntp server be.pool.ntp.org

     # server 0.be.pool.ntp.org
	 #   server 1.be.pool.ntp.org
	 #   server 2.be.pool.ntp.org
	 #   server 3.be.pool.ntp.org


#
# Domain Name Service
#

set service dns forwarding system # staat niet in guide...

set service dns forwarding domain avalon.lan server 192.0.2.10 
# set service dns forwarding domain avalon.lan server 192.0.2.11 -> Geen slave-DNS server meegeven

set service dns forwarding name-server 10.0.2.3 # Gebruik DNS-interface NAT-adapter ipv Google DNS; niet .15 want dat is zijn eigen router-interface

set service dns forwarding listen-on 'eth1' # DMZ
set service dns forwarding listen-on 'eth2' # INTERNAL



# Make configuration changes persistent
commit
save

# Fix permissions on configuration
sudo chown -R root:vyattacfg /opt/vyatta/config/active

# vim: set ft=sh




# https://wiki.vyos.net/wiki/User_Guide
# https://rbgeek.wordpress.com/2013/05/14/how-to-configure-ntp-server-and-timezone-on-vyatta/
# https://github.com/bertvv/cheat-sheets/blob/master/print/VyOS.pdf