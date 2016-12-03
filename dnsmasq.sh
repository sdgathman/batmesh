#!/bin/bash

event="$2"

NS="fcef:a346:73a0:72c4:d56d:1048:88a2:e81d"

pingcheck() {
  ping6 -n -c 1 -w 5 $1 >/dev/null 2>&1
} 

exec 2>/tmp/dnsmasq.log

case "$event" in
up)	pingcheck $NS || pingcheck $NS || exit
	host -T gathman.bit 127.0.0.1 >/dev/null || exit
	if diff /etc/resolv.conf /etc/resolv.conf.dnsmasq >/dev/null; then
	  :
	else
	  cp /etc/resolv.conf /etc/resolv.conf.dhcp
	  cp /etc/resolv.conf.dnsmasq /etc/resolv.conf
	fi
      ;;
esac
