#!/bin/bash
set -euo pipefail

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
JWT_SECRET="${RETH_AUTHRPC_JWTSECRET:-/shared/jwtsecret.key}"
BOOTNODES="${RETH_BOOTNODES}"
MAX_PEERS="${RETH_MAXPEERS:-100}"

ADDITIONAL_ARGS=""

if [[ ! -r "$JWT_SECRET" ]]; then
    echo "JWT secret file is missing or unreadable: $JWT_SECRET" >&2
    exit 1
fi
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
  --ws.origins="${RETH_WS_ORIGINS:-http://localhost,http://127.0.0.1}" \
  --ws.addr=0.0.0.0 \
  --ws.port="$WS_PORT" \
  --ws.api=web3,eth,net \
  --http \
  --http.corsdomain="${RETH_HTTP_CORS:-http://localhost,http://127.0.0.1}" \
  --http.addr=0.0.0.0 \
  --http.port="$RPC_PORT" \
  --http.api=web3,eth,net \
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
