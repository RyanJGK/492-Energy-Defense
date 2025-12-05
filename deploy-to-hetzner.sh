#!/bin/bash
# One-Command Hetzner Deployment Script
# Usage: ./deploy-to-hetzner.sh <server-ip> [ssh-user]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║  492-ENERGY-DEFENSE - Hetzner Deployment                      ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

# Check arguments
if [ -z "$1" ]; then
    echo -e "${RED}Error: Server IP required${NC}"
    echo ""
    echo "Usage: ./deploy-to-hetzner.sh <server-ip> [ssh-user]"
    echo ""
    echo "Example:"
    echo "  ./deploy-to-hetzner.sh 65.21.123.45"
    echo "  ./deploy-to-hetzner.sh 65.21.123.45 ubuntu"
    echo ""
    exit 1
fi

SERVER_IP="$1"
SSH_USER="${2:-root}"
APP_DIR="/opt/cyber-defense"

echo -e "${BLUE}Deployment Configuration:${NC}"
echo "  Server IP: $SERVER_IP"
echo "  SSH User: $SSH_USER"
echo "  Install Directory: $APP_DIR"
echo ""

# Test SSH connection
echo -e "${YELLOW}[1/8] Testing SSH connection...${NC}"
if ssh -o ConnectTimeout=10 -o BatchMode=yes "$SSH_USER@$SERVER_IP" exit 2>/dev/null; then
    echo -e "${GREEN}✓ SSH connection successful${NC}"
else
    echo -e "${RED}✗ Cannot connect to server${NC}"
    echo ""
    echo "Please ensure:"
    echo "  1. Server IP is correct: $SERVER_IP"
    echo "  2. SSH key is configured"
    echo "  3. User exists: $SSH_USER"
    echo ""
    exit 1
fi
echo ""

# Create deployment package
echo -e "${YELLOW}[2/8] Creating deployment package...${NC}"
TEMP_DIR=$(mktemp -d)
tar czf "$TEMP_DIR/cyber-defense.tar.gz" \
    --exclude='.git' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='.env' \
    --exclude='node_modules' \
    --exclude='venv' \
    .

echo -e "${GREEN}✓ Package created: $(du -h "$TEMP_DIR/cyber-defense.tar.gz" | cut -f1)${NC}"
echo ""

# Copy package to server
echo -e "${YELLOW}[3/8] Uploading to server...${NC}"
ssh "$SSH_USER@$SERVER_IP" "mkdir -p $APP_DIR"
scp -q "$TEMP_DIR/cyber-defense.tar.gz" "$SSH_USER@$SERVER_IP:$APP_DIR/"
echo -e "${GREEN}✓ Upload complete${NC}"
echo ""

# Install dependencies on server
echo -e "${YELLOW}[4/8] Installing server dependencies...${NC}"
ssh "$SSH_USER@$SERVER_IP" bash << 'ENDSSH'
set -e

# Update system
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get upgrade -y -qq

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh > /dev/null 2>&1
    rm get-docker.sh
    systemctl enable docker
    systemctl start docker
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "Installing Docker Compose..."
    COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    curl -L "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
fi

# Install other utilities
apt-get install -y -qq curl jq git htop

echo "✓ Dependencies installed"
ENDSSH
echo -e "${GREEN}✓ Server dependencies ready${NC}"
echo ""

# Extract and setup application
echo -e "${YELLOW}[5/8] Setting up application...${NC}"
ssh "$SSH_USER@$SERVER_IP" bash << ENDSSH
set -e
cd $APP_DIR
tar xzf cyber-defense.tar.gz
rm cyber-defense.tar.gz

# Set permissions
chmod +x *.sh 2>/dev/null || true
chmod +x check-qwen-model.sh 2>/dev/null || true

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    cp .env.example .env
fi

echo "✓ Application extracted and configured"
ENDSSH
echo -e "${GREEN}✓ Application setup complete${NC}"
echo ""

# Configure firewall
echo -e "${YELLOW}[6/8] Configuring firewall...${NC}"
ssh "$SSH_USER@$SERVER_IP" bash << 'ENDSSH'
set -e

# Install UFW if not present
if ! command -v ufw &> /dev/null; then
    apt-get install -y -qq ufw
fi

# Configure firewall
ufw --force enable
ufw default deny incoming
ufw default allow outgoing
ufw allow 22/tcp    # SSH
ufw allow 3000/tcp  # Dashboard
ufw allow 8000/tcp  # Agent API
ufw --force reload

echo "✓ Firewall configured"
ENDSSH
echo -e "${GREEN}✓ Firewall rules applied${NC}"
echo ""

# Start the application
echo -e "${YELLOW}[7/8] Starting application...${NC}"
ssh "$SSH_USER@$SERVER_IP" bash << ENDSSH
set -e
cd $APP_DIR

# Stop any existing containers
docker-compose down 2>/dev/null || true

# Pull images and start
docker-compose pull -q
docker-compose up -d

echo "✓ Application started"
ENDSSH
echo -e "${GREEN}✓ Application is starting${NC}"
echo ""

# Wait for services and verify
echo -e "${YELLOW}[8/8] Verifying deployment...${NC}"
echo "Waiting for services to initialize (30 seconds)..."
sleep 30

# Check if services are running
ssh "$SSH_USER@$SERVER_IP" "cd $APP_DIR && docker-compose ps"
echo ""

# Test endpoints
echo "Testing endpoints..."
if curl -sf "http://$SERVER_IP:8000/health" > /dev/null; then
    echo -e "${GREEN}✓ Agent API is responding${NC}"
else
    echo -e "${YELLOW}⚠ Agent API not responding yet (may still be starting)${NC}"
fi

if curl -sf "http://$SERVER_IP:3000/health" > /dev/null; then
    echo -e "${GREEN}✓ Dashboard is responding${NC}"
else
    echo -e "${YELLOW}⚠ Dashboard not responding yet (may still be starting)${NC}"
fi
echo ""

# Cleanup
rm -rf "$TEMP_DIR"

echo "════════════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ DEPLOYMENT COMPLETE!${NC}"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "🌐 Access your services:"
echo "   Dashboard:  http://$SERVER_IP:3000"
echo "   Agent API:  http://$SERVER_IP:8000"
echo "   API Docs:   http://$SERVER_IP:8000/docs"
echo ""
echo "📊 Useful commands (run on server):"
echo "   cd $APP_DIR"
echo "   docker-compose ps              # Check status"
echo "   docker-compose logs -f         # View logs"
echo "   docker-compose restart         # Restart services"
echo "   ./check-qwen-model.sh          # Verify Qwen model"
echo ""
echo "📝 SSH into server:"
echo "   ssh $SSH_USER@$SERVER_IP"
echo ""
echo "⏳ Note: First run will download Qwen model (~400MB)"
echo "   This takes 1-2 minutes. Monitor with:"
echo "   ssh $SSH_USER@$SERVER_IP 'cd $APP_DIR && docker logs -f ollama-init'"
echo ""
echo "🎉 Deployment successful!"
echo ""
