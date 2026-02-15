#!/bin/sh
# Open everything without wiping k3s rules

# 1) Default policies: accept everything
iptables -P INPUT   ACCEPT
iptables -P FORWARD ACCEPT
iptables -P OUTPUT  ACCEPT

# 2) Insert ACCEPT at top of INPUT/FORWARD chains
#    (position 1, so it matches before any drop/limit rules you might have added)
iptables -I INPUT   1 -j ACCEPT
iptables -I FORWARD 1 -j ACCEPT

# 3) (Optional) log what we did
echo "[allow-all] All incoming/forwarded traffic is now accepted"

# List all rules and interfaces
iptables -nv -L

##########################################################################################
# I always had problems with saving these rules, so I just apply them each time on boot
##########################################################################################
# Save all rules
#iptables-save > /etc/network/iptables.rules
#netfilter-persistent save
