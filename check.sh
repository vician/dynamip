#!/bin/bash

. check.conf

### params ###
ip_file="ip_pub.txt"
ip_log="ip_pub.log"
server="pi@vician.cz"


IP=`$GETIP`
if [ $? -ne 0 ]; then
  echo "ERROR: GETIP failed! ($GETIP)"
  exit 1
fi
if [ -z "$IP" ]; then
  echo "ERROR: IP is empty!"
  exit 1
fi

echo "DEBUG: Your current public IP is: $IP"

# load old detected ip
if [ -f "$ip_file" ]; then ip_old=`cat $ip_file`; fi

echo "DEBUG: Last public IP is: $ip_old"

# exit if are same
if [ "$ip_old" ] && [ "$ip_old" = "$IP" ]; then
	echo "Same ip, exit."
	exit 0;
fi

echo "DEBUG: Updating DNS records."

exit 0

# write to file
echo $ip > $ip_file

# log
if [ "$ip_log" ]; then echo "`date`: $ip" >> $ip_log; fi
