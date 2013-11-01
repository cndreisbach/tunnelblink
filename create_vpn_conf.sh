#!/bin/sh

TBLK="/vagrant/vpn.tblk"
OVPN="$TBLK/Contents/Resources/config.ovpn"
CONF="/etc/openvpn/vpn.conf"

if [ -f $OVPN ]; then
	echo "Copying $OVPN to $CONF"
	sudo cp $OVPN $CONF
else
	echo "You must put a vpn.tblk file in the project directory."
fi
