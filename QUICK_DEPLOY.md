# Quick Deploy to Hetzner (5 Minutes)

## Prerequisites
- Hetzner Cloud account
- SSH key added to Hetzner
- Local machine with bash and ssh

## Step 1: Create Server (2 minutes)

1. Go to https://console.hetzner.cloud/
2. Click "Add Server"
3. Select:
   - **Location**: Closest to you
   - **Image**: Ubuntu 22.04 LTS
   - **Type**: CPX21 (3 vCPU, 4GB RAM) or higher
   - **SSH Key**: Select your key
   - **Name**: cyber-defense
4. Click "Create & Buy"
5. **Copy the server IP**: `65.21.123.45` (example)

## Step 2: Setup Server (2 minutes)

On your local machine:

```bash
# Make scripts executable
chmod +x hetzner-setup.sh deploy-to-hetzner.sh

# Setup server (replace IP)
ssh root@65.21.123.45 'bash -s' < hetzner-setup.sh
```

Wait for completion (~2 minutes)

## Step 3: Deploy Application (1 minute)

```bash
# Deploy (replace IP)
./deploy-to-hetzner.sh 65.21.123.45 cyber
```

Wait for completion (~5-10 minutes first time)

## Step 4: Access Services

Open in browser:
- Dashboard: http://65.21.123.45:3000
- API: http://65.21.123.45:8000/docs

**Done!** 🎉

---

## Quick Commands

```bash
# View logs
ssh cyber@65.21.123.45 'cd /opt/cyber-defense && docker compose logs -f'

# Check status
ssh cyber@65.21.123.45 'cd /opt/cyber-defense && docker compose ps'

# Restart
ssh cyber@65.21.123.45 'cd /opt/cyber-defense && docker compose restart'

# Update deployment
./deploy-to-hetzner.sh 65.21.123.45 cyber
```

---

## Troubleshooting

**Can't connect to server?**
```bash
# Test SSH
ssh root@YOUR_SERVER_IP

# If fails, check:
# - IP address is correct
# - SSH key is added to Hetzner
# - Server is running
```

**Services not starting?**
```bash
# Connect to server
ssh cyber@YOUR_SERVER_IP
cd /opt/cyber-defense

# Check logs
docker compose logs

# Restart
docker compose restart
```

**Need to reset?**
```bash
ssh cyber@YOUR_SERVER_IP 'cd /opt/cyber-defense && docker compose down -v && docker compose up -d'
```

---

## What Gets Deployed

✅ PostgreSQL database  
✅ AI Agent (rule-based mode)  
✅ Backend event generator  
✅ Web Dashboard  
✅ Ollama (optional, not used by default)  

**Configuration**: Production-optimized with auto-restart

**Mode**: Rule-based (100% accurate, no LLM overhead)

**Events**: Generated every 30 minutes

---

## Full Documentation

See `HETZNER_DEPLOYMENT.md` for complete guide including:
- Security hardening
- Monitoring
- Backups
- Troubleshooting
- Scaling

---

**Total Time**: ~5-10 minutes  
**Monthly Cost**: ~€10-20 (CPX21/CPX31)  
**Complexity**: Low (fully automated)
