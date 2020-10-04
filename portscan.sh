#!/bin/bash
# Stealthy port scanner - by Tengku Zahasman
# Uses netcat to test TCP connection based on given port range
# Scans random ports each time with random delayed timing (default between 5 - 10 secs)
# Usage: ./portscan.sh <target IP> <start port> <end port>

#Configure test delays (in seconds) 
mindelay=5
maxdelay=10

target=$1
minport=$2
maxport=$3

if [ -z $1 ] || [ -z $2 ] || [ -z $3 ]
then
        echo "Usage: ./portscan.sh <target IP> <start port> <end port>"
        exit
fi

rand=( $(seq $minport $maxport | sed -r 's/(.[^;]*;)/ \1 /g' | tr " " "\n" | shuf | tr -d " " ) )

#for J in $(seq 0 ${#rand[@]}); do echo ${rand[$J]}; done
echo "Starting scan ...."

for I in $(seq 0 $((${#rand[@]}-1))); do 

        currentport=${rand[$I]}

        if ($( nc -z -c exit $target $currentport ))
        then
                echo "Port $currentport open"
        else
                echo "Port $currentport closed"
        fi

        if [ $I -ne $((${#rand[@]}-1)) ]
        then
                sleeptime=$(( $mindelay + RANDOM % (1+$maxdelay-$mindelay) ))

                echo "Sleeping for $sleeptime seconds"
                sleep $sleeptime
        else
                echo "Scan complete!"
        fi
done
