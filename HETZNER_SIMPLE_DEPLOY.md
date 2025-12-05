# Simple Hetzner Deployment (3 Steps)

## On Your Local Machine

### Step 1: Create Package
```bash
./create-deployment-package.sh
```

Creates: `cyber-defense-YYYYMMDD-HHMMSS.tar.gz`

### Step 2: Upload to Hetzner
```bash
scp cyber-defense-*.tar.gz root@YOUR_SERVER_IP:~/
```

Example:
```bash
scp cyber-defense-20251202-140530.tar.gz root@65.21.123.45:~/
```

---

## On Your Hetzner Server

### Step 3: Deploy
```bash
# Connect to server
ssh root@YOUR_SERVER_IP

# Run quick deploy script (included in package)
tar -xzf cyber-defense-*.tar.gz
cd 492-energy-defense
bash quick-deploy-hetzner.sh
```

**Done!** The script will:
- Install Docker if needed
- Extract files
- Configure firewall (optional)
- Start all services

---

## Manual Deployment (If Script Fails)

```bash
# 1. Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt install -y docker-compose-plugin

# 2. Extract and start
tar -xzf cyber-defense-*.tar.gz
cd 492-energy-defense
docker compose up -d

# 3. Watch model download
docker logs -f ollama-init
```

---

## Verify It Works

```bash
# Check containers
docker ps

# Test agent
curl http://localhost:8000/health

# Check model
docker exec ollama-qwen ollama list
```

---

## Access Services

### Local (on server)
- Agent: `http://localhost:8000`
- Dashboard: `http://localhost:3000`

### External (if firewall allows)
- Agent: `http://YOUR_SERVER_IP:8000`
- Dashboard: `http://YOUR_SERVER_IP:3000`

---

## Common Commands

```bash
# View logs
docker compose logs -f

# Restart
docker compose restart

# Stop
docker compose down

# Status
docker ps
```

---

## Recommended Server Specs

- **CPU**: 2-4 vCPU
- **RAM**: 4-8 GB
- **Storage**: 20-40 GB SSD
- **OS**: Ubuntu 22.04 LTS

---

## Total Time

- Package creation: 10 seconds
- Upload: 30 seconds - 2 minutes (depending on internet)
- Installation: 2-3 minutes
- Model download: 1-2 minutes

**Total: ~5 minutes** ⚡

---

## Troubleshooting

### Model scoring wrong?
```bash
# Switch to rule-based mode
nano docker-compose.yml
# Change: USE_LLM=false
docker compose restart agent
```

### Can't connect externally?
```bash
# Allow firewall
ufw allow 8000/tcp
ufw allow 3000/tcp
```

### Need to update?
```bash
# Create new package on local machine
./create-deployment-package.sh

# Upload and extract on server
scp cyber-defense-*.tar.gz root@YOUR_SERVER_IP:~/
ssh root@YOUR_SERVER_IP

cd 492-energy-defense
docker compose down
cd ..
tar -xzf cyber-defense-*.tar.gz
cd 492-energy-defense  
docker compose up -d
```

---

For detailed guide, see: `DEPLOY_HETZNER_TARBALL.md`
