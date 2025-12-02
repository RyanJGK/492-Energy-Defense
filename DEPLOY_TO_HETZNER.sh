#!/bin/bash
# Local script to deploy to Hetzner server
# Run this on your LOCAL machine

set -e

echo "================================================"
echo "  Deploy 492-Energy-Defense to Hetzner"
echo "================================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if SERVER_IP is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Server IP address required${NC}"
    echo ""
    echo "Usage: ./DEPLOY_TO_HETZNER.sh <SERVER_IP> [USER]"
    echo ""
    echo "Example:"
    echo "  ./DEPLOY_TO_HETZNER.sh 65.21.123.45"
    echo "  ./DEPLOY_TO_HETZNER.sh 65.21.123.45 cyber"
    echo ""
    exit 1
fi

SERVER_IP="$1"
USER="${2:-cyber}"

echo "Target server: $SERVER_IP"
echo "Target user: $USER"
echo ""

# Check if we can SSH
echo -e "${YELLOW}[1/5] Testing SSH connection...${NC}"
if ssh -o ConnectTimeout=5 -o BatchMode=yes $USER@$SERVER_IP exit 2>/dev/null; then
    echo -e "${GREEN}✓ SSH connection successful${NC}"
else
    echo -e "${RED}✗ Cannot connect to server${NC}"
    echo "Make sure:"
    echo "  1. Server IP is correct"
    echo "  2. SSH key is set up"
    echo "  3. Server is running"
    exit 1
fi
echo ""

# Create archive
echo -e "${YELLOW}[2/5] Creating deployment archive...${NC}"
tar czf /tmp/cyber-defense-deploy.tar.gz \
    --exclude='.git' \
    --exclude='__pycache__' \
    --exclude='*.pyc' \
    --exclude='node_modules' \
    --exclude='*.tar.gz' \
    --exclude='BUILD_COMPLETE.txt' \
    agent/ backend/ docker-compose.yml *.md *.sh 2>/dev/null || true

echo -e "${GREEN}✓ Archive created${NC}"
echo ""

# Upload archive
echo -e "${YELLOW}[3/5] Uploading to server...${NC}"
scp /tmp/cyber-defense-deploy.tar.gz $USER@$SERVER_IP:/tmp/

echo -e "${GREEN}✓ Upload complete${NC}"
echo ""

# Extract on server
echo -e "${YELLOW}[4/5] Extracting on server...${NC}"
ssh $USER@$SERVER_IP "
    mkdir -p ~/492-energy-defense
    cd ~/492-energy-defense
    tar xzf /tmp/cyber-defense-deploy.tar.gz
    rm /tmp/cyber-defense-deploy.tar.gz
    chmod +x *.sh 2>/dev/null || true
    echo 'Extraction complete'
"

echo -e "${GREEN}✓ Files extracted${NC}"
echo ""

# Start services
echo -e "${YELLOW}[5/5] Starting services on server...${NC}"
ssh $USER@$SERVER_IP "
    cd ~/492-energy-defense
    
    echo 'Stopping any existing services...'
    docker compose down 2>/dev/null || true
    
    echo 'Starting services...'
    docker compose up -d
    
    echo ''
    echo 'Waiting for services to start...'
    sleep 5
    
    echo ''
    echo 'Container status:'
    docker ps --format 'table {{.Names}}\t{{.Status}}'
"

echo -e "${GREEN}✓ Services started${NC}"
echo ""

# Clean up local temp file
rm /tmp/cyber-defense-deploy.tar.gz

echo "================================================"
echo -e "${GREEN}  Deployment Complete!${NC}"
echo "================================================"
echo ""
echo "Access your application:"
echo "  - Agent API: http://$SERVER_IP:8000"
echo "  - Health check: curl http://$SERVER_IP:8000/health"
echo ""
echo "Monitor the system:"
echo "  ssh $USER@$SERVER_IP"
echo "  cd ~/492-energy-defense"
echo "  docker logs -f cyber-agent"
echo ""
echo "Check status:"
echo "  ssh $USER@$SERVER_IP 'docker ps'"
echo ""
echo "Note: Qwen model download may take 1-2 minutes."
echo "Watch progress: ssh $USER@$SERVER_IP 'docker logs -f ollama-init'"
echo ""
