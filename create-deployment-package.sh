#!/bin/bash
# Create deployment package for Hetzner

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Hetzner Deployment Package                  ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

PACKAGE_NAME="cyber-defense-deployment.tar.gz"

echo "Creating deployment package..."

# Create temporary directory
TEMP_DIR=$(mktemp -d)
DEPLOY_DIR="$TEMP_DIR/492-energy-defense"
mkdir -p "$DEPLOY_DIR"

# Copy necessary files
echo "Copying project files..."
cp -r agent "$DEPLOY_DIR/"
cp -r backend "$DEPLOY_DIR/"
cp -r dashboard "$DEPLOY_DIR/"
cp docker-compose.yml "$DEPLOY_DIR/"
cp .env.example "$DEPLOY_DIR/.env"
cp .gitignore "$DEPLOY_DIR/" 2>/dev/null || true

# Copy scripts
cp start.sh "$DEPLOY_DIR/"
cp test-llm-mode.sh "$DEPLOY_DIR/"
cp check-qwen-model.sh "$DEPLOY_DIR/"
cp apply-fix.sh "$DEPLOY_DIR/"

# Copy essential documentation
echo "Copying documentation..."
cp README.md "$DEPLOY_DIR/"
cp MIGRATION_COMPLETE.md "$DEPLOY_DIR/" 2>/dev/null || true
cp FIX_QWEN_SCORING_ISSUE.md "$DEPLOY_DIR/" 2>/dev/null || true

# Create server setup script
cat > "$DEPLOY_DIR/setup-server.sh" << 'SETUPEOF'
#!/bin/bash
# Server setup script for Hetzner deployment

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense Server Setup                      ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
   echo "Please run as root (or use sudo)"
   exit 1
fi

echo "[1/6] Updating system packages..."
apt-get update -qq
apt-get upgrade -y -qq

echo "[2/6] Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Install Docker
    apt-get install -y -qq apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository -y "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io
    systemctl enable docker
    systemctl start docker
    echo "✓ Docker installed"
else
    echo "✓ Docker already installed"
fi

echo "[3/6] Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/download/v2.24.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    ln -sf /usr/local/bin/docker-compose /usr/bin/docker-compose
    echo "✓ Docker Compose installed"
else
    echo "✓ Docker Compose already installed"
fi

echo "[4/6] Installing utilities..."
apt-get install -y -qq curl jq net-tools ufw

echo "[5/6] Configuring firewall..."
ufw --force enable
ufw allow 22/tcp    # SSH
ufw allow 8000/tcp  # Agent API
ufw allow 3000/tcp  # Dashboard
ufw allow 5432/tcp  # PostgreSQL (optional, for external access)
echo "✓ Firewall configured"

echo "[6/6] Setting up application directory..."
APP_DIR="/opt/492-energy-defense"
mkdir -p "$APP_DIR"
cd "$APP_DIR" || exit 1

# Copy files from current directory
if [ -f "docker-compose.yml" ]; then
    echo "✓ Files already in place"
else
    echo "Error: docker-compose.yml not found. Please extract the deployment package first."
    exit 1
fi

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Server setup complete!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "1. Review and edit .env file if needed"
echo "2. Start the application: docker-compose up -d"
echo "3. Watch model download: docker logs -f ollama-init"
echo "4. Check status: docker ps"
echo ""
echo "Access points:"
echo "  - Dashboard: http://$(curl -s ifconfig.me):3000"
echo "  - Agent API: http://$(curl -s ifconfig.me):8000"
echo ""
SETUPEOF

chmod +x "$DEPLOY_DIR/setup-server.sh"

# Create quick start script
cat > "$DEPLOY_DIR/quick-start.sh" << 'STARTEOF'
#!/bin/bash
# Quick start script

echo "Starting 492-Energy-Defense..."
echo ""

# Check if Docker is running
if ! docker ps &> /dev/null; then
    echo "Error: Docker is not running"
    echo "Run: systemctl start docker"
    exit 1
fi

# Start services
docker-compose up -d

echo ""
echo "Services starting..."
echo ""
echo "Monitor progress:"
echo "  docker logs -f ollama-init    # Watch model download (1-2 min)"
echo "  docker logs -f cyber-agent    # Watch agent startup"
echo "  docker ps                     # Check all containers"
echo ""
echo "Once ready, access:"
echo "  Dashboard: http://$(hostname -I | awk '{print $1}'):3000"
echo "  Agent API: http://$(hostname -I | awk '{print $1}'):8000"
echo ""
STARTEOF

chmod +x "$DEPLOY_DIR/quick-start.sh"

# Create deployment instructions
cat > "$DEPLOY_DIR/DEPLOY_INSTRUCTIONS.txt" << 'INSTREOF'
╔════════════════════════════════════════════════════════════════╗
║  492-Energy-Defense Deployment Instructions for Hetzner       ║
╚════════════════════════════════════════════════════════════════╝

PREREQUISITES:
- Hetzner Cloud Server (CPX21 or higher recommended)
- Ubuntu 22.04 or 24.04
- Root access with password
- At least 8GB RAM, 40GB disk

═══════════════════════════════════════════════════════════════

DEPLOYMENT STEPS:

1. CREATE HETZNER SERVER
   - Go to: https://console.hetzner.cloud/
   - Create new server:
     * Image: Ubuntu 22.04 or 24.04
     * Type: CPX21 (3 vCPU, 8GB RAM) or higher
     * Location: Closest to you
     * Set root password when creating server
   - Note the server IP address

2. UPLOAD DEPLOYMENT PACKAGE
   Using SCP (from your local machine):
   
   scp cyber-defense-deployment.tar.gz root@YOUR_SERVER_IP:/root/
   
   Or using WinSCP/FileZilla if on Windows

3. SSH INTO SERVER
   
   ssh root@YOUR_SERVER_IP
   # Enter password when prompted

4. EXTRACT PACKAGE
   
   cd /root
   tar -xzf cyber-defense-deployment.tar.gz
   cd 492-energy-defense

5. RUN SETUP SCRIPT
   
   bash setup-server.sh
   
   This will:
   - Update system packages
   - Install Docker & Docker Compose
   - Configure firewall
   - Set up application directory

6. START APPLICATION
   
   bash quick-start.sh
   
   Or manually:
   docker-compose up -d

7. MONITOR STARTUP
   
   # Watch Qwen model download (1-2 minutes)
   docker logs -f ollama-init
   
   # Press Ctrl+C when you see "Qwen model ready!"
   
   # Check all containers are running
   docker ps

8. ACCESS THE APPLICATION
   
   Dashboard: http://YOUR_SERVER_IP:3000
   Agent API: http://YOUR_SERVER_IP:8000
   API Docs:  http://YOUR_SERVER_IP:8000/docs

═══════════════════════════════════════════════════════════════

USEFUL COMMANDS:

Check status:
  docker ps
  docker-compose ps

View logs:
  docker logs cyber-agent
  docker logs cyber-backend
  docker logs cyber-dashboard

Restart services:
  docker-compose restart

Stop everything:
  docker-compose down

Update configuration:
  nano .env
  docker-compose restart

Test the agent:
  bash test-llm-mode.sh

═══════════════════════════════════════════════════════════════

TROUBLESHOOTING:

Issue: Cannot connect to server
Fix: Check firewall allows ports 22, 3000, 8000
     ufw status
     ufw allow 3000/tcp
     ufw allow 8000/tcp

Issue: Containers not starting
Fix: Check Docker is running
     systemctl status docker
     systemctl start docker

Issue: Model not loading
Fix: docker exec ollama-qwen ollama pull qwen2.5:0.5b

Issue: Low scoring accuracy
Fix: bash apply-fix.sh
     Choose option 1 (Rule-Based) for 100% accuracy

═══════════════════════════════════════════════════════════════

SECURITY NOTES:

1. Change default passwords in .env file
2. Use firewall to restrict access
3. Consider setting up SSL/TLS for production
4. Create non-root user for running services
5. Regular security updates: apt-get update && apt-get upgrade

═══════════════════════════════════════════════════════════════

For detailed documentation, see README.md
For model issues, see FIX_QWEN_SCORING_ISSUE.md

Support: Check logs with docker-compose logs
INSTREOF

# Make scripts executable
chmod +x "$DEPLOY_DIR"/*.sh

# Create the tarball
echo "Creating tarball..."
cd "$TEMP_DIR" || exit 1
tar -czf "$PACKAGE_NAME" 492-energy-defense/

# Move to current directory
mv "$PACKAGE_NAME" "$OLDPWD/"
cd "$OLDPWD" || exit 1

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Deployment package created: $PACKAGE_NAME"
echo ""
echo "Package size:"
du -h "$PACKAGE_NAME"
echo ""
echo "═══════════════════════════════════════════════════════"
echo "Next steps:"
echo ""
echo "1. Upload to Hetzner server:"
echo "   scp $PACKAGE_NAME root@YOUR_SERVER_IP:/root/"
echo ""
echo "2. SSH into server:"
echo "   ssh root@YOUR_SERVER_IP"
echo ""
echo "3. Extract and setup:"
echo "   tar -xzf $PACKAGE_NAME"
echo "   cd 492-energy-defense"
echo "   bash setup-server.sh"
echo "   bash quick-start.sh"
echo ""
echo "See DEPLOY_INSTRUCTIONS.txt in the package for full details."
echo "═══════════════════════════════════════════════════════"

