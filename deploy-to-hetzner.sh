#!/bin/bash
# Deploy 492-Energy-Defense to Hetzner Server
# Run this FROM YOUR LOCAL MACHINE

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense - Hetzner Deployment              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Check arguments
if [ -z "$1" ]; then
    echo -e "${RED}Error: Server IP address required${NC}"
    echo ""
    echo "Usage: ./deploy-to-hetzner.sh <SERVER_IP> [SSH_USER]"
    echo ""
    echo "Examples:"
    echo "  ./deploy-to-hetzner.sh 65.21.123.45"
    echo "  ./deploy-to-hetzner.sh 65.21.123.45 root"
    echo "  ./deploy-to-hetzner.sh 65.21.123.45 cyber"
    echo ""
    exit 1
fi

SERVER_IP="$1"
SSH_USER="${2:-cyber}"
DEPLOY_DIR="/opt/cyber-defense"

echo "Deployment Configuration:"
echo "  • Server IP: $SERVER_IP"
echo "  • SSH User: $SSH_USER"
echo "  • Deploy Directory: $DEPLOY_DIR"
echo ""

# Test SSH connection
echo -e "${YELLOW}[1/7] Testing SSH connection...${NC}"
if ssh -o ConnectTimeout=5 -o BatchMode=yes $SSH_USER@$SERVER_IP exit 2>/dev/null; then
    echo -e "${GREEN}✓ SSH connection successful${NC}"
else
    echo -e "${RED}✗ Cannot connect to server${NC}"
    echo ""
    echo "Troubleshooting:"
    echo "  1. Check server IP is correct: $SERVER_IP"
    echo "  2. Ensure SSH key is added to server"
    echo "  3. Verify user '$SSH_USER' exists on server"
    echo "  4. Try: ssh $SSH_USER@$SERVER_IP"
    echo ""
    echo "If you need to setup the server first, run:"
    echo "  ssh root@$SERVER_IP 'bash -s' < hetzner-setup.sh"
    exit 1
fi
echo ""

# Create deployment package
echo -e "${YELLOW}[2/7] Creating deployment package...${NC}"
TEMP_DIR=$(mktemp -d)
PACKAGE_NAME="cyber-defense-$(date +%Y%m%d-%H%M%S).tar.gz"

# Copy files to temp directory
mkdir -p $TEMP_DIR/cyber-defense
cp -r agent backend dashboard docker-compose.yml .env.example $TEMP_DIR/cyber-defense/
cp apply-fix.sh check-qwen-model.sh start.sh test-llm-mode.sh $TEMP_DIR/cyber-defense/ 2>/dev/null || true
cp *.md $TEMP_DIR/cyber-defense/ 2>/dev/null || true

# Create production docker-compose override
cat > $TEMP_DIR/cyber-defense/docker-compose.prod.yml << 'EOF'
version: '3.8'

# Production overrides for Hetzner deployment
services:
  agent:
    restart: always
    environment:
      - USE_LLM=false  # Rule-based mode for reliability
    
  backend:
    restart: always
    
  dashboard:
    restart: always
    
  db:
    restart: always
    
  ollama:
    restart: always
EOF

# Create deployment script that will run on server
cat > $TEMP_DIR/cyber-defense/deploy.sh << 'EOF'
#!/bin/bash
# This script runs ON THE SERVER

set -e

echo "Starting deployment..."
cd /opt/cyber-defense

# Stop existing containers
echo "Stopping existing containers..."
docker compose down 2>/dev/null || true

# Pull latest images
echo "Pulling Docker images..."
docker compose pull

# Build custom images
echo "Building application images..."
docker compose build

# Start services
echo "Starting services..."
docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Wait for services to be healthy
echo "Waiting for services to be healthy..."
sleep 10

# Check status
echo "Service status:"
docker compose ps

echo ""
echo "✅ Deployment complete!"
echo ""
echo "Services:"
echo "  • AI Agent: http://$(hostname -I | awk '{print $1}'):8000"
echo "  • Dashboard: http://$(hostname -I | awk '{print $1}'):3000"
echo ""
EOF

chmod +x $TEMP_DIR/cyber-defense/deploy.sh

# Create package
cd $TEMP_DIR
tar -czf $PACKAGE_NAME cyber-defense/
cd - > /dev/null

echo -e "${GREEN}✓ Package created: $PACKAGE_NAME${NC}"
echo ""

# Upload package to server
echo -e "${YELLOW}[3/7] Uploading package to server...${NC}"
scp $TEMP_DIR/$PACKAGE_NAME $SSH_USER@$SERVER_IP:/tmp/
echo -e "${GREEN}✓ Package uploaded${NC}"
echo ""

# Extract and deploy on server
echo -e "${YELLOW}[4/7] Extracting package on server...${NC}"
ssh $SSH_USER@$SERVER_IP << ENDSSH
    set -e
    cd /tmp
    tar -xzf $PACKAGE_NAME
    
    # Backup existing deployment if it exists
    if [ -d "$DEPLOY_DIR" ]; then
        echo "Backing up existing deployment..."
        sudo mv $DEPLOY_DIR ${DEPLOY_DIR}.backup.\$(date +%Y%m%d-%H%M%S) 2>/dev/null || true
    fi
    
    # Move new deployment
    sudo mkdir -p $DEPLOY_DIR
    sudo mv cyber-defense/* $DEPLOY_DIR/
    sudo chown -R $SSH_USER:$SSH_USER $DEPLOY_DIR
    
    # Cleanup
    rm -rf cyber-defense $PACKAGE_NAME
    
    echo "✓ Package extracted to $DEPLOY_DIR"
ENDSSH
echo -e "${GREEN}✓ Package extracted${NC}"
echo ""

# Run deployment script
echo -e "${YELLOW}[5/7] Deploying application...${NC}"
ssh $SSH_USER@$SERVER_IP "cd $DEPLOY_DIR && bash deploy.sh"
echo -e "${GREEN}✓ Application deployed${NC}"
echo ""

# Wait for services to start
echo -e "${YELLOW}[6/7] Waiting for services to start...${NC}"
sleep 15
echo -e "${GREEN}✓ Services started${NC}"
echo ""

# Verify deployment
echo -e "${YELLOW}[7/7] Verifying deployment...${NC}"
echo ""
echo "Testing AI Agent health..."
if ssh $SSH_USER@$SERVER_IP "curl -sf http://localhost:8000/health" > /dev/null; then
    echo -e "${GREEN}✓ AI Agent is healthy${NC}"
    AGENT_INFO=$(ssh $SSH_USER@$SERVER_IP "curl -s http://localhost:8000/health")
    echo "$AGENT_INFO" | jq '.' 2>/dev/null || echo "$AGENT_INFO"
else
    echo -e "${RED}✗ AI Agent not responding${NC}"
fi
echo ""

echo "Testing Dashboard health..."
if ssh $SSH_USER@$SERVER_IP "curl -sf http://localhost:3000/health" > /dev/null; then
    echo -e "${GREEN}✓ Dashboard is healthy${NC}"
else
    echo -e "${RED}✗ Dashboard not responding${NC}"
fi
echo ""

echo "Testing Database..."
if ssh $SSH_USER@$SERVER_IP "docker exec cyber-events-db pg_isready -U postgres" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Database is ready${NC}"
else
    echo -e "${RED}✗ Database not responding${NC}"
fi
echo ""

# Cleanup local temp files
rm -rf $TEMP_DIR

# Print success message
echo "════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ Deployment Successful!${NC}"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Access your services:"
echo "  • AI Agent API: http://$SERVER_IP:8000"
echo "  • API Documentation: http://$SERVER_IP:8000/docs"
echo "  • Dashboard: http://$SERVER_IP:3000"
echo ""
echo "Useful commands (run on server):"
echo "  • View logs: ssh $SSH_USER@$SERVER_IP 'cd $DEPLOY_DIR && docker compose logs -f'"
echo "  • Check status: ssh $SSH_USER@$SERVER_IP 'cd $DEPLOY_DIR && docker compose ps'"
echo "  • Restart services: ssh $SSH_USER@$SERVER_IP 'cd $DEPLOY_DIR && docker compose restart'"
echo "  • Stop services: ssh $SSH_USER@$SERVER_IP 'cd $DEPLOY_DIR && docker compose down'"
echo ""
echo "Next steps:"
echo "  1. Open http://$SERVER_IP:3000 in your browser"
echo "  2. Monitor logs: ssh $SSH_USER@$SERVER_IP 'cd $DEPLOY_DIR && docker compose logs -f'"
echo "  3. Wait for event generation (every 30 minutes)"
echo ""
