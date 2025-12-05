# Hetzner Deployment Guide

## Quick Deployment (5 Minutes)

### Prerequisites

1. **Hetzner Cloud Account**: https://console.hetzner.cloud
2. **SSH Key**: Must be configured on your local machine
3. **Local Machine**: Linux/macOS (or Windows with WSL2)

### Recommended Server Specs

| Purpose | Type | vCPU | RAM | Storage | Cost/Month |
|---------|------|------|-----|---------|------------|
| **Testing** | CX21 | 2 | 4GB | 40GB | ~€5 |
| **Production** | CPX21 | 3 | 8GB | 80GB | ~€15 |
| **Optimal** | CPX31 | 4 | 16GB | 160GB | ~€30 |

**Minimum**: 4GB RAM (for Docker + Qwen model)

---

## Step 1: Create Hetzner Server

1. **Login to Hetzner Console**: https://console.hetzner.cloud
2. **Click "Add Server"**
3. **Configure Server:**
   - **Location**: Choose nearest (e.g., Falkenstein, Nuremberg)
   - **Image**: Ubuntu 22.04 LTS
   - **Type**: CPX21 or better
   - **SSH Key**: Add your public SSH key
   - **Name**: `cyber-defense-agent`
4. **Click "Create & Buy"**
5. **Copy the server IP**: Example: `65.21.123.45`

---

## Step 2: Deploy Application

From your **local machine** (where you have this project):

```bash
# Make script executable
chmod +x deploy-to-hetzner.sh

# Deploy (replace with your server IP)
./deploy-to-hetzner.sh 65.21.123.45
```

If using non-root user:
```bash
./deploy-to-hetzner.sh 65.21.123.45 ubuntu
```

That's it! The script will:
- ✅ Install Docker and dependencies
- ✅ Copy application files
- ✅ Configure firewall
- ✅ Start all services
- ✅ Verify deployment

---

## Step 3: Access Your Application

After deployment completes (5-10 minutes):

**Dashboard**: `http://YOUR_SERVER_IP:3000`
- View alerts and security events
- Filter by severity
- Review case details

**Agent API**: `http://YOUR_SERVER_IP:8000`
- Test endpoint: `http://YOUR_SERVER_IP:8000/health`
- API Documentation: `http://YOUR_SERVER_IP:8000/docs`

---

## Verification Steps

### 1. Check Services
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
docker-compose ps
```

Should show 5 running services:
- `cyber-events-db` (PostgreSQL)
- `ollama-qwen` (AI Model)
- `cyber-agent` (Analysis API)
- `cyber-backend` (Event Generator)
- `cyber-dashboard` (Web UI)

### 2. Verify Qwen Model
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
./check-qwen-model.sh
```

### 3. Test API
```bash
curl http://YOUR_SERVER_IP:8000/health | jq
```

Should return:
```json
{
  "status": "healthy",
  "service": "492-Energy-Defense Cyber Event Triage Agent",
  "mode": "Rule-based",
  "model": "qwen2.5:0.5b"
}
```

### 4. View Logs
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense

# All logs
docker-compose logs -f

# Specific service
docker logs -f cyber-agent
docker logs -f cyber-backend
docker logs -f cyber-dashboard
```

---

## Management Commands

All commands run on the server at `/opt/cyber-defense`:

```bash
# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Restart services
docker-compose restart

# Restart specific service
docker-compose restart agent

# Stop everything
docker-compose down

# Start everything
docker-compose up -d

# View resource usage
docker stats

# Check Qwen model
./check-qwen-model.sh
```

---

## Troubleshooting

### Services Not Starting

```bash
# Check logs for errors
docker-compose logs

# Restart everything
docker-compose down
docker-compose up -d

# Check disk space
df -h

# Check memory
free -h
```

### Model Not Loading

```bash
# Manually pull model
docker exec ollama-qwen ollama pull qwen2.5:0.5b

# Check if loaded
docker exec ollama-qwen ollama list
```

### Cannot Access Dashboard

```bash
# Check firewall
ufw status

# Ensure ports are open
ufw allow 3000/tcp
ufw allow 8000/tcp

# Check if dashboard is running
docker logs cyber-dashboard
```

### High Memory Usage

```bash
# Check memory
docker stats

# If needed, restart services
docker-compose restart

# Or use rule-based mode (no LLM)
# Edit docker-compose.yml: USE_LLM=false
docker-compose restart agent
```

---

## Updating the Application

### Method 1: Redeploy
```bash
# From your local machine
./deploy-to-hetzner.sh YOUR_SERVER_IP
```

### Method 2: Manual Update
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense

# Pull latest changes (if using git)
git pull

# Rebuild and restart
docker-compose down
docker-compose build
docker-compose up -d
```

---

## Security Recommendations

### 1. Change Default Passwords

Edit `.env` on the server:
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
nano .env
```

Change:
```bash
POSTGRES_PASSWORD=your_secure_password_here
```

Then restart:
```bash
docker-compose down
docker-compose up -d
```

### 2. Enable HTTPS (Optional)

Install Caddy or Nginx reverse proxy:
```bash
# Install Caddy
apt install -y debian-keyring debian-archive-keyring apt-transport-https
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/gpg.key' | gpg --dearmor -o /usr/share/keyrings/caddy-stable-archive-keyring.gpg
curl -1sLf 'https://dl.cloudsmith.io/public/caddy/stable/debian.deb.txt' | tee /etc/apt/sources.list.d/caddy-stable.list
apt update
apt install caddy

# Configure Caddy
nano /etc/caddy/Caddyfile
```

Add:
```
cyber-defense.yourdomain.com {
    reverse_proxy localhost:3000
}

api.yourdomain.com {
    reverse_proxy localhost:8000
}
```

Restart Caddy:
```bash
systemctl restart caddy
```

### 3. Setup Automatic Backups

```bash
# Create backup script
cat > /opt/cyber-defense/backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/backups"
mkdir -p $BACKUP_DIR
DATE=$(date +%Y%m%d_%H%M%S)

# Backup database
docker exec cyber-events-db pg_dump -U postgres cyber_events | gzip > $BACKUP_DIR/db_backup_$DATE.sql.gz

# Keep only last 7 days
find $BACKUP_DIR -name "db_backup_*.sql.gz" -mtime +7 -delete

echo "Backup completed: $DATE"
EOF

chmod +x /opt/cyber-defense/backup.sh

# Add to crontab (daily at 2am)
(crontab -l 2>/dev/null; echo "0 2 * * * /opt/cyber-defense/backup.sh") | crontab -
```

---

## Performance Optimization

### For Small Servers (4GB RAM)

Use rule-based mode (no LLM overhead):

```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
nano docker-compose.yml
```

Change:
```yaml
environment:
  - USE_LLM=false  # Disable LLM mode
```

Restart:
```bash
docker-compose restart agent
```

### For Better Performance

Upgrade server or use:
- CPX31: 4 vCPU, 16GB RAM (~€30/month)
- CPX41: 8 vCPU, 32GB RAM (~€60/month)

---

## Monitoring Setup (Optional)

### Install monitoring tools:

```bash
ssh root@YOUR_SERVER_IP

# Install Netdata (real-time monitoring)
bash <(curl -Ss https://my-netdata.io/kickstart.sh)

# Access at http://YOUR_SERVER_IP:19999
```

### Setup alerts:

```bash
# Simple disk space alert
cat > /opt/cyber-defense/check-disk.sh << 'EOF'
#!/bin/bash
THRESHOLD=80
USAGE=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $USAGE -gt $THRESHOLD ]; then
    echo "WARNING: Disk usage is at ${USAGE}%"
fi
EOF

chmod +x /opt/cyber-defense/check-disk.sh
(crontab -l 2>/dev/null; echo "*/30 * * * * /opt/cyber-defense/check-disk.sh") | crontab -
```

---

## Cost Optimization

### Reduce Costs:

1. **Use smaller server** (CX21: €5/month) - sufficient for testing
2. **Use rule-based mode** - no LLM overhead
3. **Snapshot instead of running 24/7** - create snapshot, destroy server, restore when needed
4. **Use Hetzner's cheaper regions** - Falkenstein is typically cheapest

### Create Snapshot:

```bash
# Via Hetzner Console:
# 1. Stop the server
# 2. Click "Create Snapshot"
# 3. Destroy server when not in use
# 4. Restore from snapshot when needed
```

---

## Uninstall

To completely remove the application:

```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense

# Stop and remove containers
docker-compose down -v

# Remove application
cd /
rm -rf /opt/cyber-defense

# Remove Docker (optional)
apt-get purge docker-ce docker-ce-cli containerd.io -y
apt-get autoremove -y
```

Or simply destroy the Hetzner server from the console.

---

## Support

### Check Status
```bash
ssh root@YOUR_SERVER_IP 'cd /opt/cyber-defense && docker-compose ps'
```

### View Logs
```bash
ssh root@YOUR_SERVER_IP 'cd /opt/cyber-defense && docker-compose logs --tail=100'
```

### Restart Everything
```bash
ssh root@YOUR_SERVER_IP 'cd /opt/cyber-defense && docker-compose restart'
```

---

## Summary

**Deploy**: `./deploy-to-hetzner.sh YOUR_SERVER_IP`
**Access**: `http://YOUR_SERVER_IP:3000`
**Manage**: `ssh root@YOUR_SERVER_IP` → `cd /opt/cyber-defense`

That's it! Your cybersecurity agent is now running on Hetzner. 🚀
