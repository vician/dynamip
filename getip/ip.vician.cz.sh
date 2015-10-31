#!/bin/bash

IP=`wget -qO- http://ip.vician.cz`
return=$?
echo $IP
exit $return
