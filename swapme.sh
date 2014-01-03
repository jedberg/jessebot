#!/bin/bash
## swapip.sh by Jesse
## Swap IPs and Hostnames script.
## Will also ask about mac address at the end
# script assumes new host is in DNS
# DO NOT RUN VIA SSH. Script restarts network.
# and that's as frustrating as you would think if
# you don't have console access. This script was
# written for the casual user to update their hostname.
# assumes new host is in DNS. can't get update just IP.

if [ `echo $USER` != root ]; then
	printf "\e[1;31mYou must be root to run this script.\e[0m\n"
	exit
fi
## If User has no arguments to script, then give usage info and exit

if [ -z "$1" ]; then
  printf "\e[1;31mUsage: swapme.sh NewHostname\e[0m\n"
  exit
else

# Some silly one liners to get your current IP, Hostname, and MAC 
# Address. Also uses first argument at CLI to determine new IP in DNS.
  NEWIP=`nslookup "$1" | grep Address | tail -1 | awk -F ' ' '{print $2}'`
  CURRENTHOST=`hostname | awk -F '.' '{print $1}'`
  CURRENTIP=`nslookup "$CURRENTHOST" | grep Address | tail -1 | awk -F ' ' '{print $2}'`
  CURRENTMAC=`grep HWADDR /etc/sysconfig/network-scripts/ifcfg-eth0 | awk -F '=' '{print $2}'`
  printf "\e[1;33mChanging your current hostname, $CURRENTHOST, to the new hostname, $1, for you. Will also change the current IP address, $CURRENTIP, to the new IP address, $NEWIP, found in DNS.\e[0m\n"
fi

## backs up current configuration files... just in case
cp /etc/hosts /tmp/hosts.swapme
cp /etc/sysconfig/network /tmp/network.swapme
cp /etc/sysconfig/network-scripts/ifcfg-eth0 /tmp/ifcfg-eth0.swapme

## actually replaces IP and Hostname within 3 files
sed -i 's/$CURRENTHOST/$1/g' /etc/hosts
sed -i 's/$CURRENTHOST/$1/g' /etc/sysconfig/network
sed -i 's/$CURRENTIP/$NEWIP/g' /etc/sysconfig/network-scripts/ifcfg-eth0
sed -i 's/$CURRENTIP/$NEWIP/g' /etc/hosts
printf "\e[1;33mBackups have been taken prior to running executing this script. They will all be located locally in the /tmp directory with the extension .swapme\e[0m\n"
## Ask about the MAC Address and read user reply
while true; do
        printf "\e[1;37mWould you like me to update the current MAC address ($CURRENTMAC) as well? (y/n)\e[0m\n"
        read answer
## if the user doesn't want to update the MAC, then verify
## if they want to restart the network to verify changes
        if [ "$answer" = "n" ]; then
                printf "\e[1;37mLooks like we're done here then. Rerun this script to cange the hostname/IP/MAC again. Would you like to restart the network and log out to verify your changes have taken place according to plan? (y/n)\e[0m\n"
		while true; do
		read plan
		if [ "$plan" = "y" ]; then
			printf "\e[1;33mRestarting network.\e[0m\n"
			/etc/init.d/network restart
			printf "\e[1;33mGoodbye.\e[0m\n"
			exit
		elif [ "$plan" = "n" ]; then
			printf "\e[1;33mGoodbye then.\e[0m\n"
			exit
## catching an empty or invalid string
		else
			printf "\e[1;37mPlease enter y for yes or n for no for the question: Would you like to restart the network to verify your changes have taken place according to plan?\e[0m"
		fi
		done
        elif [ "$answer" = "y" ]; then
                break
## if user failed to enter y or n, ask again.
        else
                printf "\e[1;37mPlease enter y for yes or n for no.\e[0m\n"
        fi
done
## loop on getting mac in case user forget to enter that as well.
while true; do
        printf "\e[1;37mPlease enter the MAC address you'd like to change to.\e[0m\n"
        read newmac
        if [ -z "$newmac" ]; then
                printf "\e[1;37mOops, you forgot to enter in the MAC address you wanted to change to. Please enter that or hit the key combination: CTRL C to exit the script.\e[0m\n"
        else
                printf "\e[1;33mChanging $CURRENTMAC to $newmac in /etc/sysconfig/network-scripts/ifcfg-eth0.\e[0m\n"
                sed -i 's/$CURRENTMAC/$newmac/g' /etc/sysconfig/network-scripts/ifcfg-eth0
                printf "\e[1;37mMAC Address changed. Looks like we're done here then. Rerun this script to cange the hostname/IP/MAC again. Would you like to restart the network to verify your changes have taken place according to plan? (y/n)\e[0m\n"
                while true; do
                read plan
                if [ "$plan" = "y" ]; then
                        printf "\e[1;33mRestarting network.\e[0m\n"
                        /etc/init.d/network stop
			/etc/init.d/network start
			printf "\e[1;33mGoodbye.\e[0m"
                        exit
                elif [ "$plan" = "n" ]; then
                        printf "\e[1;33mGoodbye then.\e[0m\n"
                        exit
                else
                        printf "\e[1;37mPlease enter y for yes or n for no for the question: Would you like to restart the network and log out to verify your changes have taken place according to plan?\e[0m\n"
                fi
		done
	fi
	done
