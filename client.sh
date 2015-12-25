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
	ip route add 1.0.0.0/5 via 192.168.128.1
	ip route add 8.0.0.0/6 via 192.168.128.1
	ip route add 12.0.0.0/7 via 192.168.128.1
	ip route add 14.0.0.0/12 via 192.168.128.1
	ip route add 14.136.0.0/13 via 192.168.128.1
	ip route add 14.192.0.0/12 via 192.168.128.1
	ip route add 15.0.0.0/8 via 192.168.128.1
	ip route add 16.0.0.0/5 via 192.168.128.1
	ip route add 24.0.0.0/7 via 192.168.128.1
	ip route add 26.0.0.0/8 via 192.168.128.1
	ip route add 27.0.0.0/13 via 192.168.128.1
	ip route add 27.32.0.0/11 via 192.168.128.1
	ip route add 27.64.0.0/10 via 192.168.128.1
	ip route add 27.132.0.0/14 via 192.168.128.1
	ip route add 27.136.0.0/14 via 192.168.128.1
	ip route add 27.224.0.0/11 via 192.168.128.1
	ip route add 28.0.0.0/6 via 192.168.128.1
	ip route add 32.0.0.0/6 via 192.168.128.1
	ip route add 36.8.0.0/13 via 192.168.128.1
	ip route add 36.52.0.0/14 via 192.168.128.1
	ip route add 36.224.0.0/12 via 192.168.128.1
	ip route add 36.240.0.0/13 via 192.168.128.1
	ip route add 37.0.0.0/8 via 192.168.128.1
	ip route add 38.0.0.0/7 via 192.168.128.1
	ip route add 40.0.0.0/7 via 192.168.128.1
	ip route add 42.2.0.0/15 via 192.168.128.1
	ip route add 42.98.0.0/15 via 192.168.128.1
	ip route add 42.124.0.0/14 via 192.168.128.1
	ip route add 42.144.0.0/13 via 192.168.128.1
	ip route add 42.200.0.0/16 via 192.168.128.1
	ip route add 43.0.0.0/8 via 192.168.128.1
	ip route add 44.0.0.0/6 via 192.168.128.1
	ip route add 48.0.0.0/8 via 192.168.128.1
	ip route add 49.96.0.0/12 via 192.168.128.1
	ip route add 49.128.0.0/9 via 192.168.128.1
	ip route add 50.0.0.0/7 via 192.168.128.1
	ip route add 52.0.0.0/6 via 192.168.128.1
	ip route add 56.0.0.0/7 via 192.168.128.1
	ip route add 58.0.0.0/12 via 192.168.128.1
	ip route add 58.64.0.0/15 via 192.168.128.1
	ip route add 58.80.0.0/12 via 192.168.128.1
	ip route add 58.96.0.0/11 via 192.168.128.1
	ip route add 58.128.0.0/10 via 192.168.128.1
	ip route add 59.0.0.0/11 via 192.168.128.1
	ip route add 59.80.0.0/12 via 192.168.128.1
	ip route add 59.96.0.0/11 via 192.168.128.1
	ip route add 59.128.0.0/9 via 192.168.128.1
	ip route add 60.32.0.0/11 via 192.168.128.1
	ip route add 60.64.0.0/10 via 192.168.128.1
	ip route add 60.128.0.0/11 via 192.168.128.1
	ip route add 60.196.0.0/15 via 192.168.128.1
	ip route add 60.224.0.0/11 via 192.168.128.1
	ip route add 61.0.0.0/11 via 192.168.128.1
	ip route add 61.56.0.0/13 via 192.168.128.1
	ip route add 61.64.0.0/10 via 192.168.128.1
	ip route add 61.192.0.0/11 via 192.168.128.1
	ip route add 61.238.0.0/15 via 192.168.128.1
	ip route add 61.244.0.0/14 via 192.168.128.1
	ip route add 62.0.0.0/7 via 192.168.128.1
	ip route add 64.0.0.0/3 via 192.168.128.1
	ip route add 96.0.0.0/6 via 192.168.128.1
	ip route add 100.0.0.0/8 via 192.168.128.1
	ip route add 101.136.0.0/13 via 192.168.128.1
	ip route add 102.0.0.0/7 via 192.168.128.1
	ip route add 104.0.0.0/7 via 192.168.128.1
	ip route add 106.10.0.0/16 via 192.168.128.1
	ip route add 106.64.0.0/13 via 192.168.128.1
	ip route add 106.128.0.0/10 via 192.168.128.1
	ip route add 107.0.0.0/8 via 192.168.128.1
	ip route add 108.0.0.0/7 via 192.168.128.1
	ip route add 110.0.0.0/10 via 192.168.128.1
	ip route add 110.92.0.0/14 via 192.168.128.1
	ip route add 110.128.0.0/11 via 192.168.128.1
	ip route add 110.160.0.0/12 via 192.168.128.1
	ip route add 110.232.0.0/13 via 192.168.128.1
	ip route add 111.64.0.0/13 via 192.168.128.1
	ip route add 111.86.0.0/15 via 192.168.128.1
	ip route add 111.88.0.0/13 via 192.168.128.1
	ip route add 111.96.0.0/12 via 192.168.128.1
	ip route add 111.118.0.0/15 via 192.168.128.1
	ip route add 111.216.0.0/13 via 192.168.128.1
	ip route add 111.224.0.0/11 via 192.168.128.1
	ip route add 112.68.0.0/14 via 192.168.128.1
	ip route add 112.72.0.0/13 via 192.168.128.1
	ip route add 112.118.0.0/15 via 192.168.128.1
	ip route add 112.120.0.0/15 via 192.168.128.1
	ip route add 112.128.0.0/10 via 192.168.128.1
	ip route add 113.28.0.0/14 via 192.168.128.1
	ip route add 113.144.0.0/12 via 192.168.128.1
	ip route add 113.196.0.0/14 via 192.168.128.1
	ip route add 113.252.0.0/14 via 192.168.128.1
	ip route add 114.0.0.0/11 via 192.168.128.1
	ip route add 114.16.0.0/12 via 192.168.128.1
	ip route add 114.32.0.0/12 via 192.168.128.1
	ip route add 114.144.0.0/12 via 192.168.128.1
	ip route add 114.160.0.0/11 via 192.168.128.1
	ip route add 116.48.0.0/14 via 192.168.128.1
	ip route add 117.16.0.0/14 via 192.168.128.1
	ip route add 118.128.0.0/12 via 192.168.128.1
	ip route add 118.148.0.0/14 via 192.168.128.1
	ip route add 118.152.0.0/13 via 192.168.128.1
	ip route add 118.214.0.0/15 via 192.168.128.1
	ip route add 119.8.0.0/13 via 192.168.128.1
	ip route add 119.80.0.0/14 via 192.168.128.1
	ip route add 119.104.0.0/14 via 192.168.128.1
	ip route add 119.236.0.0/14 via 192.168.128.1
	ip route add 119.240.0.0/13 via 192.168.128.1
	ip route add 120.50.0.0/15 via 192.168.128.1
	ip route add 120.136.0.0/13 via 192.168.128.1
	ip route add 121.96.0.0/11 via 192.168.128.1
	ip route add 121.128.0.0/10 via 192.168.128.1
	ip route add 121.200.0.0/16 via 192.168.128.1
	ip route add 121.202.0.0/15 via 192.168.128.1
	ip route add 122.248.0.0/13 via 192.168.128.1
	ip route add 122.252.0.0/16 via 192.168.128.1
	ip route add 123.0.0.0/14 via 192.168.128.1
	ip route add 123.192.0.0/10 via 192.168.128.1
	ip route add 124.0.0.0/13 via 192.168.128.1
	ip route add 124.96.0.0/12 via 192.168.128.1
	ip route add 124.144.0.0/12 via 192.168.128.1
	ip route add 125.0.0.0/11 via 192.168.128.1
	ip route add 125.48.0.0/12 via 192.168.128.1
	ip route add 125.128.0.0/10 via 192.168.128.1
	ip route add 125.192.0.0/12 via 192.168.128.1
	ip route add 125.224.0.0/11 via 192.168.128.1
	ip route add 126.0.0.0/8 via 192.168.128.1
	ip route add 128.0.0.0/5 via 192.168.128.1
	ip route add 136.0.0.0/6 via 192.168.128.1
	ip route add 140.0.0.0/9 via 192.168.128.1
	ip route add 140.128.0.0/10 via 192.168.128.1
	ip route add 140.192.0.0/13 via 192.168.128.1
	ip route add 141.0.0.0/8 via 192.168.128.1
	ip route add 142.0.0.0/7 via 192.168.128.1
	ip route add 144.0.0.0/4 via 192.168.128.1
	ip route add 160.0.0.0/7 via 192.168.128.1
	ip route add 162.0.0.0/8 via 192.168.128.1
	ip route add 163.0.0.0/9 via 192.168.128.1
	ip route add 163.128.0.0/11 via 192.168.128.1
	ip route add 163.160.0.0/12 via 192.168.128.1
	ip route add 163.192.0.0/10 via 192.168.128.1
	ip route add 164.0.0.0/6 via 192.168.128.1
	ip route add 168.0.0.0/7 via 192.168.128.1
	ip route add 170.0.0.0/8 via 192.168.128.1
	ip route add 171.16.0.0/12 via 192.168.128.1
	ip route add 172.0.0.0/6 via 192.168.128.1
	ip route add 176.0.0.0/6 via 192.168.128.1
	ip route add 180.0.0.0/10 via 192.168.128.1
	ip route add 180.192.0.0/10 via 192.168.128.1
	ip route add 181.0.0.0/8 via 192.168.128.1
	ip route add 182.0.0.0/12 via 192.168.128.1
	ip route add 182.48.0.0/12 via 192.168.128.1
	ip route add 182.152.0.0/13 via 192.168.128.1
	ip route add 182.248.0.0/14 via 192.168.128.1
	ip route add 183.72.0.0/13 via 192.168.128.1
	ip route add 183.96.0.0/11 via 192.168.128.1
	ip route add 183.176.0.0/13 via 192.168.128.1
	ip route add 184.0.0.0/5 via 192.168.128.1
	ip route add 192.0.0.0/5 via 192.168.128.1
	ip route add 200.0.0.0/7 via 192.168.128.1
	ip route add 202.0.0.0/10 via 192.168.128.1
	ip route add 202.64.0.0/11 via 192.168.128.1
	ip route add 202.120.0.0/13 via 192.168.128.1
	ip route add 202.128.0.0/9 via 192.168.128.1
	ip route add 203.0.0.0/9 via 192.168.128.1
	ip route add 203.128.0.0/11 via 192.168.128.1
	ip route add 203.176.0.0/12 via 192.168.128.1
	ip route add 204.0.0.0/6 via 192.168.128.1
	ip route add 208.0.0.0/7 via 192.168.128.1
	ip route add 210.56.0.0/13 via 192.168.128.1
	ip route add 210.64.0.0/13 via 192.168.128.1
	ip route add 210.128.0.0/9 via 192.168.128.1
	ip route add 211.0.0.0/10 via 192.168.128.1
	ip route add 211.72.0.0/13 via 192.168.128.1
	ip route add 211.104.0.0/13 via 192.168.128.1
	ip route add 211.112.0.0/12 via 192.168.128.1
	ip route add 211.128.0.0/13 via 192.168.128.1
	ip route add 211.168.0.0/13 via 192.168.128.1
	ip route add 211.176.0.0/12 via 192.168.128.1
	ip route add 211.192.0.0/10 via 192.168.128.1
	ip route add 212.0.0.0/6 via 192.168.128.1
	ip route add 216.0.0.0/7 via 192.168.128.1
	ip route add 218.128.0.0/10 via 192.168.128.1
	ip route add 218.248.0.0/13 via 192.168.128.1
	ip route add 219.0.0.0/9 via 192.168.128.1
	ip route add 219.160.0.0/11 via 192.168.128.1
	ip route add 219.192.0.0/12 via 192.168.128.1
	ip route add 219.208.0.0/13 via 192.168.128.1
	ip route add 220.0.0.0/9 via 192.168.128.1
	ip route add 220.128.0.0/11 via 192.168.128.1
	ip route add 220.208.0.0/12 via 192.168.128.1
	ip route add 220.224.0.0/13 via 192.168.128.1
	ip route add 221.124.0.0/14 via 192.168.128.1
	ip route add 221.184.0.0/13 via 192.168.128.1
	ip route add 222.0.0.0/12 via 192.168.128.1
	ip route add 222.164.0.0/14 via 192.168.128.1
	ip route add 223.16.0.0/12 via 192.168.128.1
	ip route add 223.32.0.0/11 via 192.168.128.1
	ip route add 223.118.0.0/15 via 192.168.128.1
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
	ip route del 1.0.0.0/5
	ip route del 8.0.0.0/6
	ip route del 12.0.0.0/7
	ip route del 14.0.0.0/12
	ip route del 14.136.0.0/13
	ip route del 14.192.0.0/12
	ip route del 15.0.0.0/8
	ip route del 16.0.0.0/5
	ip route del 24.0.0.0/7
	ip route del 26.0.0.0/8
	ip route del 27.0.0.0/13
	ip route del 27.32.0.0/11
	ip route del 27.64.0.0/10
	ip route del 27.132.0.0/14
	ip route del 27.136.0.0/14
	ip route del 27.224.0.0/11
	ip route del 28.0.0.0/6
	ip route del 32.0.0.0/6
	ip route del 36.8.0.0/13
	ip route del 36.52.0.0/14
	ip route del 36.224.0.0/12
	ip route del 36.240.0.0/13
	ip route del 37.0.0.0/8
	ip route del 38.0.0.0/7
	ip route del 40.0.0.0/7
	ip route del 42.2.0.0/15
	ip route del 42.98.0.0/15
	ip route del 42.124.0.0/14
	ip route del 42.144.0.0/13
	ip route del 42.200.0.0/16
	ip route del 43.0.0.0/8
	ip route del 44.0.0.0/6
	ip route del 48.0.0.0/8
	ip route del 49.96.0.0/12
	ip route del 49.128.0.0/9
	ip route del 50.0.0.0/7
	ip route del 52.0.0.0/6
	ip route del 56.0.0.0/7
	ip route del 58.0.0.0/12
	ip route del 58.64.0.0/15
	ip route del 58.80.0.0/12
	ip route del 58.96.0.0/11
	ip route del 58.128.0.0/10
	ip route del 59.0.0.0/11
	ip route del 59.80.0.0/12
	ip route del 59.96.0.0/11
	ip route del 59.128.0.0/9
	ip route del 60.32.0.0/11
	ip route del 60.64.0.0/10
	ip route del 60.128.0.0/11
	ip route del 60.196.0.0/15
	ip route del 60.224.0.0/11
	ip route del 61.0.0.0/11
	ip route del 61.56.0.0/13
	ip route del 61.64.0.0/10
	ip route del 61.192.0.0/11
	ip route del 61.238.0.0/15
	ip route del 61.244.0.0/14
	ip route del 62.0.0.0/7
	ip route del 64.0.0.0/3
	ip route del 96.0.0.0/6
	ip route del 100.0.0.0/8
	ip route del 101.136.0.0/13
	ip route del 102.0.0.0/7
	ip route del 104.0.0.0/7
	ip route del 106.10.0.0/16
	ip route del 106.64.0.0/13
	ip route del 106.128.0.0/10
	ip route del 107.0.0.0/8
	ip route del 108.0.0.0/7
	ip route del 110.0.0.0/10
	ip route del 110.92.0.0/14
	ip route del 110.128.0.0/11
	ip route del 110.160.0.0/12
	ip route del 110.232.0.0/13
	ip route del 111.64.0.0/13
	ip route del 111.86.0.0/15
	ip route del 111.88.0.0/13
	ip route del 111.96.0.0/12
	ip route del 111.118.0.0/15
	ip route del 111.216.0.0/13
	ip route del 111.224.0.0/11
	ip route del 112.68.0.0/14
	ip route del 112.72.0.0/13
	ip route del 112.118.0.0/15
	ip route del 112.120.0.0/15
	ip route del 112.128.0.0/10
	ip route del 113.28.0.0/14
	ip route del 113.144.0.0/12
	ip route del 113.196.0.0/14
	ip route del 113.252.0.0/14
	ip route del 114.0.0.0/11
	ip route del 114.16.0.0/12
	ip route del 114.32.0.0/12
	ip route del 114.144.0.0/12
	ip route del 114.160.0.0/11
	ip route del 116.48.0.0/14
	ip route del 117.16.0.0/14
	ip route del 118.128.0.0/12
	ip route del 118.148.0.0/14
	ip route del 118.152.0.0/13
	ip route del 118.214.0.0/15
	ip route del 119.8.0.0/13
	ip route del 119.80.0.0/14
	ip route del 119.104.0.0/14
	ip route del 119.236.0.0/14
	ip route del 119.240.0.0/13
	ip route del 120.50.0.0/15
	ip route del 120.136.0.0/13
	ip route del 121.96.0.0/11
	ip route del 121.128.0.0/10
	ip route del 121.200.0.0/16
	ip route del 121.202.0.0/15
	ip route del 122.248.0.0/13
	ip route del 122.252.0.0/16
	ip route del 123.0.0.0/14
	ip route del 123.192.0.0/10
	ip route del 124.0.0.0/13
	ip route del 124.96.0.0/12
	ip route del 124.144.0.0/12
	ip route del 125.0.0.0/11
	ip route del 125.48.0.0/12
	ip route del 125.128.0.0/10
	ip route del 125.192.0.0/12
	ip route del 125.224.0.0/11
	ip route del 126.0.0.0/8
	ip route del 128.0.0.0/5
	ip route del 136.0.0.0/6
	ip route del 140.0.0.0/9
	ip route del 140.128.0.0/10
	ip route del 140.192.0.0/13
	ip route del 141.0.0.0/8
	ip route del 142.0.0.0/7
	ip route del 144.0.0.0/4
	ip route del 160.0.0.0/7
	ip route del 162.0.0.0/8
	ip route del 163.0.0.0/9
	ip route del 163.128.0.0/11
	ip route del 163.160.0.0/12
	ip route del 163.192.0.0/10
	ip route del 164.0.0.0/6
	ip route del 168.0.0.0/7
	ip route del 170.0.0.0/8
	ip route del 171.16.0.0/12
	ip route del 172.0.0.0/6
	ip route del 176.0.0.0/6
	ip route del 180.0.0.0/10
	ip route del 180.192.0.0/10
	ip route del 181.0.0.0/8
	ip route del 182.0.0.0/12
	ip route del 182.48.0.0/12
	ip route del 182.152.0.0/13
	ip route del 182.248.0.0/14
	ip route del 183.72.0.0/13
	ip route del 183.96.0.0/11
	ip route del 183.176.0.0/13
	ip route del 184.0.0.0/5
	ip route del 192.0.0.0/5
	ip route del 200.0.0.0/7
	ip route del 202.0.0.0/10
	ip route del 202.64.0.0/11
	ip route del 202.120.0.0/13
	ip route del 202.128.0.0/9
	ip route del 203.0.0.0/9
	ip route del 203.128.0.0/11
	ip route del 203.176.0.0/12
	ip route del 204.0.0.0/6
	ip route del 208.0.0.0/7
	ip route del 210.56.0.0/13
	ip route del 210.64.0.0/13
	ip route del 210.128.0.0/9
	ip route del 211.0.0.0/10
	ip route del 211.72.0.0/13
	ip route del 211.104.0.0/13
	ip route del 211.112.0.0/12
	ip route del 211.128.0.0/13
	ip route del 211.168.0.0/13
	ip route del 211.176.0.0/12
	ip route del 211.192.0.0/10
	ip route del 212.0.0.0/6
	ip route del 216.0.0.0/7
	ip route del 218.128.0.0/10
	ip route del 218.248.0.0/13
	ip route del 219.0.0.0/9
	ip route del 219.160.0.0/11
	ip route del 219.192.0.0/12
	ip route del 219.208.0.0/13
	ip route del 220.0.0.0/9
	ip route del 220.128.0.0/11
	ip route del 220.208.0.0/12
	ip route del 220.224.0.0/13
	ip route del 221.124.0.0/14
	ip route del 221.184.0.0/13
	ip route del 222.0.0.0/12
	ip route del 222.164.0.0/14
	ip route del 223.16.0.0/12
	ip route del 223.32.0.0/11
	ip route del 223.118.0.0/15
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
