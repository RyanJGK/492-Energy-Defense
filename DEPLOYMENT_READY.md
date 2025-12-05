# 🚀 DEPLOYMENT READY!

## Ultra-Quick Deployment (30 seconds)

```bash
./quick-deploy.sh
# Enter your server IP when prompted
# That's it!
```

## What You Get

✅ **Complete deployment package** for Hetzner servers  
✅ **One-command deployment** - no manual configuration  
✅ **Automatic setup** - Docker, firewall, everything  
✅ **Production-ready** - optimized docker-compose  
✅ **Secure by default** - localhost-only database  

## Files Included

### Deployment Scripts
- `quick-deploy.sh` - Interactive deployment (easiest)
- `hetzner-deploy/deploy-to-hetzner.sh` - Full deployment script
- `hetzner-deploy/setup-server.sh` - Server preparation script

### Configuration Files
- `hetzner-deploy/docker-compose.prod.yml` - Production-optimized setup
- `hetzner-deploy/.env.production` - Production environment variables
- `hetzner-deploy/README.md` - Complete deployment documentation

## Deployment Methods

### Method 1: Quick Deploy (Recommended)
```bash
./quick-deploy.sh
```
Interactive script that asks for your server IP and handles everything.

### Method 2: Direct Deploy
```bash
./hetzner-deploy/deploy-to-hetzner.sh YOUR_SERVER_IP
```
Direct deployment if you know what you're doing.

### Method 3: Manual Deploy
See `hetzner-deploy/README.md` for step-by-step manual instructions.

## Server Requirements

**Minimum:**
- Ubuntu 22.04 or 24.04
- 2 vCPU, 4GB RAM, 20GB disk
- SSH access
- Cost: ~€5/month

**Recommended:**
- 4 vCPU, 8GB RAM, 40GB disk
- Better performance for LLM mode
- Cost: ~€10-20/month

## What Happens During Deployment

1. **Server Setup** (1 min)
   - Installs Docker
   - Configures firewall
   - Creates application user

2. **File Upload** (30 sec)
   - Packages application
   - Uploads to server
   - Extracts files

3. **Service Start** (2-3 min)
   - Builds Docker containers
   - Downloads AI model
   - Starts all services

**Total Time: ~5 minutes**

## After Deployment

Your services will be available at:
- **Dashboard**: `http://YOUR_IP:3000`
- **API**: `http://YOUR_IP:8000`
- **Docs**: `http://YOUR_IP:8000/docs`

## Quick Commands

### Check Status
```bash
ssh root@YOUR_IP 'cd /opt/cyberdefense && docker-compose ps'
```

### View Logs
```bash
ssh root@YOUR_IP 'cd /opt/cyberdefense && docker-compose logs -f'
```

### Restart
```bash
ssh root@YOUR_IP 'cd /opt/cyberdefense && docker-compose restart'
```

### Update
```bash
./quick-deploy.sh  # Just run again!
```

## Configuration Options

Default configuration:
- ✅ **Rule-based mode** (100% accurate, no LLM overhead)
- ✅ **Qwen 1.5B model** (if you enable LLM mode)
- ✅ **Automatic restarts**
- ✅ **Resource limits**
- ✅ **Localhost-only database**

To change settings, edit `.env` on the server:
```bash
ssh root@YOUR_IP
cd /opt/cyberdefense
nano .env
```

## Security Features

- Database only accessible from localhost
- Production password required (change in `.env`)
- Firewall configured automatically
- Read-only code volumes
- Resource limits to prevent abuse

## Troubleshooting

**Services not starting?**
```bash
ssh root@YOUR_IP
cd /opt/cyberdefense
docker-compose logs
```

**Model not downloading?**
```bash
ssh root@YOUR_IP
docker exec ollama-qwen ollama pull qwen2.5:1.5b
```

**Need to start over?**
```bash
ssh root@YOUR_IP
cd /opt/cyberdefense
docker-compose down -v
docker-compose up -d
```

## Complete Documentation

See `hetzner-deploy/README.md` for:
- Detailed troubleshooting
- Security hardening
- HTTPS setup
- Backup/restore procedures
- Manual deployment steps
- Configuration options

## Example Deployment Session

```bash
$ ./quick-deploy.sh

╔════════════════════════════════════════════════════════╗
║  Quick Deploy to Hetzner                              ║
╚════════════════════════════════════════════════════════╝

Enter your Hetzner server IP: 195.201.123.45

Deploying to 195.201.123.45...

[1/6] Testing SSH connection...
✓ SSH connection successful

[2/6] Checking server setup...
✓ Server already configured

[3/6] Creating deployment package...
✓ Package created

[4/6] Uploading to server...
✓ Package uploaded

[5/6] Setting up application...
✓ Application deployed

[6/6] Starting services...
✓ Services started

════════════════════════════════════════════════════════
Deployment Complete!

Access your application:
  Dashboard: http://195.201.123.45:3000
  API:       http://195.201.123.45:8000
  Docs:      http://195.201.123.45:8000/docs
```

---

**🎉 Ready to Deploy!**

Just run: `./quick-deploy.sh`
