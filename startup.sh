#!/bin/bash
set -euo pipefail

if [ "$VPN_CONF" = "" ]
then
	echo "$(date): No VPN config specified, exiting!"
	exit 1
fi

wg-quick up $VPN_CONF
echo "$(date): VPN up!"

# Neatly bring down our VPN.
function finish {
    echo "$(date): Shutting down VPN!"
    wg-quick down $VPN_CONF
}

# Check to see if our IP is the right one.
function has_vpn_ip {
    curl --silent --show-error --retry 10 --fail https://ipinfo.io | grep $VPN_IP
}

trap finish TERM INT

if [ "$VPN_CHECK_IP" = "" ]
then
	echo "$(date): Not checking for VPN IP, idling!"
	tail -f /dev/null
else
	CONFIG_IP=$(grep -Po 'Endpoint\s=\s\K[^:]*' /etc/wireguard/$VPN_CONF.conf)
	if [ "$VPN_IP" = "" ]
	then
		VPN_IP="${CONFIG_IP}"
	fi

	while [[ has_vpn_ip ]]; do
		sleep 60;
	done
fi

echo "$(date): VPN IP address not detected!"
