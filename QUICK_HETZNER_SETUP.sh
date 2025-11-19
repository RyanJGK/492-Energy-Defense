#!/bin/bash
# Quick setup script for Hetzner server
# Run this on your NEW Hetzner server after initial SSH connection

set -e  # Exit on error

echo "================================================"
echo "  492-Energy-Defense - Hetzner Quick Setup"
echo "================================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Please run as root (or use sudo)${NC}"
    echo "Usage: sudo bash QUICK_HETZNER_SETUP.sh"
    exit 1
fi

echo -e "${YELLOW}[1/8] Updating system packages...${NC}"
apt update -qq
apt upgrade -y -qq
apt install -y -qq curl git vim htop nano jq net-tools ca-certificates

echo -e "${GREEN}✓ System updated${NC}"
echo ""

echo -e "${YELLOW}[2/8] Installing Docker...${NC}"

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

# Enable Docker to start on boot
systemctl enable docker

echo -e "${GREEN}✓ Docker installed${NC}"
echo ""

echo -e "${YELLOW}[3/8] Configuring Docker for non-root user...${NC}"

# If user 'cyber' doesn't exist, create it
if ! id "cyber" &>/dev/null; then
    echo "Creating user 'cyber'..."
    adduser --disabled-password --gecos "" cyber
    usermod -aG sudo cyber
    
    # Copy SSH keys if running as root
    if [ -d "/root/.ssh" ]; then
        mkdir -p /home/cyber/.ssh
        cp /root/.ssh/authorized_keys /home/cyber/.ssh/ 2>/dev/null || true
        chown -R cyber:cyber /home/cyber/.ssh
        chmod 700 /home/cyber/.ssh
        chmod 600 /home/cyber/.ssh/authorized_keys 2>/dev/null || true
    fi
fi

# Add cyber to docker group
usermod -aG docker cyber

echo -e "${GREEN}✓ User 'cyber' configured${NC}"
echo ""

echo -e "${YELLOW}[4/8] Configuring firewall...${NC}"

# Configure UFW firewall
ufw --force enable
ufw allow 22/tcp    # SSH
ufw allow 8000/tcp  # Agent API
ufw allow 5432/tcp  # PostgreSQL (optional)
ufw allow 11434/tcp # Ollama (optional)

echo -e "${GREEN}✓ Firewall configured${NC}"
ufw status
echo ""

echo -e "${YELLOW}[5/8] Configuring Docker logging...${NC}"

# Set up log rotation
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

echo -e "${GREEN}✓ Docker logging configured${NC}"
echo ""

echo -e "${YELLOW}[6/8] Creating project directory...${NC}"

# Create project directory
mkdir -p /home/cyber/492-energy-defense
chown cyber:cyber /home/cyber/492-energy-defense

echo -e "${GREEN}✓ Project directory created: /home/cyber/492-energy-defense${NC}"
echo ""

echo -e "${YELLOW}[7/8] Setting up backup script...${NC}"

# Create backup directory
mkdir -p /home/cyber/backups
chown cyber:cyber /home/cyber/backups

# Create backup script
cat > /home/cyber/backup.sh <<'EOF'
#!/bin/bash
BACKUP_DIR=~/backups
mkdir -p $BACKUP_DIR
docker exec cyber-events-db pg_dump -U postgres cyber_events 2>/dev/null | gzip > $BACKUP_DIR/cyber_events_$(date +%Y%m%d_%H%M%S).sql.gz
find $BACKUP_DIR -name "*.sql.gz" -mtime +7 -delete
EOF

chmod +x /home/cyber/backup.sh
chown cyber:cyber /home/cyber/backup.sh

echo -e "${GREEN}✓ Backup script created${NC}"
echo ""

echo -e "${YELLOW}[8/8] Testing Docker installation...${NC}"

# Test Docker
docker run --rm hello-world > /dev/null 2>&1

echo -e "${GREEN}✓ Docker is working${NC}"
echo ""

echo "================================================"
echo -e "${GREEN}  Setup Complete!${NC}"
echo "================================================"
echo ""
echo "Next steps:"
echo ""
echo "1. Switch to 'cyber' user:"
echo "   su - cyber"
echo ""
echo "2. Upload your code to: /home/cyber/492-energy-defense/"
echo "   From your local machine:"
echo "   scp -r agent backend docker-compose.yml *.md cyber@<SERVER_IP>:~/492-energy-defense/"
echo ""
echo "3. Start the application:"
echo "   cd ~/492-energy-defense"
echo "   docker compose up -d"
echo ""
echo "4. Monitor the logs:"
echo "   docker logs -f cyber-agent"
echo ""
echo "5. Check health:"
echo "   curl http://localhost:8000/health | jq"
echo ""
echo "Server IP: $(hostname -I | awk '{print $1}')"
echo ""
echo "================================================"
