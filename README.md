# mfdhost
Alpine based container with LLDP, iperf3, screen, and basic network tools

## Notes
- Defaults start lldpad in the background and iperf3 server in a screen tab
- A screen shell tab will display non-loopback IP addresses on the container.
- Environment variables can be used to control the iperf3 client
- Setting IPERF_SRVIP starts a screen tab with an iperf3 client connection to the IP.
- If run, the iperf3 client default is to run with a 1300 byte MSS and bidirectional 1Mbit traffic

## Environment variable defaults
- LLDP_SERVER=1
- IPERF_SERVER=1
- IPERF_SRVIP=""
- IPERF_RATE="1M"
- IPERF_MSS="1300"
- IPERF_BIDIR="yes"
- IPERF_OPTIONS=""

## Packages
- bash
- busybox
- curl
- iftop
- iperf
- iperf3
- iptraf-ng
- jq
- lldpad
- openrc
- tcpdump
- wget
