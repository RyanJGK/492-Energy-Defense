#!/bin/bash
# Deploy from LOCAL machine to Hetzner server
# Usage: ./deploy-to-hetzner.sh <SERVER_IP>

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo "╔══════════════════════════════════════════════════════════╗"
echo "║  Deploy to Hetzner Server                                ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Check arguments
if [ -z "$1" ]; then
    echo -e "${RED}Error: Server IP required${NC}"
    echo ""
    echo "Usage: $0 <SERVER_IP> [USER]"
    echo ""
    echo "Examples:"
    echo "  $0 65.21.123.45"
    echo "  $0 65.21.123.45 cyber"
    echo ""
    exit 1
fi

SERVER_IP="$1"
USER="${2:-cyber}"
APP_DIR="/home/$USER/app"

echo "Target server: $SERVER_IP"
echo "Target user: $USER"
echo "Target directory: $APP_DIR"
echo ""

# Test SSH connection
echo -e "${YELLOW}[1/8] Testing SSH connection...${NC}"
if ssh -o ConnectTimeout=5 -o BatchMode=yes $USER@$SERVER_IP exit 2>/dev/null; then
    echo -e "${GREEN}✓ SSH connection successful${NC}"
else
    echo -e "${RED}✗ Cannot connect to server${NC}"
    echo ""
    echo "Make sure:"
    echo "  1. Server IP is correct: $SERVER_IP"
    echo "  2. SSH key is configured"
    echo "  3. Server setup script was run"
    echo ""
    echo "To setup the server, run on the Hetzner server:"
    echo "  curl -fsSL https://raw.githubusercontent.com/your-repo/workspace/main/deploy/hetzner-setup.sh | sudo bash"
    echo ""
    exit 1
fi
echo ""

# Create deployment package
echo -e "${YELLOW}[2/8] Creating deployment package...${NC}"
TEMP_DIR=$(mktemp -d)
rsync -a --exclude='node_modules' \
         --exclude='.git' \
         --exclude='*.pyc' \
         --exclude='__pycache__' \
         --exclude='.env' \
         --exclude='*.log' \
         ./ $TEMP_DIR/
echo -e "${GREEN}✓ Package created${NC}"
echo ""

# Copy files to server
echo -e "${YELLOW}[3/8] Uploading files to server...${NC}"
rsync -avz --progress \
    --exclude='node_modules' \
    --exclude='.git' \
    --exclude='*.pyc' \
    --exclude='__pycache__' \
    --exclude='.env' \
    $TEMP_DIR/ $USER@$SERVER_IP:$APP_DIR/
rm -rf $TEMP_DIR
echo -e "${GREEN}✓ Files uploaded${NC}"
echo ""

# Create .env file on server
echo -e "${YELLOW}[4/8] Creating environment configuration...${NC}"
ssh $USER@$SERVER_IP "cat > $APP_DIR/.env << 'EOF'
# Backend Configuration
DATABASE_URL=postgresql://postgres:postgres@db:5432/cyber_events
AGENT_URL=http://agent:8000/evaluate-event

# Agent Configuration
OLLAMA_URL=http://ollama:11434/api/generate
OLLAMA_MODEL=qwen2.5:1.5b
USE_LLM=false

# Database Configuration
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres
POSTGRES_DB=cyber_events
EOF
"
echo -e "${GREEN}✓ Environment configured${NC}"
echo ""

# Make scripts executable
echo -e "${YELLOW}[5/8] Setting permissions...${NC}"
ssh $USER@$SERVER_IP "cd $APP_DIR && chmod +x *.sh 2>/dev/null || true"
echo -e "${GREEN}✓ Permissions set${NC}"
echo ""

# Pull Docker images
echo -e "${YELLOW}[6/8] Pulling Docker images...${NC}"
ssh $USER@$SERVER_IP "cd $APP_DIR && docker compose pull"
echo -e "${GREEN}✓ Images pulled${NC}"
echo ""

# Start services
echo -e "${YELLOW}[7/8] Starting services...${NC}"
ssh $USER@$SERVER_IP "cd $APP_DIR && docker compose up -d"
echo -e "${GREEN}✓ Services started${NC}"
echo ""

# Wait for services to be ready
echo -e "${YELLOW}[8/8] Waiting for services to be ready...${NC}"
echo "This may take 2-3 minutes for model download..."
sleep 30

# Check service health
echo ""
echo "Checking service health..."
for i in {1..12}; do
    if ssh $USER@$SERVER_IP "curl -f -s http://localhost:8000/health > /dev/null 2>&1"; then
        echo -e "${GREEN}✓ Agent is healthy${NC}"
        break
    fi
    if [ $i -eq 12 ]; then
        echo -e "${YELLOW}⚠ Agent not responding yet (may still be initializing)${NC}"
    else
        echo "Attempt $i/12..."
        sleep 10
    fi
done
echo ""

echo "════════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ Deployment complete!${NC}"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "🌐 Access your application:"
echo "  • Agent API:    http://$SERVER_IP:8000"
echo "  • API Docs:     http://$SERVER_IP:8000/docs"
echo "  • Dashboard:    http://$SERVER_IP:3000"
echo "  • Health Check: http://$SERVER_IP:8000/health"
echo ""
echo "📊 Useful commands:"
echo "  • View logs:        ssh $USER@$SERVER_IP 'cd $APP_DIR && docker compose logs -f'"
echo "  • Check status:     ssh $USER@$SERVER_IP 'cd $APP_DIR && docker compose ps'"
echo "  • Restart services: ssh $USER@$SERVER_IP 'cd $APP_DIR && docker compose restart'"
echo "  • Stop services:    ssh $USER@$SERVER_IP 'cd $APP_DIR && docker compose down'"
echo ""
echo "🔧 SSH into server:"
echo "  ssh $USER@$SERVER_IP"
echo ""
echo "📝 View application logs:"
echo "  ssh $USER@$SERVER_IP 'cd $APP_DIR && docker compose logs -f cyber-agent'"
echo ""
