#!/bin/bash
docker build -t hello-fluence .
# docker run -d -v $(pwd)/greeting:/greeting -v $(pwd)/greeting.aqua:/greeting.aqua --name fluence -e RUST_LOG="info" -p 7777:7777 -p 9999:9999 -p 5001:5001 -p 18080 hello-fluence
docker run -d -v $(pwd)/:/hello-fluence --name fluence -e RUST_LOG="info" -p 7777:7777 -p 9999:9999 -p 5001:5001 -p 18080 hello-fluence

echo -n "Starting Fluence..."
# Loop until there are 100 lines returned from the docker logs command
while [ $(docker logs fluence  2>&1 >/dev/null | wc -l) -lt 100 ]; do
    sleep 1
    echo -n "."
done
echo ''

out=$(docker logs fluence 2>&1 >/dev/null | head -n 100)
priv_key=$(echo "$out" | grep -o -e 'base64 = .*' | cut -d " " -f 3)
pub_key=$(echo "$out" | grep -o -e 'public key = .*' | cut -d " " -f 4)
peer_id=$(echo $out | grep -o -e 'peer id = .*' | cut -d " " -f 4)

docker exec -it -e PRIV_KEY="$priv_key" -e PUB_KEY="$pub_key" -e PEER_ID="$peer_id" fluence bash

echo "Shutting down Fluence..."
docker stop fluence && docker rm fluence