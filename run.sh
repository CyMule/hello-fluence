#!/bin/bash

# Build the container image in the current directory
docker build -t hello-fluence .

# Start the fluence node and mount the current directory into the root of the container
docker run -d -v $(pwd)/:/hello-fluence --name fluence -e RUST_LOG="info" -p 7777:7777 -p 9999:9999 -p 5001:5001 -p 18080 hello-fluence

echo -n "Starting Fluence..."
# Loop until there are 100 lines returned from the docker logs command
# At that point the node should have output the private key, public key, and peer id
while [ $(docker logs fluence  2>&1 >/dev/null | wc -l) -lt 100 ]; do
    sleep 1
    echo -n "."
done
echo ''

# Parse the output of fluence node to extract the private key, public key, and peer id
out=$(docker logs fluence 2>&1 >/dev/null | head -n 100)
priv_key=$(echo "$out" | grep -o -e 'base64 = .*' | cut -d " " -f 3)
pub_key=$(echo "$out" | grep -o -e 'public key = .*' | cut -d " " -f 4)
peer_id=$(echo $out | grep -o -e 'peer id = .*' | cut -d " " -f 4)

# Start a shell inside the docker container and set the variables
docker exec -it -e PRIV_KEY="$priv_key" -e PUB_KEY="$pub_key" -e PEER_ID="$peer_id" fluence bash

echo "Shutting down Fluence..."
# Stop the node and remove the container
docker stop fluence && docker rm fluence