# Simple Hetzner Deployment with Root User

## Prerequisites

- Hetzner Cloud Server (CPX31 recommended: 4 vCPU, 16GB RAM)
- Root user access with password
- Your local machine with the project files

---

## Step 1: Create Deployment Package (On Your Local Machine)

```bash
# In your project directory
./create-deployment-package.sh
```

This creates a `cyber-defense-YYYYMMDD-HHMMSS.tar.gz` file.

---

## Step 2: Copy to Hetzner Server

```bash
# Replace YOUR_SERVER_IP with your actual server IP
scp cyber-defense-*.tar.gz root@YOUR_SERVER_IP:~/

# Enter your root password when prompted
```

**Example:**
```bash
scp cyber-defense-20251202-143022.tar.gz root@65.108.123.45:~/
# Password: ********
```

---

## Step 3: SSH into Server

```bash
ssh root@YOUR_SERVER_IP
# Enter password when prompted
```

---

## Step 4: Install Docker (On Server)

```bash
# Update system
apt update && apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
apt install -y docker-compose

# Verify installation
docker --version
docker-compose --version
```

---

## Step 5: Extract and Deploy

```bash
# Extract the package
tar -xzf cyber-defense-*.tar.gz

# Enter the directory
cd 492-energy-defense

# Create .env file (optional - uses defaults)
cp .env.example .env

# Start the system
docker-compose up -d

# Watch the Qwen model download (1-2 minutes)
docker logs -f ollama-init
# Wait for "Qwen model ready!" then press Ctrl+C
```

---

## Step 6: Configure Firewall

```bash
# Allow necessary ports
ufw allow 22/tcp   # SSH
ufw allow 80/tcp   # HTTP (if using web access)
ufw allow 443/tcp  # HTTPS (if using web access)
ufw allow 8000/tcp # Agent API (optional, for external access)
ufw allow 3000/tcp # Dashboard (optional, for external access)

# Enable firewall
ufw --force enable

# Check status
ufw status
```

---

## Step 7: Verify Deployment

```bash
# Check all containers are running
docker ps

# Should see:
# - cyber-events-db
# - ollama-qwen
# - cyber-agent
# - cyber-backend
# - cyber-dashboard

# Check agent health
curl http://localhost:8000/health | jq

# Check dashboard
curl http://localhost:3000/health
```

---

## Step 8: Access from Your Local Machine

### Option A: Direct Access (if firewall allows)

Visit in your browser:
- Dashboard: `http://YOUR_SERVER_IP:3000`
- Agent API: `http://YOUR_SERVER_IP:8000/docs`

### Option B: SSH Tunnel (More Secure)

From your local machine:
```bash
# Forward dashboard
ssh -L 3000:localhost:3000 root@YOUR_SERVER_IP

# Forward agent
ssh -L 8000:localhost:8000 root@YOUR_SERVER_IP

# Keep this terminal open, then access:
# - http://localhost:3000 (Dashboard)
# - http://localhost:8000 (Agent API)
```

---

## Useful Commands on Server

```bash
# View logs
docker-compose logs -f

# View specific service
docker logs -f cyber-agent
docker logs -f cyber-backend
docker logs -f cyber-dashboard

# Check model is loaded
docker exec ollama-qwen ollama list

# Restart services
docker-compose restart

# Stop everything
docker-compose down

# Start again
docker-compose up -d

# View resource usage
docker stats
```

---

## Quick Update Deployment

When you make changes locally:

```bash
# 1. On local machine - create new package
./create-deployment-package.sh

# 2. Copy to server
scp cyber-defense-*.tar.gz root@YOUR_SERVER_IP:~/

# 3. On server - stop, extract, restart
ssh root@YOUR_SERVER_IP
docker-compose down
rm -rf 492-energy-defense
tar -xzf cyber-defense-*.tar.gz
cd 492-energy-defense
docker-compose up -d
```

---

## Troubleshooting

### Can't connect to server

```bash
# Test connection
ping YOUR_SERVER_IP

# Check SSH is open
telnet YOUR_SERVER_IP 22
```

### SCP authentication fails

```bash
# Make sure you're using the correct password
# If using SSH keys, add -i flag:
scp -i ~/.ssh/id_rsa cyber-defense-*.tar.gz root@YOUR_SERVER_IP:~/
```

### Docker fails to start

```bash
# Check Docker is running
systemctl status docker

# Start Docker
systemctl start docker

# Enable on boot
systemctl enable docker
```

### Out of memory

```bash
# Check memory
free -h

# If low, reduce Ollama memory in docker-compose.yml:
# memory: 4G  # instead of 8G
```

### Model won't download

```bash
# Check internet connection
ping google.com

# Manually pull model
docker exec ollama-qwen ollama pull qwen2.5:0.5b

# Or use rule-based mode (no model needed)
# Edit docker-compose.yml:
# - USE_LLM=false
docker-compose restart agent
```

---

## Production Recommendations

### 1. Use Non-Root User (More Secure)

```bash
# Create a user
adduser cyberdefense

# Add to docker group
usermod -aG docker cyberdefense

# Switch to user
su - cyberdefense

# Deploy as this user instead
```

### 2. Set Up SSL/TLS (For HTTPS)

```bash
# Install Nginx
apt install -y nginx certbot python3-certbot-nginx

# Configure reverse proxy
# (See Nginx configuration examples online)
```

### 3. Enable Auto-Updates

```bash
# Install unattended upgrades
apt install -y unattended-upgrades

# Configure
dpkg-reconfigure --priority=low unattended-upgrades
```

### 4. Set Up Monitoring

```bash
# Install monitoring tools
docker run -d --name watchtower \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower
```

### 5. Configure Backups

```bash
# Create backup script
cat > /root/backup.sh << 'BACKUP'
#!/bin/bash
DATE=$(date +%Y%m%d)
docker exec cyber-events-db pg_dump -U postgres cyber_events > /root/backup-$DATE.sql
BACKUP

chmod +x /root/backup.sh

# Add to crontab
crontab -e
# Add line:
# 0 2 * * * /root/backup.sh
```

---

## Complete Deployment Script (All-in-One)

Save this on your server as `deploy.sh`:

```bash
#!/bin/bash
set -e

echo "Installing Docker..."
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
apt install -y docker-compose

echo "Extracting application..."
tar -xzf cyber-defense-*.tar.gz
cd 492-energy-defense

echo "Starting services..."
docker-compose up -d

echo "Waiting for services..."
sleep 30

echo "Checking status..."
docker-compose ps

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Access your dashboard at: http://$(hostname -I | awk '{print $1}'):3000"
echo "Access API docs at: http://$(hostname -I | awk '{print $1}'):8000/docs"
```

Then just run:
```bash
chmod +x deploy.sh
./deploy.sh
```

---

## Summary

**On Local Machine:**
1. `./create-deployment-package.sh`
2. `scp cyber-defense-*.tar.gz root@YOUR_SERVER_IP:~/`

**On Server:**
1. `ssh root@YOUR_SERVER_IP`
2. Install Docker (one-time)
3. `tar -xzf cyber-defense-*.tar.gz`
4. `cd 492-energy-defense`
5. `docker-compose up -d`

**Done!** 🎉

Access your dashboard at `http://YOUR_SERVER_IP:3000`
