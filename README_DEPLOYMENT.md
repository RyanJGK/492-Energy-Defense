# Deployment Package

This package contains everything needed to deploy the 492-Energy-Defense Cybersecurity Agent to a Hetzner cloud server.

## 📦 What's Included

```
deploy-to-hetzner.sh         # One-command deployment script
DEPLOYMENT_GUIDE.md          # Complete deployment guide
QUICKSTART_DEPLOYMENT.md     # 5-minute quick start
check-qwen-model.sh          # Model verification script
docker-compose.yml           # Production configuration
.env.example                 # Environment template
```

## 🚀 Quick Deploy

**Prerequisites:**
- Hetzner Cloud account
- SSH key configured
- Server with Ubuntu 22.04 LTS (CPX21 or better recommended)

**Deploy in one command:**
```bash
chmod +x deploy-to-hetzner.sh
./deploy-to-hetzner.sh YOUR_SERVER_IP
```

Replace `YOUR_SERVER_IP` with your Hetzner server's IP address.

## 📋 What the Deployment Does

The script automatically:

1. ✅ Tests SSH connection
2. ✅ Creates deployment package
3. ✅ Uploads to server
4. ✅ Installs Docker & Docker Compose
5. ✅ Configures firewall (ports 22, 3000, 8000)
6. ✅ Extracts and sets up application
7. ✅ Starts all services
8. ✅ Verifies deployment

**Time**: ~5 minutes
**First run**: Additional 1-2 minutes to download Qwen model

## 🌐 Access Your Services

After deployment:

- **Dashboard**: `http://YOUR_SERVER_IP:3000`
- **Agent API**: `http://YOUR_SERVER_IP:8000`
- **API Docs**: `http://YOUR_SERVER_IP:8000/docs`

## 🔧 Server Requirements

| Purpose | Type | vCPU | RAM | Storage | Cost/Month |
|---------|------|------|-----|---------|------------|
| Testing | CX21 | 2 | 4GB | 40GB | ~€5 |
| Production | CPX21 | 3 | 8GB | 80GB | ~€15 |
| Optimal | CPX31 | 4 | 16GB | 160GB | ~€30 |

**Minimum**: 4GB RAM

## 📖 Documentation

- **[QUICKSTART_DEPLOYMENT.md](QUICKSTART_DEPLOYMENT.md)** - 5-minute quick start
- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Complete guide with troubleshooting
- **[README.md](README.md)** - Application documentation

## ✅ Verification

After deployment, verify everything is working:

```bash
# Check services
ssh root@YOUR_SERVER_IP 'cd /opt/cyber-defense && docker-compose ps'

# Test API
curl http://YOUR_SERVER_IP:8000/health | jq

# Test Dashboard
curl http://YOUR_SERVER_IP:3000/health | jq

# Check Qwen model
ssh root@YOUR_SERVER_IP 'cd /opt/cyber-defense && ./check-qwen-model.sh'
```

## 🔄 Managing Your Deployment

### View Logs
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
docker-compose logs -f
```

### Restart Services
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
docker-compose restart
```

### Update Application
```bash
# From your local machine
./deploy-to-hetzner.sh YOUR_SERVER_IP
```

### Stop Services
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
docker-compose down
```

### Start Services
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
docker-compose up -d
```

## 🛡️ Security

The deployment automatically:
- ✅ Enables UFW firewall
- ✅ Opens only necessary ports (22, 3000, 8000)
- ✅ Uses isolated Docker network
- ✅ Stores data in Docker volumes

**Recommended**: Change default passwords in `.env` file

## 🐛 Troubleshooting

### Services Not Starting
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
docker-compose logs
```

### Model Not Loading
```bash
ssh root@YOUR_SERVER_IP
docker exec ollama-qwen ollama pull qwen2.5:0.5b
```

### Out of Memory
Edit `docker-compose.yml` and set `USE_LLM=false` for rule-based mode:
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
nano docker-compose.yml
# Change: USE_LLM=false
docker-compose restart agent
```

### Cannot Access Dashboard
```bash
ssh root@YOUR_SERVER_IP
ufw allow 3000/tcp
ufw allow 8000/tcp
ufw reload
```

## 📊 Performance Optimization

**For Small Servers (4GB RAM):**
- Use rule-based mode (set `USE_LLM=false`)
- Reduces memory usage by ~4GB
- Provides 100% accurate scoring

**For Better AI Performance:**
- Upgrade to CPX31 (16GB RAM)
- Or use Qwen 1.5B or 3B model

## 💰 Cost Optimization

- **CX21** (~€5/month): Testing and development
- **CPX21** (~€15/month): Production (recommended)
- **Snapshots**: Create snapshot when not in use, destroy server, restore later

## 🔐 Backup

Set up automatic database backups:
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense

# Create backup script (included in deployment)
cat > backup.sh << 'EOF'
#!/bin/bash
BACKUP_DIR="/backups"
mkdir -p $BACKUP_DIR
DATE=$(date +%Y%m%d_%H%M%S)
docker exec cyber-events-db pg_dump -U postgres cyber_events | gzip > $BACKUP_DIR/db_backup_$DATE.sql.gz
find $BACKUP_DIR -name "db_backup_*.sql.gz" -mtime +7 -delete
EOF

chmod +x backup.sh

# Schedule daily backups
(crontab -l 2>/dev/null; echo "0 2 * * * /opt/cyber-defense/backup.sh") | crontab -
```

## 🗑️ Uninstall

To remove everything:
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyber-defense
docker-compose down -v
cd /
rm -rf /opt/cyber-defense
```

Or simply destroy the Hetzner server from the console.

## 📞 Support

**Quick Commands:**
```bash
# Status check
ssh root@YOUR_SERVER_IP 'cd /opt/cyber-defense && docker-compose ps'

# View recent logs
ssh root@YOUR_SERVER_IP 'cd /opt/cyber-defense && docker-compose logs --tail=100'

# Restart everything
ssh root@YOUR_SERVER_IP 'cd /opt/cyber-defense && docker-compose restart'
```

**For detailed help**: See [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)

## 📝 Example Deployment

```bash
# 1. Create Hetzner server (Ubuntu 22.04, CPX21)
# 2. Note the IP: 65.21.123.45

# 3. Deploy
./deploy-to-hetzner.sh 65.21.123.45

# 4. Wait for completion (5 minutes)

# 5. Access dashboard
open http://65.21.123.45:3000

# 6. Verify
curl http://65.21.123.45:8000/health | jq
```

## ✨ Features

- ✅ **One-command deployment**
- ✅ **Automatic dependency installation**
- ✅ **Firewall configuration**
- ✅ **Health checks**
- ✅ **Rollback support**
- ✅ **Production-ready**

---

**Ready to deploy?**

```bash
./deploy-to-hetzner.sh YOUR_SERVER_IP
```

See [QUICKSTART_DEPLOYMENT.md](QUICKSTART_DEPLOYMENT.md) for a 5-minute walkthrough!

---

**Built for easy deployment** | 492-Energy-Defense Cybersecurity Agent
