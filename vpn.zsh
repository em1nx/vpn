#!/bin/zsh

YOUR_SERVER_IP=$1

scp vpn-step-1.sh "root@$YOUR_SERVER_IP:~"
scp vpn-step-2.sh "root@$YOUR_SERVER_IP:~"
scp ipsec.conf "root@$YOUR_SERVER_IP:~"
scp mobileconfig.sh "root@$YOUR_SERVER_IP:~"

ssh "root@$YOUR_SERVER_IP" chmod +x *.sh

ssh "root@$YOUR_SERVER_IP" "./vpn-step-1.sh $YOUR_SERVER_IP"
ssh "root@$YOUR_SERVER_IP" reboot

echo
read -r -s -k '?Server rebooting. Wait ~1 minute and press any key to continue...'
echo

ssh "root@$YOUR_SERVER_IP" "./vpn-step-2.sh $YOUR_SERVER_IP"

mkdir -p ~/.vpn
scp "root@$YOUR_SERVER_IP:~/emin.mobileconfig" ~/.vpn
open ~/.vpn/emin.mobileconfig

