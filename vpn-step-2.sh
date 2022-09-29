#!/bin/bash

YOUR_SERVER_IP=$1

iptables -S

ipsec statusall

apt-get install -y zsh

sed -i "s/YOUR_SERVER_IP/$YOUR_SERVER_IP/" mobileconfig.sh

chmod u+x mobileconfig.sh

./mobileconfig.sh > emin.mobileconfig

