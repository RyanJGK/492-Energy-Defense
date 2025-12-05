#!/bin/bash
# Server setup script for Hetzner deployment
# Run this ON THE SERVER after extracting the tar.gz

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense Server Setup                      ║"
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

echo -e "${YELLOW}[1/6] Updating system packages...${NC}"
apt-get update
apt-get upgrade -y
echo -e "${GREEN}✓ System updated${NC}"
echo ""

echo -e "${YELLOW}[2/6] Installing Docker...${NC}"
if ! command -v docker &> /dev/null; then
    # Install Docker
    apt-get install -y ca-certificates curl gnupg lsb-release
    
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
    
    echo -e "${GREEN}✓ Docker installed${NC}"
else
    echo -e "${GREEN}✓ Docker already installed${NC}"
fi
echo ""

echo -e "${YELLOW}[3/6] Installing Docker Compose...${NC}"
if ! command -v docker-compose &> /dev/null; then
    curl -L "https://github.com/docker/compose/releases/download/v2.23.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
    echo -e "${GREEN}✓ Docker Compose installed${NC}"
else
    echo -e "${GREEN}✓ Docker Compose already installed${NC}"
fi
echo ""

echo -e "${YELLOW}[4/6] Installing additional tools...${NC}"
apt-get install -y curl wget jq git htop net-tools
echo -e "${GREEN}✓ Tools installed${NC}"
echo ""

echo -e "${YELLOW}[5/6] Configuring firewall...${NC}"
if command -v ufw &> /dev/null; then
    ufw --force enable
    ufw allow 22/tcp    # SSH
    ufw allow 3000/tcp  # Dashboard
    ufw allow 8000/tcp  # Agent API (optional - for external access)
    ufw allow 5432/tcp  # PostgreSQL (optional - for external access)
    echo -e "${GREEN}✓ Firewall configured${NC}"
else
    echo -e "${YELLOW}⚠ UFW not available, skipping firewall setup${NC}"
fi
echo ""

echo -e "${YELLOW}[6/6] Starting Docker service...${NC}"
systemctl start docker
systemctl enable docker
echo -e "${GREEN}✓ Docker service started${NC}"
echo ""

echo "════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ Server setup complete!${NC}"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo ""
echo "1. Review and customize .env file (optional):"
echo "   cp .env.example .env"
echo "   nano .env"
echo ""
echo "2. Choose deployment mode:"
echo ""
echo "   Option A - Rule-Based Mode (Recommended):"
echo "   • Fast and accurate (no LLM)"
echo "   • Edit docker-compose.yml: USE_LLM=false"
echo "   • Start: docker-compose up -d"
echo ""
echo "   Option B - LLM Mode:"
echo "   • Uses AI model (slower, needs more RAM)"
echo "   • Edit docker-compose.yml: USE_LLM=true"
echo "   • Edit docker-compose.yml: OLLAMA_MODEL=qwen2.5:1.5b (recommended)"
echo "   • Start: docker-compose up -d"
echo ""
echo "3. Start the system:"
echo "   docker-compose up -d"
echo ""
echo "4. Monitor startup (wait 2-3 minutes for first run):"
echo "   docker-compose logs -f"
echo ""
echo "5. Access the dashboard:"
echo "   http://$(hostname -I | awk '{print $1}'):3000"
echo ""
echo "6. Check system health:"
echo "   docker ps"
echo "   curl http://localhost:8000/health"
echo ""
echo "════════════════════════════════════════════════════════"
