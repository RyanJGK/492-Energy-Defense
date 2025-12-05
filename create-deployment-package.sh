#!/bin/bash
# Create deployment package for Hetzner

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Deployment Package for Hetzner              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

PACKAGE_NAME="cyber-defense-deployment.tar.gz"

echo "Preparing files..."

# Create temporary directory
TEMP_DIR=$(mktemp -d)
PROJECT_DIR="$TEMP_DIR/492-energy-defense"
mkdir -p "$PROJECT_DIR"

# Copy essential files and directories
echo "Copying project files..."

# Core application files
cp -r agent "$PROJECT_DIR/"
cp -r backend "$PROJECT_DIR/"
cp -r dashboard "$PROJECT_DIR/"

# Docker configuration
cp docker-compose.yml "$PROJECT_DIR/"
cp docker-compose-simple.yml "$PROJECT_DIR/"

# Environment and config
cp .env.example "$PROJECT_DIR/"
cp .gitignore "$PROJECT_DIR/" 2>/dev/null || true

# Shell scripts
cp start.sh "$PROJECT_DIR/"
cp test.sh "$PROJECT_DIR/" 2>/dev/null || true
cp test-llm-mode.sh "$PROJECT_DIR/"
cp troubleshoot.sh "$PROJECT_DIR/"
cp manage.sh "$PROJECT_DIR/" 2>/dev/null || true
cp check-qwen-model.sh "$PROJECT_DIR/"
cp apply-fix.sh "$PROJECT_DIR/"

# Essential documentation (keeping only what exists)
cp README.md "$PROJECT_DIR/" 2>/dev/null || true
cp PROJECT_SUMMARY.md "$PROJECT_DIR/" 2>/dev/null || true
cp FIX_QWEN_SCORING_ISSUE.md "$PROJECT_DIR/"
cp MIGRATION_COMPLETE.md "$PROJECT_DIR/" 2>/dev/null || true
cp MODEL_MIGRATION_SUMMARY.md "$PROJECT_DIR/" 2>/dev/null || true

# Make scripts executable
chmod +x "$PROJECT_DIR"/*.sh

# Create deployment instructions
cat > "$PROJECT_DIR/DEPLOY_INSTRUCTIONS.txt" << 'DEPLOY_EOF'
╔════════════════════════════════════════════════════════════╗
║  DEPLOYMENT INSTRUCTIONS - Hetzner Server                 ║
╚════════════════════════════════════════════════════════════╝

PREREQUISITES:
- Hetzner server with Ubuntu 22.04 or 24.04
- At least 8GB RAM (16GB recommended for LLM mode)
- Root access

DEPLOYMENT STEPS:
═══════════════════════════════════════════════════════════

1. UPLOAD THIS FILE TO SERVER
   ─────────────────────────────
   From your local machine:
   
   scp cyber-defense-deployment.tar.gz root@YOUR_SERVER_IP:/root/
   
   Or use WinSCP, FileZilla, or any SCP client

2. LOGIN TO SERVER
   ─────────────────────────────
   ssh root@YOUR_SERVER_IP

3. EXTRACT THE PACKAGE
   ─────────────────────────────
   cd /root
   tar -xzf cyber-defense-deployment.tar.gz
   cd 492-energy-defense

4. INSTALL DOCKER (if not installed)
   ─────────────────────────────────
   ./install-docker.sh
   
   # Wait for installation to complete
   # Logout and login again for docker group to take effect

5. START THE SYSTEM
   ─────────────────────────────
   docker-compose up -d
   
   # Watch model download (1-2 minutes)
   docker logs -f ollama-init
   
   # Press Ctrl+C when you see "Qwen model ready!"

6. VERIFY IT'S RUNNING
   ─────────────────────────────
   docker ps
   
   # Should see 5 containers running:
   # - cyber-events-db
   # - ollama-qwen
   # - cyber-agent
   # - cyber-backend
   # - cyber-dashboard

7. TEST THE SYSTEM
   ─────────────────────────────
   ./test-llm-mode.sh

8. CONFIGURE FIREWALL (IMPORTANT!)
   ─────────────────────────────────
   # Install UFW if not installed
   apt update && apt install ufw -y
   
   # Allow SSH first (CRITICAL!)
   ufw allow 22/tcp
   
   # Allow application ports
   ufw allow 3000/tcp  # Dashboard
   ufw allow 8000/tcp  # Agent API
   
   # Enable firewall
   ufw --force enable
   
   # Check status
   ufw status

9. ACCESS THE DASHBOARD
   ─────────────────────────────
   Open in browser:
   http://YOUR_SERVER_IP:3000

10. MONITOR LOGS
    ─────────────────────────────
    docker logs -f cyber-backend   # Event generation
    docker logs -f cyber-agent     # AI analysis
    docker logs -f cyber-dashboard # Web interface

TROUBLESHOOTING:
═══════════════════════════════════════════════════════════

Issue: Services won't start
Solution: Check Docker is running
  systemctl status docker
  systemctl start docker

Issue: Port already in use
Solution: Check what's using the ports
  netstat -tulpn | grep -E '3000|8000|5432|11434'

Issue: Out of memory
Solution: Check system resources
  free -h
  docker stats

Issue: Qwen model scoring incorrectly
Solution: See FIX_QWEN_SCORING_ISSUE.md or run:
  ./apply-fix.sh

USEFUL COMMANDS:
═══════════════════════════════════════════════════════════

# Start all services
docker-compose up -d

# Stop all services
docker-compose down

# View logs
docker-compose logs -f

# Restart a service
docker-compose restart agent

# Check service health
docker-compose ps

# Update and restart
docker-compose down
git pull  # or re-upload new package
docker-compose up -d --build

SUPPORT:
═══════════════════════════════════════════════════════════

For issues, check:
- README.md for full documentation
- FIX_QWEN_SCORING_ISSUE.md for scoring problems
- ./troubleshoot.sh for diagnostics

═══════════════════════════════════════════════════════════
System: 492-Energy-Defense Cybersecurity Agent
Version: 2.0 with Qwen 2.5
═══════════════════════════════════════════════════════════
DEPLOY_EOF

# Create Docker installation script
cat > "$PROJECT_DIR/install-docker.sh" << 'DOCKER_EOF'
#!/bin/bash
# Install Docker and Docker Compose on Ubuntu

echo "Installing Docker and Docker Compose..."
echo ""

# Update system
echo "[1/5] Updating system packages..."
apt update
apt upgrade -y

# Install prerequisites
echo "[2/5] Installing prerequisites..."
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    software-properties-common

# Add Docker repository
echo "[3/5] Adding Docker repository..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
echo "[4/5] Installing Docker..."
apt update
apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start Docker
systemctl start docker
systemctl enable docker

# Install docker-compose (standalone)
echo "[5/5] Installing Docker Compose..."
COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Verify installation
echo ""
echo "Verifying installation..."
docker --version
docker-compose --version

echo ""
echo "✅ Docker installation complete!"
echo ""
echo "Note: If you're not running as root, logout and login again"
echo "      for docker group permissions to take effect."
DOCKER_EOF

chmod +x "$PROJECT_DIR/install-docker.sh"

# Create quick start script
cat > "$PROJECT_DIR/quick-start.sh" << 'QUICK_EOF'
#!/bin/bash
# Quick start script for deployment

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense Quick Start                       ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing..."
    ./install-docker.sh
    echo ""
    echo "Docker installed. Please logout and login again, then run this script again."
    exit 0
fi

# Check if docker-compose is available
if ! command -v docker-compose &> /dev/null; then
    echo "Error: docker-compose not found"
    echo "Run: ./install-docker.sh"
    exit 1
fi

echo "Starting services..."
docker-compose up -d

echo ""
echo "Waiting for Qwen model download..."
echo "(This will take 1-2 minutes on first run)"
echo ""

sleep 5
docker logs -f ollama-init &
LOGS_PID=$!

# Wait for model to be ready (max 5 minutes)
for i in {1..150}; do
    if docker logs ollama-init 2>&1 | grep -q "Qwen model ready"; then
        kill $LOGS_PID 2>/dev/null
        break
    fi
    sleep 2
done

echo ""
echo "Checking service status..."
docker-compose ps

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  System Started Successfully!                         ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "📊 Access Points:"
echo "   Dashboard:  http://$(hostname -I | awk '{print $1}'):3000"
echo "   Agent API:  http://$(hostname -I | awk '{print $1}'):8000"
echo ""
echo "📝 Next Steps:"
echo "   1. Configure firewall: ufw allow 3000/tcp && ufw allow 8000/tcp"
echo "   2. Test the system: ./test-llm-mode.sh"
echo "   3. View logs: docker-compose logs -f"
echo ""
echo "📚 Documentation: cat DEPLOY_INSTRUCTIONS.txt"
echo ""
QUICK_EOF

chmod +x "$PROJECT_DIR/quick-start.sh"

# Create the tar.gz archive
echo ""
echo "Creating archive..."
cd "$TEMP_DIR"
tar -czf "/workspace/$PACKAGE_NAME" 492-energy-defense/

# Cleanup
rm -rf "$TEMP_DIR"

# Get file size
SIZE=$(du -h "/workspace/$PACKAGE_NAME" | cut -f1)

echo ""
echo "✅ Deployment package created successfully!"
echo ""
echo "Package: $PACKAGE_NAME"
echo "Size: $SIZE"
echo "Location: /workspace/$PACKAGE_NAME"
echo ""
echo "═══════════════════════════════════════════════════════"
echo "DEPLOYMENT INSTRUCTIONS:"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "1. Upload to your Hetzner server:"
echo "   scp $PACKAGE_NAME root@YOUR_SERVER_IP:/root/"
echo ""
echo "2. SSH into your server:"
echo "   ssh root@YOUR_SERVER_IP"
echo ""
echo "3. Extract and run:"
echo "   cd /root"
echo "   tar -xzf $PACKAGE_NAME"
echo "   cd 492-energy-defense"
echo "   ./quick-start.sh"
echo ""
echo "4. Access dashboard:"
echo "   http://YOUR_SERVER_IP:3000"
echo ""
echo "═══════════════════════════════════════════════════════"
echo ""
echo "Full instructions included in: DEPLOY_INSTRUCTIONS.txt"
echo ""

