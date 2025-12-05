# 🚀 Easy Deployment to Hetzner Server

Complete deployment package for deploying the 492-Energy-Defense Cybersecurity Agent to a Hetzner cloud server.

## 📦 What's Included

- **hetzner-setup.sh** - Server initialization script (run ON server)
- **deploy-to-hetzner.sh** - Deployment script (run from LOCAL machine)
- **server-config.yml** - Optimized docker-compose for production
- **health-check.sh** - Post-deployment verification
- **README.md** - This file

## 🎯 Quick Start (5 Minutes)

### Prerequisites

- Hetzner Cloud account
- SSH key configured
- Local machine with SSH and rsync

### Step 1: Create Hetzner Server (2 min)

1. Go to [Hetzner Cloud Console](https://console.hetzner.cloud/)
2. Create new server:
   - **Image**: Ubuntu 22.04 LTS
   - **Type**: CPX21 (3 vCPU, 8GB RAM) - €15/month
   - **Location**: Closest to you
   - **SSH Key**: Add your public key
   - **Name**: cyber-defense
3. Note the **IP address**

### Step 2: Setup Server (1 min)

**Option A: Automated (Recommended)**

From your LOCAL machine:
```bash
# Copy setup script to server
scp deploy/hetzner-setup.sh root@YOUR_SERVER_IP:/tmp/

# Run setup
ssh root@YOUR_SERVER_IP "bash /tmp/hetzner-setup.sh"
```

**Option B: Manual**

SSH into your Hetzner server and run:
```bash
ssh root@YOUR_SERVER_IP

# Download and run setup script
curl -fsSL https://raw.githubusercontent.com/your-repo/workspace/main/deploy/hetzner-setup.sh | bash
```

### Step 3: Deploy Application (2 min)

From your LOCAL machine (in the project directory):
```bash
# Make deployment script executable
chmod +x deploy/deploy-to-hetzner.sh

# Deploy to server
./deploy/deploy-to-hetzner.sh YOUR_SERVER_IP
```

**That's it!** 🎉

### Step 4: Verify Deployment

```bash
# Check health
curl http://YOUR_SERVER_IP:8000/health

# View in browser
# Open: http://YOUR_SERVER_IP:8000/docs
```

---

## 📋 Detailed Instructions

### Server Specifications

**Minimum (Budget):**
- CPX11: 2 vCPU, 4GB RAM, 40GB SSD - ~€5/month
- ⚠️ Use rule-based mode only (USE_LLM=false)

**Recommended:**
- CPX21: 3 vCPU, 8GB RAM, 80GB SSD - ~€15/month
- ✅ Can run Qwen 1.5B model with LLM mode

**Optimal:**
- CPX31: 4 vCPU, 16GB RAM, 160GB SSD - ~€30/month
- ✅ Can run Qwen 3B model with excellent performance

### What the Setup Script Does

1. ✅ Updates system packages
2. ✅ Installs Docker and dependencies
3. ✅ Configures firewall (UFW)
4. ✅ Creates 'cyber' user
5. ✅ Sets up application directory
6. ✅ Configures Docker daemon

### What the Deploy Script Does

1. ✅ Tests SSH connection
2. ✅ Creates deployment package
3. ✅ Uploads files via rsync
4. ✅ Creates .env configuration
5. ✅ Pulls Docker images
6. ✅ Starts services
7. ✅ Verifies health
8. ✅ Provides access URLs

---

## 🔧 Configuration Options

### Environment Variables

Edit `.env` on the server to customize:

```bash
ssh cyber@YOUR_SERVER_IP
cd /home/cyber/app
nano .env
```

**Key settings:**

```bash
# Use rule-based (fast, accurate) or LLM mode
USE_LLM=false  # Set to 'true' for AI analysis

# Choose model (if USE_LLM=true)
OLLAMA_MODEL=qwen2.5:1.5b  # Options: 0.5b, 1.5b, 3b

# Database credentials (change for production!)
POSTGRES_PASSWORD=your_secure_password
```

After editing, restart:
```bash
docker compose restart
```

---

## 🔍 Post-Deployment

### Check Service Status

```bash
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose ps'
```

### View Logs

```bash
# All services
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose logs -f'

# Specific service
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose logs -f cyber-agent'
```

### Test the API

```bash
# Health check
curl http://YOUR_SERVER_IP:8000/health | jq

# Test event analysis
curl -X POST http://YOUR_SERVER_IP:8000/evaluate-event \
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

### Run Health Check

```bash
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && ./deploy/health-check.sh'
```

---

## 🔐 Security Recommendations

### 1. Change Default Passwords

```bash
# Edit .env and change:
POSTGRES_PASSWORD=your_secure_password_here
```

### 2. Restrict Firewall (Optional)

If you don't need external database access:
```bash
ssh root@YOUR_SERVER_IP
ufw delete allow 5432/tcp
```

### 3. Enable HTTPS (Recommended for Production)

Use a reverse proxy like nginx with Let's Encrypt:
```bash
# Install nginx and certbot
apt-get install -y nginx certbot python3-certbot-nginx

# Configure nginx to proxy to port 8000
# Get SSL certificate
certbot --nginx -d your-domain.com
```

### 4. Use SSH Keys Only

```bash
# Disable password authentication
ssh root@YOUR_SERVER_IP
nano /etc/ssh/sshd_config
# Set: PasswordAuthentication no
systemctl restart sshd
```

---

## 📊 Monitoring

### System Resources

```bash
ssh cyber@YOUR_SERVER_IP 'docker stats --no-stream'
```

### Application Statistics

```bash
# Connect to database
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker exec -it cyber-events-db psql -U postgres -d cyber_events'

# Run queries
SELECT COUNT(*) FROM event_analyses;
SELECT severity, COUNT(*) FROM event_analyses GROUP BY severity;
```

---

## 🔄 Updates and Maintenance

### Update Application Code

From your LOCAL machine:
```bash
# Pull latest changes
git pull

# Redeploy
./deploy/deploy-to-hetzner.sh YOUR_SERVER_IP
```

### Update Docker Images

```bash
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose pull && docker compose up -d'
```

### Backup Database

```bash
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker exec cyber-events-db pg_dump -U postgres cyber_events > backup_$(date +%Y%m%d).sql'
```

### Restore Database

```bash
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker exec -i cyber-events-db psql -U postgres cyber_events < backup_20241202.sql'
```

---

## 🆘 Troubleshooting

### Services Won't Start

```bash
# Check logs
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose logs'

# Restart services
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose restart'
```

### Out of Memory

```bash
# Check memory usage
ssh cyber@YOUR_SERVER_IP 'free -h'

# Solution: Switch to rule-based mode
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && nano .env'
# Set: USE_LLM=false
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose restart'
```

### Can't Connect to Server

```bash
# Check firewall
ssh root@YOUR_SERVER_IP 'ufw status'

# Allow port if needed
ssh root@YOUR_SERVER_IP 'ufw allow 8000/tcp'
```

### Model Download Stuck

```bash
# Pull model manually
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker exec ollama-qwen ollama pull qwen2.5:1.5b'
```

---

## 🗑️ Uninstall

### Stop and Remove Everything

```bash
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose down -v'
```

### Remove Application

```bash
ssh root@YOUR_SERVER_IP 'rm -rf /home/cyber/app'
```

### Delete Server

Go to Hetzner Console → Select Server → Delete

---

## 💰 Cost Estimation

### Monthly Costs

| Server Type | Price/Month | Recommended For |
|-------------|-------------|-----------------|
| CPX11 (2 vCPU, 4GB) | €5 | Testing, rule-based mode |
| CPX21 (3 vCPU, 8GB) | €15 | Production, LLM mode |
| CPX31 (4 vCPU, 16GB) | €30 | High-performance, large models |

**Additional costs:** None (includes bandwidth)

---

## 📞 Support

### Check Deployment Status

```bash
./deploy/health-check.sh YOUR_SERVER_IP
```

### View Real-time Logs

```bash
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose logs -f --tail=100'
```

### Get Help

1. Check logs first: `docker compose logs`
2. Review troubleshooting section above
3. Check firewall: `ufw status`
4. Verify DNS/IP: `ping YOUR_SERVER_IP`

---

## ✅ Quick Reference

```bash
# Deploy
./deploy/deploy-to-hetzner.sh YOUR_SERVER_IP

# Check status
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose ps'

# View logs
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose logs -f'

# Restart
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose restart'

# Stop
ssh cyber@YOUR_SERVER_IP 'cd /home/cyber/app && docker compose down'

# Update
./deploy/deploy-to-hetzner.sh YOUR_SERVER_IP
```

---

**🎉 Your cybersecurity agent is now running on Hetzner!**

Access it at: **http://YOUR_SERVER_IP:8000**
