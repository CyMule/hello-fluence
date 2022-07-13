#!/bin/bash

out=$(/init | tee out.txt)
echo hello > /hello.txt
out=$(cat out.txt | head -n 15)
priv_key=$(echo "$out" | grep -o -e 'base64 = .*' | cut -d " " -f 3)
pub_key=$(echo "$result" | grep -o -E '[a-zA-Z0-9-]+{32}' | sed -n '1 p')
peer_id=$(echo "$result" | grep -o -E '[a-zA-Z0-9-]+{32}' | sed -n '2 p')
# Set the variables in bashrc
{
    echo "export PRIV_KEY=$priv_key"
    echo "export PUB_KEY=$pub_key"
    echo "export PEER_ID=$peer_id"
} >> /root/.bashrc

# [2022-07-13T01:25:30.443356Z WARN  server_config::defaults] New management key generated. ed25519 private key in base64 = gF8BmDqZpoaUaJhZopl3pKJdb8UvpNSfL+Ym5l0m4v8=
# [2022-07-13T01:25:30.444285Z INFO  particle_node] AIR interpreter: "/.fluence/v1/aquamarine_0.24.16.wasm"
# [2022-07-13T01:25:30.444303Z INFO  particle_node] node public key = DvzmyEpt7fwTcQS6qTd5QZxy9DBEuW7cJJVxMMpaSeDS
# [2022-07-13T01:25:30.444314Z INFO  particle_node] node server peer id = 12D3KooWNkMwiNQbJaCx2HwXU4NRBN3odYDswCC6FtryjLyULawN
# [2022-07-13T01:25:30.447060Z INFO  particle_node::node] Fluence listening on ["/ip4/0.0.0.0/tcp/7777", "/ip4/0.0.0.0/tcp/9999/ws"]