# Hetzner Server Deployment Guide

Complete guide for deploying 492-Energy-Defense to a Hetzner Cloud server.

## Quick Start (5 Minutes)

### Step 1: Create Hetzner Server

1. Go to https://console.hetzner.cloud/
2. Create new server:
   - **Image**: Ubuntu 22.04 LTS
   - **Type**: CPX21 or higher (3 vCPU, 4GB RAM minimum)
   - **Location**: Choose nearest to you
   - **SSH Key**: Add your public SSH key
   - **Name**: cyber-defense
3. Note the server IP address (e.g., `65.21.123.45`)

### Step 2: Setup Server

From your local machine, run:

```bash
# Make scripts executable
chmod +x hetzner-setup.sh deploy-to-hetzner.sh

# Setup the server (one-time, as root)
ssh root@YOUR_SERVER_IP 'bash -s' < hetzner-setup.sh
```

This script will:
- ✅ Update system packages
- ✅ Install Docker and Docker Compose
- ✅ Configure firewall (UFW)
- ✅ Create application user (`cyber`)
- ✅ Optimize system for containers
- ✅ Setup log rotation

### Step 3: Deploy Application

```bash
# Deploy from your local machine
./deploy-to-hetzner.sh YOUR_SERVER_IP cyber
```

This will:
- ✅ Package the application
- ✅ Upload to server
- ✅ Deploy with Docker Compose
- ✅ Verify all services are running

### Step 4: Access Services

Open in your browser:
- **Dashboard**: http://YOUR_SERVER_IP:3000
- **API Docs**: http://YOUR_SERVER_IP:8000/docs

Done! 🎉

---

## Detailed Deployment Steps

### Prerequisites

**On your local machine:**
- SSH access to server
- SSH key added to Hetzner
- `bash`, `ssh`, `scp`, `tar` installed

**Hetzner server requirements:**
- **Minimum**: CPX21 (3 vCPU, 4GB RAM, 80GB SSD) ~€10/month
- **Recommended**: CPX31 (4 vCPU, 8GB RAM, 160GB SSD) ~€20/month
- **OS**: Ubuntu 22.04 LTS (recommended) or Ubuntu 24.04

### Server Setup (One-Time)

The `hetzner-setup.sh` script configures your server:

```bash
ssh root@YOUR_SERVER_IP 'bash -s' < hetzner-setup.sh
```

**What it does:**

1. **System Updates**
   - Updates all packages
   - Installs essential tools (curl, git, jq, vim, etc.)

2. **Docker Installation**
   - Removes old Docker versions
   - Installs latest Docker and Docker Compose
   - Enables Docker service

3. **Firewall Configuration**
   - Enables UFW firewall
   - Allows SSH (port 22)
   - Allows AI Agent (port 8000)
   - Allows Dashboard (port 3000)
   - Optionally allows PostgreSQL (port 5432)

4. **User Setup**
   - Creates `cyber` user for application
   - Adds user to docker group
   - Sets up application directory: `/opt/cyber-defense`

5. **System Optimization**
   - Increases file limits
   - Optimizes kernel parameters
   - Configures log rotation

**Time**: ~3-5 minutes

### Application Deployment

The `deploy-to-hetzner.sh` script handles deployment:

```bash
./deploy-to-hetzner.sh YOUR_SERVER_IP [SSH_USER]
```

**Parameters:**
- `YOUR_SERVER_IP`: Server IP address (required)
- `SSH_USER`: SSH user (default: `cyber`, can use `root`)

**What it does:**

1. **Tests Connection**
   - Verifies SSH access to server

2. **Creates Package**
   - Bundles application files
   - Includes docker-compose configuration
   - Adds production overrides
   - Creates deployment scripts

3. **Uploads Package**
   - Transfers package to server via SCP
   - Extracts to `/opt/cyber-defense`

4. **Deploys Application**
   - Stops existing containers
   - Pulls Docker images
   - Builds custom images
   - Starts all services

5. **Verifies Deployment**
   - Checks AI Agent health
   - Checks Dashboard health
   - Checks Database connectivity

**Time**: ~5-10 minutes (first deployment)

---

## Production Configuration

The deployment uses production-optimized settings:

### docker-compose.prod.yml

```yaml
version: '3.8'

services:
  agent:
    restart: always
    environment:
      - USE_LLM=false  # Rule-based mode for reliability
    
  backend:
    restart: always
    
  dashboard:
    restart: always
    
  db:
    restart: always
    
  ollama:
    restart: always
```

**Key settings:**
- ✅ `restart: always` - Auto-restart on failure or reboot
- ✅ `USE_LLM=false` - Rule-based mode (100% accurate, no LLM overhead)

### To Enable LLM Mode

Edit on server:

```bash
ssh cyber@YOUR_SERVER_IP
cd /opt/cyber-defense
nano docker-compose.prod.yml

# Change:
- USE_LLM=true

# Restart:
docker compose restart agent
```

---

## Server Management

### Connect to Server

```bash
ssh cyber@YOUR_SERVER_IP
cd /opt/cyber-defense
```

### View Logs

```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f agent
docker compose logs -f backend
docker compose logs -f dashboard
```

### Check Status

```bash
docker compose ps
```

### Restart Services

```bash
# All services
docker compose restart

# Specific service
docker compose restart agent
```

### Stop Services

```bash
docker compose down
```

### Start Services

```bash
docker compose up -d
```

### Update Deployment

From your local machine:

```bash
./deploy-to-hetzner.sh YOUR_SERVER_IP cyber
```

This will:
- Backup current deployment
- Deploy new version
- Restart services

---

## Monitoring

### Health Checks

```bash
# AI Agent
curl http://localhost:8000/health | jq

# Dashboard
curl http://localhost:3000/health | jq

# Database
docker exec cyber-events-db pg_isready -U postgres
```

### Resource Usage

```bash
# Container stats
docker stats

# System resources
htop

# Disk usage
df -h
```

### Database Access

```bash
# Connect to database
docker exec -it cyber-events-db psql -U postgres -d cyber_events

# Example queries
SELECT COUNT(*) FROM event_analyses;
SELECT severity, COUNT(*) FROM event_analyses GROUP BY severity;
SELECT * FROM event_analyses WHERE severity='critical' ORDER BY analyzed_at DESC LIMIT 10;
```

---

## Troubleshooting

### Services Not Starting

```bash
# Check logs
docker compose logs

# Check if ports are available
sudo netstat -tlnp | grep -E '3000|8000|5432'

# Restart Docker
sudo systemctl restart docker
docker compose up -d
```

### Firewall Issues

```bash
# Check firewall status
sudo ufw status

# Re-configure if needed
sudo ufw allow 8000/tcp
sudo ufw allow 3000/tcp
sudo ufw reload
```

### Out of Memory

```bash
# Check memory
free -h

# Add swap if needed
sudo fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
```

### Database Issues

```bash
# Reset database
docker compose down
docker volume rm workspace_postgres_data
docker compose up -d
```

### Complete Reset

```bash
# Stop and remove everything
docker compose down -v
docker system prune -a --volumes -f

# Redeploy
cd /opt/cyber-defense
bash deploy.sh
```

---

## Security Considerations

### Firewall Rules

The setup script configures UFW with minimal open ports:
- Port 22: SSH (required)
- Port 8000: AI Agent API
- Port 3000: Dashboard
- Port 5432: PostgreSQL (optional, blocked by default)

### SSH Hardening (Optional)

```bash
# Disable password authentication
sudo nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no

# Restart SSH
sudo systemctl restart sshd
```

### HTTPS Setup (Optional)

For production, use a reverse proxy with SSL:

```bash
# Install Nginx
sudo apt install nginx certbot python3-certbot-nginx

# Configure reverse proxy
sudo nano /etc/nginx/sites-available/cyber-defense

# Get SSL certificate
sudo certbot --nginx -d your-domain.com
```

### Database Security

By default, PostgreSQL is only accessible from Docker network. To restrict external access:

```bash
# Remove PostgreSQL port from firewall
sudo ufw delete allow 5432/tcp
```

---

## Backup and Recovery

### Backup Database

```bash
# Create backup
docker exec cyber-events-db pg_dump -U postgres cyber_events > backup_$(date +%Y%m%d).sql

# Download to local machine
scp cyber@YOUR_SERVER_IP:/opt/cyber-defense/backup_*.sql ./
```

### Restore Database

```bash
# Upload backup to server
scp backup_20251202.sql cyber@YOUR_SERVER_IP:/opt/cyber-defense/

# Restore
cat backup_20251202.sql | docker exec -i cyber-events-db psql -U postgres cyber_events
```

### Backup Volumes

```bash
# Backup all Docker volumes
docker run --rm -v workspace_postgres_data:/data -v $(pwd):/backup \
  ubuntu tar czf /backup/postgres_backup.tar.gz /data

docker run --rm -v workspace_ollama_data:/data -v $(pwd):/backup \
  ubuntu tar czf /backup/ollama_backup.tar.gz /data
```

---

## Scaling Considerations

### Vertical Scaling (Upgrade Server)

1. Create snapshot of current server in Hetzner console
2. Resize server to larger type (CPX41, CPX51, etc.)
3. Restart services

### Horizontal Scaling

For multiple servers, consider:
- Separate database server
- Load balancer for API/Dashboard
- Shared storage for Docker volumes

---

## Cost Estimation

| Server Type | vCPU | RAM | Storage | Monthly Cost |
|-------------|------|-----|---------|--------------|
| CPX11 | 2 | 2GB | 40GB | ~€5 | ⚠️ Too small |
| CPX21 | 3 | 4GB | 80GB | ~€10 | ✅ Minimum |
| CPX31 | 4 | 8GB | 160GB | ~€20 | ✅ Recommended |
| CPX41 | 8 | 16GB | 240GB | ~€40 | High performance |

**Recommended**: CPX31 for production use

---

## Support Files

The deployment package includes:

- `hetzner-setup.sh` - Server setup script
- `deploy-to-hetzner.sh` - Deployment script from local machine
- `deploy.sh` - Deployment script that runs on server
- `docker-compose.prod.yml` - Production configuration
- `apply-fix.sh` - Fix Qwen scoring issues
- `check-qwen-model.sh` - Verify model loading

---

## Quick Command Reference

```bash
# Initial setup (run once)
ssh root@YOUR_SERVER_IP 'bash -s' < hetzner-setup.sh

# Deploy application
./deploy-to-hetzner.sh YOUR_SERVER_IP cyber

# Connect to server
ssh cyber@YOUR_SERVER_IP
cd /opt/cyber-defense

# View logs
docker compose logs -f

# Check status
docker compose ps

# Restart
docker compose restart

# Update
./deploy-to-hetzner.sh YOUR_SERVER_IP cyber
```

---

## Next Steps

1. ✅ Deploy to Hetzner
2. ✅ Verify all services running
3. ✅ Open dashboard in browser
4. ✅ Wait for first event generation (30 min)
5. ✅ Review security settings
6. ✅ Setup backups
7. ✅ Monitor resource usage

**Questions or issues?** Check the troubleshooting section or logs!
