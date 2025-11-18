#!/bin/bash
set -euxo pipefail

GENESIS_FILE="${GENESIS_FILE:-/app/sepolia-genesis.json}"
DATA_DIR="${GETH_DATADIR:-/app/data}"
RPC_PORT="${GETH_HTTP_PORT:-8545}"
WS_PORT="${GETH_WS_PORT:-8546}"
AUTHRPC_PORT="${GETH_AUTHRPC_PORT:-8551}"
METRICS_PORT="${GETH_METRICS_PORT:-6060}"
ROLLUP_SEQUENCER_HTTP="${GETH_ROLLUP_SEQUENCERHTTP}"
DISCOVERY_PORT="${GETH_DISCOVERY_PORT:-30303}"
P2P_PORT="${GETH_PORT:-30303}"

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
  --authrpc.jwtsecret="$OP_NODE_L2_ENGINE_AUTH" \
  --metrics=0.0.0.0:"$METRICS_PORT" \
  --max-outbound-peers=100 \
  --chain "$GENESIS_FILE" \
  --rollup.sequencer-http="$ROLLUP_SEQUENCER_HTTP" \
  --rollup.disable-tx-pool-gossip \
  --discovery.port="$DISCOVERY_PORT" \
  --port="$P2P_PORT"
