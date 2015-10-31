#!/bin/bash

# Load configuration
. check.conf
if [ $? -ne 0 ]; then
  echo "Cannot load configuration file"
  exit 1
fi

. $IP_NEW_GET
if [ $? -ne 0 ]; then
  echo "Cannot load file for getting new IP ($IP_NEW_GET)"
  exit 1
fi

# GetIP
get_ip_new
if [ $? -ne 0 ]; then
  echo "ERROR: GETIP failed! ($IP_GET)"
  exit 1
fi
if [ -z "$IP_NEW" ]; then
  echo "ERROR: IP is empty!"
  exit 1
fi

echo "DEBUG: Your current public IP is: $IP_NEW"

. $IP_OLD_GET
if [ $? -ne 0 ]; then
  echo "Cannot load file for getting old IP ($IP_OLD_GET)"
  exit 1
fi

# Get old IP
get_ip_old
if [ $? -ne 0 ]; then
  echo "ERROR: get_ip_old failed!"
  exit 1
fi
if [ -z "$IP_OLD" ]; then
  echo "ERROR: IP is empty!"
  exit 1
fi

echo "DEBUG: Your last public IP was: $IP_OLD"

# exit if are same
if [ "$IP_NEW" == "$IP_OLD" ]; then
	echo "Same ip, exit."
	exit 0;
fi

echo "DEBUG: Updating DNS records."

. $DNS
if [ $? -ne 0 ]; then
  echo "Cannot load file for DNS update ($DNS)"
  exit 1
fi

dns_update $IP_NEW

exit 0
