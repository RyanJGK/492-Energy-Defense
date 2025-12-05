# Simple Hetzner Deployment with tar.gz (Root User + Password)

## Quick Deployment Guide

This guide is for deploying using **root user with password authentication** (no SSH keys needed).

---

## Step 1: Create Hetzner Server

1. **Login to Hetzner Cloud Console**: https://console.hetzner.cloud/

2. **Create New Server:**
   - **Image**: Ubuntu 22.04 or 24.04 LTS
   - **Type**: 
     - **CPX21** (3 vCPU, 8GB RAM) - Minimum, use rule-based mode
     - **CPX31** (4 vCPU, 16GB RAM) - Recommended for LLM mode
   - **Location**: Choose closest to you
   - **Name**: `cyber-defense-agent`
   - **Additional Options**: None needed (skip SSH keys if using password)

3. **Set Root Password:**
   - When prompted, set a strong root password
   - **Save this password securely!**

4. **Create Server** and wait for it to provision (~30 seconds)

5. **Note the IP address** (e.g., `65.108.123.45`)

---

## Step 2: Create Deployment Package (On Your Local Machine)

```bash
# Navigate to project directory
cd /workspace

# Create deployment package
./create-deployment-package.sh
```

This creates a file like: `cyber-defense-agent-20251202-143022.tar.gz`

---

## Step 3: Transfer Package to Server

### Option A: Using SCP (Command Line)

```bash
# Replace YOUR_SERVER_IP with your actual IP
scp cyber-defense-agent-*.tar.gz root@YOUR_SERVER_IP:/root/

# Example:
# scp cyber-defense-agent-20251202-143022.tar.gz root@65.108.123.45:/root/
```

You'll be prompted for the root password you set in Step 1.

### Option B: Using FileZilla (GUI)

1. **Download FileZilla**: https://filezilla-project.org/
2. **Connect to server:**
   - Host: `sftp://YOUR_SERVER_IP`
   - Username: `root`
   - Password: `[your root password]`
   - Port: `22`
3. **Upload the tar.gz file** to `/root/`

### Option C: Using WinSCP (Windows)

1. **Download WinSCP**: https://winscp.net/
2. **New Session:**
   - File protocol: `SFTP`
   - Host name: `YOUR_SERVER_IP`
   - User name: `root`
   - Password: `[your root password]`
3. **Connect** and upload the tar.gz file

### Option D: Using Hetzner Console (Browser-based)

1. In Hetzner Cloud Console, click on your server
2. Click **"Console"** tab
3. Login as `root` with your password
4. Use `wget` or `curl` to download from a temporary hosting service

---

## Step 4: Setup Server and Deploy

**SSH into your server:**

```bash
ssh root@YOUR_SERVER_IP
# Enter password when prompted
```

**Once connected to the server, run:**

```bash
# List files to verify upload
ls -lh

# Extract the package
tar -xzf cyber-defense-agent-*.tar.gz

# Navigate into directory
cd cyber-defense-deploy

# Make scripts executable
chmod +x *.sh

# Run server setup (installs Docker, etc.)
bash setup-server.sh
```

The setup script will:
- ✅ Update system packages
- ✅ Install Docker and Docker Compose
- ✅ Install required tools (curl, jq, git, etc.)
- ✅ Configure firewall (UFW)
- ✅ Enable Docker service

**This takes about 3-5 minutes.**

---

## Step 5: Choose Deployment Mode

### Option A: Rule-Based Mode (RECOMMENDED)

**Best for: Accuracy, speed, low resource usage**

```bash
# Edit docker-compose.yml
nano docker-compose.yml

# Find the agent section and set:
environment:
  - USE_LLM=false

# Save (Ctrl+O, Enter, Ctrl+X)
```

### Option B: LLM Mode with Qwen 1.5B

**Best for: AI reasoning, learning experience**

```bash
# Edit docker-compose.yml
nano docker-compose.yml

# Find the agent section and set:
environment:
  - USE_LLM=true
  - OLLAMA_MODEL=qwen2.5:1.5b

# Also update the ollama-init section:
command:
  - |
    echo "Waiting for Ollama to be ready..."
    sleep 10
    echo "Pulling Qwen model..."
    ollama pull qwen2.5:1.5b
    echo "Qwen model ready!"

# Save (Ctrl+O, Enter, Ctrl+X)
```

---

## Step 6: Start the System

```bash
# Start all services
docker-compose up -d

# Watch the logs (optional)
docker-compose logs -f

# Wait for:
# - "Qwen model ready!" (if using LLM mode)
# - "Database initialized"
# - All containers healthy
```

**First startup takes:**
- **Rule-based mode**: 30-60 seconds
- **LLM mode**: 2-3 minutes (downloads Qwen model)

Press `Ctrl+C` to exit logs (containers keep running).

---

## Step 7: Verify It's Working

### Check Container Status

```bash
docker ps
```

You should see containers running:
- `cyber-events-db` (PostgreSQL)
- `cyber-agent` (AI Agent)
- `cyber-backend` (Data Generator)
- `cyber-dashboard` (Web UI)
- `ollama-qwen` (if using LLM mode)

### Check Agent Health

```bash
curl http://localhost:8000/health | jq
```

Expected output:
```json
{
  "status": "healthy",
  "service": "492-Energy-Defense Cyber Event Triage Agent",
  "mode": "Rule-based"
}
```

### Test Event Analysis

```bash
curl -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "admin",
      "status": "FAIL",
      "is_admin": true,
      "is_suspicious_ip": true,
      "is_burst_failure": true,
      "timestamp": "2025-12-02T02:30:00"
    }
  }' | jq
```

Should return:
```json
{
  "event_type": "login",
  "risk_score": 130,
  "severity": "critical",
  "reasoning": "Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)",
  "recommended_action": "IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP"
}
```

---

## Step 8: Access the Dashboard

Get your server's public IP:

```bash
curl ifconfig.me
```

**Open in your browser:**

```
http://YOUR_SERVER_IP:3000
```

Example: `http://65.108.123.45:3000`

You should see the security dashboard with real-time alerts!

---

## Troubleshooting

### Container won't start

```bash
# Check logs
docker-compose logs [service-name]

# Example:
docker-compose logs cyber-agent

# Restart specific service
docker-compose restart [service-name]
```

### Can't access dashboard from browser

```bash
# Check firewall
ufw status

# Make sure port 3000 is allowed
ufw allow 3000/tcp

# Check if service is listening
netstat -tulpn | grep 3000
```

### Qwen model fails to download (LLM mode)

```bash
# Pull manually
docker exec ollama-qwen ollama pull qwen2.5:1.5b

# Check available models
docker exec ollama-qwen ollama list

# View logs
docker logs ollama-qwen
```

### Reset everything

```bash
# Stop and remove all containers
docker-compose down -v

# Start fresh
docker-compose up -d
```

---

## Useful Commands

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f cyber-agent

# Restart all services
docker-compose restart

# Stop all services
docker-compose down

# Check resource usage
docker stats

# Shell into a container
docker exec -it cyber-agent bash

# Database access
docker exec -it cyber-events-db psql -U postgres -d cyber_events
```

---

## Updating the System

To update with a new version:

```bash
# Stop current system
docker-compose down

# Upload new tar.gz (repeat Step 3)

# Extract
cd /root
tar -xzf cyber-defense-agent-NEW.tar.gz

# Navigate to new directory
cd cyber-defense-deploy

# Start updated version
docker-compose up -d
```

---

## Resource Usage

### Rule-Based Mode
- **RAM**: ~2-3GB
- **CPU**: 1-2 cores
- **Disk**: ~5GB
- **Recommended**: CPX21 or higher

### LLM Mode (Qwen 1.5B)
- **RAM**: ~4-6GB
- **CPU**: 2-4 cores
- **Disk**: ~6GB
- **Recommended**: CPX31 or higher

---

## Security Notes

### Change Default Passwords

```bash
# Edit docker-compose.yml
nano docker-compose.yml

# Change PostgreSQL password:
POSTGRES_PASSWORD: your_secure_password_here

# Also update in DATABASE_URL:
DATABASE_URL: postgresql://postgres:your_secure_password_here@db:5432/cyber_events
```

### Restrict Access

```bash
# Only allow specific IPs to access dashboard
ufw delete allow 3000/tcp
ufw allow from YOUR_IP_ADDRESS to any port 3000

# Only allow SSH from specific IPs
ufw delete allow 22/tcp
ufw allow from YOUR_IP_ADDRESS to any port 22
```

### Enable HTTPS (Optional)

Use Nginx reverse proxy with Let's Encrypt:
```bash
apt-get install -y nginx certbot python3-certbot-nginx
# Follow standard Nginx + certbot setup
```

---

## Support

### View System Status

```bash
./check-qwen-model.sh  # If using LLM mode
docker ps
docker-compose ps
```

### Apply Fixes

```bash
./apply-fix.sh  # If having scoring issues
```

### Get Help

1. Check logs: `docker-compose logs`
2. Check README.md for detailed documentation
3. Check FIX_QWEN_SCORING_ISSUE.md for LLM issues

---

## Summary

✅ **Package created**: `create-deployment-package.sh`  
✅ **Transfer**: SCP, FileZilla, WinSCP, or console  
✅ **Setup**: `bash setup-server.sh`  
✅ **Deploy**: `docker-compose up -d`  
✅ **Access**: `http://YOUR_IP:3000`  

**Total deployment time: 5-10 minutes**

---

## Example Full Workflow

```bash
# === ON YOUR LOCAL MACHINE ===
cd /workspace
./create-deployment-package.sh
scp cyber-defense-agent-*.tar.gz root@65.108.123.45:/root/

# === ON HETZNER SERVER ===
ssh root@65.108.123.45
tar -xzf cyber-defense-agent-*.tar.gz
cd cyber-defense-deploy
bash setup-server.sh

# Edit config (optional)
nano docker-compose.yml
# Set USE_LLM=false for rule-based mode

# Start system
docker-compose up -d

# Verify
docker ps
curl http://localhost:8000/health | jq

# Access dashboard
# Open browser: http://65.108.123.45:3000

# Done! 🎉
```
