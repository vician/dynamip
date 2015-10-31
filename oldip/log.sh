#!/bin/bash

function get_ip_old {
  IP_FILE="`dirname $0`/oldip/log.ip.txt"

  if [ ! -f $IP_FILE ]; then
    echo "Last IP not found $IP_FILE, initialize new IP - will try to change DNS."
    IP_OLD="8.8.8.8"
    return 0
  fi

  if [ ! -r $IP_FILE ]; then
    echo "ERROR: Cannot read file with old IP ($IP_FILE). Fix permission."
    exit 1
  fi

  IP_OLD=`cat $IP_FILE`
  ret=$?
  if [ -n "$IP_NEW" ] && [ "$IP_NEW" != "8.8.8.8" ]; then
    echo $IP_NEW > $IP_FILE
  fi
  return $ret
}
