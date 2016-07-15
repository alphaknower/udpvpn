#!/bin/sh

# tunnel server ip address
server=192.168.128.1

# tunnel server port
port=8000

do_create(){
	python /usr/local/udptun/udptun.py -s $port -l $server >>/var/log/udptun.log 2>&1 &
	sysctl -w net.ipv4.ip_forward=1
	sleep 5
	# turn on NAT over VPN
	if !(iptables-save -t nat | grep -q "udptun"); then
          iptables -t nat -A PREROUTING -s ${server%.[0-9]*}.0/24 -p udp --dport 53 -j DNAT --to $server:5353
          iptables -t nat -A PREROUTING -s ${server%.[0-9]*}.0/24 -p tcp --dport 53 -j DNAT --to $server:5353
	  iptables -t nat -A POSTROUTING -s ${server%.[0-9]*}.0/24 ! -d ${server%.[0-9]*}.0/24 -m comment --comment "udptun" -j MASQUERADE
	fi
	iptables -A FORWARD -s ${server%.[0-9]*}.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -A FORWARD -d ${server%.[0-9]*}.0/24 -j ACCEPT

	# Turn on MSS fix (MSS = MTU - TCP header - IP header)
	iptables -t mangle -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
}

do_destroy(){
	kill -9 `ps -ef |grep udptun.py|awk '{print $2}'`
        iptables -t nat -D PREROUTING -s ${server%.[0-9]*}.0/24 -p udp --dport 53 -j DNAT --to $server:5353
        iptables -t nat -D PREROUTING -s ${server%.[0-9]*}.0/24 -p tcp --dport 53 -j DNAT --to $server:5353
	iptables -t nat -D POSTROUTING -s ${server%.[0-9]*}.0/24 ! -d ${server%.[0-9]*}.0/24 -m comment --comment "udptun" -j MASQUERADE
	iptables -D FORWARD -s ${server%.[0-9]*}.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -D FORWARD -d ${server%.[0-9]*}.0/24 -j ACCEPT

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
reset)
    $0 down
    sleep 1
    $0 up
    ;;
*)
    echo "Usage: `basename $0` {up|down|reset}" >&2
    ;;
esac
