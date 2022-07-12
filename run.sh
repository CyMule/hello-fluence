#!/bin/bash

git clone https://github.com/fluencelabs/examples.git
cp examples/marine-examples/greeting/ /greeting -r
cp greeting.aqua /greeting/greeting.aqua

# [2022-07-12T21:24:21.481887Z WARN  server_config::defaults] New management key generated. ed25519 private key in base64 = b6UYuzFZHxgYsJ/bAFujMLM4EcRtSPgkikMlB3rk7Ig=
# [2022-07-12T21:24:21.483056Z INFO  particle_node] AIR interpreter: "/.fluence/v1/aquamarine_0.24.16.wasm"
# [2022-07-12T21:24:21.483081Z INFO  particle_node] node public key = HmTDLeLkJb55EobhnwZXSJE4PFDRhxmYyTBVGZdiQ93Z
# [2022-07-12T21:24:21.483096Z INFO  particle_node] node server peer id = 12D3KooWSapP5mvTVVLZeh78RYJsD6JtsaG4jer2w3YWeYncJ5mV
export PRIV_KEY=b6UYuzFZHxgYsJ/bAFujMLM4EcRtSPgkikMlB3rk7Ig=
export PUB_KEY=HmTDLeLkJb55EobhnwZXSJE4PFDRhxmYyTBVGZdiQ93Z
export PEER_ID=12D3KooWSapP5mvTVVLZeh78RYJsD6JtsaG4jer2w3YWeYncJ5mV

aqua remote list_modules \
     --addr /ip4/127.0.0.1/tcp/9999/ws/p2p/$PEER_ID

cd /greeting || exit

./build.sh

result=$(aqua remote deploy_service \
     --addr /ip4/127.0.0.1/tcp/9999/ws/p2p/$PEER_ID \
     --config-path configs/greeting_deploy_cfg.json  \
     --service greeting \
     --sk $PRIV_KEY)

# Now time to make a blueprint...
# Blueprint id:
# f66e40d9811acb892ae422813d2522f99553c66837615312ecf0f1851dce0e81
# And your service id is:
# "4236de0b-eabf-4d30-8c42-d79c6d5e8208"
blueprint=$(echo "$result" | grep -o -E '[a-zA-Z0-9-]+{32}' | sed -n '1 p')
service_id=$(echo "$result" | grep -o -E '[a-zA-Z0-9-]+{32}' | sed -n '2 p')
export BLUEPRINT_ID=$blueprint
export SERVICE_ID=$service_id

aqua remote get_interface \
     --addr /ip4/127.0.0.1/tcp/9999/ws/p2p/$PEER_ID \
     --id "$SERVICE_ID"

# Running aqua script from https://doc.fluence.dev/docs/tutorials_tutorials/tutorial_run_local_node
aqua run \
    -a /ip4/127.0.0.1/tcp/9999/ws/p2p/$PEER_ID \
    -i greeting.aqua \
    -f 'greeting("Fluence", "'$PEER_ID'", "'$SERVICE_ID'")'