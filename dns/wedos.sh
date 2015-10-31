#!/bin/bash

function dns_update {
  if [ $# -ne 1 ]; then
    echo "ERROR: dns_update wrong arguments!"
    exit 1
  fi

  php5 ./`dirname $0`/dns/wedos.php $1
}
