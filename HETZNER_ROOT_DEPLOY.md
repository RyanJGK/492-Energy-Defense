# Hetzner Deployment with Root User & Password

This guide shows how to deploy using root user authentication (no SSH keys needed).

## Prerequisites

- Hetzner Cloud account
- Local machine with `scp` and `ssh` commands
- Server IP and root password

---

## Quick Deployment (5 Steps)

### Step 1: Create Deployment Package

On your **local development machine**:

```bash
./create-deployment-package.sh
```

This creates: `cyber-defense-agent.tar.gz` (~50MB)

---

### Step 2: Create Hetzner Server

1. Go to: https://console.hetzner.cloud/
2. Click "Add Server"
3. Configure:
   - **Location**: Choose closest to you
   - **Image**: Ubuntu → Ubuntu 22.04 LTS
   - **Type**: 
     - Minimum: CPX21 (3 vCPU, 8GB RAM) - €15/month
     - Recommended: CPX31 (4 vCPU, 16GB RAM) - €30/month
   - **Volume**: Not needed
   - **Network**: Default
   - **SSH Key**: Skip (we'll use password)
   - **Name**: cyber-defense-agent

4. Click "Create & Buy Now"
5. **IMPORTANT**: Note your server IP (e.g., 65.21.123.45)
6. **IMPORTANT**: Set/note your root password

---

### Step 3: Upload Package to Server

On your **local machine**:

```bash
# Replace YOUR_SERVER_IP with actual IP
scp cyber-defense-agent.tar.gz root@YOUR_SERVER_IP:/root/

# Enter root password when prompted
```

Example:
```bash
scp cyber-defense-agent.tar.gz root@65.21.123.45:/root/
# Password: [enter your root password]
```

---

### Step 4: Connect to Server

```bash
ssh root@YOUR_SERVER_IP
# Enter root password
```

You should now be connected to your Hetzner server.

---

### Step 5: Install and Run

On the **Hetzner server** (via SSH):

```bash
# Extract package
cd /root
tar -xzf cyber-defense-agent.tar.gz
cd cyber-defense-agent

# Install Docker (takes 1-2 minutes)
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version

# Start the application
docker-compose up -d

# Watch model download (1-2 minutes)
docker logs -f ollama-init
```

Wait until you see:
```
Qwen model ready!
```

Press `Ctrl+C` to exit logs.

---

## Configure Firewall

Still on the **server**:

```bash
# Install firewall
apt-get update
apt-get install -y ufw

# Allow ports
ufw allow 22/tcp    # SSH (important!)
ufw allow 3000/tcp  # Dashboard
ufw allow 8000/tcp  # API (optional)

# Enable firewall
ufw --force enable

# Check status
ufw status
```

---

## Verify Installation

On the **server**:

```bash
# Check all containers are running
docker ps

# Should see 5 containers:
# - cyber-events-db
# - ollama-qwen
# - cyber-agent
# - cyber-backend
# - cyber-dashboard

# Test agent
curl http://localhost:8000/health | jq

# Test event analysis
curl -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "test",
      "status": "SUCCESS",
      "timestamp": "2025-12-02T10:00:00",
      "is_admin": false
    }
  }' | jq
```

---

## Access from Your Computer

Open in your browser:

- **Dashboard**: `http://YOUR_SERVER_IP:3000`
- **API**: `http://YOUR_SERVER_IP:8000`
- **API Docs**: `http://YOUR_SERVER_IP:8000/docs`

Example with IP `65.21.123.45`:
- Dashboard: http://65.21.123.45:3000
- API: http://65.21.123.45:8000/docs

---

## Post-Installation

### View Logs

```bash
# All logs
docker-compose logs -f

# Specific service
docker logs -f cyber-agent
docker logs -f cyber-backend
docker logs -f cyber-dashboard
```

### Check Status

```bash
docker-compose ps
```

### Restart Services

```bash
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart agent
```

### Stop Services

```bash
docker-compose down
```

### Start Services

```bash
docker-compose up -d
```

---

## Troubleshooting

### Can't Upload File

```bash
# Check SSH connection
ssh root@YOUR_SERVER_IP

# If connection works but scp fails, try:
scp -v cyber-defense-agent.tar.gz root@YOUR_SERVER_IP:/root/
```

### Docker Installation Fails

```bash
# Try manual installation
apt-get update
apt-get install -y docker.io docker-compose
systemctl start docker
systemctl enable docker
```

### Model Not Loading

```bash
# Check Ollama container
docker ps | grep ollama

# Check logs
docker logs ollama-qwen

# Manually pull model
docker exec ollama-qwen ollama pull qwen2.5:0.5b

# Verify
docker exec ollama-qwen ollama list
```

### Port Already in Use

```bash
# Check what's using the port
netstat -tulpn | grep :3000
netstat -tulpn | grep :8000

# Kill the process or change ports in docker-compose.yml
```

### Firewall Blocks Access

```bash
# Check firewall status
ufw status

# Add rules if missing
ufw allow 3000/tcp
ufw allow 8000/tcp
ufw reload
```

### Out of Memory

```bash
# Check memory usage
free -h

# If low memory, upgrade server or:
# 1. Disable LLM mode (edit docker-compose.yml: USE_LLM=false)
# 2. Restart: docker-compose restart
```

---

## Updating the Application

To update after making changes:

### On Local Machine:
```bash
# Recreate package
./create-deployment-package.sh

# Upload new version
scp cyber-defense-agent.tar.gz root@YOUR_SERVER_IP:/root/
```

### On Server:
```bash
# Stop current version
cd /root/cyber-defense-agent
docker-compose down

# Backup old version
cd /root
mv cyber-defense-agent cyber-defense-agent.backup

# Extract new version
tar -xzf cyber-defense-agent.tar.gz
cd cyber-defense-agent

# Start new version
docker-compose up -d
```

---

## Security Notes

### Change Default Passwords

Edit `.env` file on server:
```bash
nano .env
```

Change:
```
POSTGRES_PASSWORD=your_secure_password_here
```

Restart database:
```bash
docker-compose restart db
```

### Restrict Access

If you don't need public access:

```bash
# Only allow from your IP
ufw delete allow 3000/tcp
ufw delete allow 8000/tcp
ufw allow from YOUR_HOME_IP to any port 3000 proto tcp
ufw allow from YOUR_HOME_IP to any port 8000 proto tcp
```

### Regular Updates

```bash
# Update system
apt-get update && apt-get upgrade -y

# Update Docker images
docker-compose pull
docker-compose up -d
```

---

## Backup

### Backup Database

```bash
# Create backup
docker exec cyber-events-db pg_dump -U postgres cyber_events > backup.sql

# Download to local machine
scp root@YOUR_SERVER_IP:/root/cyber-defense-agent/backup.sql ./
```

### Restore Database

```bash
# Upload backup
scp backup.sql root@YOUR_SERVER_IP:/root/cyber-defense-agent/

# Restore
docker exec -i cyber-events-db psql -U postgres cyber_events < backup.sql
```

---

## Complete Example Session

```bash
# === ON LOCAL MACHINE ===
./create-deployment-package.sh
scp cyber-defense-agent.tar.gz root@65.21.123.45:/root/

# === CONNECT TO SERVER ===
ssh root@65.21.123.45

# === ON SERVER ===
cd /root
tar -xzf cyber-defense-agent.tar.gz
cd cyber-defense-agent

curl -fsSL https://get.docker.com | sh
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

docker-compose up -d
docker logs -f ollama-init  # Wait for "Qwen model ready!"

apt-get update && apt-get install -y ufw
ufw allow 22/tcp
ufw allow 3000/tcp
ufw allow 8000/tcp
ufw --force enable

docker ps
curl http://localhost:8000/health

# === ON LOCAL MACHINE ===
# Open browser: http://65.21.123.45:3000
```

---

## Support

- Full documentation: `README.md`
- Scoring issues: `FIX_QWEN_SCORING_ISSUE.md`
- Check model: `./check-qwen-model.sh`
- Test system: `./test-llm-mode.sh`

---

**Total deployment time: ~10 minutes**

**Monthly cost: €15-30 (depending on server size)**
