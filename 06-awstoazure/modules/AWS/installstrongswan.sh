#!/bin/bash

# sleep until instance is ready
until [[ -f /var/lib/cloud/instance/boot-finished ]]; do
  sleep 1
done

myHostName=`hostname`

# Remove current line with hostname at the end of line ($ means end of line)
sed -i '/'$myHostName'$/ d' /etc/hosts

ipaddr=$(ifconfig  | grep 'inet'| grep -v '127.0.0.*' | cut -d: -f2 | awk '{ print $2}')
echo "$ipaddr $myHostName" >>/etc/hosts

# update packages and install strongswan
apt-get update
apt-get -y install strongswan


# softether is a possible alternate