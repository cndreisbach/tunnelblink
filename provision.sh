#!/bin/sh

sudo apt-get install -y -qq openvpn tinyproxy netcat

if [ ! -f /etc/openvpn/vpn.conf ]; then
	. /vagrant/create_vpn_conf.sh
fi

. /vagrant/setup_tinyproxy.sh