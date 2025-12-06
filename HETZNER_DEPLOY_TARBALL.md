# Hetzner Deployment via Tar.gz Package

## For Root User with Password Access

This guide is for deploying to Hetzner when you have:
- Root user access
- Password authentication (not SSH keys)
- Want a simple tar.gz upload method

---

## Step 1: Create Deployment Package

On your **local machine** (in the project directory):

```bash
./create-deployment-package.sh
```

This creates a file like: `cyber-defense-agent-20251202-143022.tar.gz`

**Package includes:**
- All application code (agent, backend, dashboard)
- Docker Compose configuration
- Auto-deployment script
- Essential documentation

**Package size:** ~5-10 MB (small!)

---

## Step 2: Upload to Hetzner

### Option A: Using SCP (Command Line)

```bash
scp cyber-defense-agent-*.tar.gz root@YOUR_SERVER_IP:/root/
```

When prompted, enter your root password.

### Option B: Using FileZilla (GUI)

1. Open FileZilla
2. Connect to your server:
   - Host: `sftp://YOUR_SERVER_IP`
   - Username: `root`
   - Password: `your_password`
   - Port: `22`
3. Drag and drop the `.tar.gz` file to `/root/`

### Option C: Using WinSCP (Windows GUI)

1. Open WinSCP
2. New Session:
   - File protocol: `SFTP`
   - Host name: `YOUR_SERVER_IP`
   - Port: `22`
   - User name: `root`
   - Password: `your_password`
3. Upload the `.tar.gz` file

---

## Step 3: Deploy on Hetzner

SSH into your server:

```bash
ssh root@YOUR_SERVER_IP
# Enter password when prompted
```

Extract and deploy:

```bash
# Navigate to the package
cd /root

# Extract the package
tar -xzf cyber-defense-agent-*.tar.gz

# Enter the directory
cd cyber-defense-agent

# Run the auto-deployment script
bash deploy-on-hetzner.sh
```

**The script will automatically:**
1. ✅ Install Docker
2. ✅ Install Docker Compose
3. ✅ Configure firewall (ports 22, 8000, 3000, 5432)
4. ✅ Start all services
5. ✅ Download Qwen model (~400MB, takes 1-2 minutes)

---

## Step 4: Verify Deployment

Wait 2-3 minutes for services to initialize, then check:

```bash
# Check service status
docker-compose ps

# Watch model download
docker logs -f ollama-init
# Press Ctrl+C when you see "Qwen model ready!"

# Check agent health
curl http://localhost:8000/health | jq
```

---

## Step 5: Access Your Services

Get your server IP:

```bash
curl ifconfig.me
```

Then open in your browser:

- **Dashboard**: `http://YOUR_SERVER_IP:3000`
- **Agent API**: `http://YOUR_SERVER_IP:8000`
- **API Docs**: `http://YOUR_SERVER_IP:8000/docs`

---

## Complete Example

```bash
# On your LOCAL machine:
./create-deployment-package.sh
# Creates: cyber-defense-agent-20251202-143022.tar.gz

# Upload to Hetzner
scp cyber-defense-agent-20251202-143022.tar.gz root@65.21.123.45:/root/
# Enter password when prompted

# SSH to Hetzner
ssh root@65.21.123.45
# Enter password when prompted

# On HETZNER server:
cd /root
tar -xzf cyber-defense-agent-20251202-143022.tar.gz
cd cyber-defense-agent
bash deploy-on-hetzner.sh

# Wait 2-3 minutes, then access:
# http://65.21.123.45:3000
```

---

## Server Requirements

**Minimum:**
- Ubuntu 20.04+ or Debian 11+
- 4GB RAM
- 20GB disk space
- Root access

**Recommended:**
- Ubuntu 22.04 LTS
- 8GB RAM
- 40GB disk space
- CPX31 or CX41 instance

---

## Firewall Ports

The deployment script automatically configures these ports:

| Port | Service | Access |
|------|---------|--------|
| 22 | SSH | Required |
| 3000 | Dashboard | Web UI |
| 8000 | Agent API | API Access |
| 5432 | PostgreSQL | Optional (external DB access) |

---

## Post-Deployment Commands

```bash
# View all logs
docker-compose logs -f

# View specific service
docker logs cyber-agent -f
docker logs cyber-backend -f
docker logs cyber-dashboard -f
docker logs ollama-qwen -f

# Check status
docker-compose ps

# Restart services
docker-compose restart

# Stop everything
docker-compose down

# Start again
docker-compose up -d
```

---

## Update Deployment

To update your deployment with new code:

1. **On local machine:** Create new package
   ```bash
   ./create-deployment-package.sh
   ```

2. **Upload new package** to Hetzner

3. **On Hetzner:**
   ```bash
   # Stop current services
   cd /root/cyber-defense-agent
   docker-compose down
   
   # Remove old directory
   cd /root
   rm -rf cyber-defense-agent
   
   # Extract new package
   tar -xzf cyber-defense-agent-NEW-DATE.tar.gz
   cd cyber-defense-agent
   
   # Deploy
   bash deploy-on-hetzner.sh
   ```

---

## Backup Your Data

To backup your database before updates:

```bash
# Backup database
docker exec cyber-events-db pg_dump -U postgres cyber_events > backup.sql

# Restore if needed
docker exec -i cyber-events-db psql -U postgres cyber_events < backup.sql
```

---

## Troubleshooting

### Upload fails with password

```bash
# Make sure you're using the correct password
# Try connecting first:
ssh root@YOUR_SERVER_IP

# If that works, try upload again
scp cyber-defense-agent-*.tar.gz root@YOUR_SERVER_IP:/root/
```

### Services not starting

```bash
# Check Docker is running
systemctl status docker

# Check logs
docker-compose logs

# Try restarting
docker-compose down
docker-compose up -d
```

### Can't access from browser

```bash
# Check firewall
ufw status

# Make sure ports are open
ufw allow 3000/tcp
ufw allow 8000/tcp

# Check services are running
docker-compose ps
```

### Model not downloading

```bash
# Check Ollama logs
docker logs ollama-qwen

# Manually pull model
docker exec ollama-qwen ollama pull qwen2.5:0.5b

# Or upgrade to larger model
docker exec ollama-qwen ollama pull qwen2.5:1.5b
```

---

## Security Notes

**For Production:**
1. Change default passwords in `.env` file
2. Set up proper firewall rules
3. Consider using SSH keys instead of password
4. Enable HTTPS with Let's Encrypt
5. Restrict database port (5432) to localhost only

**Change passwords:**
```bash
cd /root/cyber-defense-agent
nano .env
# Edit POSTGRES_PASSWORD
docker-compose down
docker-compose up -d
```

---

## Package Contents

```
cyber-defense-agent/
├── agent/                      # AI Agent service
├── backend/                    # Backend service
├── dashboard/                  # Dashboard service
├── docker-compose.yml          # Service configuration
├── .env                        # Environment variables
├── deploy-on-hetzner.sh        # Auto-deployment script
├── README.md                   # Full documentation
├── DEPLOY_README.txt           # Quick start guide
└── *.sh                        # Helper scripts
```

---

## Quick Reference Card

```
┌─────────────────────────────────────────────────────────┐
│  LOCAL MACHINE                                          │
├─────────────────────────────────────────────────────────┤
│  $ ./create-deployment-package.sh                       │
│  $ scp cyber-defense-*.tar.gz root@SERVER_IP:/root/     │
└─────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────┐
│  HETZNER SERVER                                         │
├─────────────────────────────────────────────────────────┤
│  $ ssh root@SERVER_IP                                   │
│  $ cd /root                                             │
│  $ tar -xzf cyber-defense-*.tar.gz                      │
│  $ cd cyber-defense-agent                               │
│  $ bash deploy-on-hetzner.sh                            │
│                                                          │
│  Wait 2-3 minutes...                                    │
│                                                          │
│  Access: http://SERVER_IP:3000                          │
└─────────────────────────────────────────────────────────┘
```

---

## Support

- Full documentation: `README.md` (included in package)
- Check logs: `docker-compose logs`
- Restart services: `docker-compose restart`
- View status: `docker-compose ps`

---

**Deployment time: ~5-10 minutes total** (including model download)
