#!/bin/bash
# Create deployment package for Hetzner

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Hetzner Deployment Package                  ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

PACKAGE_NAME="cyber-defense-deployment.tar.gz"
TEMP_DIR="cyber-defense-deploy"

echo "[1/4] Creating temporary directory..."
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

echo "[2/4] Copying necessary files..."

# Copy core application files
cp -r agent $TEMP_DIR/
cp -r backend $TEMP_DIR/
cp -r dashboard $TEMP_DIR/
cp docker-compose.yml $TEMP_DIR/
cp .env.example $TEMP_DIR/.env

# Copy scripts
cp start.sh $TEMP_DIR/
cp test-llm-mode.sh $TEMP_DIR/
cp check-qwen-model.sh $TEMP_DIR/
cp apply-fix.sh $TEMP_DIR/

# Copy essential documentation
cp README.md $TEMP_DIR/
cp MIGRATION_COMPLETE.md $TEMP_DIR/ 2>/dev/null || true
cp FIX_QWEN_SCORING_ISSUE.md $TEMP_DIR/ 2>/dev/null || true

echo "[3/4] Creating deployment scripts..."

# Create server setup script
cat > $TEMP_DIR/setup-server.sh << 'SETUP'
#!/bin/bash
# Setup script for Hetzner server

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense - Hetzner Setup                   ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (use: sudo bash setup-server.sh)"
    exit 1
fi

echo "[1/6] Updating system..."
apt-get update -qq
apt-get upgrade -y -qq

echo "[2/6] Installing Docker..."
if ! command -v docker &> /dev/null; then
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    systemctl enable docker
    systemctl start docker
    echo "✓ Docker installed"
else
    echo "✓ Docker already installed"
fi

echo "[3/6] Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo "✓ Docker Compose installed"
else
    echo "✓ Docker Compose already installed"
fi

echo "[4/6] Configuring firewall..."
if command -v ufw &> /dev/null; then
    ufw --force enable
    ufw allow 22/tcp    # SSH
    ufw allow 8000/tcp  # Agent API
    ufw allow 3000/tcp  # Dashboard
    ufw allow 11434/tcp # Ollama
    echo "✓ Firewall configured"
else
    echo "⚠ UFW not available, skipping firewall setup"
fi

echo "[5/6] Setting up application directory..."
APP_DIR="/opt/cyber-defense"
mkdir -p $APP_DIR
cp -r ./* $APP_DIR/
cd $APP_DIR
chmod +x *.sh

echo "[6/6] Creating environment file..."
if [ ! -f .env ]; then
    cp .env.example .env
    echo "✓ Environment file created"
fi

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  Setup Complete!                                       ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "Application installed in: $APP_DIR"
echo ""
echo "Next steps:"
echo "  1. cd $APP_DIR"
echo "  2. ./start-services.sh"
echo ""
SETUP

chmod +x $TEMP_DIR/setup-server.sh

# Create service start script
cat > $TEMP_DIR/start-services.sh << 'START'
#!/bin/bash
# Start all services

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Starting 492-Energy-Defense Services                 ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

echo "[1/3] Starting Docker containers..."
docker-compose up -d

echo ""
echo "[2/3] Waiting for services to initialize..."
echo "This will take 1-2 minutes for model download..."
sleep 10

echo ""
echo "[3/3] Monitoring startup (press Ctrl+C when you see 'Qwen model ready!')..."
docker-compose logs -f ollama-init

echo ""
echo "╔════════════════════════════════════════════════════════╗"
echo "║  Services Started!                                     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""
echo "Access the services:"
echo "  • Dashboard: http://$(curl -s ifconfig.me):3000"
echo "  • Agent API: http://$(curl -s ifconfig.me):8000"
echo "  • API Docs:  http://$(curl -s ifconfig.me):8000/docs"
echo ""
echo "Useful commands:"
echo "  docker-compose ps        # Check status"
echo "  docker-compose logs -f   # View logs"
echo "  docker-compose down      # Stop services"
echo ""
START

chmod +x $TEMP_DIR/start-services.sh

# Create quick check script
cat > $TEMP_DIR/check-status.sh << 'CHECK'
#!/bin/bash
# Quick status check

echo "Service Status:"
docker-compose ps

echo ""
echo "Model Status:"
docker exec ollama-qwen ollama list 2>/dev/null || echo "Ollama not ready yet"

echo ""
echo "Agent Health:"
curl -s http://localhost:8000/health | jq 2>/dev/null || echo "Agent not ready yet"

echo ""
echo "Public IP: $(curl -s ifconfig.me)"
CHECK

chmod +x $TEMP_DIR/check-status.sh

echo "[4/4] Creating tar.gz package..."
tar -czf $PACKAGE_NAME $TEMP_DIR
rm -rf $TEMP_DIR

echo ""
echo "✅ Package created: $PACKAGE_NAME"
echo ""
echo "Size: $(du -h $PACKAGE_NAME | cut -f1)"
echo ""
echo "Next steps:"
echo "  1. Upload to Hetzner: scp $PACKAGE_NAME root@YOUR_SERVER_IP:/root/"
echo "  2. SSH to server:      ssh root@YOUR_SERVER_IP"
echo "  3. Extract:            tar -xzf $PACKAGE_NAME"
echo "  4. Run setup:          cd cyber-defense-deploy && bash setup-server.sh"
echo "  5. Start services:     ./start-services.sh"
echo ""
