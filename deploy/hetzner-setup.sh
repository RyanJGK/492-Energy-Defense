#!/bin/bash
# Hetzner Server Setup Script
# Run this ON the Hetzner server as root

set -e

echo "╔══════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense - Hetzner Server Setup              ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   echo -e "${RED}This script must be run as root${NC}"
   exit 1
fi

echo -e "${YELLOW}[1/7] Updating system packages...${NC}"
apt-get update -qq
apt-get upgrade -y -qq
echo -e "${GREEN}✓ System updated${NC}"
echo ""

echo -e "${YELLOW}[2/7] Installing dependencies...${NC}"
apt-get install -y -qq \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    git \
    jq \
    ufw
echo -e "${GREEN}✓ Dependencies installed${NC}"
echo ""

echo -e "${YELLOW}[3/7] Installing Docker...${NC}"
if ! command -v docker &> /dev/null; then
    # Add Docker's official GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    chmod a+r /etc/apt/keyrings/docker.asc

    # Add Docker repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    echo -e "${GREEN}✓ Docker installed${NC}"
else
    echo -e "${GREEN}✓ Docker already installed${NC}"
fi
echo ""

echo -e "${YELLOW}[4/7] Configuring firewall...${NC}"
# Enable UFW
ufw --force enable

# Allow SSH (prevent lockout!)
ufw allow 22/tcp

# Allow application ports
ufw allow 8000/tcp  # Agent API
ufw allow 3000/tcp  # Dashboard (optional)
ufw allow 5432/tcp  # PostgreSQL (optional, for remote access)

ufw --force reload
echo -e "${GREEN}✓ Firewall configured${NC}"
echo ""

echo -e "${YELLOW}[5/7] Creating application user...${NC}"
if ! id "cyber" &>/dev/null; then
    useradd -m -s /bin/bash cyber
    usermod -aG docker cyber
    echo -e "${GREEN}✓ User 'cyber' created${NC}"
else
    echo -e "${GREEN}✓ User 'cyber' already exists${NC}"
fi
echo ""

echo -e "${YELLOW}[6/7] Creating application directory...${NC}"
mkdir -p /home/cyber/app
chown -R cyber:cyber /home/cyber/app
echo -e "${GREEN}✓ Application directory created${NC}"
echo ""

echo -e "${YELLOW}[7/7] Configuring Docker daemon...${NC}"
# Optimize Docker for server use
cat > /etc/docker/daemon.json <<EOF
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}
EOF
systemctl restart docker
echo -e "${GREEN}✓ Docker configured${NC}"
echo ""

echo "════════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ Server setup complete!${NC}"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "1. From your LOCAL machine, run:"
echo "   ./deploy/deploy-to-hetzner.sh <SERVER_IP>"
echo ""
echo "2. Or manually:"
echo "   scp -r ./* cyber@<SERVER_IP>:/home/cyber/app/"
echo "   ssh cyber@<SERVER_IP>"
echo "   cd /home/cyber/app"
echo "   docker compose up -d"
echo ""
echo "System Information:"
echo "  • Docker version: $(docker --version)"
echo "  • User: cyber"
echo "  • App directory: /home/cyber/app"
echo "  • Firewall: enabled"
echo "  • Allowed ports: 22, 8000, 3000, 5432"
echo ""
