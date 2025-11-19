# Hetzner Deployment - Ultra Quick Start

## 🚀 5-Minute Deployment

### Step 1: Create Hetzner Server (2 minutes)

1. Go to: https://console.hetzner.cloud/
2. Create new server:
   - **Image**: Ubuntu 22.04 LTS
   - **Type**: CPX31 (4 vCPU, 16GB RAM) - ~€30/month
   - **Location**: Closest to you
   - **SSH Key**: Add your public key
   - **Name**: cyber-defense-llm
3. Click "Create & Buy Now"
4. **Copy the IP address**: `65.21.123.45` (example)

### Step 2: Setup Server (2 minutes)

**On your local machine:**

```bash
# SSH into server (replace IP)
ssh root@65.21.123.45

# Download and run setup script
curl -fsSL https://raw.githubusercontent.com/your-repo/492-energy-defense/main/QUICK_HETZNER_SETUP.sh | sudo bash

# Switch to cyber user
su - cyber
```

### Step 3: Deploy Application (1 minute)

**On your local machine** (in project directory):

```bash
# Make script executable
chmod +x DEPLOY_TO_HETZNER.sh

# Deploy (replace IP)
./DEPLOY_TO_HETZNER.sh 65.21.123.45 cyber
```

**Done!** 🎉

---

## Verify It's Working

```bash
# Check health (replace IP)
curl http://65.21.123.45:8000/health | jq

# Should see:
{
  "status": "healthy",
  "mode": "LLM",
  ...
}
```

---

## Manual Method (If Scripts Don't Work)

### 1. SSH to Server

```bash
ssh root@<YOUR_SERVER_IP>
```

### 2. Install Docker

```bash
# Update system
apt update && apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt install -y docker-compose-plugin
```

### 3. Upload Your Code

**On your local machine:**

```bash
# Create archive
tar czf deploy.tar.gz agent/ backend/ docker-compose.yml

# Upload to server (replace IP)
scp deploy.tar.gz root@<YOUR_IP>:~/
```

**On server:**

```bash
# Extract
mkdir -p ~/492-energy-defense
cd ~/492-energy-defense
tar xzf ~/deploy.tar.gz
```

### 4. Start Services

```bash
cd ~/492-energy-defense

# Start everything
docker compose up -d

# Watch logs
docker logs -f ollama-init  # Wait for "Mistral model ready!"
docker logs -f cyber-agent   # Watch LLM analysis
```

### 5. Open Firewall

```bash
# Allow traffic
ufw allow 22/tcp
ufw allow 8000/tcp
ufw --force enable
```

---

## Test It

```bash
# From your local machine (replace IP)
curl -X POST http://<YOUR_IP>:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "admin",
      "status": "FAIL",
      "is_admin": true,
      "is_suspicious_ip": true,
      "is_burst_failure": true
    }
  }' | jq
```

You should get an LLM-powered analysis!

---

## Cost

- **CPX31** (recommended): €30/month
- **CPX21** (budget): €15/month (may be slow)
- **First 20 hours free** on new accounts!

---

## Troubleshooting

### Can't connect via HTTP

```bash
# On server, check firewall
sudo ufw status

# Allow port
sudo ufw allow 8000/tcp
```

### Services not starting

```bash
# Check logs
docker compose logs

# Restart
docker compose restart
```

### Out of memory

```bash
# Check memory
free -h

# If low, upgrade server or reduce Ollama memory limit
nano docker-compose.yml
# Change: memory: 6G (under ollama)
docker compose restart
```

---

## Next Steps

1. **Monitor logs**: `docker logs -f cyber-agent`
2. **Wait for events**: Generated every 30 minutes
3. **View database**: See `HETZNER_DEPLOYMENT_GUIDE.md` Step 9

---

## Full Documentation

For complete step-by-step guide with all details:
→ See `HETZNER_DEPLOYMENT_GUIDE.md`
