#!/bin/bash
set -euxo pipefail

echo "WARNING: op-geth is deprecated and will stop following GIWA after the Karst hardfork."
echo "         Migrate to reth (CLIENT=reth). See: https://docs.giwa.io/notices/giwa-chain/op-geth-sunset"

if [ -n "${GENESIS_FILE-}" ]; then
  geth init "${GENESIS_FILE}"
fi

exec geth "$@"
