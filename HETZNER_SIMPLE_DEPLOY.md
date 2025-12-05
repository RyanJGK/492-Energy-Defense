# Simple Hetzner Deployment with tar.gz

## Overview

This is the **simplest way** to deploy to Hetzner using a tar.gz package as root user.

## Prerequisites

- Hetzner server with Ubuntu 22.04 or 24.04
- Root SSH access
- At least 4GB RAM, 2 vCPU

## Step-by-Step Deployment

### 1. Create Deployment Package (On Your Local Machine)

```bash
# In your project directory
chmod +x create-deployment-package.sh
./create-deployment-package.sh
```

This creates: `cyber-defense-agent-1.0.tar.gz`

### 2. Upload to Hetzner

```bash
# Replace with your server IP
scp cyber-defense-agent-1.0.tar.gz root@YOUR_SERVER_IP:/root/
```

Example:
```bash
scp cyber-defense-agent-1.0.tar.gz root@65.21.123.45:/root/
```

### 3. SSH into Hetzner Server

```bash
ssh root@YOUR_SERVER_IP
```

### 4. Extract Package

```bash
tar -xzf cyber-defense-agent-1.0.tar.gz
cd cyber-defense-agent
ls -la
```

You should see:
```
agent/
backend/
dashboard/
docker-compose.yml
.env.example
deploy-on-hetzner.sh
DEPLOY_README.md
README.md
```

### 5. Run Deployment Script

```bash
chmod +x deploy-on-hetzner.sh
./deploy-on-hetzner.sh
```

This will:
- ✅ Update system
- ✅ Install Docker & Docker Compose
- ✅ Install utilities (curl, jq, etc.)
- ✅ Configure firewall (UFW)
- ✅ Setup application directory

Takes ~3-5 minutes.

### 6. Start the Application

```bash
docker-compose up -d
```

### 7. Monitor the Startup

```bash
# Watch Qwen model download (1-2 minutes)
docker logs -f ollama-init

# Wait for "Qwen model ready!"
# Press Ctrl+C to exit
```

### 8. Verify Everything is Running

```bash
docker-compose ps
```

Expected output:
```
NAME              STATUS        PORTS
cyber-agent       Up (healthy)  0.0.0.0:8000->8000/tcp
cyber-backend     Up            
cyber-dashboard   Up (healthy)  0.0.0.0:3000->3000/tcp
cyber-events-db   Up (healthy)  0.0.0.0:5432->5432/tcp
ollama-qwen       Up (healthy)  0.0.0.0:11434->11434/tcp
```

### 9. Test the Agent

```bash
curl http://localhost:8000/health | jq
```

Expected output:
```json
{
  "status": "healthy",
  "service": "492-Energy-Defense Cyber Event Triage Agent",
  "mode": "Rule-based",
  "model": "qwen2.5:0.5b"
}
```

### 10. Access from Outside

From your browser:
- **Agent API**: http://YOUR_SERVER_IP:8000
- **Dashboard**: http://YOUR_SERVER_IP:3000
- **API Docs**: http://YOUR_SERVER_IP:8000/docs

## Complete Example

Here's the entire process in one script:

```bash
# === ON YOUR LOCAL MACHINE ===
./create-deployment-package.sh
scp cyber-defense-agent-1.0.tar.gz root@65.21.123.45:/root/

# === ON HETZNER SERVER ===
ssh root@65.21.123.45

# Extract
tar -xzf cyber-defense-agent-1.0.tar.gz
cd cyber-defense-agent

# Deploy
./deploy-on-hetzner.sh

# Start
docker-compose up -d

# Monitor
docker logs -f ollama-init  # Wait for "Qwen model ready!"

# Test
curl http://localhost:8000/health | jq

# Done! Access at http://65.21.123.45:8000
```

## Configuration Options

### Option 1: Use Rule-Based Mode (Recommended)

Edit `docker-compose.yml` before starting:

```yaml
agent:
  environment:
    - USE_LLM=false  # 100% accurate, no LLM needed
```

### Option 2: Use Different Qwen Model

```yaml
agent:
  environment:
    - OLLAMA_MODEL=qwen2.5:1.5b  # Larger model (900MB)
```

Then:
```bash
docker-compose up -d
docker exec ollama-qwen ollama pull qwen2.5:1.5b
docker-compose restart agent
```

## Useful Commands

```bash
# View logs (all services)
docker-compose logs -f

# View specific service
docker logs cyber-agent -f
docker logs cyber-backend -f

# Check status
docker-compose ps

# Restart services
docker-compose restart

# Stop everything
docker-compose down

# Start fresh (removes data)
docker-compose down -v
docker-compose up -d

# Resource usage
docker stats --no-stream

# Shell into container
docker exec -it cyber-agent bash
docker exec -it ollama-qwen bash
```

## Testing the System

### Test Event Analysis

```bash
curl -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "admin",
      "src_ip": "203.0.113.50",
      "status": "FAIL",
      "timestamp": "2025-12-02T02:30:00",
      "is_burst_failure": true,
      "is_suspicious_ip": true,
      "is_admin": true
    }
  }' | jq
```

Expected: `risk_score: 130, severity: "critical"`

### Check Database

```bash
docker exec -it cyber-events-db psql -U postgres -d cyber_events

# Inside psql:
SELECT COUNT(*) FROM event_analyses;
SELECT event_type, severity, COUNT(*) FROM event_analyses GROUP BY event_type, severity;
\q
```

### Check Qwen Model

```bash
docker exec ollama-qwen ollama list
```

Should show:
```
NAME              SIZE
qwen2.5:0.5b      400 MB
```

## Troubleshooting

### Problem: Can't connect from outside

```bash
# Check firewall
ufw status

# Allow ports
ufw allow 8000/tcp
ufw allow 3000/tcp

# Check if services are listening
netstat -tlnp | grep -E "8000|3000"
```

### Problem: Services not starting

```bash
# Check logs
docker-compose logs

# Restart specific service
docker-compose restart agent

# Full restart
docker-compose down
docker-compose up -d
```

### Problem: Model not downloading

```bash
# Check Ollama container
docker logs ollama-qwen

# Pull manually
docker exec ollama-qwen ollama pull qwen2.5:0.5b

# Verify
docker exec ollama-qwen ollama list
```

### Problem: Out of memory

```bash
# Check resources
free -h
docker stats --no-stream

# Use rule-based mode (no LLM)
# Edit docker-compose.yml: USE_LLM=false
docker-compose restart agent
```

## Updates and Maintenance

### Update the Application

```bash
# On your local machine, create new package
./create-deployment-package.sh

# Upload to server
scp cyber-defense-agent-1.0.tar.gz root@YOUR_SERVER_IP:/root/

# On server
cd /root
docker-compose down
tar -xzf cyber-defense-agent-1.0.tar.gz
cd cyber-defense-agent
docker-compose up -d
```

### System Updates

```bash
# Update system packages
apt update && apt upgrade -y

# Update Docker images
docker-compose pull
docker-compose up -d
```

### Backup Data

```bash
# Backup database
docker exec cyber-events-db pg_dump -U postgres cyber_events > backup.sql

# Backup volumes
docker run --rm -v workspace_postgres_data:/data -v $(pwd):/backup ubuntu tar czf /backup/postgres_backup.tar.gz /data
```

## Security Checklist

- [ ] Firewall configured (UFW)
- [ ] Only necessary ports open (22, 8000, 3000)
- [ ] SSH key authentication (disable password auth)
- [ ] Regular system updates
- [ ] Changed default passwords in `.env`
- [ ] HTTPS/TLS for production (use nginx reverse proxy)

## Cost Estimate (Hetzner)

| Server Type | vCPU | RAM | Storage | Cost/Month |
|-------------|------|-----|---------|------------|
| CPX11 | 2 | 2GB | 40GB | ~€5 | Minimum |
| CPX21 | 3 | 4GB | 80GB | ~€10 | Recommended |
| CPX31 | 4 | 8GB | 160GB | ~€20 | Comfortable |

**Recommendation**: CPX21 (4GB RAM) for rule-based mode

## Next Steps

1. ✅ Deploy to Hetzner using steps above
2. ✅ Access dashboard at http://YOUR_IP:3000
3. ✅ Test event analysis
4. ✅ Review configuration options
5. ✅ Setup monitoring/alerts
6. ✅ Configure backups

## Support

For issues:
1. Check logs: `docker-compose logs`
2. Check status: `docker-compose ps`
3. Review DEPLOY_README.md in package
4. Check firewall: `ufw status`

---

**Quick Command Reference Card**

```bash
# Deploy
./deploy-on-hetzner.sh && docker-compose up -d

# Status
docker-compose ps

# Logs
docker-compose logs -f

# Test
curl http://localhost:8000/health | jq

# Restart
docker-compose restart

# Stop
docker-compose down
```
