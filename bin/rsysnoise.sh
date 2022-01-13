#!/bin/bash

#
#   Close STDIN and STDOUT.
#
exec 1>/dev/null
exec 2>/dev/null

#
#   Random number of fake services.
#
QSRV=$(shuf -i 5-30 -n 1)

#
#   Last fake services array index.
#
LSRV=$( expr $QSRV - 1 )

#
#   Generate fake services array.
#
for (( i=0; i < $QSRV; i++))
do
    SERVICES+=("FAKE_SRV_$i")
done

#
#   Main loop.
#
while [ true ]
do
#
#   Random length of log string between 32 and 256.
#
    LSTR=$(shuf -i 32-256 -n 1)

#
#   Select random fake service name from array.
#
    SSRV=$(shuf -i 0-${LSRV} -n 1)

#
#   Randon sleep time between 0 and 10 seconds.
#
    SLEEPTIME=$(shuf -i 0-10 -n 1)

#
#   Generate random log string.
#
    RANDSTR=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w $LSTR | head -n 1)

#
#   Log message.
#
    logger "${SERVICES[$SSRV]}: the time for $RANDSTR"

#
#   Sleep before next iteration.
#
    sleep $SLEEPTIME
done
