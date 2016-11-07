#!/bin/sh
#
# /etc/NetworkManager/dispatcher.d/05-batman

if test -s /etc/sysconfig/batman-mesh; then
  . /etc/sysconfig/batman-mesh
fi

test -z "$ESSID" && ESSID="chantilly-mesh"

IFACE="${DEVICE_IFACE}"
CONN="${CONNECTION_ID}"

log="/tmp/batlog.txt"
date >>$log
echo "$*" >>$log
env >>$log

exec 2>>$log
set -x

interface="$1"
status="$2"

function current {
    s=`nmcli -t -f GENERAL.CONNECTION d show $IFACE`
    echo "$s" >>$log
    echo "$s"| cut -d\: -f2
}

function ether {
  set - `ip link show dev $IFACE | tail -1`
  echo "$2"
}

if [ ! "$interface" = $IFACE ]; then
  exit 0
fi

case $status in
  up)
    case "$(current)" in
    *"$ESSID")
      modprobe batman-adv
      ip link set dev bat0 down
      batctl if add $IFACE
      batctl gw_mode client
      # Keep the same MAC address (optional)
      ip link set dev bat0 address $(ether)
      test -z "$IP6ADDR" || ip -6 addr add $IP6ADDR dev bat0
      test -z "$IPADDR" || ip addr add $IPADDR dev bat0
      ip link set dev $IFACE mtu 1560 # 1500+60
      ip link set dev bat0 up
      # DHCP (optional)
      #dhclient -r
      #dhclient -H $(hostname) bat0
      systemctl restart cjdns
      ;;
    esac
    ;;
  down)
    case "$CONN" in
    *mesh*)
      ip link set dev bat0 down
      batctl if del $IFACE
      ;;
    esac
    ;;
esac
