# 🚀 Quick Deploy to Hetzner (5 Minutes)

Ultra-fast deployment guide using tar.gz file transfer.

## Local Machine (1 minute)

```bash
# Create deployment package
./create-deployment-package.sh

# Upload to server (replace YOUR_SERVER_IP)
scp cyber-defense-*.tar.gz root@YOUR_SERVER_IP:/root/
```

Enter root password when prompted.

---

## On Hetzner Server (4 minutes)

```bash
# SSH into server
ssh root@YOUR_SERVER_IP

# Extract and setup
cd /root
tar -xzf cyber-defense-*.tar.gz
cd 492-energy-defense
bash setup-hetzner.sh
```

Wait for setup to complete (installs Docker, configures firewall, starts services).

---

## Done! 🎉

Access your services:

```bash
# Get your server IP
curl ifconfig.me

# Then visit:
# Dashboard:  http://YOUR_IP:3000
# Agent API:  http://YOUR_IP:8000
# API Docs:   http://YOUR_IP:8000/docs
```

---

## Quick Test

```bash
# On server
curl http://localhost:8000/health | jq
docker-compose ps
./test-llm-mode.sh
```

---

## Common Commands

```bash
# View logs
docker-compose logs -f

# Restart
docker-compose restart

# Stop
docker-compose down

# Start
docker-compose up -d
```

---

## Troubleshooting

**Can't connect from outside?**
```bash
ufw allow 3000/tcp
ufw allow 8000/tcp
```

**Services not starting?**
```bash
docker-compose logs
systemctl status docker
```

**Need to update?**
```bash
# Upload new package, then:
cd /root/492-energy-defense
docker-compose down
tar -xzf ../cyber-defense-NEW.tar.gz -C /root --overwrite
docker-compose up -d
```

---

Full guide: See `HETZNER_TARBALL_DEPLOYMENT.md`
