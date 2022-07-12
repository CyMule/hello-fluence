#!/bin/bash

$(/init | tee out.txt)
out=$(cat out.txt | head -n 15)
priv_key=$(echo "$out" | grep -o -e 'base64 = .*' | cut -d " " -f 3)
pub_key=$(echo "$result" | grep -o -E '[a-zA-Z0-9-]+{32}' | sed -n '1 p')
peer_id=$(echo "$result" | grep -o -E '[a-zA-Z0-9-]+{32}' | sed -n '2 p')
# Set the variables in bashrc
{
    echo "export PRIV_KEY=$priv_key"
    echo "export PUB_KEY=$pub_key"
    echo "export PEER_ID=$peer_id"
} >> ~/.bashrc