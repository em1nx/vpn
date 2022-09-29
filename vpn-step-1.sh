#!/bin/bash

YOUR_SERVER_IP=$1

apt-get update
apt-get upgrade -y
apt-get install -y strongswan libstrongswan-standard-plugins
apt-get install -y strongswan-pki

cd /etc/ipsec.d || exit
ipsec pki --gen --type rsa --size 4096 --outform pem > private/ca.pem
ipsec pki --self --ca --lifetime 3650 --in private/ca.pem \
--type rsa --digest sha256 \
--dn "CN=$YOUR_SERVER_IP" \
--outform pem > cacerts/ca.pem

ipsec pki --gen --type rsa --size 4096 --outform pem > private/debian.pem
ipsec pki --pub --in private/debian.pem --type rsa |
ipsec pki --issue --lifetime 3650 --digest sha256 \
--cacert cacerts/ca.pem --cakey private/ca.pem \
--dn "CN=$YOUR_SERVER_IP" \
--san "$YOUR_SERVER_IP" \
--flag serverAuth --outform pem > certs/debian.pem

ipsec pki --gen --type rsa --size 4096 --outform pem > private/me.pem
ipsec pki --pub --in private/me.pem --type rsa |
ipsec pki --issue --lifetime 3650 --digest sha256 \
--cacert cacerts/ca.pem --cakey private/ca.pem \
--dn "CN=me" --san me \
--flag clientAuth \
--outform pem > certs/me.pem

rm /etc/ipsec.d/private/ca.pem

cat ~/ipsec.conf > /etc/ipsec.conf

sed -i "s/YOUR_SERVER_IP/$YOUR_SERVER_IP/" /etc/ipsec.conf

echo ": RSA debian.pem" >> /etc/ipsec.secrets

ipsec restart

sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/' /etc/sysctl.conf
sed -i 's/#net.ipv4.conf.all.accept_redirects = 0/net.ipv4.conf.all.accept_redirects = 0/' /etc/sysctl.conf
sed -i 's/#net.ipv4.conf.all.send_redirects = 0/net.ipv4.conf.all.send_redirects = 0/' /etc/sysctl.conf
sed -i 's/#net.ipv4.ip_no_pmtu_disc = 1/net.ipv4.ip_no_pmtu_disc = 1/' /etc/sysctl.conf

sysctl -p

echo iptables-persistent iptables-persistent/autosave_v4 boolean false | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean false | debconf-set-selections

apt-get install -y iptables-persistent

iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
iptables -Z

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT

iptables -A INPUT -i lo -j ACCEPT

iptables -A INPUT -p udp --dport  500 -j ACCEPT
iptables -A INPUT -p udp --dport 4500 -j ACCEPT

iptables -A FORWARD --match policy --pol ipsec --dir in  --proto esp -s 10.10.10.0/24 -j ACCEPT
iptables -A FORWARD --match policy --pol ipsec --dir out --proto esp -d 10.10.10.0/24 -j ACCEPT

iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o eth0 -m policy --pol ipsec --dir out -j ACCEPT
iptables -t nat -A POSTROUTING -s 10.10.10.0/24 -o eth0 -j MASQUERADE

iptables -t mangle -A FORWARD --match policy --pol ipsec --dir in -s 10.10.10.0/24 -o eth0 -p tcp -m tcp --tcp-flags SYN,RST SYN -m tcpmss --mss 1361:1536 -j TCPMSS --set-mss 1360

iptables -A INPUT -j DROP
iptables -A FORWARD -j DROP

netfilter-persistent save
netfilter-persistent reload






