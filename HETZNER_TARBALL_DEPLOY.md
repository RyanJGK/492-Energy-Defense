# Hetzner Deployment via Tar.gz Package

## Quick Deployment Guide (Root User with Password)

This guide is for deploying to Hetzner using a simple tar.gz package when you have root access with password authentication.

---

## Step 1: Create Deployment Package

On your **local machine** (where the code is):

```bash
# Create the deployment package
./create-deployment-package.sh
```

This creates: `cyber-defense-deployment.tar.gz` (~10-20MB)

---

## Step 2: Upload to Hetzner Server

### Option A: Using SCP (Secure Copy)

```bash
# Replace YOUR_SERVER_IP with your actual IP
scp cyber-defense-deployment.tar.gz root@YOUR_SERVER_IP:/root/

# Enter password when prompted
```

### Option B: Using SFTP

```bash
sftp root@YOUR_SERVER_IP
# Enter password
put cyber-defense-deployment.tar.gz
quit
```

### Option C: Using Web Panel

If your provider has a file manager:
1. Login to Hetzner Cloud Console
2. Use the web-based file manager
3. Upload `cyber-defense-deployment.tar.gz` to `/root/`

---

## Step 3: Connect to Server

```bash
ssh root@YOUR_SERVER_IP
# Enter password when prompted
```

---

## Step 4: Extract and Setup

Once connected to your Hetzner server:

```bash
# Extract the package
tar -xzf cyber-defense-deployment.tar.gz

# Go into the directory
cd cyber-defense-deploy

# Run setup script (installs Docker, configures firewall, etc.)
bash setup-server.sh
```

The setup script will:
- ✅ Update the system
- ✅ Install Docker & Docker Compose
- ✅ Configure firewall (ports 22, 8000, 3000, 11434)
- ✅ Copy files to `/opt/cyber-defense`
- ✅ Create environment configuration

---

## Step 5: Start Services

```bash
# Go to application directory
cd /opt/cyber-defense

# Start all services
./start-services.sh
```

Wait for the message: **"Qwen model ready!"** (takes 1-2 minutes)

Press `Ctrl+C` to exit the logs.

---

## Step 6: Verify It's Running

```bash
# Check service status
./check-status.sh
```

Expected output:
```
Service Status:
NAME               STATUS
ollama-qwen        Up X minutes (healthy)
cyber-agent        Up X minutes (healthy)
cyber-backend      Up X minutes
cyber-dashboard    Up X minutes
cyber-events-db    Up X minutes (healthy)

Model Status:
qwen2.5:0.5b      [model details]

Agent Health:
{
  "status": "healthy",
  "model": "qwen2.5:0.5b"
}

Public IP: XX.XX.XX.XX
```

---

## Step 7: Access the Application

### From Your Browser

Replace `YOUR_SERVER_IP` with your actual server IP:

- **Dashboard**: http://YOUR_SERVER_IP:3000
- **Agent API**: http://YOUR_SERVER_IP:8000
- **API Docs**: http://YOUR_SERVER_IP:8000/docs

### Test the API

```bash
# From your local machine
curl http://YOUR_SERVER_IP:8000/health
```

---

## Management Commands

### View Logs
```bash
cd /opt/cyber-defense

# All logs
docker-compose logs -f

# Specific service
docker-compose logs -f cyber-agent
docker-compose logs -f cyber-backend
docker-compose logs -f ollama-qwen
```

### Check Status
```bash
./check-status.sh
```

### Restart Services
```bash
docker-compose restart

# Or restart specific service
docker-compose restart agent
```

### Stop Services
```bash
docker-compose down
```

### Start Again
```bash
docker-compose up -d
```

### Update Application

To deploy updates:
```bash
# On local machine - create new package
./create-deployment-package.sh

# Upload new package
scp cyber-defense-deployment.tar.gz root@YOUR_SERVER_IP:/root/

# On server
cd /root
tar -xzf cyber-defense-deployment.tar.gz
cd cyber-defense-deploy
cp -r * /opt/cyber-defense/
cd /opt/cyber-defense
docker-compose down
docker-compose build
docker-compose up -d
```

---

## Troubleshooting

### Can't Upload File (File Too Large)

Compress better:
```bash
# Create smaller package without some docs
tar -czf cyber-defense-deployment.tar.gz \
  --exclude='*.md' \
  --exclude='.*' \
  cyber-defense-deploy/
```

### Upload Interrupted

Resume upload with rsync:
```bash
rsync -avz --progress cyber-defense-deployment.tar.gz root@YOUR_SERVER_IP:/root/
```

### Services Not Starting

Check Docker:
```bash
docker --version
docker-compose --version
systemctl status docker
```

Restart Docker:
```bash
systemctl restart docker
cd /opt/cyber-defense
docker-compose up -d
```

### Firewall Blocking Access

Check firewall:
```bash
ufw status
```

Open required ports:
```bash
ufw allow 8000/tcp
ufw allow 3000/tcp
ufw allow 11434/tcp
```

### Out of Disk Space

Check space:
```bash
df -h
```

Clean up Docker:
```bash
docker system prune -a
```

### Model Not Loading

Manual pull:
```bash
docker exec ollama-qwen ollama pull qwen2.5:0.5b
docker exec ollama-qwen ollama list
```

---

## Package Contents

The deployment package includes:

```
cyber-defense-deploy/
├── agent/                      # AI agent code
├── backend/                    # Backend service
├── dashboard/                  # Web dashboard
├── docker-compose.yml          # Service orchestration
├── .env                        # Configuration
├── setup-server.sh            # Initial server setup
├── start-services.sh          # Start all services
├── check-status.sh            # Status checker
├── apply-fix.sh               # Scoring fix tool
├── start.sh                   # Helper scripts
├── test-llm-mode.sh
├── check-qwen-model.sh
└── README.md                  # Documentation
```

---

## Complete Deployment Timeline

| Step | Time | Description |
|------|------|-------------|
| Create package | 10s | Run create-deployment-package.sh |
| Upload to server | 30-60s | SCP/SFTP upload |
| Setup server | 2-3 min | Install Docker, configure |
| Start services | 1-2 min | Download model, start containers |
| **Total** | **5-7 min** | Full deployment |

---

## Server Requirements

### Minimum
- **CPU**: 2 vCPUs
- **RAM**: 4 GB
- **Disk**: 20 GB
- **Cost**: ~€5-10/month (CX21)

### Recommended
- **CPU**: 4 vCPUs
- **RAM**: 8 GB
- **Disk**: 40 GB
- **Cost**: ~€15-20/month (CX31)

### With LLM Mode
- **CPU**: 4 vCPUs
- **RAM**: 16 GB
- **Disk**: 40 GB
- **Cost**: ~€30/month (CPX31)

---

## Security Notes

### Change Default Passwords

After deployment, update database password:

```bash
cd /opt/cyber-defense

# Edit .env
nano .env

# Change:
POSTGRES_PASSWORD=your_secure_password_here

# Restart
docker-compose down
docker-compose up -d
```

### Use SSH Keys (Optional)

For better security, set up SSH keys:

```bash
# On local machine
ssh-keygen -t rsa -b 4096

# Copy to server
ssh-copy-id root@YOUR_SERVER_IP

# Test
ssh root@YOUR_SERVER_IP  # Should not ask for password
```

### Disable Password Authentication (Optional)

```bash
# On server
nano /etc/ssh/sshd_config

# Change:
PasswordAuthentication no

# Restart SSH
systemctl restart sshd
```

---

## Quick Reference Card

```bash
# CREATE PACKAGE (local)
./create-deployment-package.sh

# UPLOAD (local)
scp cyber-defense-deployment.tar.gz root@SERVER_IP:/root/

# CONNECT (local)
ssh root@SERVER_IP

# EXTRACT & SETUP (server)
tar -xzf cyber-defense-deployment.tar.gz
cd cyber-defense-deploy
bash setup-server.sh

# START (server)
cd /opt/cyber-defense
./start-services.sh

# CHECK (server)
./check-status.sh

# ACCESS (browser)
http://SERVER_IP:3000  # Dashboard
http://SERVER_IP:8000  # API
```

---

## Support

If you encounter issues:

1. Check logs: `docker-compose logs -f`
2. Check status: `./check-status.sh`
3. Verify ports: `netstat -tlnp | grep -E '8000|3000'`
4. Check firewall: `ufw status`
5. Review README.md in the package

---

**Deployment complete!** 🚀

Access your dashboard at: **http://YOUR_SERVER_IP:3000**
