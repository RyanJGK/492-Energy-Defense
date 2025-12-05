#!/bin/bash
# Hetzner Server Setup Script
# Run this ON the Hetzner server as root

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense Hetzner Server Setup              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root (use: sudo bash setup-server.sh)${NC}"
    exit 1
fi

echo -e "${YELLOW}[1/7] Updating system packages...${NC}"
apt-get update -qq
apt-get upgrade -y -qq
echo -e "${GREEN}✓ System updated${NC}"
echo ""

echo -e "${YELLOW}[2/7] Installing Docker...${NC}"
if command -v docker &> /dev/null; then
    echo -e "${GREEN}✓ Docker already installed${NC}"
else
    # Install Docker
    apt-get install -y -qq ca-certificates curl gnupg lsb-release
    mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin
    systemctl enable docker
    systemctl start docker
    echo -e "${GREEN}✓ Docker installed${NC}"
fi
echo ""

echo -e "${YELLOW}[3/7] Installing Docker Compose...${NC}"
if command -v docker-compose &> /dev/null; then
    echo -e "${GREEN}✓ Docker Compose already installed${NC}"
else
    curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}✓ Docker Compose installed${NC}"
fi
echo ""

echo -e "${YELLOW}[4/7] Installing utilities...${NC}"
apt-get install -y -qq git curl jq vim htop
echo -e "${GREEN}✓ Utilities installed${NC}"
echo ""

echo -e "${YELLOW}[5/7] Creating application user...${NC}"
if id "cyberdefense" &>/dev/null; then
    echo -e "${GREEN}✓ User cyberdefense already exists${NC}"
else
    useradd -m -s /bin/bash cyberdefense
    usermod -aG docker cyberdefense
    echo -e "${GREEN}✓ User cyberdefense created${NC}"
fi
echo ""

echo -e "${YELLOW}[6/7] Configuring firewall...${NC}"
apt-get install -y -qq ufw
ufw --force enable
ufw allow 22/tcp    # SSH
ufw allow 8000/tcp  # Agent API
ufw allow 3000/tcp  # Dashboard
ufw allow 5432/tcp  # PostgreSQL (optional, comment out for security)
echo -e "${GREEN}✓ Firewall configured${NC}"
echo ""

echo -e "${YELLOW}[7/7] Setting up application directory...${NC}"
mkdir -p /opt/cyberdefense
chown cyberdefense:cyberdefense /opt/cyberdefense
echo -e "${GREEN}✓ Application directory ready${NC}"
echo ""

echo "════════════════════════════════════════════════════════"
echo -e "${GREEN}Server setup complete!${NC}"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "1. Upload application files to /opt/cyberdefense"
echo "2. Switch to application user: su - cyberdefense"
echo "3. Start the application: cd /opt/cyberdefense && docker-compose up -d"
echo ""
echo "System Information:"
echo "  • Docker: $(docker --version)"
echo "  • Docker Compose: $(docker-compose --version)"
echo "  • Application User: cyberdefense"
echo "  • Application Path: /opt/cyberdefense"
echo ""
