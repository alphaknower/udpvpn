#!/bin/sh

server=106.186.28.103
port=1111

do_create(){
	python udptun.py -c $server,$port -l 192.168.128.2 -p 192.168.128.1 -d >/var/log/udptun.log 2>&1 &
	# Turn on NAT over VPN
	iptables -t nat -A POSTROUTING -s 192.168.128.0/24 -j MASQUERADE
	iptables -I FORWARD 1 -s 192.168.128.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -I FORWARD 1 -d 192.168.128.0/24 -j ACCEPT

	# Direct route to VPN server's public IP via current gateway
	ip route add $server via $(ip route show 0/0 | sort -k 7 | head -n 1 | sed -e 's/.* via \([^ ]*\).*/\1/')

	# Custom IPT
	ip route add 8.8.8.8/32 via 192.168.128.1
}

do_destroy(){
	kill -9 `ps -ef |grep udptun.py|awk '{print $2}'`
	# turn off NAT over VPN
	iptables -t nat -D POSTROUTING -s 192.168.128.0/24 -j MASQUERADE
	iptables -D FORWARD -s 192.168.128.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -D FORWARD -d 192.168.128.0/24 -j ACCEPT

	# Restore routing table
	ip route del $server

	# Custom IPT
	ip route del 8.8.8.8/32
}

case "$1" in
up)
    do_create
    ;;
down)
    do_destroy
    ;;
*)
    echo "Usage: `basename $0` {up|down}" >&2
    ;;
esac
