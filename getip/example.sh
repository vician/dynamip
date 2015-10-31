#!/bin/bash

function get_ip_new {

  IP_NEW=... # Plese add how you want to detect your public IP
  return=$?
  echo "DEBUG [get_ip_new]: Your current IP: $IP_NEW"
  return $return
}
