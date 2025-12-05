# Hetzner Deployment with Root Password (tar.gz Method)

## Quick Overview

This guide shows how to deploy to Hetzner Cloud using **root password authentication** and a **tar.gz deployment package**.

**Time Required:** 10-15 minutes  
**Cost:** ~€15-30/month depending on server size

---

## Step 1: Create Deployment Package (On Your Local Machine)

```bash
# Create the deployment package
./create-deployment-package.sh
```

This creates: `cyber-defense-deployment.tar.gz` (~500KB)

---

## Step 2: Create Hetzner Server

### 2.1 Go to Hetzner Cloud Console
https://console.hetzner.cloud/

### 2.2 Create New Server

**Basic Settings:**
- **Name:** `cyber-defense-001`
- **Location:** Choose closest to you (Nuremberg, Helsinki, etc.)
- **Image:** Ubuntu 22.04 LTS or 24.04

**Server Type (Choose One):**

| Type | vCPU | RAM | Disk | Price/month | Recommended |
|------|------|-----|------|-------------|-------------|
| CPX11 | 2 | 4GB | 80GB | ~€8 | Minimal (Rule-based only) |
| CPX21 | 3 | 8GB | 160GB | ~€15 | **Good for LLM** ✅ |
| CPX31 | 4 | 16GB | 240GB | ~€30 | Best for LLM |

**Authentication:**
- Select "Password" (NOT SSH key)
- Set a strong root password
- **Save this password securely**

**Networking:**
- Enable IPv4 & IPv6
- No additional options needed

### 2.3 Create Server
- Click "Create & Buy Now"
- Wait 30-60 seconds for server to start
- **Copy the IP address** (e.g., 65.21.123.45)

---

## Step 3: Upload Deployment Package

### Option A: Using SCP (Linux/Mac)
```bash
scp cyber-defense-deployment.tar.gz root@YOUR_SERVER_IP:/root/
# Enter password when prompted
```

### Option B: Using WinSCP (Windows)
1. Download WinSCP: https://winscp.net/
2. Connect to server:
   - Host: YOUR_SERVER_IP
   - User: root
   - Password: [your root password]
   - Port: 22
3. Drag and drop `cyber-defense-deployment.tar.gz` to `/root/`

### Option C: Using FileZilla (Any OS)
1. Download FileZilla: https://filezilla-project.org/
2. Connect via SFTP:
   - Host: sftp://YOUR_SERVER_IP
   - Username: root
   - Password: [your root password]
   - Port: 22
3. Upload the tar.gz file

---

## Step 4: Connect to Server via SSH

### Linux/Mac:
```bash
ssh root@YOUR_SERVER_IP
# Enter password when prompted
```

### Windows:
Use PuTTY or Windows Terminal:
```bash
ssh root@YOUR_SERVER_IP
```

---

## Step 5: Deploy Application

Once logged into the server:

```bash
# 1. Extract the package
cd /root
tar -xzf cyber-defense-deployment.tar.gz
cd 492-energy-defense

# 2. Run setup script (installs Docker, configures system)
bash setup-server.sh

# 3. Start the application
bash quick-start.sh
```

### What the setup script does:
- Updates system packages
- Installs Docker & Docker Compose
- Configures firewall (opens ports 22, 3000, 8000, 5432)
- Sets up application directory

---

## Step 6: Monitor Startup

```bash
# Watch the Qwen model download (takes 1-2 minutes)
docker logs -f ollama-init

# You'll see:
# Pulling Qwen model...
# pulling manifest
# pulling layers...
# success
# Qwen model ready!

# Press Ctrl+C when done

# Check all containers are running
docker ps
```

Expected containers:
- `cyber-events-db` (PostgreSQL)
- `ollama-qwen` (Ollama)
- `cyber-agent` (Agent API)
- `cyber-backend` (Data generator)
- `cyber-dashboard` (Web UI)

---

## Step 7: Access Your Application

Replace `YOUR_SERVER_IP` with your actual IP:

**Dashboard:**
```
http://YOUR_SERVER_IP:3000
```

**Agent API:**
```
http://YOUR_SERVER_IP:8000
```

**API Documentation:**
```
http://YOUR_SERVER_IP:8000/docs
```

---

## Quick Test

```bash
# Test the agent (from the server)
curl http://localhost:8000/health | jq

# Or from your local machine
curl http://YOUR_SERVER_IP:8000/health | jq
```

Expected output:
```json
{
  "status": "healthy",
  "service": "492-Energy-Defense Cyber Event Triage Agent",
  "mode": "LLM",
  "model": "qwen2.5:0.5b"
}
```

---

## Post-Deployment Configuration

### Fix Scoring Issue (IMPORTANT)

If you want 100% accurate scoring:

```bash
cd /root/492-energy-defense
bash apply-fix.sh
# Choose option 1 for rule-based mode
```

### Update Environment Variables

```bash
cd /root/492-energy-defense
nano .env

# Edit settings as needed:
# OLLAMA_MODEL=qwen2.5:1.5b
# USE_LLM=false

# Restart services
docker-compose restart
```

---

## Useful Commands

### Service Management
```bash
cd /root/492-energy-defense

# Check status
docker ps
docker-compose ps

# View logs
docker logs cyber-agent
docker logs cyber-backend
docker logs cyber-dashboard

# Restart specific service
docker-compose restart agent

# Restart all services
docker-compose restart

# Stop everything
docker-compose down

# Start again
docker-compose up -d
```

### System Management
```bash
# Check disk space
df -h

# Check memory
free -h

# Check Docker stats
docker stats

# System update
apt update && apt upgrade -y
```

### Firewall
```bash
# Check firewall status
ufw status

# Add rule
ufw allow 8080/tcp

# Remove rule
ufw delete allow 8080/tcp
```

---

## Troubleshooting

### Problem: Cannot connect to server
**Check:**
```bash
# On server - verify firewall
ufw status

# Ensure ports are open
ufw allow 3000/tcp
ufw allow 8000/tcp
```

### Problem: Docker not starting
```bash
# Check Docker status
systemctl status docker

# Start Docker
systemctl start docker

# Enable on boot
systemctl enable docker
```

### Problem: Containers not running
```bash
# Check logs
docker-compose logs

# Restart everything
docker-compose down
docker-compose up -d
```

### Problem: Model not loading
```bash
# Check Ollama logs
docker logs ollama-qwen

# Manually pull model
docker exec ollama-qwen ollama pull qwen2.5:0.5b

# Check model exists
docker exec ollama-qwen ollama list
```

### Problem: Out of memory
```bash
# Check memory usage
free -h
docker stats

# Solution: Upgrade server or use rule-based mode
cd /root/492-energy-defense
bash apply-fix.sh
# Choose option 1
```

---

## Security Hardening (Optional but Recommended)

### 1. Create Non-Root User
```bash
# Create user
adduser cyber

# Add to docker group
usermod -aG docker cyber

# Switch to user
su - cyber
```

### 2. Disable Root SSH Login
```bash
nano /etc/ssh/sshd_config

# Change:
PermitRootLogin no

# Restart SSH
systemctl restart sshd
```

### 3. Set Up Firewall Properly
```bash
# Reset firewall
ufw --force reset

# Default policies
ufw default deny incoming
ufw default allow outgoing

# Allow only necessary ports
ufw allow 22/tcp   # SSH
ufw allow 3000/tcp # Dashboard (optional, use nginx proxy)
ufw allow 8000/tcp # API (optional, use nginx proxy)

# Enable
ufw enable
```

### 4. Install Fail2Ban
```bash
apt install -y fail2ban
systemctl enable fail2ban
systemctl start fail2ban
```

---

## Updating the Application

### Method 1: Update Code Only
```bash
cd /root/492-energy-defense

# Pull changes (if using git)
git pull

# Rebuild and restart
docker-compose build
docker-compose up -d
```

### Method 2: Full Redeployment
```bash
# On local machine - create new package
./create-deployment-package.sh

# Upload to server
scp cyber-defense-deployment.tar.gz root@YOUR_SERVER_IP:/root/

# On server
cd /root
docker-compose down
rm -rf 492-energy-defense
tar -xzf cyber-defense-deployment.tar.gz
cd 492-energy-defense
docker-compose up -d
```

---

## Monitoring & Maintenance

### Daily Checks
```bash
# Check services are running
docker ps

# Check disk space
df -h

# Check logs for errors
docker-compose logs --tail=50
```

### Weekly Tasks
```bash
# Update system packages
apt update && apt upgrade -y

# Restart services (to apply updates)
cd /root/492-energy-defense
docker-compose restart
```

### Monthly Tasks
```bash
# Clean up Docker
docker system prune -a

# Backup database
docker exec cyber-events-db pg_dump -U postgres cyber_events > backup_$(date +%Y%m%d).sql
```

---

## Cost Estimation

**Monthly Costs (Hetzner):**
- CPX11 (4GB RAM): ~€8/month (minimal, rule-based only)
- CPX21 (8GB RAM): ~€15/month (recommended for LLM)
- CPX31 (16GB RAM): ~€30/month (best performance)

**Additional Costs:**
- None (includes 20TB traffic)

**Annual Cost:**
- ~€180-360 depending on server size

---

## Backup Strategy

### Manual Backup
```bash
# Backup database
docker exec cyber-events-db pg_dump -U postgres cyber_events > backup.sql

# Download to local machine
scp root@YOUR_SERVER_IP:/root/492-energy-defense/backup.sql ./
```

### Automated Backup (Cron)
```bash
# Create backup script
cat > /root/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/root/backups"
mkdir -p $BACKUP_DIR
docker exec cyber-events-db pg_dump -U postgres cyber_events > $BACKUP_DIR/backup_$(date +%Y%m%d_%H%M%S).sql
# Keep only last 7 days
find $BACKUP_DIR -name "backup_*.sql" -mtime +7 -delete
EOF

chmod +x /root/backup.sh

# Add to crontab (daily at 2 AM)
crontab -e
# Add: 0 2 * * * /root/backup.sh
```

---

## Summary

✅ **Created deployment package**  
✅ **Uploaded to Hetzner server**  
✅ **Installed Docker & dependencies**  
✅ **Started application**  
✅ **Application accessible**  

**Your system is now running!**

**Access:**
- Dashboard: http://YOUR_SERVER_IP:3000
- Agent API: http://YOUR_SERVER_IP:8000

**Next:**
- Review FIX_QWEN_SCORING_ISSUE.md
- Consider running `bash apply-fix.sh` for better accuracy
- Set up monitoring and backups

---

For questions or issues, check the logs:
```bash
docker-compose logs
```
