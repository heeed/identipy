#!/bin/bash

##############################################################
#
# indentipy.sh
#
# A short script to automatically email network information from a pi
#
#(c)2014 Michael Rimicans @heeedt
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
# 
#################################################################

origIFS=$IFS 
IFS='|'
function getInfo {
echo -e "Interface: $1\n" >> /tmp/info.txt

info=$(/sbin/ifconfig $1 | grep 'inet addr' ) 
mac=$(/sbin/ifconfig $1 | grep -P 'HWaddr'| awk '{print $5}' )
ip=$(echo $info | cut -d: -f2 | awk '{ print $1}')
bc=$(echo $info | cut -d: -f3 | awk '{ print $1}')
mask=$(echo $info | cut -d: -f4 | awk '{ print $1}')



if [ -z "${ip-unset}" ]; then
    ip=$(echo -e "No information found")
fi

if [ -z "${bc-unset}" ]; then
    bc=$(echo -e "No information found")
fi

if [ -z "${mask-unset}" ]; then
    mask=$(echo -e "No information found")
fi

echo -e "IP Address: "$ip"\nBroadcast: "$bc"\nNetwork Mask: "$mask"\nMAC: "$mac"\n" >> /tmp/info.txt
}

serial=$(cat /proc/cpuinfo | tail -c 5)
echo -e "Pi Serial Number: $serial\n" >> /tmp/info.txt

getInfo wlan0
getInfo eth0

mail -s "RasPi Serial No: $serial" root@localhost < /tmp/info.txt
rm /tmp/info.txt
IFS=$origIFS



