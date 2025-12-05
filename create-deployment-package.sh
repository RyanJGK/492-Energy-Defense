#!/bin/bash
# Create deployment package for Hetzner

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Deployment Package for Hetzner              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

PACKAGE_NAME="cyber-defense-agent-$(date +%Y%m%d-%H%M%S).tar.gz"

echo "Creating deployment package: $PACKAGE_NAME"
echo ""

# Create temporary directory
TEMP_DIR=$(mktemp -d)
DEPLOY_DIR="$TEMP_DIR/492-energy-defense"
mkdir -p "$DEPLOY_DIR"

echo "Copying files..."

# Copy essential files
cp -r agent "$DEPLOY_DIR/"
cp -r backend "$DEPLOY_DIR/"
cp -r dashboard "$DEPLOY_DIR/"
cp docker-compose.yml "$DEPLOY_DIR/"
cp .env.example "$DEPLOY_DIR/.env"
cp .gitignore "$DEPLOY_DIR/" 2>/dev/null || true

# Copy scripts
cp start.sh "$DEPLOY_DIR/" 2>/dev/null || true
cp test-llm-mode.sh "$DEPLOY_DIR/" 2>/dev/null || true
cp check-qwen-model.sh "$DEPLOY_DIR/" 2>/dev/null || true
cp apply-fix.sh "$DEPLOY_DIR/" 2>/dev/null || true

# Copy documentation
cp README.md "$DEPLOY_DIR/" 2>/dev/null || true
cp PROJECT_SUMMARY.md "$DEPLOY_DIR/" 2>/dev/null || true

# Make scripts executable
chmod +x "$DEPLOY_DIR"/*.sh 2>/dev/null || true

echo "✓ Files copied"
echo ""

# Create deployment instructions
cat > "$DEPLOY_DIR/DEPLOY_INSTRUCTIONS.txt" << 'INSTRUCTIONS'
╔════════════════════════════════════════════════════════════════════╗
║  492-Energy-Defense - Deployment Instructions                     ║
╚════════════════════════════════════════════════════════════════════╝

QUICK START (5 minutes)
═══════════════════════════════════════════════════════════════════

1. Upload this package to your Hetzner server:
   
   scp cyber-defense-agent-*.tar.gz root@YOUR_SERVER_IP:/root/

2. SSH into your server:
   
   ssh root@YOUR_SERVER_IP

3. Extract the package:
   
   cd /root
   tar -xzf cyber-defense-agent-*.tar.gz
   cd 492-energy-defense

4. Install Docker (if not already installed):
   
   # Update packages
   apt update
   
   # Install Docker
   curl -fsSL https://get.docker.com -o get-docker.sh
   sh get-docker.sh
   
   # Start Docker
   systemctl start docker
   systemctl enable docker

5. Start the application:
   
   docker compose up -d

6. Wait for model download (1-2 minutes):
   
   docker logs -f ollama-init
   # Press Ctrl+C when you see "Qwen model ready!"

7. Verify it's running:
   
   docker ps
   curl http://localhost:8000/health

8. Test the agent:
   
   ./test-llm-mode.sh

═══════════════════════════════════════════════════════════════════
FIREWALL SETUP (Optional but recommended)
═══════════════════════════════════════════════════════════════════

# Install firewall
apt install ufw -y

# Allow SSH (IMPORTANT!)
ufw allow 22/tcp

# Allow application ports
ufw allow 8000/tcp    # Agent API
ufw allow 3000/tcp    # Dashboard
ufw allow 5432/tcp    # PostgreSQL (if external access needed)

# Enable firewall
ufw --force enable

# Check status
ufw status

═══════════════════════════════════════════════════════════════════
ACCESS YOUR APPLICATION
═══════════════════════════════════════════════════════════════════

Dashboard:    http://YOUR_SERVER_IP:3000
Agent API:    http://YOUR_SERVER_IP:8000
API Docs:     http://YOUR_SERVER_IP:8000/docs

═══════════════════════════════════════════════════════════════════
USEFUL COMMANDS
═══════════════════════════════════════════════════════════════════

# View logs
docker logs -f cyber-agent
docker logs -f cyber-backend
docker logs -f cyber-dashboard

# Check status
docker ps
docker compose ps

# Restart services
docker compose restart

# Stop everything
docker compose down

# Stop and remove all data
docker compose down -v

# Update application (after uploading new package)
docker compose down
cd /root
tar -xzf cyber-defense-agent-NEW.tar.gz
cd 492-energy-defense
docker compose up -d

═══════════════════════════════════════════════════════════════════
TROUBLESHOOTING
═══════════════════════════════════════════════════════════════════

Problem: "Cannot connect to Docker daemon"
Solution: systemctl start docker

Problem: "Port already in use"
Solution: 
  netstat -tlnp | grep :8000  # Find process using port
  kill -9 <PID>                # Kill the process
  docker compose up -d         # Restart

Problem: Model not loading
Solution:
  docker exec ollama-qwen ollama pull qwen2.5:0.5b
  docker compose restart agent

Problem: Low severity on critical events
Solution: Run ./apply-fix.sh and choose option 1 or 4

═══════════════════════════════════════════════════════════════════
CONFIGURATION
═══════════════════════════════════════════════════════════════════

All configuration is in docker-compose.yml

To use rule-based mode (recommended for accuracy):
  1. Edit docker-compose.yml
  2. Change: USE_LLM=true to USE_LLM=false
  3. Run: docker compose restart agent

To change the model:
  1. Edit docker-compose.yml
  2. Change: OLLAMA_MODEL=qwen2.5:0.5b to qwen2.5:1.5b
  3. Run: docker compose down && docker compose up -d

═══════════════════════════════════════════════════════════════════
SYSTEM REQUIREMENTS
═══════════════════════════════════════════════════════════════════

Minimum:
- 2 CPU cores
- 4GB RAM
- 20GB disk space
- Ubuntu 20.04 or newer

Recommended:
- 4 CPU cores
- 8GB RAM
- 40GB disk space
- Ubuntu 22.04 LTS

═══════════════════════════════════════════════════════════════════
SUPPORT
═══════════════════════════════════════════════════════════════════

Documentation: README.md
Health Check:  curl http://localhost:8000/health
Test Script:   ./test-llm-mode.sh

For issues, check:
  docker logs cyber-agent
  docker logs cyber-backend

═══════════════════════════════════════════════════════════════════
INSTRUCTIONS
chmod +x "$DEPLOY_DIR/DEPLOY_INSTRUCTIONS.txt"

echo "✓ Created deployment instructions"
echo ""

# Create quick start script
cat > "$DEPLOY_DIR/quick-start.sh" << 'QUICKSTART'
#!/bin/bash
# Quick start script for Hetzner deployment

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense - Quick Start                     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing..."
    apt update
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    systemctl start docker
    systemctl enable docker
    echo "✓ Docker installed"
else
    echo "✓ Docker already installed"
fi
echo ""

# Check if Docker Compose is available
if ! docker compose version &> /dev/null; then
    echo "❌ Docker Compose not available"
    echo "Please upgrade Docker to get Docker Compose V2"
    exit 1
fi
echo "✓ Docker Compose available"
echo ""

# Start services
echo "Starting services..."
docker compose up -d
echo ""

echo "Waiting for services to initialize..."
sleep 10
echo ""

echo "Checking status..."
docker ps
echo ""

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Services are starting!                               ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "Monitor model download:"
echo "  docker logs -f ollama-init"
echo ""
echo "Check when ready:"
echo "  curl http://localhost:8000/health"
echo ""
echo "Access your application:"
echo "  Dashboard: http://$(hostname -I | awk '{print $1}'):3000"
echo "  API:       http://$(hostname -I | awk '{print $1}'):8000"
echo ""
QUICKSTART
chmod +x "$DEPLOY_DIR/quick-start.sh"

echo "✓ Created quick-start.sh"
echo ""

# Create package
cd "$TEMP_DIR"
tar -czf "$PACKAGE_NAME" 492-energy-defense/
mv "$PACKAGE_NAME" /workspace/

# Cleanup
rm -rf "$TEMP_DIR"

echo "════════════════════════════════════════════════════════"
echo "✅ Deployment package created!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Package: $PACKAGE_NAME"
echo "Size: $(du -h /workspace/$PACKAGE_NAME | cut -f1)"
echo ""
echo "Next steps:"
echo ""
echo "1. Upload to your Hetzner server:"
echo "   scp $PACKAGE_NAME root@YOUR_SERVER_IP:/root/"
echo ""
echo "2. SSH into server and extract:"
echo "   ssh root@YOUR_SERVER_IP"
echo "   tar -xzf $PACKAGE_NAME"
echo "   cd 492-energy-defense"
echo ""
echo "3. Run quick start:"
echo "   ./quick-start.sh"
echo ""
echo "4. Access your application:"
echo "   Dashboard: http://YOUR_SERVER_IP:3000"
echo "   API:       http://YOUR_SERVER_IP:8000"
echo ""
echo "See DEPLOY_INSTRUCTIONS.txt in the package for details."
echo ""

