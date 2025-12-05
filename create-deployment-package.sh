#!/bin/bash
# Create deployment package for Hetzner

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Deployment Package for Hetzner              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

PACKAGE_NAME="cyber-defense-agent.tar.gz"

echo "Preparing files..."

# Create temporary directory
TEMP_DIR=$(mktemp -d)
PROJECT_DIR="$TEMP_DIR/cyber-defense-agent"
mkdir -p "$PROJECT_DIR"

# Copy necessary files
echo "Copying application files..."
cp -r agent "$PROJECT_DIR/"
cp -r backend "$PROJECT_DIR/"
cp -r dashboard "$PROJECT_DIR/"
cp docker-compose.yml "$PROJECT_DIR/"
cp .env.example "$PROJECT_DIR/.env"
cp .gitignore "$PROJECT_DIR/" 2>/dev/null || true

# Copy scripts
echo "Copying scripts..."
cp start.sh "$PROJECT_DIR/" 2>/dev/null || true
cp test-llm-mode.sh "$PROJECT_DIR/" 2>/dev/null || true
cp check-qwen-model.sh "$PROJECT_DIR/" 2>/dev/null || true
cp apply-fix.sh "$PROJECT_DIR/" 2>/dev/null || true

# Copy documentation
echo "Copying documentation..."
cp README.md "$PROJECT_DIR/" 2>/dev/null || true
cp PROJECT_SUMMARY.md "$PROJECT_DIR/" 2>/dev/null || true
cp MIGRATION_COMPLETE.md "$PROJECT_DIR/" 2>/dev/null || true
cp FIX_QWEN_SCORING_ISSUE.md "$PROJECT_DIR/" 2>/dev/null || true

# Make scripts executable
chmod +x "$PROJECT_DIR"/*.sh 2>/dev/null || true

# Create deployment instructions
cat > "$PROJECT_DIR/DEPLOY_HETZNER.txt" << 'DEPLOY'
═══════════════════════════════════════════════════════════
  HETZNER DEPLOYMENT INSTRUCTIONS
═══════════════════════════════════════════════════════════

STEP 1: Create Hetzner Server
──────────────────────────────
1. Go to: https://console.hetzner.cloud/
2. Create new server:
   - Image: Ubuntu 22.04 LTS
   - Type: CPX21 or higher (8GB+ RAM recommended)
   - Location: Closest to you
   - Name: cyber-defense
3. Set root password (you'll need this)
4. Note the server IP address

STEP 2: Upload Files to Server
───────────────────────────────
On your LOCAL machine (where this file is):

# Upload the package
scp cyber-defense-agent.tar.gz root@YOUR_SERVER_IP:/root/

# Enter password when prompted

STEP 3: Connect to Server
──────────────────────────
ssh root@YOUR_SERVER_IP
# Enter password

STEP 4: Install on Server
──────────────────────────
Run these commands on the SERVER:

# Extract the package
cd /root
tar -xzf cyber-defense-agent.tar.gz
cd cyber-defense-agent

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Install Docker Compose
curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Start the application
docker-compose up -d

# Watch model download (1-2 minutes)
docker logs -f ollama-init
# Press Ctrl+C when you see "Qwen model ready!"

STEP 5: Configure Firewall
───────────────────────────
# Install firewall
apt-get update
apt-get install -y ufw

# Allow necessary ports
ufw allow 22/tcp    # SSH
ufw allow 3000/tcp  # Dashboard
ufw allow 8000/tcp  # API
ufw --force enable

STEP 6: Verify Installation
────────────────────────────
# Check containers are running
docker ps

# Check agent health
curl http://localhost:8000/health

# Test event analysis
curl -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{"type":"login","data":{"username":"test","status":"SUCCESS","timestamp":"2025-12-02T10:00:00","is_admin":false,"is_burst_failure":false,"is_suspicious_ip":false}}' | jq

STEP 7: Access from Your Computer
──────────────────────────────────
Open in your browser:
- Dashboard: http://YOUR_SERVER_IP:3000
- API: http://YOUR_SERVER_IP:8000
- API Docs: http://YOUR_SERVER_IP:8000/docs

═══════════════════════════════════════════════════════════
  USEFUL COMMANDS
═══════════════════════════════════════════════════════════

# View logs
docker logs -f cyber-agent
docker logs -f cyber-backend

# Restart services
docker-compose restart

# Stop services
docker-compose down

# Check status
docker-compose ps

# Update application (if needed)
docker-compose down
# Upload new tar.gz and extract
docker-compose up -d

═══════════════════════════════════════════════════════════
  TROUBLESHOOTING
═══════════════════════════════════════════════════════════

If you have issues, run:
./check-qwen-model.sh      # Verify model is loaded
./test-llm-mode.sh         # Test the system
./apply-fix.sh             # Fix scoring issues

For scoring issues, see: FIX_QWEN_SCORING_ISSUE.md

═══════════════════════════════════════════════════════════
DEPLOY

echo "✓ Deployment instructions created"

# Create package
echo ""
echo "Creating tar.gz package..."
cd "$TEMP_DIR"
tar -czf "$PACKAGE_NAME" cyber-defense-agent/

# Move to workspace
mv "$PACKAGE_NAME" /workspace/
cd /workspace

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Package created: $PACKAGE_NAME"
echo ""
echo "Package size:"
du -h "$PACKAGE_NAME"
echo ""
echo "Next steps:"
echo "1. Copy this file to your local machine"
echo "2. Upload to Hetzner: scp $PACKAGE_NAME root@YOUR_IP:/root/"
echo "3. SSH to server: ssh root@YOUR_IP"
echo "4. Extract and follow DEPLOY_HETZNER.txt instructions"
echo ""
echo "The package includes DEPLOY_HETZNER.txt with full instructions."
