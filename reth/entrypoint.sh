#!/bin/bash
set -euxo pipefail

GENESIS_FILE="${GENESIS_FILE}"
DATA_DIR="${GETH_DATADIR}"
RPC_PORT="${GETH_HTTP_PORT}"
WS_PORT="${GETH_WS_PORT}"
AUTHRPC_PORT="${GETH_AUTHRPC_PORT}"
METRICS_PORT="${GETH_METRICS_PORT}"
P2P_PORT="${GETH_PORT}"
DISCOVERY_PORT="${GETH_DISCOVERY_PORT}"
ROLLUP_SEQUENCER_HTTP="${GETH_ROLLUP_SEQUENCERHTTP}"
PRUNING_MODE="${GETH_GCMODE}"
JWT_SECRET="${GETH_AUTHRPC_JWTSECRET}"
BOOTNODES="${GETH_BOOTNODES}"

ADDITIONAL_ARGS=""
if [[ "$PRUNING_MODE" == "full" ]]; then
  ADDITIONAL_ARGS="--full"
fi

if [[ -n "${FLASHBLOCKS_WEBSOCKET_URL:-}" ]]; then
    ADDITIONAL_ARGS="$ADDITIONAL_ARGS --flashblocks-url=$FLASHBLOCKS_WEBSOCKET_URL"
    echo "Running in flashblocks support mode"
else
    echo "Running in vanilla mode"
fi

exec op-reth node \
  --datadir="$DATA_DIR" \
  --ws \
  --ws.origins="*" \
  --ws.addr=0.0.0.0 \
  --ws.port="$WS_PORT" \
  --ws.api=web3,debug,eth,net,txpool \
  --http \
  --http.corsdomain="*" \
  --http.addr=0.0.0.0 \
  --http.port="$RPC_PORT" \
  --http.api=web3,debug,eth,net,txpool,miner \
  --authrpc.addr=0.0.0.0 \
  --authrpc.port="$AUTHRPC_PORT" \
  --authrpc.jwtsecret="$JWT_SECRET" \
  --metrics=0.0.0.0:"$METRICS_PORT" \
  --max-outbound-peers=100 \
  --chain="$GENESIS_FILE" \
  --rollup.sequencer-http="$ROLLUP_SEQUENCER_HTTP" \
  --rollup.disable-tx-pool-gossip \
  --discovery.port="$DISCOVERY_PORT" \
  --port="$P2P_PORT" \
  --bootnodes="$BOOTNODES" \
  $ADDITIONAL_ARGS
