#!/usr/bin/env bash
SCREENRC="/root/.screenrc"
cat << EOF > /root/.bashrc
sleep 2
echo "IPs: "
ip -o addr show | cut -d' ' -f7| grep -v '127\|^::1' | cut -d'/' -f1
EOF

cat << EOF > $SCREENRC
startup_message off
defscrollback 1000
caption always "%{= bb}%{+b w}%n %t %h %=%l %H %c"
hardstatus alwayslastline "%-Lw%{= BW}%50>%n%f* %t%{-}%+Lw%<"
activity "Activity in %t(%n)"
shelltitle "shell"
EOF

if [ -z "$LLDP_SERVER" ] || [ ! "$LLDP_SERVER" == "0" ]; then
    echo "Starting lldpad"
    /usr/sbin/lldpad -d -f /etc/lldpad.conf
    #echo "screen -t lldp /usr/sbin/lldpad -f /etc/lldpad.conf" >> $SCREENRC
    LTOOL='/usr/sbin/lldptool'
    for net in `ls /sys/class/net/ | grep 'et\|en'`; do
        echo "Enabling LLDP on $net"
        $LTOOL set-lldp -i $net adminStatus=rxtx >/dev/null
        for tlv in `lldptool --h |grep -A100 "TLV identifiers:" | tail +2 | awk -F':' '{print $1}' | xargs`; do
            $LTOOL -T -i $net -V $tlv enableTx=yes >/dev/null
        done
    done
fi

if [ -z "$IPERF_SERVER" ] || [ ! "$IPERF_SERVER" == "no" ]; then
    echo "screen -t \"iperf-server\" /iperf-wrapper.sh server" >> $SCREENRC
    #echo "Starting iperf server"
    #echo "screen -t \"iperf3-server\" /usr/bin/iperf3 -s" >> $SCREENRC
fi

[ -z "$IPERF_RATE" ] && export IPERF_RATE="1M"
[ -z "$IPERF_RETRY_DELAY" ] && export IPERF_RETRY_DELAY="10"

[ -z "$IPERF_MSS" ] && export IPERF_MSS="1300"
if [ "$IPERF_MSS" == "yes" ]; then
    export IPERF_OPTIONS="${IPERF_OPTIONS} -M ${IPERF_MSS}"
fi

[ -z "$IPERF_BIDIR" ] && export IPERF_BIDIR="yes"
if [ "$IPERF_BIDIR" == "yes" ]; then
    export IPERF_OPTIONS="${IPERF_OPTIONS} --bidir"
fi

echo "screen -t shell bash" >> $SCREENRC

if [ "$IPERF_SRVIP" ]; then
    echo "screen -t \"iperf-client\" /iperf-wrapper.sh client" >> $SCREENRC
    #echo "Starting iperf client"
    #echo "screen -t \"iperf-client\" bash while [[ 1 ]]; do /usr/bin/iperf3 -c $IPERF_SRVIP -t 0 -b $IPERF_RATE$IPERF_OPTIONS; sleep $IPERF_RETRY_DELAY; done" >> $SCREENRC
    #echo "screen -t \"iperf-client\" /usr/bin/iperf3 -c $IPERF_SRVIP -t 0 -b $IPERF_RATE$IPERF_OPTIONS" >> $SCREENRC
fi

screen -c $SCREENRC
