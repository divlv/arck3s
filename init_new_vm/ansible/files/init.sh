#!/bin/bash

#
# Just initial setup for Docker
#

apt update

apt install -y docker.io

echo "alias getsize='du -a -h --max-depth=1'" >> /root/.bash_aliases
echo "alias ffind='find / -name '" >> /root/.bash_aliases
echo "alias ports='netstat -anltpu | grep -E udp\|LISTEN'" >> /root/.bash_aliases
echo "alias portsa='netstat -anltp'" >> /root/.bash_aliases
echo "alias dstop='docker stop '" >> /root/.bash_aliases
echo "alias iptl='iptables -nv -L'" >> /root/.bash_aliases
echo "alias checkport='nc -w5 -z -v '" >> /root/.bash_aliases
echo "alias myip='dig +short myip.opendns.com @resolver1.opendns.com'" >> /root/.bash_aliases
echo "alias pvc='k3s kubectl get pvc --all-namespaces'" >> /root/.bash_aliases


apt install -y apt-transport-https
apt-add-repository -y universe

apt update

apt install -y net-tools
apt install -y apache2-utils
apt install -y inetutils-tools
apt install -y inetutils-traceroute
apt install -y net-tools
apt install -y ipset
apt install -y mc
apt install -y htop
apt install -y psmisc
apt install -y wput
apt install -y zip
apt install -y unzip
apt install -y resolvconf
apt install -y bash-completion
#apt install -y gnupg2
apt install -y pass
apt install -y ioping
