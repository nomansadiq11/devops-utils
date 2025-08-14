# Network Troubleshoot tools

Test the packets and latency

```bash
brew install nmap

# test
nping --tcp -p 3389 <RDP_SERVER_IP> --count 1000

```

traceroute + continuous ping using TCP packets.

```bash
brew install mtr

# test
mtr -P 443 --tcp 10.143.200.53

```

Measures TCP or UDP throughput.

```bash
brew install iperf3

# Test
iperf3 -c <server-ip>

```

Test the `TCP` connections

```bash
brew install tcping

# Like this
tcping 10.143.200.53 443

```

Script it built for traceroute

```bash
#!/bin/bash

# Remote Desktop server IP or hostname
TARGET="serverip"
PORT=3389

# Output log file
LOGFILE="rdp_latency_log.csv"

# Create log file with headers if it doesn't exist
if [ ! -f "$LOGFILE" ]; then
    echo "Timestamp,Hop,Loss%,Sent,Last(ms),Avg(ms),Best(ms),Worst(ms),StdDev" > "$LOGFILE"
fi

# Run indefinitely
while true; do
    TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

    # Run MTR for TCP port 3389 (one cycle, report mode)
    mtr -P "$PORT" --tcp -n -r -c 5 "$TARGET" | tail -n +2 | while read line; do
        echo "$TIMESTAMP,$line" >> "$LOGFILE"
    done

    # Wait before next check
    sleep 10
done

```
