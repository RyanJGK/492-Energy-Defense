# Simple Hetzner Deployment with Root User

## Overview

This guide shows you how to deploy using a tar.gz package when you only have root access with password authentication.

---

## Step 1: Create Deployment Package

On your **local machine**, in the project directory:

```bash
./create-deployment-package.sh
```

This creates a file like: `cyber-defense-agent-20251202-143022.tar.gz`

---

## Step 2: Upload to Hetzner Server

### Option A: Using SCP (if you have SSH key)

```bash
scp cyber-defense-agent-*.tar.gz root@YOUR_SERVER_IP:/root/
```

### Option B: Using SFTP (if you only have password)

```bash
sftp root@YOUR_SERVER_IP
# Enter password when prompted
sftp> cd /root
sftp> put cyber-defense-agent-*.tar.gz
sftp> exit
```

### Option C: Using Hetzner Console

1. Log into Hetzner Cloud Console
2. Open your server
3. Click "Console" button (browser-based terminal)
4. Use wget to download from your hosting:

```bash
cd /root
wget https://your-host.com/cyber-defense-agent-*.tar.gz
```

---

## Step 3: SSH into Server

```bash
ssh root@YOUR_SERVER_IP
# Enter your password
```

---

## Step 4: Extract and Deploy

```bash
# Navigate to root home
cd /root

# Extract the package
tar -xzf cyber-defense-agent-*.tar.gz

# Enter directory
cd 492-energy-defense

# View deployment instructions
cat DEPLOY_INSTRUCTIONS.txt

# Run quick start (installs Docker if needed and starts services)
./quick-start.sh
```

---

## Step 5: Monitor Startup

```bash
# Watch model download (takes 1-2 minutes)
docker logs -f ollama-init

# Press Ctrl+C when you see "Qwen model ready!"

# Check all services are running
docker ps

# Test the agent
curl http://localhost:8000/health
```

---

## Step 6: Configure Firewall (Recommended)

```bash
# Install firewall
apt install ufw -y

# IMPORTANT: Allow SSH first!
ufw allow 22/tcp

# Allow application ports
ufw allow 8000/tcp    # Agent API
ufw allow 3000/tcp    # Dashboard

# Enable firewall
ufw --force enable

# Check status
ufw status
```

---

## Step 7: Access Your Application

From your browser:

- **Dashboard**: `http://YOUR_SERVER_IP:3000`
- **Agent API**: `http://YOUR_SERVER_IP:8000`
- **API Docs**: `http://YOUR_SERVER_IP:8000/docs`

---

## Manual Docker Installation (if needed)

If `quick-start.sh` doesn't work or you prefer manual installation:

```bash
# Update system
apt update
apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Start Docker
systemctl start docker
systemctl enable docker

# Verify Docker is running
docker --version
docker compose version

# Now start the application
cd /root/492-energy-defense
docker compose up -d
```

---

## Common Tasks

### View Logs

```bash
cd /root/492-energy-defense

# Agent logs
docker logs -f cyber-agent

# Backend logs
docker logs -f cyber-backend

# Dashboard logs
docker logs -f cyber-dashboard

# All logs
docker compose logs -f
```

### Restart Services

```bash
cd /root/492-energy-defense

# Restart everything
docker compose restart

# Restart specific service
docker compose restart agent
```

### Stop Services

```bash
cd /root/492-energy-defense

# Stop (keeps data)
docker compose down

# Stop and remove data
docker compose down -v
```

### Update Application

When you have a new version:

```bash
# Upload new package
sftp root@YOUR_SERVER_IP
put cyber-defense-agent-NEW.tar.gz
exit

# SSH in
ssh root@YOUR_SERVER_IP

# Stop current version
cd /root/492-energy-defense
docker compose down

# Extract new version
cd /root
tar -xzf cyber-defense-agent-NEW.tar.gz

# Start new version
cd 492-energy-defense
docker compose up -d
```

---

## Troubleshooting

### Port Already in Use

```bash
# Find what's using the port
netstat -tlnp | grep :8000

# Kill the process
kill -9 <PID>

# Restart services
docker compose up -d
```

### Docker Daemon Not Running

```bash
systemctl start docker
systemctl status docker
```

### Model Not Loading

```bash
# Pull model manually
docker exec ollama-qwen ollama pull qwen2.5:0.5b

# Check it's there
docker exec ollama-qwen ollama list

# Restart agent
docker compose restart agent
```

### Fix Low Severity Issue

```bash
cd /root/492-energy-defense
./apply-fix.sh
# Choose option 1 for rule-based mode (most reliable)
```

### Out of Disk Space

```bash
# Check disk usage
df -h

# Clean Docker
docker system prune -a
```

### Out of Memory

```bash
# Check memory
free -h

# If using 0.5B model, switch to rule-based mode:
cd /root/492-energy-defense
nano docker-compose.yml
# Change: USE_LLM=true to USE_LLM=false
docker compose restart agent
```

---

## Configuration

All configuration is in `docker-compose.yml`:

```bash
cd /root/492-energy-defense
nano docker-compose.yml
```

### Switch to Rule-Based Mode (Recommended)

Change:
```yaml
- USE_LLM=true
```
To:
```yaml
- USE_LLM=false
```

Then restart:
```bash
docker compose restart agent
```

### Change Model

Change:
```yaml
- OLLAMA_MODEL=qwen2.5:0.5b
```
To:
```yaml
- OLLAMA_MODEL=qwen2.5:1.5b  # or qwen2.5:3b
```

Update the pull command too:
```yaml
ollama pull qwen2.5:1.5b
```

Then restart:
```bash
docker compose down
docker compose up -d
```

---

## Security Tips

1. **Change root password** after first login:
   ```bash
   passwd
   ```

2. **Create a non-root user** (optional but recommended):
   ```bash
   adduser cyberdefense
   usermod -aG sudo cyberdefense
   usermod -aG docker cyberdefense
   ```

3. **Disable root login** (after setting up SSH keys for another user):
   ```bash
   nano /etc/ssh/sshd_config
   # Change: PermitRootLogin yes to PermitRootLogin no
   systemctl restart sshd
   ```

4. **Enable automatic updates**:
   ```bash
   apt install unattended-upgrades -y
   dpkg-reconfigure -plow unattended-upgrades
   ```

---

## System Requirements

### Minimum
- **CPU**: 2 cores
- **RAM**: 4GB
- **Disk**: 20GB
- **OS**: Ubuntu 20.04+

### Recommended
- **CPU**: 4 cores
- **RAM**: 8GB  
- **Disk**: 40GB
- **OS**: Ubuntu 22.04 LTS

---

## Quick Reference

```bash
# Create package (local machine)
./create-deployment-package.sh

# Upload to server
scp cyber-defense-agent-*.tar.gz root@IP:/root/

# Deploy on server
ssh root@IP
cd /root
tar -xzf cyber-defense-agent-*.tar.gz
cd 492-energy-defense
./quick-start.sh

# Access
http://SERVER_IP:3000  # Dashboard
http://SERVER_IP:8000  # API
```

---

## Need Help?

Check the deployment instructions in the package:
```bash
cat DEPLOY_INSTRUCTIONS.txt
```

Check logs:
```bash
docker logs cyber-agent
docker logs cyber-backend
```

Test the system:
```bash
./test-llm-mode.sh
```

---

**Deployment package includes everything you need - no git required!** 🚀
