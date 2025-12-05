# ⚡ Hetzner Deployment - Ultra Quick Start

Deploy in **5 minutes** with 3 commands.

## Prerequisites

- Hetzner account
- SSH key configured
- Terminal with ssh/rsync

## Step 1: Create Server (Web UI)

1. Go to https://console.hetzner.cloud/
2. Click "Add Server"
3. Choose:
   - **Image**: Ubuntu 22.04 LTS
   - **Type**: CPX21 (€15/month)
   - **SSH Key**: Your key
4. Click "Create"
5. **Copy the IP address** (e.g., 65.21.123.45)

## Step 2: Setup Server

Replace `YOUR_IP` with your server IP:

```bash
# Copy setup script
scp deploy/hetzner-setup.sh root@YOUR_IP:/tmp/

# Run setup (takes 1-2 minutes)
ssh root@YOUR_IP "bash /tmp/hetzner-setup.sh"
```

## Step 3: Deploy Application

```bash
# From your local project directory
./deploy/deploy-to-hetzner.sh YOUR_IP
```

**Done!** 🎉

Access at: **http://YOUR_IP:8000**

---

## Verify It Works

```bash
# Health check
curl http://YOUR_IP:8000/health

# Test analysis
curl -X POST http://YOUR_IP:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "admin",
      "status": "FAIL",
      "is_admin": true
    }
  }' | jq
```

---

## Useful Commands

```bash
# View logs
ssh cyber@YOUR_IP 'cd /home/cyber/app && docker compose logs -f'

# Restart services
ssh cyber@YOUR_IP 'cd /home/cyber/app && docker compose restart'

# Check status
ssh cyber@YOUR_IP 'cd /home/cyber/app && docker compose ps'

# Update deployment
./deploy/deploy-to-hetzner.sh YOUR_IP
```

---

## Troubleshooting

**Can't connect?**
```bash
# Check firewall
ssh root@YOUR_IP 'ufw status'
ssh root@YOUR_IP 'ufw allow 8000/tcp'
```

**Services not starting?**
```bash
# Check logs
ssh cyber@YOUR_IP 'cd /home/cyber/app && docker compose logs'
```

**Need to switch to rule-based mode?**
```bash
# Edit config
ssh cyber@YOUR_IP
cd /home/cyber/app
nano .env
# Change: USE_LLM=false
docker compose restart
```

---

## Full Documentation

See `deploy/README.md` for complete documentation.

---

**Total time: ~5 minutes** ⏱️
**Monthly cost: ~€15** 💰
