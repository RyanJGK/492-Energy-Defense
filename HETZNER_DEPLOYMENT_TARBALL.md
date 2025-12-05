# Hetzner Deployment Guide - Using tar.gz

This guide is for deploying to Hetzner Cloud using password authentication (no SSH keys).

## Prerequisites

- Hetzner Cloud account
- A running Ubuntu server (22.04 or 24.04)
- Root password for SSH access
- Your local machine with SSH client

## Step 1: Create Deployment Package

On your **local machine** (in the project directory):

```bash
./create-deployment-package.sh
```

This creates a file like: `cyber-defense-20251202_143045.tar.gz`

## Step 2: Create Hetzner Server

1. **Go to Hetzner Cloud Console**: https://console.hetzner.cloud/

2. **Create a new server:**
   - **Location**: Choose closest to you (e.g., Nuremberg, Helsinki)
   - **Image**: Ubuntu 22.04 or 24.04
   - **Type**: 
     - **Minimum**: CPX21 (3 vCPU, 8GB RAM) - €15/month
     - **Recommended**: CPX31 (4 vCPU, 16GB RAM) - €30/month
   - **SSH Keys**: Skip (we'll use password)
   - **Volume**: None needed
   - **Name**: cyber-defense-agent

3. **Click "Create & Buy Now"**

4. **Note the credentials:**
   - IP Address: (shown in console, e.g., `65.21.123.45`)
   - Root Password: (sent to your email)

## Step 3: Upload Package to Server

On your **local machine**:

```bash
# Replace with your actual IP and filename
scp cyber-defense-20251202_143045.tar.gz root@65.21.123.45:/root/

# Enter the root password when prompted
```

**Note**: On Windows, use WinSCP or similar tool to upload the file.

## Step 4: Connect to Server

```bash
ssh root@65.21.123.45

# Enter the root password when prompted
```

## Step 5: Extract and Setup

On the **Hetzner server** (via SSH):

```bash
# Extract the package
tar -xzf cyber-defense-*.tar.gz

# Run the setup script
chmod +x hetzner-setup.sh
./hetzner-setup.sh
```

This script will:
- Update the system
- Install Docker and Docker Compose
- Configure firewall
- Set up the project directory

**Takes about 3-5 minutes**

## Step 6: Choose Your Configuration

After setup completes:

```bash
cd /opt/cyber-defense

# Choose how to handle the Qwen model issue
./apply-fix.sh
```

**Recommended options:**
- **Option 1**: Rule-based mode (100% accurate, no LLM)
- **Option 4**: Hybrid mode (accurate + AI reasoning)

## Step 7: Start the System

```bash
docker-compose up -d

# Watch the initialization (takes 1-2 minutes)
docker logs -f ollama-init

# When you see "Qwen model ready!" press Ctrl+C
```

## Step 8: Verify Everything Works

```bash
# Check all containers are running
docker-compose ps

# Test the agent
curl http://localhost:8000/health | jq

# Check model is loaded
./check-qwen-model.sh
```

## Step 9: Access from Your Computer

Get your server's public IP:

```bash
curl ifconfig.me
```

Then from your **local machine**:

```bash
# Test agent API
curl http://65.21.123.45:8000/health | jq

# Access dashboard in browser
http://65.21.123.45:3000
```

## Firewall Ports

The setup automatically opens these ports:
- **22**: SSH (already open)
- **8000**: Agent API
- **3000**: Dashboard
- **5432**: PostgreSQL (optional)

## Security Recommendations

### 1. Change Root Password

```bash
passwd
```

### 2. Create Non-Root User (Optional)

```bash
adduser cyberdefense
usermod -aG docker cyberdefense
usermod -aG sudo cyberdefense

# Switch to new user
su - cyberdefense
```

### 3. Set Up SSH Keys (Recommended)

On your **local machine**:

```bash
# Generate key if you don't have one
ssh-keygen -t ed25519

# Copy to server
ssh-copy-id root@65.21.123.45
```

### 4. Disable Password SSH (After keys work)

```bash
nano /etc/ssh/sshd_config

# Change:
PasswordAuthentication no

# Restart SSH
systemctl restart sshd
```

## Monitoring and Maintenance

### Check System Status

```bash
# Container status
docker-compose ps

# System resources
htop

# Docker resource usage
docker stats

# View logs
docker-compose logs -f
```

### Common Commands

```bash
# Restart services
docker-compose restart

# Stop everything
docker-compose down

# Start again
docker-compose up -d

# View agent logs
docker logs -f cyber-agent

# View backend logs
docker logs -f cyber-backend

# Check database
docker exec -it cyber-events-db psql -U postgres -d cyber_events
```

## Troubleshooting

### Problem: Can't connect via SSH

**Solution:**
1. Check IP address is correct
2. Check server is running in Hetzner console
3. Check firewall allows port 22
4. Try from different network (some ISPs block port 22)

### Problem: Can't upload file

**Solution:**
```bash
# Try with verbose mode
scp -v cyber-defense-*.tar.gz root@65.21.123.45:/root/

# Or use SFTP
sftp root@65.21.123.45
put cyber-defense-*.tar.gz
quit
```

### Problem: Docker not starting

**Solution:**
```bash
# Check Docker status
systemctl status docker

# Restart Docker
systemctl restart docker

# Check logs
journalctl -u docker -n 50
```

### Problem: Out of disk space

**Solution:**
```bash
# Check disk usage
df -h

# Clean up Docker
docker system prune -a

# Clean up old models
docker exec ollama-qwen ollama rm qwen2.5:0.5b
```

### Problem: Can't access from browser

**Solution:**
```bash
# Check firewall
ufw status

# Make sure ports are open
ufw allow 3000/tcp
ufw allow 8000/tcp

# Check containers are running
docker-compose ps

# Check if services are listening
netstat -tulpn | grep -E '3000|8000'
```

## Updating the System

To update to a new version:

```bash
# On local machine - create new package
./create-deployment-package.sh

# Upload to server
scp cyber-defense-*.tar.gz root@65.21.123.45:/root/

# On server
docker-compose down
cd /root
tar -xzf cyber-defense-*.tar.gz
cd /opt/cyber-defense
docker-compose up -d
```

## Backup and Restore

### Backup Database

```bash
# Create backup
docker exec cyber-events-db pg_dump -U postgres cyber_events > backup_$(date +%Y%m%d).sql

# Download to local machine
scp root@65.21.123.45:/root/backup_*.sql .
```

### Restore Database

```bash
# Upload backup to server
scp backup_*.sql root@65.21.123.45:/root/

# Restore
docker exec -i cyber-events-db psql -U postgres cyber_events < backup_20251202.sql
```

## Cost Estimates

| Server Type | Specs | Monthly Cost | Use Case |
|-------------|-------|--------------|----------|
| CPX21 | 3 vCPU, 8GB | ~€15 | Testing/Development |
| CPX31 | 4 vCPU, 16GB | ~€30 | Recommended |
| CPX41 | 8 vCPU, 32GB | ~€60 | High-load/Production |

## Complete Deployment Checklist

- [ ] Created deployment package
- [ ] Created Hetzner server
- [ ] Uploaded package to server
- [ ] Extracted package
- [ ] Ran hetzner-setup.sh
- [ ] Applied fix (./apply-fix.sh)
- [ ] Started system (docker-compose up -d)
- [ ] Verified model loaded
- [ ] Tested agent API
- [ ] Accessed dashboard
- [ ] Configured firewall
- [ ] Changed root password
- [ ] (Optional) Set up SSH keys

## Quick Reference

```bash
# ON LOCAL MACHINE
./create-deployment-package.sh
scp cyber-defense-*.tar.gz root@YOUR_IP:/root/
ssh root@YOUR_IP

# ON HETZNER SERVER
tar -xzf cyber-defense-*.tar.gz
./hetzner-setup.sh
cd /opt/cyber-defense
./apply-fix.sh  # Choose option 1 or 4
docker-compose up -d
docker logs -f ollama-init

# VERIFY
curl http://localhost:8000/health | jq
./check-qwen-model.sh

# ACCESS
# http://YOUR_IP:3000 - Dashboard
# http://YOUR_IP:8000 - API
```

## Support

If you encounter issues:

1. Check logs: `docker-compose logs`
2. Check status: `docker-compose ps`
3. Check firewall: `ufw status`
4. Check disk space: `df -h`
5. Restart: `docker-compose restart`

---

**Deployment should take about 10-15 minutes total!** 🚀
