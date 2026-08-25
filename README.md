![GIWA](resources/logo.png)


# GIWA Node


**GIWA** is a Ethereum Layer 2 network built on Optimism's [OP Stack](https://stack.optimism.io/).  
This repository provides everything you need to run your own node on the GIWA network.

## 💡 Supported Networks

| Network           | Status |
|-------------------|--------|
| Mainnet           | 🚧     |
| Testnet (Sepolia) | ✅      |


## 🚀 Quick Start

1. Ensure you have an Ethereum L1 full node RPC available
2. Choose your network
    - For **mainnet**: *Coming soon – mainnet is currently under development.*
    - For **Testnet (Sepolia)**: Use `.env.sepolia`
3. Configure your L1 endpoints in the env file. You can also customize other runtime parameters (e.g. network, cache, logging, metrics) directly in the env file.
   ```bash
   OP_NODE_L1_ETH_RPC=<your-preferred-l1-eth-rpc>
   OP_NODE_L1_BEACON=<your-preferred-l1-beacon>
   ```
4. Build and run
   ```bash
   docker compose build --parallel
   NETWORK_ENV=<.env.{network}> docker compose up -d
   ```

5. Stop
    ```bash
    docker compose down
    ```

6. Cleanup
    ```bash
    docker compose down -v && rm -rf ./${DATA_DIR}
    ```


## 🛠️ Configuration

### Required Configuration

| Variable             | Description                        |
|----------------------|------------------------------------|
| `OP_NODE_L1_ETH_RPC` | Your Ethereum L1 node RPC endpoint |
| `OP_NODE_L1_BEACON`  | Your L1 beacon node endpoint       |

### Execution Client
GIWA nodes run [op-reth](https://github.com/ethereum-optimism/optimism/tree/main/rust/op-reth) as the execution client.

> [!NOTE]
> op-geth is no longer supported. It cannot follow GIWA once the Karst hardfork is active. See the [op-geth sunset notice](https://docs.giwa.io/notices/giwa-chain/op-geth-sunset).

### Sync Configuration

Choose one of the following sync strategies depending on your preference.
> Enable the corresponding **OPTION** block in your `.env.{network}` (only one at a time).

#### 1) Snap Sync — Fast & Practical
- **What it does:** Downloads a recent state snapshot and syncs to the current head without executing every historical block.
- **Use when:** You want to bring up a production/full node quickly (RPC nodes, followers).
- **Trade‑offs:** Fastest to get online; not suitable for deep historical state queries.

#### 2) Archive Sync — Full History
- **What it does:** Executes every block from genesis and **retains all historical state** (archive).
- **Use when:** You run an indexer, do research/debugging, or need historical state at arbitrary blocks.
- **Trade‑offs:** Significantly slower and requires much more disk; most operators don’t need this for day‑to‑day operations.

#### 3) Consensus‑Driven Sync — Trust‑Minimized
- **What it does:** The consensus client **drives** the execution client by inserting unsafe blocks; no L2 peer discovery required for the execution client.
- **Use when:** You prefer replay‑based syncing and tighter control (e.g. L2 verifier).
- **Trade‑offs:** Slower than snap; operationally simpler for controlled environments.

### Flashblocks (Optional)
To enable Flashblocks:

1. Edit your `.env.{network}` and uncomment:
   ```bash
   FLASHBLOCKS_WEBSOCKET_URL=
   ```

2. Run your node:
   ```bash
   NETWORK_ENV=<.env.{network}> docker compose up -d
   ```

## 💽 Persisting Data

By default, execution data is mounted to `{PROJECT_ROOT}/reth_data`.  
To customize the mount path, set the `$DATA_DIR` environment variable.


## ⚙️ Hardware Requirements

### Testnet

| Resource | Minimum       | Recommended |
|----------|---------------|-------------|
| CPU      | 4 cores       | 8+ cores    |
| RAM      | 8 GB          | 16+ GB      |
| Disk     | 500 GB (NVMe) | 1+ TB       |


## 🚀 Snapshot

For the fastest sync experience, you can restore from a snapshot instead of syncing from genesis.  
👉 **[Snapshot Guide](https://docs.giwa.io/node-operators/snapshots)** — Follow the step-by-step instructions to download and restore a snapshot.

## 🔗 Peers & Sync

Bootnodes for both the execution client (Reth) and the consensus client (op-node) are **pre-configured** in `.env.sepolia` — you don't need to add trusted peers manually for a standard setup:

- `RETH_BOOTNODES` — 3 execution-layer (P2P) bootnodes for Reth.
- `OP_NODE_P2P_BOOTNODES` — 3 consensus-layer (ENR) bootnodes for op-node.

### If your node is lagging behind the network

1. **Check your peer count** in the logs:
   ```bash
   docker compose logs -f giwa-el | grep -i peers
   docker compose logs -f giwa-cl | grep -i peers
   ```
   A healthy node should have several peers connected within a few minutes of startup. If peer count stays at 0, the issue is almost always network/firewall related, not the bootnode list itself.

2. **Make sure the P2P ports are reachable**, not just `HTTP`/`WS` RPC ports:
   - Reth (execution): `30303/tcp` and `30303/udp`
   - op-node (consensus): `9222/tcp` and `9222/udp`

   If you're running behind NAT, a cloud firewall, or a security group, these ports must be open for inbound/outbound traffic — otherwise your node can only reach a handful of peers (or none), which shows up as slow, lagging sync.

3. **Behind NAT / private IP?** Set `OP_NODE_P2P_ADVERTISE_IP` in your `.env.{network}` file to your node's public IP so other peers can dial back to you. This line is present but commented out by default.

4. **Snap sync still slow even with healthy peer count?** Consider restoring from the official [Snapshot Guide](https://docs.giwa.io/node-operators/snapshots) instead of syncing from genesis — this is the fastest path to a synced node.

## 🙋 Troubleshooting

- To check logs:
```bash
docker compose logs -f giwa-el
docker compose logs -f giwa-cl
```


## 🛑 Disclaimer

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND.  
By running this node, you are responsible for your infrastructure, security, and compliance.


## 🌐 Join the GIWA Community

- [📖 Documentation](https://docs.giwa.io)
- [🆇 X](https://x.com/giwachain)
- 💬 Discord: *Coming Soon*
