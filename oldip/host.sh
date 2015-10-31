#!/bin/bash

. `dirname $0`/domain.conf

IP_old=`host $DOMAIN | head -n 1 | awk '{print $(NF)}'`
ret=$?

echo "DEBUG: Your current DNS IP is: $IP_OLD"
return $ret
