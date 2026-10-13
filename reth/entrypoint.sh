#!/bin/bash
set -euxo pipefail

GENESIS_FILE="${GENESIS_FILE}"
DATA_DIR="${RETH_DATADIR}"
RPC_PORT="${RETH_HTTP_PORT}"
WS_PORT="${RETH_WS_PORT}"
AUTHRPC_PORT="${RETH_AUTHRPC_PORT}"
METRICS_PORT="${RETH_METRICS_PORT}"
P2P_PORT="${RETH_PORT}"
DISCOVERY_PORT="${RETH_DISCOVERY_PORT}"
ROLLUP_SEQUENCER_HTTP="${RETH_ROLLUP_SEQUENCERHTTP}"
PRUNING_MODE="${RETH_GCMODE}"
JWT_SECRET="${RETH_AUTHRPC_JWTSECRET}"
BOOTNODES="${RETH_BOOTNODES}"
MAX_PEERS="${RETH_MAXPEERS:-100}"
HTTP_API="${RETH_HTTP_API:-eth,net,web3}"
WS_API="${RETH_WS_API:-eth,net,web3}"

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
  --ws.api="$WS_API" \
  --http \
  --http.corsdomain="*" \
  --http.addr=0.0.0.0 \
  --http.port="$RPC_PORT" \
  --http.api="$HTTP_API" \
  --authrpc.addr=0.0.0.0 \
  --authrpc.port="$AUTHRPC_PORT" \
  --authrpc.jwtsecret="$JWT_SECRET" \
  --metrics=0.0.0.0:"$METRICS_PORT" \
  --max-outbound-peers="$MAX_PEERS" \
  --chain="$GENESIS_FILE" \
  --rollup.sequencer-http="$ROLLUP_SEQUENCER_HTTP" \
  --rollup.disable-tx-pool-gossip \
  --discovery.port="$DISCOVERY_PORT" \
  --port="$P2P_PORT" \
  --bootnodes="$BOOTNODES" \
  $ADDITIONAL_ARGS
