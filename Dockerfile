FROM alpine:latest

RUN apk update
RUN apk add iptables iproute2 curl openresolv wireguard-tools bash grep

COPY startup.sh /.

ENV VPN_IP=""
ENV VPN_CHECK_IP=""
ENV VPN_CONF=""

ENTRYPOINT ["/startup.sh"]
