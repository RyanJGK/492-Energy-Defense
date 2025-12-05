# 🚀 Easy Deployment to Hetzner Server

Complete package for deploying the 492-Energy-Defense system to a Hetzner cloud server.

## 📋 Prerequisites

**On Your Local Machine:**
- SSH key configured
- Bash shell (Linux/macOS/WSL)

**Hetzner Server Requirements:**
- Ubuntu 22.04 or 24.04
- Minimum: 2 vCPU, 4GB RAM, 20GB disk
- Recommended: 4 vCPU, 8GB RAM, 40GB disk
- SSH access (root or sudo user)

## 🎯 One-Command Deployment

```bash
# Make scripts executable
chmod +x hetzner-deploy/*.sh

# Deploy to your server
./hetzner-deploy/deploy-to-hetzner.sh YOUR_SERVER_IP
```

**Example:**
```bash
./hetzner-deploy/deploy-to-hetzner.sh 195.201.123.45
```

That's it! The script will:
1. ✅ Setup Docker on the server
2. ✅ Configure firewall
3. ✅ Upload application files
4. ✅ Start all services
5. ✅ Download AI model

## 📦 What Gets Deployed

The deployment package includes:
- Docker containers for all services
- PostgreSQL database
- AI Agent (FastAPI)
- Backend event generator
- Dashboard (web interface)
- Ollama AI model (Qwen 2.5)

## 🌐 Accessing Your Application

After deployment, your services will be available at:

- **Dashboard**: `http://YOUR_SERVER_IP:3000`
- **Agent API**: `http://YOUR_SERVER_IP:8000`
- **API Docs**: `http://YOUR_SERVER_IP:8000/docs`

## 🔧 Server Management

### View Logs
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyberdefense
docker-compose logs -f
```

### Check Status
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyberdefense
docker-compose ps
```

### Restart Services
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyberdefense
docker-compose restart
```

### Stop Services
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyberdefense
docker-compose down
```

### Update Application
Just run the deploy script again:
```bash
./hetzner-deploy/deploy-to-hetzner.sh YOUR_SERVER_IP
```

## 🔒 Security Configuration

### Change Database Password

1. Edit `.env` on server:
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyberdefense
nano .env
```

2. Update password:
```
DB_PASSWORD=your_secure_password_here
```

3. Restart:
```bash
docker-compose down
docker-compose up -d
```

### Secure PostgreSQL Access

By default, PostgreSQL is only accessible from localhost (127.0.0.1).

To block external access completely:
```bash
ssh root@YOUR_SERVER_IP
ufw deny 5432/tcp
```

### Enable HTTPS (Optional)

For production, use a reverse proxy with SSL:

```bash
# Install Nginx
apt-get install -y nginx certbot python3-certbot-nginx

# Configure domain
nano /etc/nginx/sites-available/cyberdefense

# Add SSL with Let's Encrypt
certbot --nginx -d your-domain.com
```

## ⚙️ Configuration Options

### Use Rule-Based Mode (Recommended)

Edit `docker-compose.prod.yml` or `.env` on server:
```yaml
USE_LLM=false
```

This provides:
- ✅ 100% accurate scoring
- ✅ Instant response times
- ✅ Lower memory usage

### Use LLM Mode

For AI-powered analysis:
```yaml
USE_LLM=true
OLLAMA_MODEL=qwen2.5:1.5b
```

**Model Options:**
- `qwen2.5:1.5b` - Good balance (900MB, 3-4GB RAM)
- `qwen2.5:3b` - Better accuracy (2GB, 4-6GB RAM)
- `qwen2.5:7b` - Best accuracy (4GB, 8GB RAM)

## 📊 Monitoring

### Check Model Status
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyberdefense
docker exec ollama-qwen ollama list
```

### View Event Generation
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyberdefense
docker logs -f cyber-backend
```

### Monitor Resource Usage
```bash
ssh root@YOUR_SERVER_IP
docker stats
```

## 🆘 Troubleshooting

### Services Won't Start

Check logs:
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyberdefense
docker-compose logs
```

Restart everything:
```bash
docker-compose down
docker-compose up -d
```

### Model Not Downloading

Pull manually:
```bash
ssh root@YOUR_SERVER_IP
docker exec ollama-qwen ollama pull qwen2.5:1.5b
```

### Database Connection Issues

Reset database:
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyberdefense
docker-compose down -v
docker-compose up -d
```

### Port Already in Use

Change ports in `docker-compose.prod.yml`:
```yaml
ports:
  - "8001:8000"  # Agent on 8001 instead of 8000
```

## 🎓 Development vs Production

### Development (docker-compose.yml)
- Live code reloading
- Debug logging
- Volume mounts for development
- Smaller model (faster startup)

### Production (docker-compose.prod.yml)
- Read-only volumes
- Resource limits
- Automatic restarts
- Localhost-only database
- Production passwords
- Larger, more accurate model

## 📝 Manual Deployment Steps

If you prefer manual deployment:

### 1. Prepare Server
```bash
ssh root@YOUR_SERVER_IP
bash <(curl -s https://raw.githubusercontent.com/your-repo/setup-server.sh)
```

### 2. Upload Files
```bash
# On your local machine
scp -r ./* root@YOUR_SERVER_IP:/opt/cyberdefense/
```

### 3. Start Services
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyberdefense
docker-compose -f docker-compose.prod.yml up -d
```

## 💰 Cost Estimates

**Hetzner Server Costs:**
- CPX11 (2 vCPU, 4GB): ~€5/month (minimum)
- CPX21 (3 vCPU, 8GB): ~€10/month (recommended)
- CPX31 (4 vCPU, 16GB): ~€20/month (ideal)

## 📚 Additional Resources

- **Main Documentation**: `README.md`
- **Troubleshooting**: `FIX_QWEN_SCORING_ISSUE.md`
- **Model Setup**: `check-qwen-model.sh`

## 🔄 Backup and Restore

### Backup Database
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyberdefense
docker exec cyber-events-db pg_dump -U postgres cyber_events > backup.sql
```

### Restore Database
```bash
ssh root@YOUR_SERVER_IP
cd /opt/cyberdefense
cat backup.sql | docker exec -i cyber-events-db psql -U postgres cyber_events
```

## 🎉 Quick Start Example

```bash
# 1. Create Hetzner server with Ubuntu 22.04
# 2. Add your SSH key
# 3. Note the server IP

# 4. Deploy from your local machine
cd /path/to/492-energy-defense
chmod +x hetzner-deploy/*.sh
./hetzner-deploy/deploy-to-hetzner.sh 195.201.123.45

# 5. Wait 3-5 minutes for setup

# 6. Access your application
open http://195.201.123.45:3000
```

## ✅ Post-Deployment Checklist

- [ ] All containers running: `docker-compose ps`
- [ ] Agent API responding: `curl http://YOUR_IP:8000/health`
- [ ] Dashboard accessible: `http://YOUR_IP:3000`
- [ ] Model downloaded: `docker exec ollama-qwen ollama list`
- [ ] Events generating: `docker logs cyber-backend`
- [ ] Database password changed in `.env`
- [ ] Firewall configured: `ufw status`
- [ ] Backups scheduled (optional)

---

**Need Help?** Check the main `README.md` or open an issue.

**Built for easy deployment** | 492-Energy-Defense Course
