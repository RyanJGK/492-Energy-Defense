# 🚀 Quick Deployment to Hetzner (5 Minutes)

## What You Need

1. Hetzner account (sign up at https://console.hetzner.cloud)
2. SSH key on your computer
3. This project on your local machine

## Deploy in 3 Steps

### Step 1: Create Server (2 minutes)

Go to https://console.hetzner.cloud and create a server:

- **Image**: Ubuntu 22.04 LTS
- **Type**: CPX21 (3 vCPU, 8GB RAM) - €15/month
- **Location**: Any (choose closest)
- **SSH Key**: Add your SSH key
- **Name**: cyber-defense

**Copy your server IP**: `65.21.123.45` (example)

### Step 2: Deploy (2 minutes)

On your local machine:

```bash
chmod +x deploy-to-hetzner.sh
./deploy-to-hetzner.sh 65.21.123.45
```

Replace `65.21.123.45` with your actual server IP.

Wait for deployment to complete...

### Step 3: Access (1 minute)

Open in your browser:

**Dashboard**: `http://65.21.123.45:3000`

**API**: `http://65.21.123.45:8000/docs`

Done! 🎉

---

## What Gets Installed

The deployment script automatically:
- ✅ Installs Docker
- ✅ Installs Docker Compose
- ✅ Configures firewall (ports 22, 3000, 8000)
- ✅ Deploys all services
- ✅ Downloads Qwen AI model
- ✅ Starts event generation

---

## Verify Deployment

```bash
# Check services are running
ssh root@65.21.123.45 'cd /opt/cyber-defense && docker-compose ps'

# View logs
ssh root@65.21.123.45 'cd /opt/cyber-defense && docker-compose logs -f'

# Test API
curl http://65.21.123.45:8000/health
```

---

## Common Commands

```bash
# SSH into server
ssh root@YOUR_SERVER_IP

# Go to app directory
cd /opt/cyber-defense

# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Restart services
docker-compose restart

# Stop everything
docker-compose down

# Start everything
docker-compose up -d
```

---

## Troubleshooting

### Services not starting?
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
docker-compose logs
```

### Cannot access dashboard?
```bash
# Check firewall
ssh root@YOUR_SERVER_IP 'ufw status'

# Ensure ports are open
ssh root@YOUR_SERVER_IP 'ufw allow 3000/tcp && ufw allow 8000/tcp'
```

### Out of memory?
Use rule-based mode (no AI overhead):
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
nano docker-compose.yml
# Change: USE_LLM=false
docker-compose restart agent
```

---

## Updating

Redeploy from your local machine:
```bash
./deploy-to-hetzner.sh YOUR_SERVER_IP
```

---

## Cost

| Server Type | vCPU | RAM | Storage | Price/Month |
|-------------|------|-----|---------|-------------|
| CX21 (min) | 2 | 4GB | 40GB | €5 |
| CPX21 (rec) | 3 | 8GB | 80GB | €15 |
| CPX31 (opt) | 4 | 16GB | 160GB | €30 |

**Recommendation**: CPX21 for production, CX21 for testing

---

## Need Help?

See full guide: [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

**Quick test after deployment:**
```bash
curl http://YOUR_SERVER_IP:8000/health | jq
curl http://YOUR_SERVER_IP:3000/health | jq
```

Both should return `{"status": "healthy", ...}`

---

**That's it! Your cybersecurity agent is now running on Hetzner.** 🎉
