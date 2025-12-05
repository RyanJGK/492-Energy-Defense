#!/bin/bash
# Simple deployment script for Hetzner (as root user)

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense Deployment (Hetzner)              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root${NC}"
    exit 1
fi

echo -e "${YELLOW}[1/6] Updating system...${NC}"
apt-get update -qq
echo -e "${GREEN}✓ System updated${NC}"
echo ""

echo -e "${YELLOW}[2/6] Installing Docker...${NC}"
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓ Docker already installed${NC}"
else
    # Install Docker
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update -qq
    apt-get install -y docker-ce docker-ce-cli containerd.io
    echo -e "${GREEN}✓ Docker installed${NC}"
fi
echo ""

echo -e "${YELLOW}[3/6] Installing Docker Compose...${NC}"
if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✓ Docker Compose already installed${NC}"
else
    # Install Docker Compose
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}✓ Docker Compose installed${NC}"
fi
echo ""

echo -e "${YELLOW}[4/6] Starting Docker service...${NC}"
systemctl enable docker
systemctl start docker
echo -e "${GREEN}✓ Docker service running${NC}"
echo ""

echo -e "${YELLOW}[5/6] Configuring firewall...${NC}"
if command -v ufw &> /dev/null; then
    ufw allow 22/tcp comment 'SSH'
    ufw allow 8000/tcp comment 'Agent API'
    ufw allow 3000/tcp comment 'Dashboard'
    ufw --force enable
    echo -e "${GREEN}✓ Firewall configured${NC}"
else
    echo -e "${YELLOW}⚠ UFW not installed, skipping firewall setup${NC}"
fi
echo ""

echo -e "${YELLOW}[6/6] Starting application...${NC}"

# Make scripts executable
chmod +x start.sh test-llm-mode.sh check-qwen-model.sh apply-fix.sh 2>/dev/null

# Start the application
docker-compose up -d

echo -e "${GREEN}✓ Application starting...${NC}"
echo ""

echo "═══════════════════════════════════════════════════════"
echo -e "${GREEN}Deployment Complete!${NC}"
echo "═══════════════════════════════════════════════════════"
echo ""

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo "📊 Service URLs:"
echo "   • Dashboard:  http://$SERVER_IP:3000"
echo "   • Agent API:  http://$SERVER_IP:8000"
echo "   • API Docs:   http://$SERVER_IP:8000/docs"
echo ""

echo "⏳ First-time setup will take 1-2 minutes to download Qwen model."
echo ""

echo "📝 Useful commands:"
echo "   • Check status:    docker-compose ps"
echo "   • View logs:       docker-compose logs -f"
echo "   • Check model:     ./check-qwen-model.sh"
echo "   • Test system:     ./test-llm-mode.sh"
echo "   • Fix scoring:     ./apply-fix.sh"
echo "   • Stop system:     docker-compose down"
echo ""

echo "🔍 Monitor model download:"
echo "   docker logs -f ollama-init"
echo "   (Wait for 'Qwen model ready!' message)"
echo ""

echo "═══════════════════════════════════════════════════════"
echo ""
