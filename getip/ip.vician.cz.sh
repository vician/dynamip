#!/bin/bash

function get_ip_new {

  IP_NEW=`wget -qO- http://ip.vician.cz`
  return=$?
  echo "DEBUG [get_ip_new]: Your current IP: $IP_NEW"
  return $return
}
