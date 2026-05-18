# GIWA Node FAQ

Frequently Asked Questions about running and operating a GIWA node.

## Table of Contents

- [General Questions](#general-questions)
- [Getting Started](#getting-started)
- [Hardware & Infrastructure](#hardware--infrastructure)
- [Costs](#costs)
- [Operations & Maintenance](#operations--maintenance)
- [Performance](#performance)
- [Security](#security)
- [Troubleshooting](#troubleshooting)

---

## General Questions

### What is GIWA?

**GIWA** (Global Infrastructure for Web3 Access) is an Ethereum Layer 2 network built on Optimism's OP Stack. It's backed by UPbit and designed to provide fast, secure, scalable infrastructure for Web3 applications.

### Why should I run a GIWA node?

Running a node:
- ✅ Supports network decentralization
- ✅ Provides trustless access to the blockchain
- ✅ Enables you to run your own RPC endpoint
- ✅ Contributes to network security
- ✅ Required if you're building dApps on GIWA

### What's the difference between Testnet and Mainnet?

| Feature | Testnet (Sepolia) | Mainnet |
|---------|-------------------|---------|
| Status | ✅ Live | 🚧 Coming Soon |
| Purpose | Testing & Development | Production |
| Tokens | Free (from faucet) | Real value |
| Reset | May be reset | Permanent |
| Hardware | Lower requirements | Higher requirements |

---

## Getting Started

### What do I need to run a node?

**Minimum requirements:**
- 4 CPU cores (8+ recommended)
- 8GB RAM (16GB+ recommended)
- 500GB SSD/NVMe storage (1TB+ recommended)
- 100+ Mbps network connection
- Docker & Docker Compose installed
- Access to Ethereum L1 RPC endpoint

### Which execution client should I use?

We support two options:

**Reth (Recommended):**
- ✅ Faster sync times
- ✅ Lower resource usage
- ✅ Better performance
- ✅ Rust-based (more modern)
- ✅ Flashblocks support

**Geth:**
- ✅ Battle-tested
- ✅ More widely known
- ✅ Stable

**Recommendation:** Start with `reth` unless you have specific requirements for `geth`.

### How long does initial sync take?

**With Snapshot (Recommended):** 2-6 hours
**Without Snapshot (Full Sync):** 1-3 days

**Pro tip:** Always use snapshots! Follow the [Snapshot Guide](https://docs.giwa.io/node-operators/snapshots).

### Do I need a full Ethereum L1 node?

No! You can use:
- 🔷 **RPC Services:** Alchemy, Infura, Quicknode (easiest)
- 🔷 **Public Endpoints:** Free but rate-limited
- 🔷 **Your Own L1 Node:** Most decentralized but requires significant resources

---

## Hardware & Infrastructure

### Can I run a node on cloud services?

Yes! Popular options:

**AWS:**
- t3.xlarge or larger
- 500GB+ EBS SSD
- ~$150-300/month

**Google Cloud:**
- n2-standard-4 or larger
- 500GB+ SSD persistent disk
- ~$150-300/month

**Hetzner/OVH:**
- Dedicated servers
- Often cheaper than AWS/GCP
- ~$50-150/month

### Can I run on a Raspberry Pi?

**Not recommended.** GIWA nodes require:
- High-performance SSD/NVMe
- Significant CPU power
- At least 8GB RAM

Raspberry Pi lacks the performance for smooth operation.

### SSD vs HDD?

**⚠️ SSD/NVMe is REQUIRED.**

- ❌ **HDD:** Will NOT work - too slow for blockchain sync
- ⚠️ **SATA SSD:** Minimum acceptable, may cause delays
- ✅ **NVMe SSD:** Recommended for best performance

### How much disk space do I need?

**Current (May 2026):**
- Testnet: ~200GB used
- Mainnet: TBD (not yet launched)

**Recommendations:**
- Testnet: 500GB (1TB preferred)
- Mainnet: 1TB minimum (2TB+ recommended)

**Growth rate:** ~50-100GB per month (estimate)

---

## Costs

### How much does it cost to run a node?

**Monthly costs breakdown:**

**Home Setup:**
- Hardware (one-time): $800-2000
- Electricity: $10-30/month
- Internet: Included in home plan
- **Total: $10-30/month** (after initial investment)

**Cloud Hosting:**
- VPS/Dedicated Server: $50-300/month
- L1 RPC Service: $0-100/month
- Bandwidth: Usually included
- **Total: $50-400/month**

### Are there ongoing costs besides hardware?

Yes:
- **L1 RPC Endpoint:** $0-100/month (if using paid service)
- **Electricity:** $10-30/month (home) / included (cloud)
- **Internet:** Usually free with existing connection
- **Maintenance Time:** Your time for updates & monitoring

### Can I monetize my node?

Currently:
- ❌ No direct block rewards (L2 sequencer runs separately)
- ✅ Can offer RPC services to others (paid)
- ✅ Use for your own dApps (saves RPC costs)
- ✅ Network contribution (community value)

---

## Operations & Maintenance

### How do I update my node?

```bash
# Stop current node
docker compose down

# Pull latest changes
git pull origin main

# Rebuild images
CLIENT=reth docker compose build --parallel

# Start updated node
CLIENT=reth NETWORK_ENV=.env.sepolia docker compose up -d

# Check logs
docker compose logs -f
```

### How often should I update?

- **Security updates:** Immediately
- **Feature updates:** Within 1-2 weeks
- **Minor updates:** When convenient

**Monitor:** https://github.com/giwa-io/node/releases

### Should I backup my node data?

**Execution Layer Data:** Not necessary
- Can resync from network
- Use snapshots for quick recovery

**Configuration Files:** YES!
- `.env` files
- Custom configs
- Private keys (if any)

### How do I monitor node health?

```bash
# Check container status
docker compose ps

# Watch real-time logs
docker compose logs -f

# Check sync status
# (RPC call to your node)
curl -X POST http://localhost:8545 \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}'
```

**Pro tip:** Set up Prometheus + Grafana for advanced monitoring.

---

## Performance

### My sync is very slow, what can I do?

1. **Use snapshots** - reduces sync time by 90%
2. **Switch to reth** - faster than geth
3. **Improve disk I/O** - use NVMe instead of SATA SSD
4. **Better internet** - at least 100Mbps
5. **More peers** - see issue #13 for trusted peers
6. **Check L1 RPC** - slow L1 endpoint = slow sync

### How do I improve RPC response times?

1. **More RAM** - increase cache sizes
2. **NVMe storage** - faster read/write
3. **Better CPU** - faster block processing
4. **Dedicated machine** - no other services competing
5. **Optimize configs** - see performance tuning guide (coming soon)

### What's normal resource usage?

**During Sync:**
- CPU: 200-400% (multiple cores)
- RAM: 6-12GB
- Disk I/O: High (constant writes)
- Network: 10-50 Mbps

**After Sync (Idle):**
- CPU: 50-150%
- RAM: 4-8GB
- Disk I/O: Medium (periodic)
- Network: 1-10 Mbps

---

## Security

### What ports should I expose?

**Required (outbound only):**
- 443 (HTTPS) - L1 RPC, downloads
- 30303 (TCP/UDP) - P2P networking

**Optional (if providing RPC service):**
- 8545 (HTTP RPC) - only if needed externally
- 8546 (WebSocket RPC) - only if needed externally

**⚠️ Never expose RPC ports publicly without authentication!**

### How do I secure my node?

1. **Firewall:** Use `ufw` or cloud security groups
2. **No Public RPC:** Don't expose 8545/8546 publicly
3. **Updates:** Keep Docker and OS updated
4. **Monitoring:** Watch for unusual activity
5. **Backups:** Back up configuration files
6. **SSH:** Use key-based auth, disable password login

### Do I need to worry about DDoS?

**If RPC is private:** Low risk
**If RPC is public:** Higher risk

**Protection:**
- Use rate limiting (nginx/caddy)
- Whitelist known IPs
- Use cloud DDoS protection (Cloudflare)
- Don't advertise your node IP publicly

---

## Troubleshooting

### My node won't start

See detailed guide: [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)

**Quick checks:**
```bash
# Check Docker is running
sudo systemctl status docker

# Check logs for errors
docker compose logs

# Verify config
cat .env.sepolia
```

### "Out of disk space" error

```bash
# Check usage
df -h
du -sh ./${DATA_DIR}

# Free space by pruning Docker
docker system prune -a

# Resize disk (cloud)
# Or add external volume
```

### Node is synced but no peers

```bash
# Check P2P port
sudo ufw status
sudo ufw allow 30303/tcp
sudo ufw allow 30303/udp

# Check logs
docker compose logs -f giwa-cl | grep peer

# Request trusted peers in issue #13
```

### How do I completely reset and start over?

```bash
# ⚠️ WARNING: Deletes all data!

# Stop and remove everything
docker compose down -v

# Delete data directory
rm -rf ./reth_data  # or ./geth_data

# Start fresh
CLIENT=reth NETWORK_ENV=.env.sepolia docker compose up -d

# Use snapshot to speed up resync
```

---

## Additional Resources

- 📖 **Documentation:** https://docs.giwa.io
- 🐙 **GitHub:** https://github.com/giwa-io/node
- 🆇 **X/Twitter:** [@giwachain](https://x.com/giwachain)
- 📧 **Email:** support@giwa.io
- 💬 **Discord:** Coming Soon

### Useful Links

- [Snapshot Guide](https://docs.giwa.io/node-operators/snapshots)
- [Troubleshooting Guide](./TROUBLESHOOTING.md)
- [GitHub Issues](https://github.com/giwa-io/node/issues)
- [Testnet Explorer](https://sepolia-explorer.giwa.io)
- [Testnet Faucet](https://faucet.giwa.io)

---

## Contributing

Found an error? Have a question not covered here?

- Open an issue: https://github.com/giwa-io/node/issues
- Submit a PR with improvements
- Ask in community channels

---

**Last Updated:** May 2026  
**Maintained by:** GIWA Community
