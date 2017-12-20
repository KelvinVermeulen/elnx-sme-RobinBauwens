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

set nat source rule 100 outbound-interface 'eth0' # Moet naar Internet kunnen (via WAN link)
set nat source rule 100 source address '172.16.0.0/16' # INTERNAL network
set nat source rule 100 translation address masquerade

set nat source rule 200 outbound-interface 'eth1'
set nat source rule 200 source address '172.16.0.0/16' # INTERNAL network
set nat source rule 200 translation address masquerade # Moet naar DMZ kunnen

#
# Time
#

delete system ntp server 0.pool.ntp.org
delete system ntp server 1.pool.ntp.org
delete system ntp server 2.pool.ntp.org

set system ntp server 0.be.pool.ntp.org prefer # vergeet prefer niet!
set system ntp server 1.be.pool.ntp.org
set system ntp server 2.be.pool.ntp.org
set system ntp server 3.be.pool.ntp.org

set system time-zone Europe/Brussels

#
# Domain Name Service
#

set service dns forwarding system # staat niet in guide... -> eerst aanzetten

set service dns forwarding domain avalon.lan server 192.0.2.10 	# Alles van het domein avalon.lan moet door deze DNS-server afgehandeld worden
# set service dns forwarding domain avalon.lan server 192.0.2.11 -> Geen slave-DNS server meegeven

set service dns forwarding name-server 10.0.2.3 		# Alles buiten het domein avalon.lan wordt hier verder doorgestuurd
# Gebruik DNS-interface NAT-adapter ipv Google DNS; niet .15 want dat is zijn eigen router-interface

set service dns forwarding listen-on 'eth1' # DMZ
set service dns forwarding listen-on 'eth2' # INTERNAL
						

# Make configuration changes persistent
commit
save

# Fix permissions on configuration
sudo chown -R root:vyattacfg /opt/vyatta/config/active

# vim: set ft=sh
