# Complete Deployment Guide - Hetzner Cloud Server (LLM Mode)

## 📋 Prerequisites

- Hetzner Cloud account
- SSH key pair (or ability to create one)
- Domain name (optional, for easier access)
- Local computer with SSH client

---

## Step 1: Create Hetzner Cloud Server

### 1.1 Choose Server Specifications

**Minimum Requirements for LLM Mode:**
- **CPU**: 4 vCPUs
- **RAM**: 16 GB (Ollama/Qwen needs 2-4GB, plus system overhead)
- **Storage**: 40 GB SSD
- **Recommended**: CPX31 or CX41

**Budget Option (Slower LLM):**
- **CPX21**: 3 vCPUs, 8 GB RAM, 80 GB SSD (~€15/month)
- May struggle with Ollama, but workable

**Recommended Option:**
- **CPX31**: 4 vCPUs, 16 GB RAM, 160 GB SSD (~€30/month)
- Good performance for LLM

**High Performance Option:**
- **CPX41**: 8 vCPUs, 32 GB RAM, 240 GB SSD (~€60/month)
- Excellent LLM performance

### 1.2 Create the Server

1. **Login to Hetzner Cloud Console**: https://console.hetzner.cloud/

2. **Create New Project** (if needed):
   - Click "New Project"
   - Name: `492-energy-defense`
   - Click "Add Project"

3. **Create Server**:
   - Click "Add Server"
   
   **Location**: Choose closest to you (e.g., Falkenstein, Nuremberg, Helsinki)
   
   **Image**: 
   - Select "Ubuntu"
   - Choose "Ubuntu 24.04" or "Ubuntu 22.04 LTS"
   
   **Type**: 
   - Select "Shared vCPU" → **CPX31** (recommended)
   
   **Networking**:
   - ✅ Public IPv4 (required)
   - ⬜ Public IPv6 (optional)
   
   **SSH Keys**:
   - Click "Add SSH Key"
   - Paste your public key (from `~/.ssh/id_rsa.pub`)
   - Name it: "my-laptop"
   
   **Name**: `cyber-defense-llm`
   
   **Click "Create & Buy Now"**

4. **Wait for Server Creation** (30-60 seconds)

5. **Note the IP Address**: 
   - Copy the IPv4 address (e.g., `65.21.123.45`)

---

## Step 2: Initial Server Setup

### 2.1 Connect to Server

```bash
# Replace with your server IP
ssh root@65.21.123.45
```

Accept the fingerprint when prompted.

### 2.2 Update System

```bash
# Update package list
apt update

# Upgrade all packages
apt upgrade -y

# Install basic tools
apt install -y curl git vim htop nano jq net-tools
```

### 2.3 Create Non-Root User (Recommended)

```bash
# Create user
adduser cyber
# Set password when prompted

# Add to sudo group
usermod -aG sudo cyber

# Copy SSH keys to new user
mkdir -p /home/cyber/.ssh
cp /root/.ssh/authorized_keys /home/cyber/.ssh/
chown -R cyber:cyber /home/cyber/.ssh
chmod 700 /home/cyber/.ssh
chmod 600 /home/cyber/.ssh/authorized_keys
```

**Test new user** (in new terminal):
```bash
ssh cyber@65.21.123.45
sudo ls  # Test sudo access
```

From now on, use the `cyber` user. Exit root session:
```bash
exit
ssh cyber@65.21.123.45
```

---

## Step 3: Install Docker

### 3.1 Install Docker Engine

```bash
# Add Docker's official GPG key
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

### 3.2 Configure Docker for Non-Root User

```bash
# Add current user to docker group
sudo usermod -aG docker $USER

# Apply group changes
newgrp docker

# Test Docker
docker run hello-world
```

**Expected output**: "Hello from Docker!"

### 3.3 Verify Docker Compose

```bash
docker compose version
```

**Expected output**: `Docker Compose version v2.x.x`

---

## Step 4: Deploy the Application

### 4.1 Clone Repository or Upload Code

**Option A: If Code is in Git Repository**

```bash
cd ~
git clone https://github.com/your-username/492-energy-defense.git
cd 492-energy-defense
```

**Option B: Upload Code from Local Machine**

On your **local machine**:

```bash
# Navigate to project directory
cd /path/to/492-Energy-Defense

# Create archive (exclude unnecessary files)
tar czf cyber-defense.tar.gz \
  --exclude='.git' \
  --exclude='__pycache__' \
  --exclude='*.pyc' \
  --exclude='node_modules' \
  agent/ backend/ docker-compose.yml *.md *.sh

# Upload to server (replace IP)
scp cyber-defense.tar.gz cyber@65.21.123.45:~/
```

On **server**:

```bash
# Extract archive
cd ~
tar xzf cyber-defense.tar.gz
ls -la  # Verify files are there
```

### 4.2 Verify Project Structure

```bash
cd ~/492-energy-defense  # or wherever you extracted
ls -la
```

**Should see**:
```
agent/
backend/
docker-compose.yml
README.md
LLM_MODE_IMPLEMENTATION.md
...
```

---

## Step 5: Configure for Production

### 5.1 Review docker-compose.yml

```bash
cat docker-compose.yml | grep USE_LLM
```

**Should see**: `- USE_LLM=true`

If not, edit it:

```bash
nano docker-compose.yml
```

Find the `agent:` section and ensure:
```yaml
agent:
  environment:
    - USE_LLM=true
```

Save: `Ctrl+O`, Enter, `Ctrl+X`

### 5.2 Optional: Increase Memory for Ollama (if server has 16GB+ RAM)

```bash
nano docker-compose.yml
```

Find the `ollama:` section:
```yaml
ollama:
  deploy:
    resources:
      limits:
        memory: 10G  # Increase from 8G if you have RAM
      reservations:
        memory: 6G   # Increase from 4G
```

### 5.3 Configure Firewall (Allow External Access)

```bash
# Allow SSH (important - don't lock yourself out!)
sudo ufw allow 22/tcp

# Allow application ports
sudo ufw allow 5432/tcp   # PostgreSQL (optional, for external DB tools)
sudo ufw allow 8000/tcp   # Agent API
sudo ufw allow 11434/tcp  # Ollama API (optional)

# Enable firewall
sudo ufw --force enable

# Check status
sudo ufw status
```

---

## Step 6: Launch the Application

### 6.1 Start Services

```bash
cd ~/492-energy-defense  # Or your project directory

# Build and start all services
docker compose up -d
```

**This will**:
1. Download Docker images (3-5 minutes)
2. Build custom images (2-3 minutes)
3. Start all containers
4. Pull Qwen model (~400MB, 1-2 minutes depending on connection)

### 6.2 Monitor Initial Startup

**Watch Ollama pull Qwen model**:
```bash
docker logs -f ollama-init
```

Wait until you see:
```
Qwen model ready!
```

Press `Ctrl+C` to exit logs.

**Check all containers are running**:
```bash
docker ps
```

**Should see 5 running containers**:
- `cyber-events-db` (PostgreSQL)
- `ollama-qwen` (Ollama)
- `cyber-agent` (Agent API)
- `cyber-backend` (Event generator)
- `ollama-init` (will exit after pulling model - that's normal)

---

## Step 7: Verify Everything Works

### 7.1 Check Service Health

```bash
# Check agent health
curl http://localhost:8000/health | jq

# Expected output:
{
  "status": "healthy",
  "mode": "LLM",
  "ollama_url": "http://ollama:11434/api/generate",
  "model": "qwen2.5:0.5b"
}
```

### 7.2 Check from External Machine

On your **local machine**, replace `<SERVER_IP>` with your server's IP:

```bash
# Check agent (should work if firewall allows)
curl http://<SERVER_IP>:8000/health | jq
```

### 7.3 Test LLM Analysis

```bash
# Test with a critical event
curl -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "admin",
      "src_ip": "203.0.113.50",
      "status": "FAIL",
      "timestamp": "2025-11-19T02:30:00",
      "device_id": "WIN-LAPTOP-01",
      "auth_method": "password",
      "is_burst_failure": true,
      "is_suspicious_ip": true,
      "is_admin": true
    }
  }' | jq
```

**Expected**: JSON response with LLM analysis (may take 2-5 seconds)

---

## Step 8: Monitor the System

### 8.1 View Logs

```bash
# Backend (event generation)
docker logs -f cyber-backend

# Agent (LLM analysis)
docker logs -f cyber-agent

# Ollama (LLM engine)
docker logs ollama-qwen

# All logs combined
docker compose logs -f
```

### 8.2 Check Resource Usage

```bash
# System resources
htop
# Press 'q' to exit

# Docker stats
docker stats

# Disk usage
df -h
```

### 8.3 Wait for Event Generation Cycle

Events are generated every 30 minutes. Check backend logs:

```bash
docker logs -f cyber-backend
```

Look for:
```
=== Starting event generation cycle at 2025-11-19T... ===
Dispatching 12 login events to agent (in parallel)...
Login events completed: 12/12 successful in 25.3s
...
=== Event generation cycle completed in 95.2s (1.6 minutes) ===
```

---

## Step 9: Database Access (Optional)

### 9.1 Connect to Database

```bash
# From server
docker exec -it cyber-events-db psql -U postgres -d cyber_events
```

### 9.2 Query Events

```sql
-- Count events
SELECT 
  (SELECT COUNT(*) FROM login_events) as login_events,
  (SELECT COUNT(*) FROM firewall_logs) as firewall_events,
  (SELECT COUNT(*) FROM patch_levels) as patch_levels,
  (SELECT COUNT(*) FROM event_analyses) as analyses;

-- View recent analyses
SELECT event_type, severity, risk_score, analyzed_at 
FROM event_analyses 
ORDER BY analyzed_at DESC 
LIMIT 10;

-- Exit
\q
```

---

## Step 10: Production Hardening (Recommended)

### 10.1 Set Up Automatic Restarts

```bash
# Make sure containers restart on failure/reboot
docker compose down

# Edit docker-compose.yml
nano docker-compose.yml
```

Add to each service:
```yaml
services:
  db:
    restart: unless-stopped
  ollama:
    restart: unless-stopped
  agent:
    restart: unless-stopped
  backend:
    restart: unless-stopped
```

Restart:
```bash
docker compose up -d
```

### 10.2 Enable Docker Auto-Start on Boot

```bash
sudo systemctl enable docker
```

### 10.3 Set Up Log Rotation

```bash
# Create logrotate config
sudo nano /etc/docker/daemon.json
```

Add:
```json
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
```

Restart Docker:
```bash
sudo systemctl restart docker
docker compose up -d
```

### 10.4 Regular Backups

**Backup Database**:
```bash
# Create backup directory
mkdir -p ~/backups

# Backup database
docker exec cyber-events-db pg_dump -U postgres cyber_events > ~/backups/cyber_events_$(date +%Y%m%d).sql

# Compress
gzip ~/backups/cyber_events_$(date +%Y%m%d).sql
```

**Automated backup script**:
```bash
nano ~/backup.sh
```

Add:
```bash
#!/bin/bash
BACKUP_DIR=~/backups
mkdir -p $BACKUP_DIR
docker exec cyber-events-db pg_dump -U postgres cyber_events | gzip > $BACKUP_DIR/cyber_events_$(date +%Y%m%d_%H%M%S).sql.gz
# Keep only last 7 days
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete
```

Make executable:
```bash
chmod +x ~/backup.sh
```

Add to crontab (daily at 2 AM):
```bash
crontab -e
```

Add line:
```
0 2 * * * /home/cyber/backup.sh
```

---

## Step 11: Accessing Remotely

### 11.1 Via SSH Tunnel (Most Secure)

On your **local machine**:

```bash
# Create SSH tunnel
ssh -L 8000:localhost:8000 -L 5432:localhost:5432 cyber@<SERVER_IP>
```

Now access on your local machine:
- Agent API: http://localhost:8000
- Database: localhost:5432

### 11.2 Via Public IP (Less Secure)

Access directly via server IP:
- Agent API: http://<SERVER_IP>:8000

**⚠️ Security Warning**: This exposes services to the internet. Consider:
1. Adding authentication
2. Using a reverse proxy (Nginx)
3. Setting up SSL/TLS

### 11.3 Optional: Set Up Domain Name

If you have a domain (e.g., `cyber-defense.yourdomain.com`):

1. **Add DNS A Record**: Point to your server IP
2. **Install Nginx**:
   ```bash
   sudo apt install -y nginx
   ```

3. **Configure Nginx**:
   ```bash
   sudo nano /etc/nginx/sites-available/cyber-defense
   ```

   Add:
   ```nginx
   server {
       listen 80;
       server_name cyber-defense.yourdomain.com;

       location / {
           proxy_pass http://localhost:8000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```

4. **Enable site**:
   ```bash
   sudo ln -s /etc/nginx/sites-available/cyber-defense /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

5. **Add SSL with Let's Encrypt**:
   ```bash
   sudo apt install -y certbot python3-certbot-nginx
   sudo certbot --nginx -d cyber-defense.yourdomain.com
   ```

---

## Troubleshooting

### Problem: Containers Won't Start

```bash
# Check logs
docker compose logs

# Check specific service
docker logs cyber-agent

# Restart all
docker compose restart
```

### Problem: Out of Memory

```bash
# Check memory
free -h

# If low, reduce Ollama memory limit in docker-compose.yml
# Or upgrade server to more RAM
```

### Problem: Ollama Not Responding

```bash
# Restart Ollama
docker compose restart ollama

# Re-pull Qwen model
docker exec ollama-qwen ollama pull qwen2.5:0.5b

# Check Ollama logs
docker logs ollama-qwen
```

### Problem: Can't Connect from Outside

```bash
# Check firewall
sudo ufw status

# Make sure port is allowed
sudo ufw allow 8000/tcp

# Check if service is listening
sudo netstat -tlnp | grep 8000
```

### Problem: LLM Analysis Too Slow

```bash
# Check server load
htop

# Reduce parallel workers
nano docker-compose.yml
# Under backend, add:
#   - DISPATCH_WORKERS=3

# Restart
docker compose restart backend
```

---

## Maintenance Commands

### Daily Operations

```bash
# Check status
docker ps

# View logs
docker compose logs --tail=50

# Check disk space
df -h

# Check memory
free -h
```

### Updates

```bash
cd ~/492-energy-defense

# Pull latest code (if using git)
git pull

# Rebuild and restart
docker compose down
docker compose build
docker compose up -d
```

### Clean Up

```bash
# Remove old images
docker image prune -a

# Remove old volumes (⚠️ deletes data!)
docker volume prune

# Remove old containers
docker container prune
```

---

## Cost Optimization

### Lower Costs

1. **Use CPX21** (8GB RAM) - €15/month instead of €30/month
   - May be slower but functional

2. **Stop server when not in use**:
   ```bash
   docker compose down
   sudo shutdown -h now
   ```

3. **Use Hetzner Snapshots** before shutting down
   - Save state, delete server, recreate from snapshot later

### Estimate Costs

- **CPX21** (8GB): ~€15/month (~€0.021/hour)
- **CPX31** (16GB): ~€30/month (~€0.042/hour)
- **CPX41** (32GB): ~€60/month (~€0.083/hour)

**Bandwidth**: 20TB included (more than enough)

---

## Summary Checklist

✅ **Server Created** on Hetzner Cloud  
✅ **SSH Access** configured  
✅ **Docker Installed** and configured  
✅ **Code Deployed** to server  
✅ **Services Running** (all containers up)  
✅ **Qwen Model** downloaded  
✅ **LLM Mode** enabled and verified  
✅ **Firewall** configured  
✅ **Monitoring** set up  
✅ **Backups** configured (optional)  
✅ **Remote Access** working  

---

## Quick Reference

**Server Access**:
```bash
ssh cyber@<SERVER_IP>
```

**Project Directory**:
```bash
cd ~/492-energy-defense
```

**Start Services**:
```bash
docker compose up -d
```

**Stop Services**:
```bash
docker compose down
```

**View Logs**:
```bash
docker logs -f cyber-agent
docker logs -f cyber-backend
```

**Check Health**:
```bash
curl http://localhost:8000/health | jq
```

**Restart Everything**:
```bash
docker compose restart
```

---

## Support

If you encounter issues:

1. Check logs: `docker compose logs`
2. Check system resources: `htop` and `df -h`
3. Restart services: `docker compose restart`
4. Check firewall: `sudo ufw status`
5. Review documentation: `cat LLM_MODE_IMPLEMENTATION.md`

---

**🎉 Your system is now running on Hetzner Cloud in LLM mode!**
