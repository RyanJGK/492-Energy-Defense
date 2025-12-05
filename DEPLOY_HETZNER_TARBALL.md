# Deploy to Hetzner Using tar.gz Package

## Quick Deployment Guide (Root User)

This guide shows how to deploy the cybersecurity agent to Hetzner using a simple tar.gz package.

---

## Step 1: Create Deployment Package

On your **local machine**, in the project directory:

```bash
./create-deployment-package.sh
```

This creates a file like `cyber-defense-20251202-123456.tar.gz`

---

## Step 2: Upload to Hetzner

Replace `YOUR_SERVER_IP` with your Hetzner server IP:

```bash
# Upload the package
scp cyber-defense-*.tar.gz root@YOUR_SERVER_IP:~/
```

Enter your root password when prompted.

**Example:**
```bash
scp cyber-defense-20251202-123456.tar.gz root@65.21.123.45:~/
```

---

## Step 3: Connect to Hetzner

```bash
ssh root@YOUR_SERVER_IP
```

---

## Step 4: Install Docker (If Not Installed)

On the **Hetzner server**:

```bash
# Update system
apt update && apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt install -y docker-compose-plugin

# Verify installation
docker --version
docker compose version
```

---

## Step 5: Extract and Deploy

Still on the **Hetzner server**:

```bash
# Extract the package
tar -xzf cyber-defense-*.tar.gz

# Enter the directory
cd 492-energy-defense

# Start the system
docker compose up -d

# Watch the model download (1-2 minutes)
docker logs -f ollama-init
```

Press `Ctrl+C` when you see "Qwen model ready!"

---

## Step 6: Verify Deployment

```bash
# Check all containers are running
docker ps

# Test the agent
curl http://localhost:8000/health | jq

# Check if model is loaded
docker exec ollama-qwen ollama list
```

---

## Step 7: Configure Firewall (Optional)

If you want to access from outside:

```bash
# Install UFW if not installed
apt install -y ufw

# Allow SSH (IMPORTANT - do this first!)
ufw allow 22/tcp

# Allow agent API (optional)
ufw allow 8000/tcp

# Allow dashboard (optional)
ufw allow 3000/tcp

# Enable firewall
ufw enable

# Check status
ufw status
```

---

## Access Your Services

### From the Server (Local)
```bash
# Agent health
curl http://localhost:8000/health

# Dashboard
curl http://localhost:3000/health
```

### From External (If firewall allows)
```bash
# Agent (replace with your IP)
curl http://YOUR_SERVER_IP:8000/health

# Dashboard in browser
http://YOUR_SERVER_IP:3000
```

---

## Common Commands

### View Logs
```bash
# All services
docker compose logs -f

# Specific service
docker logs -f cyber-agent
docker logs -f cyber-backend
docker logs -f ollama-qwen
```

### Restart Services
```bash
# All services
docker compose restart

# Specific service
docker compose restart agent
```

### Stop Everything
```bash
docker compose down
```

### Update Application
```bash
# On local machine: Create new package
./create-deployment-package.sh

# Upload new package
scp cyber-defense-*.tar.gz root@YOUR_SERVER_IP:~/

# On Hetzner: Stop old version
cd 492-energy-defense
docker compose down

# Backup old version
cd ~
mv 492-energy-defense 492-energy-defense.backup

# Extract new version
tar -xzf cyber-defense-*.tar.gz

# Start new version
cd 492-energy-defense
docker compose up -d
```

---

## Troubleshooting

### Problem: Docker not found
```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
```

### Problem: Permission denied
```bash
# Make sure you're root
whoami  # Should say "root"

# Or use sudo
sudo docker compose up -d
```

### Problem: Port already in use
```bash
# Check what's using the port
netstat -tulpn | grep 8000

# Kill the process if needed
kill -9 <PID>
```

### Problem: Model won't download
```bash
# Pull manually
docker exec ollama-qwen ollama pull qwen2.5:0.5b

# Or use larger model
docker exec ollama-qwen ollama pull qwen2.5:1.5b
```

### Problem: Agent shows "low" severity for critical events
```bash
# Switch to rule-based mode (100% accurate)
nano docker-compose.yml
# Change: USE_LLM=false

# Restart
docker compose restart agent
```

---

## Quick Reference

### Server Specs (Recommended)
- **Minimum**: 2 vCPU, 4GB RAM, 20GB SSD
- **Recommended**: 4 vCPU, 8GB RAM, 40GB SSD
- **OS**: Ubuntu 22.04 LTS

### Package Contents
```
492-energy-defense/
├── agent/              # AI agent service
├── backend/            # Data generator
├── dashboard/          # Web dashboard
├── docker-compose.yml  # Container orchestration
├── .env               # Environment variables
├── start.sh           # Quick start script
├── README.md          # Full documentation
└── *.sh               # Utility scripts
```

### Ports Used
- `5432` - PostgreSQL database
- `8000` - AI Agent API
- `3000` - Web Dashboard
- `11434` - Ollama API (internal)

---

## Complete Example Session

```bash
# === ON LOCAL MACHINE ===
./create-deployment-package.sh
scp cyber-defense-20251202-123456.tar.gz root@65.21.123.45:~/

# === ON HETZNER SERVER ===
ssh root@65.21.123.45

# Install Docker if needed
curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh
apt install -y docker-compose-plugin

# Deploy application
tar -xzf cyber-defense-20251202-123456.tar.gz
cd 492-energy-defense
docker compose up -d

# Wait for model download
docker logs -f ollama-init

# Verify it works
docker ps
curl http://localhost:8000/health | jq

# Done! 🎉
```

---

## Security Notes

### Change Default Passwords

Edit `.env` file:
```bash
nano .env

# Change these:
POSTGRES_PASSWORD=your_secure_password
```

Then restart:
```bash
docker compose down
docker compose up -d
```

### Use Non-Root User (Recommended)

```bash
# Create user
adduser cyber
usermod -aG docker cyber

# Switch to user
su - cyber

# Deploy from here
cd ~
# ... extract and deploy
```

---

## Backup

### Backup Database
```bash
# Create backup
docker exec cyber-events-db pg_dump -U postgres cyber_events > backup.sql

# Download to local machine
scp root@YOUR_SERVER_IP:~/backup.sql ./
```

### Restore Database
```bash
# Upload backup
scp backup.sql root@YOUR_SERVER_IP:~/

# Restore
cat backup.sql | docker exec -i cyber-events-db psql -U postgres cyber_events
```

---

## Performance Tuning

### For Low-Resource Servers

Edit `docker-compose.yml`:

```yaml
# Use rule-based mode (no LLM)
agent:
  environment:
    - USE_LLM=false

# Reduce memory limits
ollama:
  deploy:
    resources:
      limits:
        memory: 2G
```

---

## Summary

✅ **Simple**: Just upload and extract  
✅ **Fast**: No git or complex setup  
✅ **Clean**: Self-contained package  
✅ **Portable**: Works on any server  

**Total deployment time: ~5 minutes** (excluding model download)

---

## Support

If you encounter issues:
1. Check logs: `docker compose logs`
2. Verify services: `docker ps`
3. Test connectivity: `curl http://localhost:8000/health`
4. Check firewall: `ufw status`

For scoring issues, see `FIX_QWEN_SCORING_ISSUE.md`
