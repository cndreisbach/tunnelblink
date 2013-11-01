#!/bin/sh

CONF=/etc/tinyproxy.conf

sudo sed -i.old \
	-e 's/#Allow 10.0.0.0\/8/Allow 10.0.0.0\/8/' \
	-e '/ConnectPort 5222/d' \
	-e '/ConnectPort 563/aConnectPort 5222' \
	$CONF