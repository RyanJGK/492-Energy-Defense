#!/bin/bash
# Hetzner Server Setup Script
# Run this ON THE HETZNER SERVER as root

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense - Hetzner Server Setup            ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo -e "${RED}Please run as root (use sudo)${NC}"
    exit 1
fi

echo -e "${YELLOW}[1/8] Updating system packages...${NC}"
apt-get update
apt-get upgrade -y
echo -e "${GREEN}✓ System updated${NC}"
echo ""

echo -e "${YELLOW}[2/8] Installing required packages...${NC}"
apt-get install -y \
    curl \
    wget \
    git \
    ufw \
    htop \
    vim \
    jq \
    ca-certificates \
    gnupg \
    lsb-release
echo -e "${GREEN}✓ Packages installed${NC}"
echo ""

echo -e "${YELLOW}[3/8] Installing Docker...${NC}"
# Remove old Docker versions
apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

# Add Docker's official GPG key
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# Set up Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Start Docker
systemctl start docker
systemctl enable docker
echo -e "${GREEN}✓ Docker installed${NC}"
echo ""

echo -e "${YELLOW}[4/8] Configuring firewall...${NC}"
# Configure UFW
ufw --force reset
ufw default deny incoming
ufw default allow outgoing

# Allow SSH (important!)
ufw allow 22/tcp

# Allow application ports
ufw allow 8000/tcp  comment 'AI Agent API'
ufw allow 3000/tcp  comment 'Dashboard'
ufw allow 5432/tcp  comment 'PostgreSQL (if needed externally)'

# Enable firewall
ufw --force enable
echo -e "${GREEN}✓ Firewall configured${NC}"
echo ""

echo -e "${YELLOW}[5/8] Creating application user...${NC}"
# Create dedicated user for the application
if id "cyber" &>/dev/null; then
    echo "User 'cyber' already exists"
else
    useradd -m -s /bin/bash cyber
    usermod -aG docker cyber
    echo -e "${GREEN}✓ User 'cyber' created${NC}"
fi
echo ""

echo -e "${YELLOW}[6/8] Creating application directory...${NC}"
# Create app directory
mkdir -p /opt/cyber-defense
chown cyber:cyber /opt/cyber-defense
echo -e "${GREEN}✓ Directory created: /opt/cyber-defense${NC}"
echo ""

echo -e "${YELLOW}[7/8] Optimizing system for Docker...${NC}"
# Increase file limits for containers
cat > /etc/security/limits.d/docker.conf << EOF
* soft nofile 65536
* hard nofile 65536
* soft nproc 4096
* hard nproc 4096
EOF

# Optimize kernel parameters
cat > /etc/sysctl.d/99-docker.conf << EOF
# Docker optimizations
vm.max_map_count=262144
fs.file-max=65536
net.core.somaxconn=1024
EOF
sysctl -p /etc/sysctl.d/99-docker.conf
echo -e "${GREEN}✓ System optimized${NC}"
echo ""

echo -e "${YELLOW}[8/8] Setting up log rotation...${NC}"
cat > /etc/logrotate.d/docker-containers << EOF
/var/lib/docker/containers/*/*.log {
    rotate 7
    daily
    compress
    missingok
    delaycompress
    copytruncate
}
EOF
echo -e "${GREEN}✓ Log rotation configured${NC}"
echo ""

# Print summary
echo "════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ Hetzner Server Setup Complete!${NC}"
echo "════════════════════════════════════════════════════════"
echo ""
echo "System Information:"
echo "  • Docker version: $(docker --version)"
echo "  • Docker Compose: $(docker compose version)"
echo "  • Application user: cyber"
echo "  • Application directory: /opt/cyber-defense"
echo ""
echo "Firewall Status:"
ufw status numbered
echo ""
echo "Next Steps:"
echo "  1. Switch to cyber user: su - cyber"
echo "  2. Upload application files to /opt/cyber-defense"
echo "  3. Run deployment script"
echo ""
echo "Or use the automated deployment from your local machine:"
echo "  ./deploy-to-hetzner.sh <SERVER_IP>"
echo ""
