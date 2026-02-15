#!/bin/bash

# 1) DROP everything by default
iptables -P INPUT  DROP
iptables -P FORWARD DROP
iptables -P OUTPUT ACCEPT

# 2) Clean current filter rules (leave NAT/MANGLE that k3s created)
iptables -F INPUT
iptables -F FORWARD
iptables -F OUTPUT

# 3) Always allow loopback & established traffic
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT


# MAIN PART ######################################################################

ipset destroy trustedips
ipset -N trustedips iphash
#
ipset -A trustedips 1.2.3.4
#
#
# Sometimes it needs to make requests to/from the same machine via Domain Name.
# That's why own external IP should be opened:
#
###
ipset destroy trustednets
ipset -N trustednets nethash
#

#
#


# 4) Public services
iptables -A INPUT -p tcp -m multiport --dport 80,443   -m conntrack --ctstate NEW -j ACCEPT   # HTTP

# 5) SSH only from your workstation/VPN
iptables -A INPUT -p tcp -m multiport -m tcp -m set --match-set trustedips src --dports 22,6443 -j ACCEPT
iptables -A INPUT -p tcp -m multiport -m tcp -m set --match-set trustednets src --dports 22 -j ACCEPT
#iptables -A INPUT -p tcp -m multiport -m tcp -m set --match-set trustedips src --dports 22,5432,15432 -j ACCEPT


# KUBERNETES EXTRAS: (Optional) allow intra-cluster pod/overlay traffic
iptables -A INPUT -s 10.0.0.0/8 -j ACCEPT          # cluster/pod CIDR
iptables -A INPUT -p udp --dport 8472 -s 10.0.0.0/8 -j ACCEPT   # Flannel VXLAN
# ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::


# (Optional) ICMP so we can ping
iptables -A INPUT -p icmp -j ACCEPT


# # Web server traffic
# iptables -A INPUT -p tcp -m multiport -m tcp --dports 80,443,1080 -j ACCEPT

# # [temporary] GrayLog Server (Security through obscurity. Original port - 12201)
# iptables -A INPUT -p tcp -m multiport -m tcp --dports 12250,12251 -j ACCEPT
# iptables -A INPUT -p udp -m multiport -m udp --dports 12250,12251 -j ACCEPT

# # Trusted
# iptables -A INPUT -p tcp -m multiport -m tcp -m set --match-set trustedips src --dports 22,2812,19000,18000,8080,9000,9090,9990,5432,15432,9323,6379,9273 -j ACCEPT


# iptables -A INPUT -p tcp -m multiport -m tcp -m set --match-set trustednets src --dports 22,2812,19000,18000,8080,9000,9090,9990,5432,15432,9323,6379,9273 -j ACCEPT

##################################################################################

# Allow outgoing connections for previously established incoming connections
#iptables -I INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT












# LOGGING: Log incoming blocked packets to /var/log/syslog  (e.g. --limit 20/min)
# Uncomment, if needed
#
#iptables -N LOGGING
#iptables -A INPUT -j LOGGING
#iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "### IPTables-Dropped: " --log-level 4
#iptables -A LOGGING -j DROP


# List all rules and interfaces
iptables -nv -L

##########################################################################################
# I always had problems with saving these rules, so I just apply them each time on boot
##########################################################################################
# Save all rules
#iptables-save > /etc/network/iptables.rules
#netfilter-persistent save


# Restart IPtables
# REBOOT needed
#service iptables restart
#netfilter-persistent reload

#eof
