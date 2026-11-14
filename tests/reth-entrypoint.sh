#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
entrypoint=${1:-"$repo_dir/reth/entrypoint.sh"}
tmp_dir=$(mktemp -d)
trap 'rm -f -- "$tmp_dir/op-reth" "$tmp_dir/args"; rmdir -- "$tmp_dir"' EXIT

# Capture argv instead of starting an execution client or connecting to a network.
cat > "$tmp_dir/op-reth" <<'EOF'
#!/usr/bin/env bash
printf '%s\0' "$@" > "$GIWA_TEST_ARGS"
EOF
chmod +x "$tmp_dir/op-reth"
export PATH="$tmp_dir:$PATH" GIWA_TEST_ARGS="$tmp_dir/args"

export GENESIS_FILE=test-genesis.json RETH_DATADIR=/app/data
export RETH_HTTP_PORT=8545 RETH_WS_PORT=8546 RETH_AUTHRPC_PORT=8551
export RETH_METRICS_PORT=6060 RETH_PORT=30303 RETH_DISCOVERY_PORT=30303
export RETH_ROLLUP_SEQUENCERHTTP=https://sequencer.example.invalid
export RETH_AUTHRPC_JWTSECRET=/shared/test.key RETH_BOOTNODES=test-bootnode
export RETH_MAXPEERS=12

run_entrypoint() {
    bash "$entrypoint" "$@" > /dev/null 2>&1
    mapfile -d '' -t actual < "$GIWA_TEST_ARGS"
}

check_forwarded_args() {
    local -a extra=("$@")
    run_entrypoint "${extra[@]}"
    if (( ${#actual[@]} != ${#defaults[@]} + ${#extra[@]} )); then
        echo "FAIL: extra arguments were not forwarded ($RETH_GCMODE, flashblocks=$FLASHBLOCKS_WEBSOCKET_URL)" >&2
        exit 1
    fi
    local i
    for ((i = 0; i < ${#defaults[@]}; i++)); do
        [[ "${actual[i]}" == "${defaults[i]}" ]] || {
            echo "FAIL: default argument $i changed" >&2
            exit 1
        }
    done
    for ((i = 0; i < ${#extra[@]}; i++)); do
        [[ "${actual[${#defaults[@]} + i]}" == "${extra[i]}" ]] || {
            echo "FAIL: extra argument $i changed" >&2
            exit 1
        }
    done
}

for mode in full archive; do
    for flashblocks in '' wss://flashblocks.example.invalid/ws; do
        export RETH_GCMODE="$mode" FLASHBLOCKS_WEBSOCKET_URL="$flashblocks"
        run_entrypoint
        defaults=("${actual[@]}")
        [[ "${defaults[0]}" == node ]]
        full_flags=0
        flashblocks_flags=0
        for arg in "${defaults[@]}"; do
            [[ "$arg" != --full ]] || full_flags=$((full_flags + 1))
            [[ "$arg" != --flashblocks-url=* ]] || flashblocks_flags=$((flashblocks_flags + 1))
        done
        [[ "$full_flags" == "$([[ "$mode" == full ]] && echo 1 || echo 0)" ]]
        [[ "$flashblocks_flags" == "$([[ -n "$flashblocks" ]] && echo 1 || echo 0)" ]]
        check_forwarded_args --help
        check_forwarded_args --ipcpath 'path with spaces [and]*glob' '' '--log.file.directory=another path'
        printf 'PASS: %s, flashblocks=%s\n' "$mode" "${flashblocks:-disabled}"
    done
done
