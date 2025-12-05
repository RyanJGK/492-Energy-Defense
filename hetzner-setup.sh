#!/bin/bash
# Hetzner server setup script - Run this ON the Hetzner server as root

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense - Hetzner Setup                   ║"
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
apt-get update
apt-get upgrade -y

echo ""
echo -e "${YELLOW}[2/6] Installing Docker...${NC}"
if ! command -v docker &> /dev/null; then
    # Install Docker
    apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker's official GPG key
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Set up repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    apt-get update
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Start Docker
    systemctl start docker
    systemctl enable docker
    
    echo -e "${GREEN}✓ Docker installed${NC}"
else
    echo -e "${GREEN}✓ Docker already installed${NC}"
fi

echo ""
echo -e "${YELLOW}[3/6] Installing Docker Compose (standalone)...${NC}"
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}✓ Docker Compose installed${NC}"
else
    echo -e "${GREEN}✓ Docker Compose already installed${NC}"
fi

echo ""
echo -e "${YELLOW}[4/6] Installing additional utilities...${NC}"
apt-get install -y curl wget git jq htop vim

echo ""
echo -e "${YELLOW}[5/6] Configuring firewall...${NC}"
ufw --force enable
ufw allow 22/tcp   # SSH
ufw allow 8000/tcp # Agent API
ufw allow 3000/tcp # Dashboard
ufw allow 5432/tcp # PostgreSQL (optional, for external access)
echo -e "${GREEN}✓ Firewall configured${NC}"

echo ""
echo -e "${YELLOW}[6/6] Creating project directory...${NC}"
INSTALL_DIR="/opt/cyber-defense"
mkdir -p "$INSTALL_DIR"

# If we're in the extracted directory, copy files
if [ -f "docker-compose.yml" ]; then
    echo "Copying project files to $INSTALL_DIR..."
    cp -r . "$INSTALL_DIR/"
    cd "$INSTALL_DIR"
else
    echo "Project files should already be in: $INSTALL_DIR"
fi

echo ""
echo "════════════════════════════════════════════════════════"
echo -e "${GREEN}Setup Complete!${NC}"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Docker version:"
docker --version
docker-compose --version
echo ""
echo "Next steps:"
echo "  1. cd $INSTALL_DIR"
echo "  2. Choose your fix: ./apply-fix.sh (recommended: option 1 for rule-based)"
echo "  3. Start system: docker-compose up -d"
echo "  4. Watch logs: docker logs -f ollama-init"
echo "  5. Test: curl http://localhost:8000/health"
echo ""
echo "Access the system:"
echo "  - Agent API: http://$(curl -s ifconfig.me):8000"
echo "  - Dashboard: http://$(curl -s ifconfig.me):3000"
echo ""
echo "Monitor:"
echo "  docker-compose ps     # Check status"
echo "  docker-compose logs   # View logs"
echo "  ./check-qwen-model.sh # Verify model"
echo ""
