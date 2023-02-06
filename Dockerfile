FROM alpine

RUN apk add --no-cache bash busybox curl iftop iperf iperf3 iptraf-ng jq open-lldp screen tcpdump wget
COPY entrypoint.sh /
COPY iperf-wrapper.sh /

### Defaults ###
#ENV LLDP_SERVER=1
#ENV IPERF_SERVER=1
#
# Setting IPERF_SRVIP starts a screen tab with an iperf3 client that connects to it. 
#ENV IPERF_SRVIP=""
#
#ENV IPERF_RATE="1M"
#ENV IPERF_MSS="1300"
#ENV IPERF_BIDIR="yes"
#ENV IPERF_OPTIONS=""

ENTRYPOINT ["/entrypoint.sh"]
