#!/bin/sh

port=1111

do_create(){
	python udptun.py -s $port -l 192.168.128.1 -d >/var/log/udptun.log 2>&1 &
	sysctl -w net.ipv4.ip_forward=1

	# turn on NAT over VPN
	if !(iptables-save -t nat | grep -q "udptun"); then
	  iptables -t nat -A POSTROUTING -s 192.168.128.0/24 ! -d 192.168.128.0/24 -m comment --comment "udptun" -j MASQUERADE
	fi
	iptables -A FORWARD -s 192.168.128.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -A FORWARD -d 192.168.128.0/24 -j ACCEPT

	# Turn on MSS fix (MSS = MTU - TCP header - IP header)
	iptables -t mangle -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
}

do_destroy(){
	kill -9 `ps -ef |grep udptun.py|awk '{print $2}'`
	iptables -t nat -D POSTROUTING -s 192.168.128.0/24 ! -d 192.168.128.0/24 -m comment --comment "udptun" -j MASQUERADE
	iptables -D FORWARD -s 192.168.128.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -D FORWARD -d 192.168.128.0/24 -j ACCEPT

	# Turn off MSS fix (MSS = MTU - TCP header - IP header)
	iptables -t mangle -D FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
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
