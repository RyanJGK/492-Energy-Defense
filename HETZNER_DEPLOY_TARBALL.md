# Hetzner Deployment via Tar.gz (Root User)

## Quick Deployment Guide

This guide is for deploying to a Hetzner server as **root user** using a tar.gz package.

---

## Step 1: Create Deployment Package (On Your Local Machine)

```bash
cd /path/to/workspace

# Create the deployment package
./create-deployment-package.sh
```

This creates `cyber-agent-deployment.tar.gz` (~5-10MB)

---

## Step 2: Upload to Hetzner Server

```bash
# Upload the package
scp cyber-agent-deployment.tar.gz root@YOUR_SERVER_IP:/root/

# Example:
scp cyber-agent-deployment.tar.gz root@65.108.123.45:/root/
```

---

## Step 3: Deploy on Hetzner (SSH as root)

```bash
# SSH to your server
ssh root@YOUR_SERVER_IP

# Extract the package
cd /root
tar -xzf cyber-agent-deployment.tar.gz
cd cyber-agent

# Run the deployment script
bash deploy-hetzner.sh
```

The script will:
1. ✅ Update system packages
2. ✅ Install Docker & Docker Compose
3. ✅ Configure firewall (ports 22, 3000, 8000)
4. ✅ Start all services
5. ✅ Download Qwen model (~400MB)

**Total time: 5-10 minutes** (first time)

---

## Step 4: Verify Deployment

### Monitor Model Download
```bash
docker logs -f ollama-init
# Wait for: "Qwen model ready!"
# Press Ctrl+C when done
```

### Check All Services
```bash
docker-compose ps
# All should show "Up" or "healthy"
```

### Test the Agent
```bash
./check-qwen-model.sh
```

### Access Dashboard
Open in browser: `http://YOUR_SERVER_IP:3000`

---

## Server Requirements

### Minimum (Qwen 0.5B)
- **CPU**: 2 vCPUs
- **RAM**: 4 GB
- **Storage**: 20 GB SSD
- **Cost**: ~€8-12/month (CX21)

### Recommended (Qwen 1.5B)
- **CPU**: 4 vCPUs
- **RAM**: 8 GB
- **Storage**: 40 GB SSD
- **Cost**: ~€15-20/month (CPX21/CX31)

### Optimal (Qwen 3B)
- **CPU**: 4-8 vCPUs
- **RAM**: 16 GB
- **Storage**: 40 GB SSD
- **Cost**: ~€30/month (CPX31)

---

## Post-Deployment Configuration

### Fix Scoring Issue (Qwen 0.5B is too small)

If you get incorrect risk scores:

```bash
./apply-fix.sh
```

Choose option:
1. **Rule-Based Mode** (100% accurate, no LLM) ⭐ RECOMMENDED
2. **Qwen 1.5B** (Better AI, 900MB)
3. **Qwen 3B** (Best AI, 2GB)
4. **Hybrid** (Accurate scores + AI reasoning)

---

## Useful Commands

### System Management
```bash
# Check status
docker-compose ps

# View logs
docker-compose logs -f

# View specific service
docker logs -f cyber-agent
docker logs -f cyber-backend
docker logs -f ollama-qwen

# Restart services
docker-compose restart

# Stop everything
docker-compose down

# Start again
docker-compose up -d
```

### Testing
```bash
# Check Qwen model
./check-qwen-model.sh

# Test LLM mode
./test-llm-mode.sh

# Test agent directly
curl http://localhost:8000/health | jq
```

### Resource Monitoring
```bash
# Check Docker resource usage
docker stats

# Check system resources
htop  # or: top

# Check disk usage
df -h
```

---

## Firewall Ports

The deployment script configures these ports:

| Port | Service | Access |
|------|---------|--------|
| 22 | SSH | External |
| 3000 | Dashboard | External |
| 8000 | Agent API | External |
| 5432 | PostgreSQL | Internal only |
| 11434 | Ollama | Internal only |

### Secure the Server (Optional but Recommended)

```bash
# Allow only specific IPs to access dashboard
ufw delete allow 3000/tcp
ufw allow from YOUR_IP_ADDRESS to any port 3000 proto tcp

# Same for API
ufw delete allow 8000/tcp
ufw allow from YOUR_IP_ADDRESS to any port 8000 proto tcp

# Reload firewall
ufw reload
```

---

## Troubleshooting

### Problem: Services won't start

```bash
# Check Docker is running
systemctl status docker

# Check logs
docker-compose logs

# Restart Docker
systemctl restart docker
docker-compose up -d
```

### Problem: Model download fails

```bash
# Check Ollama logs
docker logs ollama-qwen

# Pull model manually
docker exec ollama-qwen ollama pull qwen2.5:0.5b

# Or pull larger model
docker exec ollama-qwen ollama pull qwen2.5:1.5b
```

### Problem: Out of memory

```bash
# Check memory usage
free -h

# Reduce model size
./apply-fix.sh
# Choose option 1 (Rule-Based Mode)
```

### Problem: Can't access from browser

```bash
# Check firewall
ufw status

# Check services are listening
netstat -tulpn | grep -E '3000|8000'

# Check if services are running
docker-compose ps
```

---

## Update/Redeploy

To update the application:

```bash
# On local machine - create new package
./create-deployment-package.sh

# Upload to server
scp cyber-agent-deployment.tar.gz root@YOUR_SERVER_IP:/root/

# On server
ssh root@YOUR_SERVER_IP
cd /root
docker-compose down  # Stop current version
rm -rf cyber-agent   # Remove old files
tar -xzf cyber-agent-deployment.tar.gz
cd cyber-agent
docker-compose up -d  # Start new version
```

---

## Backup Data

The PostgreSQL database data is stored in Docker volumes.

### Backup Database
```bash
# Create backup
docker exec cyber-events-db pg_dump -U postgres cyber_events > backup.sql

# Download to local machine
scp root@YOUR_SERVER_IP:/root/cyber-agent/backup.sql ./
```

### Restore Database
```bash
# Upload backup
scp backup.sql root@YOUR_SERVER_IP:/root/cyber-agent/

# Restore on server
cat backup.sql | docker exec -i cyber-events-db psql -U postgres -d cyber_events
```

---

## Complete Reset

If you need to start completely fresh:

```bash
# Stop and remove everything
docker-compose down -v

# Remove all containers and images
docker system prune -a

# Start fresh
docker-compose up -d
```

---

## Summary Checklist

- ✅ Create deployment package: `./create-deployment-package.sh`
- ✅ Upload to server: `scp cyber-agent-deployment.tar.gz root@IP:/root/`
- ✅ SSH to server: `ssh root@IP`
- ✅ Extract: `tar -xzf cyber-agent-deployment.tar.gz`
- ✅ Deploy: `cd cyber-agent && bash deploy-hetzner.sh`
- ✅ Wait for model: `docker logs -f ollama-init`
- ✅ Test: `./check-qwen-model.sh`
- ✅ Fix scoring if needed: `./apply-fix.sh`
- ✅ Access dashboard: `http://YOUR_IP:3000`

---

## Support

- **Quick test**: `./test-llm-mode.sh`
- **Check model**: `./check-qwen-model.sh`
- **Fix scoring**: `./apply-fix.sh`
- **View logs**: `docker-compose logs -f`
- **Documentation**: See `README.md` and `FIX_QWEN_SCORING_ISSUE.md`

---

**Deployment time: 5-10 minutes**  
**Estimated cost: €8-30/month** (depending on server size)
