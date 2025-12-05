#!/bin/bash
# Create deployment package for Hetzner

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Deployment Package for Hetzner              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

PACKAGE_NAME="cyber-agent-deployment.tar.gz"

echo "Creating temporary directory..."
mkdir -p /tmp/cyber-agent-deploy

echo "Copying project files..."
# Copy essential files
cp -r agent /tmp/cyber-agent-deploy/
cp -r backend /tmp/cyber-agent-deploy/
cp -r dashboard /tmp/cyber-agent-deploy/
cp docker-compose.yml /tmp/cyber-agent-deploy/
cp docker-compose-simple.yml /tmp/cyber-agent-deploy/
cp .env.example /tmp/cyber-agent-deploy/
cp .gitignore /tmp/cyber-agent-deploy/ 2>/dev/null || true

# Copy documentation
cp README.md /tmp/cyber-agent-deploy/ 2>/dev/null || true
cp PROJECT_SUMMARY.md /tmp/cyber-agent-deploy/ 2>/dev/null || true

# Copy utility scripts
cp start.sh /tmp/cyber-agent-deploy/
cp test-llm-mode.sh /tmp/cyber-agent-deploy/
cp troubleshoot.sh /tmp/cyber-agent-deploy/
cp check-qwen-model.sh /tmp/cyber-agent-deploy/
cp apply-fix.sh /tmp/cyber-agent-deploy/

# Create server setup script
cat > /tmp/cyber-agent-deploy/setup-server.sh << 'SETUP_EOF'
#!/bin/bash
# Server setup script for Hetzner - Run as root

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense - Hetzner Server Setup            ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
   echo "Please run as root (or with sudo)"
   exit 1
fi

echo "[1/6] Updating system packages..."
apt-get update -qq
apt-get upgrade -y -qq

echo "[2/6] Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Install Docker
    apt-get install -y ca-certificates curl gnupg
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    apt-get update -qq
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    echo "✓ Docker installed"
else
    echo "✓ Docker already installed"
fi

echo "[3/6] Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    # Install docker-compose standalone
    curl -SL https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    echo "✓ Docker Compose installed"
else
    echo "✓ Docker Compose already installed"
fi

echo "[4/6] Starting Docker service..."
systemctl enable docker
systemctl start docker
echo "✓ Docker service started"

echo "[5/6] Installing additional tools..."
apt-get install -y jq curl wget htop net-tools -qq
echo "✓ Tools installed"

echo "[6/6] Configuring firewall (UFW)..."
if command -v ufw &> /dev/null; then
    # Allow SSH first (important!)
    ufw allow 22/tcp
    # Allow application ports
    ufw allow 3000/tcp  # Dashboard
    ufw allow 8000/tcp  # Agent API
    ufw allow 5432/tcp  # PostgreSQL (if external access needed)
    # Enable firewall (will prompt if not already enabled)
    echo "y" | ufw enable
    echo "✓ Firewall configured"
else
    echo "⚠ UFW not installed, skipping firewall setup"
fi

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Server setup complete!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "1. Run: docker-compose up -d"
echo "2. Wait 1-2 minutes for model download"
echo "3. Access dashboard: http://$(curl -s ifconfig.me):3000"
echo "4. Access API: http://$(curl -s ifconfig.me):8000"
echo ""
SETUP_EOF

chmod +x /tmp/cyber-agent-deploy/setup-server.sh

# Create quick start script
cat > /tmp/cyber-agent-deploy/quick-start.sh << 'QUICKSTART_EOF'
#!/bin/bash
# Quick start script - Run after setup-server.sh

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Starting 492-Energy-Defense System                   ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

echo "[1/4] Starting services..."
docker-compose up -d

echo ""
echo "[2/4] Waiting for Ollama to initialize..."
sleep 10

echo ""
echo "[3/4] Checking service status..."
docker-compose ps

echo ""
echo "[4/4] Monitoring model download..."
echo "This will take 1-2 minutes for Qwen model..."
echo ""
docker logs -f ollama-init &
LOGS_PID=$!

# Wait up to 3 minutes for model download
timeout=180
elapsed=0
while [ $elapsed -lt $timeout ]; do
    if docker logs ollama-init 2>&1 | grep -q "Qwen model ready"; then
        kill $LOGS_PID 2>/dev/null
        break
    fi
    sleep 5
    elapsed=$((elapsed + 5))
done

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ System is running!"
echo "════════════════════════════════════════════════════════"
echo ""

# Get server IP
SERVER_IP=$(curl -s ifconfig.me 2>/dev/null || hostname -I | awk '{print $1}')

echo "🌐 Access your services:"
echo ""
echo "   Dashboard:  http://${SERVER_IP}:3000"
echo "   Agent API:  http://${SERVER_IP}:8000"
echo "   API Docs:   http://${SERVER_IP}:8000/docs"
echo ""
echo "📊 Useful commands:"
echo "   View logs:        docker-compose logs -f"
echo "   Check status:     docker-compose ps"
echo "   Stop system:      docker-compose down"
echo "   Restart:          docker-compose restart"
echo ""
QUICKSTART_EOF

chmod +x /tmp/cyber-agent-deploy/quick-start.sh

# Create README for deployment
cat > /tmp/cyber-agent-deploy/DEPLOY.md << 'DEPLOY_MD'
# Hetzner Deployment Guide

## Simple 3-Step Deployment

### Step 1: Upload Package to Server

On your **local machine**, upload the package:

```bash
scp cyber-agent-deployment.tar.gz root@YOUR_SERVER_IP:/root/
```

### Step 2: Extract and Setup on Server

SSH into your server:

```bash
ssh root@YOUR_SERVER_IP
```

Then run:

```bash
# Extract package
cd /root
tar -xzf cyber-agent-deployment.tar.gz
cd cyber-agent-deploy

# Run setup script (installs Docker, etc.)
chmod +x setup-server.sh
./setup-server.sh
```

### Step 3: Start the Application

```bash
# Start all services
chmod +x quick-start.sh
./quick-start.sh
```

Wait 1-2 minutes for the Qwen model to download.

## Access Your Application

- **Dashboard**: http://YOUR_SERVER_IP:3000
- **Agent API**: http://YOUR_SERVER_IP:8000
- **API Docs**: http://YOUR_SERVER_IP:8000/docs

## Management Commands

```bash
# View all logs
docker-compose logs -f

# View specific service logs
docker logs -f cyber-agent
docker logs -f cyber-backend
docker logs -f cyber-dashboard

# Check service status
docker-compose ps

# Restart services
docker-compose restart

# Stop everything
docker-compose down

# Stop and remove all data
docker-compose down -v
```

## Troubleshooting

### Check if services are running
```bash
docker-compose ps
```

### Check model is loaded
```bash
docker exec ollama-qwen ollama list
```

### Test agent health
```bash
curl http://localhost:8000/health | jq
```

### View firewall status
```bash
ufw status
```

## Configuration

### Switch to Rule-Based Mode (No LLM)

For 100% accurate scoring without LLM overhead:

```bash
# Edit docker-compose.yml
nano docker-compose.yml

# Change: USE_LLM=true
# To:     USE_LLM=false

# Restart
docker-compose restart agent
```

### Change Model Size

Edit `docker-compose.yml` and change:

```yaml
- OLLAMA_MODEL=qwen2.5:0.5b   # Small (400MB)
# to:
- OLLAMA_MODEL=qwen2.5:1.5b   # Medium (900MB)
# or:
- OLLAMA_MODEL=qwen2.5:3b     # Large (2GB)
```

Then:
```bash
docker exec ollama-qwen ollama pull qwen2.5:1.5b
docker-compose restart agent
```

## Security Notes

**For Production:**

1. Change default passwords in docker-compose.yml
2. Restrict firewall rules (use UFW)
3. Set up HTTPS with nginx reverse proxy
4. Create non-root user for operation
5. Enable automatic security updates

## Server Requirements

- **Minimum**: 2 vCPU, 4GB RAM, 20GB disk
- **Recommended**: 4 vCPU, 8GB RAM, 40GB disk
- **OS**: Ubuntu 22.04 or 24.04 LTS

## Support

- Full documentation: README.md
- Troubleshooting: troubleshoot.sh
- Model fix: apply-fix.sh

---

**Project**: 492-Energy-Defense Cybersecurity Agent
**Version**: 2.1.0
DEPLOY_MD

echo ""
echo "Creating tar.gz archive..."
cd /tmp
tar -czf "$PACKAGE_NAME" cyber-agent-deploy/

# Move to workspace
mv "$PACKAGE_NAME" /workspace/

# Cleanup
rm -rf /tmp/cyber-agent-deploy

echo "✓ Package created: /workspace/$PACKAGE_NAME"
echo ""

# Show package size
SIZE=$(du -h "/workspace/$PACKAGE_NAME" | cut -f1)
echo "Package size: $SIZE"
echo ""

echo "════════════════════════════════════════════════════════"
echo "✅ Deployment package ready!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "To deploy to Hetzner:"
echo ""
echo "1. Upload package to server:"
echo "   scp cyber-agent-deployment.tar.gz root@YOUR_SERVER_IP:/root/"
echo ""
echo "2. SSH to server and extract:"
echo "   ssh root@YOUR_SERVER_IP"
echo "   cd /root"
echo "   tar -xzf cyber-agent-deployment.tar.gz"
echo "   cd cyber-agent-deploy"
echo ""
echo "3. Run setup script:"
echo "   ./setup-server.sh"
echo ""
echo "4. Start application:"
echo "   ./quick-start.sh"
echo ""
echo "See cyber-agent-deploy/DEPLOY.md for full instructions"
echo ""

