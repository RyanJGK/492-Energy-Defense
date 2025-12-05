# Hetzner Deployment Guide (tar.gz method)

Simple deployment guide for Hetzner Cloud using tar.gz file transfer with root access.

## Prerequisites

- Hetzner Cloud server created
- Root password or SSH access
- Local terminal with `scp` or file transfer tool

## Server Requirements

**Minimum (Rule-Based Mode):**
- 2 vCPU
- 4 GB RAM
- 20 GB SSD
- **Server Type**: CX21 (~€5/month)

**Recommended (LLM Mode):**
- 4 vCPU
- 8 GB RAM
- 40 GB SSD
- **Server Type**: CX31 or CPX31 (~€15-30/month)

---

## Step 1: Create Deployment Package

On your **local machine**, in the project directory:

```bash
./create-deployment-package.sh
```

This creates a file like: `cyber-defense-20251202-143022.tar.gz`

---

## Step 2: Upload to Hetzner Server

### Option A: Using SCP (Command Line)

```bash
# Replace with your actual server IP and filename
scp cyber-defense-*.tar.gz root@YOUR_SERVER_IP:/root/
```

Enter root password when prompted.

### Option B: Using SFTP Client

Use FileZilla, WinSCP, or Cyberduck:
1. Connect to server with root credentials
2. Upload the `.tar.gz` file to `/root/`

### Option C: Using Web-Based Transfer

```bash
# On server (via Hetzner console or SSH)
cd /root
wget YOUR_FILE_URL/cyber-defense-*.tar.gz
```

---

## Step 3: SSH into Server

```bash
ssh root@YOUR_SERVER_IP
```

Or use Hetzner Cloud Console web terminal.

---

## Step 4: Extract and Setup

```bash
# Extract the package
cd /root
tar -xzf cyber-defense-*.tar.gz

# Enter project directory
cd 492-energy-defense

# Run setup script
bash setup-hetzner.sh
```

The setup script will:
1. Update system packages
2. Install Docker & Docker Compose
3. Install additional tools (curl, jq, git)
4. Configure firewall (UFW)
5. Build and start all containers
6. Download Qwen model (~1-2 minutes)

---

## Step 5: Verify Installation

### Check Services

```bash
docker-compose ps
```

Should show 5 services running:
- `cyber-events-db` (PostgreSQL)
- `ollama-qwen` (Ollama)
- `cyber-agent` (Agent API)
- `cyber-backend` (Event Generator)
- `cyber-dashboard` (Web UI)

### Check Agent Health

```bash
curl http://localhost:8000/health | jq
```

Expected output:
```json
{
  "status": "healthy",
  "service": "492-Energy-Defense Cyber Event Triage Agent",
  "mode": "Rule-based",
  "model": "N/A"
}
```

### Test Event Analysis

```bash
curl -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "test",
      "status": "SUCCESS",
      "timestamp": "2025-12-02T10:00:00"
    }
  }' | jq
```

---

## Step 6: Access Services

Get your server's public IP:

```bash
curl ifconfig.me
```

Then access:

- **Dashboard**: `http://YOUR_SERVER_IP:3000`
- **Agent API**: `http://YOUR_SERVER_IP:8000`
- **API Docs**: `http://YOUR_SERVER_IP:8000/docs`

---

## Configuration Options

### Enable LLM Mode

If you want to use LLM analysis instead of rule-based:

```bash
# Edit docker-compose.yml
nano docker-compose.yml

# Find the agent section and change:
- USE_LLM=false    # Change to true

# Save and restart
docker-compose restart agent
```

### Change Qwen Model

To use a larger model (better accuracy):

```bash
# Edit docker-compose.yml
nano docker-compose.yml

# Find OLLAMA_MODEL and change to:
- OLLAMA_MODEL=qwen2.5:1.5b  # or qwen2.5:3b

# Pull new model and restart
docker exec ollama-qwen ollama pull qwen2.5:1.5b
docker-compose restart agent
```

---

## Management Commands

### View Logs

```bash
# All services
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
# All services
docker-compose restart

# Specific service
docker-compose restart agent
docker-compose restart backend
```

### Stop Services

```bash
docker-compose down
```

### Start Services

```bash
docker-compose up -d
```

### Update Application

```bash
# Upload new tar.gz to server
cd /root
rm -rf 492-energy-defense  # Remove old version
tar -xzf cyber-defense-NEW.tar.gz
cd 492-energy-defense
docker-compose down
docker-compose build
docker-compose up -d
```

---

## Troubleshooting

### Can't Access Services from Outside

**Check firewall:**
```bash
ufw status
```

**Make sure ports are open:**
```bash
ufw allow 3000/tcp
ufw allow 8000/tcp
```

### Services Not Starting

**Check Docker:**
```bash
systemctl status docker
```

**Check logs:**
```bash
docker-compose logs
```

**Restart everything:**
```bash
docker-compose down
docker-compose up -d
```

### Out of Memory

**Check memory usage:**
```bash
free -h
docker stats --no-stream
```

**If using LLM mode with low RAM:**
```bash
# Switch to rule-based mode
nano docker-compose.yml
# Set USE_LLM=false
docker-compose restart agent
```

### Model Not Downloading

**Manual pull:**
```bash
docker exec ollama-qwen ollama pull qwen2.5:0.5b
```

**Check Ollama logs:**
```bash
docker logs ollama-qwen
```

---

## Security Recommendations

### Change Default Passwords

The system uses default PostgreSQL credentials. To change:

```bash
# Edit docker-compose.yml
nano docker-compose.yml

# Change POSTGRES_PASSWORD in db service
# Change DATABASE_URL in other services

# Restart
docker-compose down
docker-compose up -d
```

### Enable HTTPS

Use nginx reverse proxy with Let's Encrypt:

```bash
apt-get install -y nginx certbot python3-certbot-nginx

# Configure nginx for your domain
# Get SSL certificate
certbot --nginx -d your-domain.com
```

### Restrict Access

```bash
# Only allow specific IPs
ufw delete allow 3000/tcp
ufw delete allow 8000/tcp
ufw allow from YOUR_IP to any port 3000
ufw allow from YOUR_IP to any port 8000
```

---

## Resource Monitoring

### Check Resource Usage

```bash
# System resources
htop

# Docker resources
docker stats

# Disk usage
df -h
```

### Setup Monitoring (Optional)

```bash
# Install monitoring tools
apt-get install -y prometheus node-exporter grafana
```

---

## Backup

### Backup Database

```bash
docker exec cyber-events-db pg_dump -U postgres cyber_events > backup.sql
```

### Backup Configuration

```bash
cp docker-compose.yml docker-compose.yml.backup
cp .env .env.backup 2>/dev/null || true
```

### Restore Database

```bash
docker exec -i cyber-events-db psql -U postgres cyber_events < backup.sql
```

---

## Uninstall

To completely remove the application:

```bash
cd /root/492-energy-defense
docker-compose down -v  # Remove containers and volumes
cd /root
rm -rf 492-energy-defense
rm cyber-defense-*.tar.gz
```

---

## Quick Reference

### One-Line Deployment

```bash
# On local machine
./create-deployment-package.sh && scp cyber-defense-*.tar.gz root@YOUR_IP:/root/

# On server
ssh root@YOUR_IP
cd /root && tar -xzf cyber-defense-*.tar.gz && cd 492-energy-defense && bash setup-hetzner.sh
```

### Health Check

```bash
curl http://localhost:8000/health | jq
docker-compose ps
docker exec ollama-qwen ollama list
```

### Quick Restart

```bash
cd /root/492-energy-defense
docker-compose restart
```

---

## Support

For issues:
1. Check logs: `docker-compose logs`
2. Check status: `docker-compose ps`
3. Check system resources: `htop`
4. Review this guide's troubleshooting section

---

## Summary

✅ Simple tar.gz deployment
✅ One setup script does everything
✅ Works with root user and password
✅ No SSH key configuration needed
✅ Firewall automatically configured
✅ Ready to use in 5 minutes

**Deploy in 4 steps:**
1. Create package: `./create-deployment-package.sh`
2. Upload: `scp file.tar.gz root@SERVER:/root/`
3. Extract: `tar -xzf file.tar.gz`
4. Setup: `bash setup-hetzner.sh`

Done! 🎉
