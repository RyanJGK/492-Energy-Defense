#!/bin/bash
# Local Deployment Script - Run this on YOUR LOCAL machine
# This script packages and deploys to Hetzner server

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Deploy to Hetzner Server                             ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check arguments
if [ -z "$1" ]; then
    echo -e "${RED}Error: Server IP address required${NC}"
    echo ""
    echo "Usage: ./deploy-to-hetzner.sh <SERVER_IP> [USER]"
    echo ""
    echo "Examples:"
    echo "  ./deploy-to-hetzner.sh 195.201.123.45"
    echo "  ./deploy-to-hetzner.sh 195.201.123.45 root"
    echo "  ./deploy-to-hetzner.sh 195.201.123.45 cyberdefense"
    echo ""
    exit 1
fi

SERVER_IP="$1"
SERVER_USER="${2:-root}"
APP_DIR="/opt/cyberdefense"

echo "Deployment Configuration:"
echo "  Server: $SERVER_IP"
echo "  User: $SERVER_USER"
echo "  Directory: $APP_DIR"
echo ""

# Test SSH connection
echo -e "${YELLOW}[1/6] Testing SSH connection...${NC}"
if ssh -o ConnectTimeout=5 -o BatchMode=yes "$SERVER_USER@$SERVER_IP" exit 2>/dev/null; then
    echo -e "${GREEN}✓ SSH connection successful${NC}"
else
    echo -e "${RED}✗ Cannot connect to server${NC}"
    echo ""
    echo "Make sure:"
    echo "  1. Server IP is correct: $SERVER_IP"
    echo "  2. SSH key is configured"
    echo "  3. Server is running"
    echo ""
    echo "To add your SSH key:"
    echo "  ssh-copy-id $SERVER_USER@$SERVER_IP"
    echo ""
    exit 1
fi
echo ""

# Setup server if needed
echo -e "${YELLOW}[2/6] Checking server setup...${NC}"
SERVER_READY=$(ssh "$SERVER_USER@$SERVER_IP" "command -v docker &>/dev/null && echo 'yes' || echo 'no'")

if [ "$SERVER_READY" = "no" ]; then
    echo "Docker not found. Running server setup..."
    scp hetzner-deploy/setup-server.sh "$SERVER_USER@$SERVER_IP:/tmp/"
    ssh "$SERVER_USER@$SERVER_IP" "sudo bash /tmp/setup-server.sh"
    echo -e "${GREEN}✓ Server setup complete${NC}"
else
    echo -e "${GREEN}✓ Server already configured${NC}"
fi
echo ""

# Create deployment package
echo -e "${YELLOW}[3/6] Creating deployment package...${NC}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
PACKAGE_NAME="cyberdefense_${TIMESTAMP}.tar.gz"

# Create temporary directory
TMP_DIR=$(mktemp -d)
DEPLOY_DIR="$TMP_DIR/cyberdefense"
mkdir -p "$DEPLOY_DIR"

# Copy necessary files
cp docker-compose.yml "$DEPLOY_DIR/"
cp .env.example "$DEPLOY_DIR/.env"
cp -r agent "$DEPLOY_DIR/"
cp -r backend "$DEPLOY_DIR/"
cp -r dashboard "$DEPLOY_DIR/" 2>/dev/null || true
cp README.md "$DEPLOY_DIR/" 2>/dev/null || true
cp check-qwen-model.sh "$DEPLOY_DIR/" 2>/dev/null || true
cp apply-fix.sh "$DEPLOY_DIR/" 2>/dev/null || true

# Create production docker-compose if it doesn't exist
if [ ! -f "$DEPLOY_DIR/docker-compose.prod.yml" ]; then
    cp hetzner-deploy/docker-compose.prod.yml "$DEPLOY_DIR/" 2>/dev/null || cp docker-compose.yml "$DEPLOY_DIR/docker-compose.prod.yml"
fi

# Create package
cd "$TMP_DIR"
tar -czf "$PACKAGE_NAME" cyberdefense/
mv "$PACKAGE_NAME" /tmp/
rm -rf "$TMP_DIR"

echo -e "${GREEN}✓ Package created: /tmp/$PACKAGE_NAME${NC}"
echo ""

# Upload package
echo -e "${YELLOW}[4/6] Uploading to server...${NC}"
scp "/tmp/$PACKAGE_NAME" "$SERVER_USER@$SERVER_IP:/tmp/"
echo -e "${GREEN}✓ Package uploaded${NC}"
echo ""

# Extract and setup on server
echo -e "${YELLOW}[5/6] Setting up application on server...${NC}"
ssh "$SERVER_USER@$SERVER_IP" << EOF
    set -e
    
    # Create directory if needed
    sudo mkdir -p $APP_DIR
    
    # Stop existing services
    cd $APP_DIR 2>/dev/null && sudo docker-compose down 2>/dev/null || true
    
    # Extract new version
    cd /tmp
    sudo tar -xzf $PACKAGE_NAME -C /tmp/
    sudo rsync -av --delete /tmp/cyberdefense/ $APP_DIR/
    
    # Set ownership
    if id "cyberdefense" &>/dev/null; then
        sudo chown -R cyberdefense:cyberdefense $APP_DIR
    fi
    
    # Cleanup
    rm -rf /tmp/cyberdefense /tmp/$PACKAGE_NAME
    
    echo "Application files deployed to $APP_DIR"
EOF

echo -e "${GREEN}✓ Application deployed${NC}"
echo ""

# Start services
echo -e "${YELLOW}[6/6] Starting services...${NC}"
ssh "$SERVER_USER@$SERVER_IP" << EOF
    set -e
    cd $APP_DIR
    
    # Use production compose if available, otherwise regular
    if [ -f docker-compose.prod.yml ]; then
        sudo docker-compose -f docker-compose.prod.yml up -d
    else
        sudo docker-compose up -d
    fi
    
    echo ""
    echo "Waiting for services to start..."
    sleep 10
    
    echo ""
    echo "Container status:"
    sudo docker-compose ps
EOF

echo -e "${GREEN}✓ Services started${NC}"
echo ""

# Cleanup local package
rm -f "/tmp/$PACKAGE_NAME"

echo "════════════════════════════════════════════════════════"
echo -e "${GREEN}Deployment Complete!${NC}"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Your application is now running at:"
echo "  • Agent API:  http://$SERVER_IP:8000"
echo "  • Dashboard:  http://$SERVER_IP:3000"
echo "  • API Docs:   http://$SERVER_IP:8000/docs"
echo ""
echo "Useful commands (run on server):"
echo "  • View logs:      cd $APP_DIR && sudo docker-compose logs -f"
echo "  • Check status:   cd $APP_DIR && sudo docker-compose ps"
echo "  • Restart:        cd $APP_DIR && sudo docker-compose restart"
echo "  • Stop:           cd $APP_DIR && sudo docker-compose down"
echo ""
echo "SSH to server:"
echo "  ssh $SERVER_USER@$SERVER_IP"
echo ""
echo "Monitor deployment:"
echo "  ssh $SERVER_USER@$SERVER_IP 'cd $APP_DIR && sudo docker-compose logs -f ollama-init'"
echo ""
