#!/bin/bash

# Rebuild the rust code
./build.sh

result=$(aqua remote deploy_service \
     --addr /ip4/127.0.0.1/tcp/9999/ws/p2p/"$PEER_ID" \
     --config-path ./configs/greeting_deploy_cfg.json  \
     --service greeting \
     --sk "$PRIV_KEY")

# Parse the output of the deployment to get the blueprint & service id
BLUEPRINT_ID=$(echo "$result" | grep -o -E '[a-zA-Z0-9-]+{32}' | sed -n '1 p')
SERVICE_ID=$(echo "$result" | grep -o -E '[a-zA-Z0-9-]+{32}' | sed -n '2 p')



# Running aqua script from https://doc.fluence.dev/docs/tutorials_tutorials/tutorial_run_local_node
aqua run \
    -a /ip4/127.0.0.1/tcp/9999/ws/p2p/$PEER_ID \
    -i ./greeting.aqua \
    -f 'greeting("Fluence", "'$PEER_ID'", "'$SERVICE_ID'")'