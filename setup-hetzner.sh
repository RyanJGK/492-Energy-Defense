#!/bin/bash
# Setup script for Hetzner server (run as root)

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense Hetzner Setup                     ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Error: Please run as root${NC}"
    echo "Run: sudo bash setup-hetzner.sh"
    exit 1
fi

echo -e "${YELLOW}[1/6] Updating system packages...${NC}"
apt-get update -qq
echo -e "${GREEN}✓ System updated${NC}"
echo ""

echo -e "${YELLOW}[2/6] Installing Docker...${NC}"
if ! command -v docker &> /dev/null; then
    # Install Docker
    apt-get install -y apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
    add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    apt-get update -qq
    apt-get install -y docker-ce docker-ce-cli containerd.io
    systemctl start docker
    systemctl enable docker
    echo -e "${GREEN}✓ Docker installed${NC}"
else
    echo -e "${GREEN}✓ Docker already installed${NC}"
fi
echo ""

echo -e "${YELLOW}[3/6] Installing Docker Compose...${NC}"
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}✓ Docker Compose installed${NC}"
else
    echo -e "${GREEN}✓ Docker Compose already installed${NC}"
fi
echo ""

echo -e "${YELLOW}[4/6] Installing additional tools...${NC}"
apt-get install -y curl jq git htop
echo -e "${GREEN}✓ Tools installed${NC}"
echo ""

echo -e "${YELLOW}[5/6] Configuring firewall...${NC}"
# Install UFW if not present
if ! command -v ufw &> /dev/null; then
    apt-get install -y ufw
fi

# Configure firewall
ufw --force enable
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 8000/tcp  # Agent API
ufw allow 3000/tcp  # Dashboard
echo -e "${GREEN}✓ Firewall configured${NC}"
echo ""

echo -e "${YELLOW}[6/6] Starting application...${NC}"
cd "$(dirname "$0")"

# Make scripts executable
chmod +x *.sh

# Start with docker-compose
echo "Building and starting containers..."
docker-compose build
docker-compose up -d

echo ""
echo -e "${GREEN}✓ Application starting...${NC}"
echo ""

echo "Waiting for services to initialize (this may take 2-3 minutes)..."
sleep 10

# Wait for Ollama model download
echo ""
echo "Monitoring Qwen model download..."
echo "(You can press Ctrl+C to stop watching, services will continue)"
echo ""
docker logs -f ollama-init 2>&1 | grep -m 1 "Qwen model ready!" || true

echo ""
echo "════════════════════════════════════════════════════════"
echo -e "${GREEN}Setup Complete!${NC}"
echo "════════════════════════════════════════════════════════"
echo ""
echo "🎉 Your cybersecurity agent is now running!"
echo ""
echo "Access your services:"
echo "  Dashboard:    http://$(curl -s ifconfig.me):3000"
echo "  Agent API:    http://$(curl -s ifconfig.me):8000"
echo "  API Docs:     http://$(curl -s ifconfig.me):8000/docs"
echo ""
echo "Useful commands:"
echo "  View logs:           docker-compose logs -f"
echo "  Check status:        docker-compose ps"
echo "  Stop services:       docker-compose down"
echo "  Restart services:    docker-compose restart"
echo "  View agent health:   curl http://localhost:8000/health | jq"
echo ""
echo "Test the agent:"
echo "  ./test-llm-mode.sh"
echo ""
echo "Check model status:"
echo "  docker exec ollama-qwen ollama list"
echo ""
