#!/bin/bash

. `dirname $0`/domain.conf
if [ $? -ne 0 ]; then
  echo "Cannot load file for domain conf."
  exit 1
fi

which dig 1>/dev/null 2>/dev/null
if [ $? -ne 0 ]; then
  echo "Command dig not found. Aborting..."
  exit 1
fi

IP_OLD=`dig +short $DOMAIN 2>/dev/null | tail -n 1`
ret=$?

echo "DEBUG: Your current DNS IP is: $IP_OLD"
return $ret
