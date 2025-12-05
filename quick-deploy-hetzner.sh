#!/bin/bash
# Quick deployment script for Hetzner (to be run ON THE SERVER)

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense Quick Deploy (Hetzner)            ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
   echo "⚠️  Not running as root. Some commands may require sudo."
fi

echo "This script will:"
echo "1. Install Docker and Docker Compose"
echo "2. Extract the application"
echo "3. Start all services"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
fi

# Step 1: Check for Docker
echo ""
echo "[1/5] Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    echo "Docker not found. Installing..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sh get-docker.sh
    rm get-docker.sh
    echo "✓ Docker installed"
else
    echo "✓ Docker already installed"
fi

# Step 2: Check for Docker Compose
echo ""
echo "[2/5] Checking Docker Compose..."
if ! docker compose version &> /dev/null; then
    echo "Installing Docker Compose plugin..."
    apt-get update
    apt-get install -y docker-compose-plugin
    echo "✓ Docker Compose installed"
else
    echo "✓ Docker Compose already installed"
fi

# Step 3: Find and extract tar.gz
echo ""
echo "[3/5] Looking for deployment package..."
TARBALL=$(ls -t cyber-defense-*.tar.gz 2>/dev/null | head -1)

if [ -z "$TARBALL" ]; then
    echo "❌ No cyber-defense-*.tar.gz file found in current directory"
    echo ""
    echo "Please upload the package first:"
    echo "  scp cyber-defense-*.tar.gz root@YOUR_SERVER_IP:~/"
    exit 1
fi

echo "Found: $TARBALL"
echo "Extracting..."
tar -xzf "$TARBALL"
echo "✓ Extracted"

# Step 4: Configure firewall (optional)
echo ""
echo "[4/5] Configure firewall?"
echo "This will allow SSH and optionally the web dashboard."
read -p "Configure UFW firewall? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    if ! command -v ufw &> /dev/null; then
        apt-get install -y ufw
    fi
    
    echo "Configuring firewall..."
    ufw --force enable
    ufw allow 22/tcp  # SSH
    echo "✓ SSH (22) allowed"
    
    read -p "Allow dashboard access (port 3000)? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ufw allow 3000/tcp
        echo "✓ Dashboard (3000) allowed"
    fi
    
    read -p "Allow agent API access (port 8000)? (y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        ufw allow 8000/tcp
        echo "✓ Agent API (8000) allowed"
    fi
    
    echo "Firewall status:"
    ufw status
fi

# Step 5: Start services
echo ""
echo "[5/5] Starting services..."
cd 492-energy-defense

echo "Starting Docker containers..."
docker compose up -d

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Deployment complete!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "The system is now starting. This will take 1-2 minutes."
echo ""
echo "Watch the model download:"
echo "  docker logs -f ollama-init"
echo ""
echo "Check status:"
echo "  docker ps"
echo ""
echo "Test the agent:"
echo "  curl http://localhost:8000/health | jq"
echo ""
echo "View logs:"
echo "  docker compose logs -f"
echo ""

# Ask if user wants to watch logs
read -p "Watch Ollama model download now? (y/n) " -n 1 -r
echo ""
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Watching ollama-init logs (press Ctrl+C to exit)..."
    echo ""
    docker logs -f ollama-init
fi

