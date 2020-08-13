# docker-wireroute

Route your docker containers through WireGuard!

## Environmental Variables

`VPN_CONF` - The name of your Wireguard config (without the `.conf`), in `/etc/wireguard` (**REQUIRED**)
`VPN_IP` - The public IP address that a VPN connection will have.
`VPN_CHECK_IP` - Whether to automatically check to see if your VPN is actually connected or not. Uses `VPN_IP`, and if it is not specified, will pull it from the wireguard config.

## Example

```yaml
version: "3"
services:
  wireguard:
    image: aspenluxxxxy/wireroute
    container_name: wireguard
    restart: "unless-stopped"
    privileged: true
    sysctls:
      net.ipv4.conf.all.rp_filter: 2
    cap_add:
      - net_admin
	    - sys_module
	volumes:
		- ./example-vpn.conf:/etc/wireguard/example-vpn.conf:ro
	environment:
		CHECK_VPN_IP: 1
		VPN_IP: 1.2.3.4
		VPN_CONF: example-vpn
  ports:
    - "8080:8080"
  qbittorrent:
    image: linuxserver/qbittorrent
    container_name: qbittorrent
    environment:
      - PUID=1000
      - PGID=1000
      - UMASK_SET=022
      - WEBUI_PORT=8080
    volumes:
      - ./config:/config
      - ./downloads:/downloads
    restart: unless-stopped
    network_mode: "service:wireguard"
    depends_on:
      - wireguard
```

## Credits

The Dockerfile and startup.sh are derived from those on [Nick Babcock's blog post](https://nbsoftsolutions.com/blog/routing-select-docker-containers-through-wireguard-vpn).
