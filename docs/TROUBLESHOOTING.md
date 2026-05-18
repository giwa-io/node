# GIWA Node Troubleshooting Guide

This guide addresses common issues encountered when running a GIWA node.

## Table of Contents

- [Certificate Errors](#certificate-errors)
- [Link and Connection Issues](#link-and-connection-issues)
- [Docker Configuration Issues](#docker-configuration-issues)
- [Sync Problems](#sync-problems)
- [Network Connectivity](#network-connectivity)
- [Performance Issues](#performance-issues)

---

## Certificate Errors

### Issue #1: `x509: certificate signed by unknown authority`

**Problem:** Node fails to start with certificate validation errors.

**Symptoms:**
```
failed to verify certificate: x509: certificate signed by unknown authority
```

**Solutions:**

1. **Update CA Certificates:**
   ```bash
   # Ubuntu/Debian
   sudo apt-get update
   sudo apt-get install ca-certificates
   sudo update-ca-certificates

   # CentOS/RHEL
   sudo yum install ca-certificates
   sudo update-ca-trust
   ```

2. **Check System Time:**
   Incorrect system time can cause certificate validation failures.
   ```bash
   # Check current time
   date
   
   # Sync with NTP server
   sudo ntpdate -s time.nist.gov
   # or
   sudo timedatectl set-ntp true
   ```

3. **Docker-Specific Fix:**
   If running in Docker, ensure the container has access to host certificates:
   ```yaml
   volumes:
     - /etc/ssl/certs:/etc/ssl/certs:ro
     - /etc/ca-certificates:/etc/ca-certificates:ro
   ```

4. **Verify L1 RPC Endpoint:**
   Ensure your L1 RPC endpoint uses a valid SSL certificate.
   ```bash
   # Test the endpoint
   curl -v https://your-l1-rpc-endpoint
   ```

---

## Link and Connection Issues

### Issue #5: Link Errors / Faucet Link Issues

**Problem:** Cannot access testnet faucet or other linked resources.

**Solutions:**

1. **Verify Network Access:**
   - **Testnet Faucet:** Check https://faucet.giwa.io for availability
   - **Explorer:** Verify https://sepolia-explorer.giwa.io is accessible
   - **Documentation:** Ensure https://docs.giwa.io loads correctly

2. **Check Firewall Rules:**
   ```bash
   # Allow outbound HTTPS
   sudo ufw allow out 443/tcp
   
   # Check if ports are blocked
   telnet faucet.giwa.io 443
   ```

3. **DNS Resolution:**
   ```bash
   # Test DNS resolution
   nslookup faucet.giwa.io
   nslookup sepolia-explorer.giwa.io
   
   # Try alternative DNS
   # Edit /etc/resolv.conf and add:
   nameserver 8.8.8.8
   nameserver 1.1.1.1
   ```

4. **Regional Restrictions:**
   Some services may have regional restrictions. Try:
   - Using a VPN
   - Accessing from a different network
   - Contact support@giwa.io if issue persists

---

## Docker Configuration Issues

### Issue #6: TLS, Docker Configs, and Repo Housekeeping

**Problem:** Docker configuration errors or TLS issues.

**Common Issues & Solutions:**

#### **1. Docker TLS Errors**

**Problem:** Docker daemon connection failures
```bash
Error response from daemon: Get https://registry-1.docker.io/v2/
```

**Solution:**
```bash
# Restart Docker daemon
sudo systemctl restart docker

# Check Docker daemon status
sudo systemctl status docker

# Verify Docker is running without TLS errors
docker info
```

#### **2. Docker Compose Version Mismatch**

**Problem:** `docker-compose` syntax errors

**Solution:**
```bash
# Check Docker Compose version
docker-compose --version

# Upgrade if needed (should be v2+)
sudo apt-get update
sudo apt-get install docker-compose-plugin

# Or use Docker Compose V2 syntax
docker compose up -d  # Note: no hyphen
```

#### **3. Permission Issues**

**Problem:** `permission denied` when running Docker commands

**Solution:**
```bash
# Add user to docker group
sudo usermod -aG docker $USER

# Log out and back in, or run:
newgrp docker

# Verify
docker ps
```

#### **4. Port Conflicts**

**Problem:** `port is already allocated`

**Solution:**
```bash
# Check what's using the port
sudo lsof -i :8545  # RPC port
sudo lsof -i :30303 # P2P port

# Kill conflicting process or change port in .env
```

---

## Sync Problems

### Slow Initial Sync

**Problem:** Node takes very long to sync.

**Solutions:**

1. **Use Snapshot (Recommended):**
   - Follow the [Snapshot Guide](https://docs.giwa.io/node-operators/snapshots)
   - Reduces sync time from days to hours

2. **Enable Snap Sync:**
   ```bash
   # In your .env file, ensure snap sync is enabled
   # See README.md section "Sync Configuration"
   ```

3. **Check Peer Connections:**
   ```bash
   # Monitor logs for peer connections
   docker compose logs -f giwa-cl | grep "peer"
   
   # Low peer count? Request trusted peers in issue #13
   ```

4. **Verify Disk I/O:**
   ```bash
   # Check disk performance
   sudo hdparm -Tt /dev/sda  # Replace with your disk
   
   # Ensure you're using SSD/NVMe (required)
   ```

### Stuck Sync

**Problem:** Sync progress stops at a certain block.

**Solutions:**

1. **Restart Node:**
   ```bash
   docker compose down
   docker compose up -d
   ```

2. **Check Logs:**
   ```bash
   docker compose logs --tail=100 giwa-el
   docker compose logs --tail=100 giwa-cl
   ```

3. **Verify L1 Connection:**
   ```bash
   # Test L1 RPC endpoint
   curl -X POST -H "Content-Type: application/json" \
     --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' \
     $OP_NODE_L1_ETH_RPC
   ```

4. **Clear Corrupted Data:**
   ```bash
   # ⚠️ WARNING: This deletes all synced data
   docker compose down -v
   rm -rf ./${DATA_DIR}
   # Restore from snapshot or resync from genesis
   ```

---

## Network Connectivity

### Cannot Connect to L1

**Problem:** Node cannot reach L1 Ethereum RPC.

**Solutions:**

1. **Verify L1 Endpoints:**
   ```bash
   # Check .env configuration
   echo $OP_NODE_L1_ETH_RPC
   echo $OP_NODE_L1_BEACON
   
   # Test connectivity
   curl -s $OP_NODE_L1_ETH_RPC
   ```

2. **Rate Limiting:**
   - Free RPC endpoints have rate limits
   - Consider using paid services (Alchemy, Infura, Quicknode)
   - Or run your own L1 node

3. **Firewall:**
   ```bash
   # Ensure outbound connections are allowed
   sudo ufw status
   sudo ufw allow out 443/tcp  # HTTPS
   sudo ufw allow out 80/tcp   # HTTP
   ```

### P2P Connection Issues

**Problem:** No peers, isolated node.

**Solutions:**

1. **Check P2P Ports:**
   ```bash
   # Default ports: 30303 (TCP/UDP)
   sudo ufw allow 30303/tcp
   sudo ufw allow 30303/udp
   
   # Verify port is listening
   sudo netstat -tulpn | grep 30303
   ```

2. **Add Trusted Peers:**
   - See issue #13 for trusted peer list
   - Add to your node configuration

3. **Check NAT/Router:**
   - Enable port forwarding on your router
   - Forward port 30303 to your node's IP

---

## Performance Issues

### High CPU Usage

**Solutions:**

1. **Use Reth (Faster):**
   ```bash
   CLIENT=reth docker compose up -d
   ```

2. **Reduce Logging:**
   ```bash
   # In .env, set log level
   RUST_LOG=info  # instead of debug/trace
   ```

3. **Allocate More Resources:**
   ```yaml
   # docker-compose.yml
   services:
     giwa-el:
       deploy:
         resources:
           limits:
             cpus: '4'
             memory: 16G
   ```

### High Memory Usage

**Solutions:**

1. **Increase Swap:**
   ```bash
   # Create 8GB swap file
   sudo fallocate -l 8G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   
   # Make permanent
   echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
   ```

2. **Reduce Cache Size:**
   ```bash
   # In .env, adjust cache settings
   # See client-specific documentation
   ```

### Disk Space Issues

**Solutions:**

1. **Monitor Disk Usage:**
   ```bash
   df -h
   du -sh ./${DATA_DIR}/*
   ```

2. **Prune Old Data:**
   ```bash
   # For archive nodes only
   # ⚠️ Don't prune if you need historical state
   ```

3. **Use Larger Disk:**
   - Testnet: 500GB minimum, 1TB recommended
   - Mainnet: 1TB minimum, 2TB+ recommended

---

## Getting Help

If you're still experiencing issues:

1. **Check Logs:**
   ```bash
   docker compose logs -f --tail=100
   ```

2. **Search Existing Issues:**
   - https://github.com/giwa-io/node/issues

3. **Create New Issue:**
   - Include: OS, Docker version, error logs, steps to reproduce

4. **Community Support:**
   - 🆇 X: [@giwachain](https://x.com/giwachain)
   - 📧 Email: support@giwa.io
   - 💬 Discord: Coming Soon

---

## Appendix: Useful Commands

```bash
# Check node health
docker compose ps
docker compose logs -f giwa-el --tail=50
docker compose logs -f giwa-cl --tail=50

# Resource usage
docker stats

# Restart services
docker compose restart giwa-el
docker compose restart giwa-cl

# Full reset
docker compose down -v && rm -rf ./${DATA_DIR}

# Update to latest
git pull origin main
CLIENT=reth docker compose build --parallel
CLIENT=reth NETWORK_ENV=.env.sepolia docker compose up -d
```

---

**Last Updated:** May 2026  
**Contributors:** GIWA Community
