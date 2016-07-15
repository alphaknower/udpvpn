#!/bin/bash

# tunnel server ip address
server=119.9.95.88

# tunnel server port
port=8000

# tunnel ip address
tun=192.168.128.248

# get tunnel gateway
tun_gw=${tun%.[0-9]*}.1

# get old gateway
old_gw=`ip route show 0/0 | sort -k 7 | head -n 1 | sed -e 's/.* via \([^ ]*\).*/\1/'`


do_create(){
	python /usr/local/udptun/udptun.py -c $server,$port -l $tun -p $tun_gw >/var/log/udptun.log 2>&1 &
	sleep 5
	# Turn on NAT over VPN
	iptables -t nat -A POSTROUTING -s ${tun%.[0-9]*}.0/24 -j MASQUERADE
	iptables -I FORWARD 1 -s ${tun%.[0-9]*}.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -I FORWARD 1 -d ${tun%.[0-9]*}.0/24 -j ACCEPT

	# Direct route to VPN server's public IP via current gateway
	ip route add $server via $old_gw

        iptables -t nat -A PREROUTING  -m tcp -p tcp --dport 53 -j DNAT --to-destination $tun_gw:5353
        iptables -t nat -A POSTROUTING -m tcp -p tcp --dport 5353 -d $tun_gw -j SNAT --to-source $tun

	# Custom IPT
	/usr/local/udptun/route_up.sh $tun_gw

}

do_destroy(){
	kill -9 `ps -ef |grep udptun.py|awk '{print $2}'`
	# turn off NAT over VPN
	iptables -t nat -D POSTROUTING -s ${tun%.[0-9]*}.0/24 -j MASQUERADE
	iptables -D FORWARD -s ${tun%.[0-9]*}.0/24 -m state --state RELATED,ESTABLISHED -j ACCEPT
	iptables -D FORWARD -d ${tun%.[0-9]*}.0/24 -j ACCEPT

	# Restore routing table
	ip route del $server

        iptables -t nat -D PREROUTING  -m tcp -p tcp --dport 53 -j DNAT --to-destination $tun_gw:5353
        iptables -t nat -D POSTROUTING -m tcp -p tcp --dport 5353 -d $tun_gw -j SNAT --to-source $tun

	# Custom IPT
	#/usr/local/udptun/route_down.sh $tun_gw
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
    sleep 1
    service dnsmasq restart
    ;;
*)
    echo "Usage: `basename $0` {up|down|reset}" >&2
    ;;
esac

