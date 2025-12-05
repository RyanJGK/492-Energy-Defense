#!/bin/bash
# One-line setup script for Hetzner server
# Run this on your server after extracting the tar.gz

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense Server Setup                      ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root (or use sudo)"
    exit 1
fi

# Update system
echo "📦 Updating system packages..."
apt update
apt upgrade -y

# Install Docker if not present
if ! command -v docker &> /dev/null; then
    echo "🐳 Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
else
    echo "✓ Docker already installed"
fi

# Install Docker Compose if not present
if ! command -v docker-compose &> /dev/null; then
    echo "🐳 Installing Docker Compose..."
    apt install -y docker-compose
else
    echo "✓ Docker Compose already installed"
fi

# Install useful tools
echo "🔧 Installing additional tools..."
apt install -y curl jq htop net-tools ufw

# Configure firewall
echo "🔥 Configuring firewall..."
ufw --force reset
ufw allow 22/tcp    # SSH
ufw allow 80/tcp    # HTTP
ufw allow 443/tcp   # HTTPS
ufw allow 8000/tcp  # Agent API (comment out if not needed externally)
ufw allow 3000/tcp  # Dashboard (comment out if not needed externally)
ufw --force enable

# Get server IP
SERVER_IP=$(hostname -I | awk '{print $1}')

echo ""
echo "✅ Server setup complete!"
echo ""
echo "Docker version: $(docker --version)"
echo "Docker Compose version: $(docker-compose --version)"
echo "Server IP: $SERVER_IP"
echo ""
echo "Next steps:"
echo "1. Navigate to your application directory"
echo "2. Run: docker-compose up -d"
echo "3. Monitor model download: docker logs -f ollama-init"
echo ""
echo "Access your services at:"
echo "  - Dashboard: http://$SERVER_IP:3000"
echo "  - Agent API: http://$SERVER_IP:8000/docs"
echo ""
