FROM alpine

RUN apk add --no-cache bash busybox curl iftop iperf iperf3 iptraf-ng jq open-lldp openrc tcpdump wget
COPY lldpad-post /etc/init.d/
RUN sed -i 's/^tty.*//; s/^#.*//;/^$/d' /etc/inittab; rc-update add lldpad; rc-update add lldpad-post

ENTRYPOINT ["/sbin/init"]
#ENTRYPOINT ["/bin/sh"]
