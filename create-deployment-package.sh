#!/bin/bash
# Create deployment package for Hetzner

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Hetzner Deployment Package                  ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

VERSION="1.0"
PACKAGE_NAME="cyber-defense-agent-${VERSION}.tar.gz"

echo "Preparing deployment package..."

# Create temporary directory
TEMP_DIR=$(mktemp -d)
PROJECT_DIR="$TEMP_DIR/cyber-defense-agent"
mkdir -p "$PROJECT_DIR"

echo "✓ Created temporary directory"

# Copy essential files
echo "Copying project files..."

# Application code
cp -r agent "$PROJECT_DIR/"
cp -r backend "$PROJECT_DIR/"
cp -r dashboard "$PROJECT_DIR/" 2>/dev/null || echo "  (skipping dashboard - not found)"

# Configuration
cp docker-compose.yml "$PROJECT_DIR/"
cp .env.example "$PROJECT_DIR/"
cp .gitignore "$PROJECT_DIR/" 2>/dev/null || true

# Scripts
cp start.sh "$PROJECT_DIR/" 2>/dev/null || true
cp test-llm-mode.sh "$PROJECT_DIR/" 2>/dev/null || true
cp check-qwen-model.sh "$PROJECT_DIR/" 2>/dev/null || true
cp apply-fix.sh "$PROJECT_DIR/" 2>/dev/null || true

# Documentation (only essential ones)
cp README.md "$PROJECT_DIR/" 2>/dev/null || true
cp PROJECT_SUMMARY.md "$PROJECT_DIR/" 2>/dev/null || true

echo "✓ Copied project files"

# Create Hetzner deployment script
echo "Creating deployment script..."

cat > "$PROJECT_DIR/deploy-on-hetzner.sh" << 'DEPLOY_EOF'
#!/bin/bash
# Deployment script for Hetzner server (run as root)

set -e

echo "╔════════════════════════════════════════════════════════╗"
echo "║  492-Energy-Defense Deployment on Hetzner            ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then 
   echo "⚠️  Please run as root: sudo ./deploy-on-hetzner.sh"
   exit 1
fi

echo "[1/6] Updating system..."
apt-get update -qq
apt-get upgrade -y -qq

echo ""
echo "[2/6] Installing Docker..."
if ! command -v docker &> /dev/null; then
    # Install Docker
    apt-get install -y -qq ca-certificates curl gnupg lsb-release
    
    # Add Docker's official GPG key
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    chmod a+r /etc/apt/keyrings/docker.gpg
    
    # Set up repository
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    
    # Install Docker Engine
    apt-get update -qq
    apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    echo "✓ Docker installed"
else
    echo "✓ Docker already installed"
fi

echo ""
echo "[3/6] Installing Docker Compose..."
if ! command -v docker-compose &> /dev/null; then
    apt-get install -y -qq docker-compose
    echo "✓ Docker Compose installed"
else
    echo "✓ Docker Compose already installed"
fi

echo ""
echo "[4/6] Installing utilities..."
apt-get install -y -qq curl jq git net-tools htop

echo ""
echo "[5/6] Configuring firewall..."
if command -v ufw &> /dev/null; then
    # Allow SSH first (important!)
    ufw allow 22/tcp
    
    # Allow application ports
    ufw allow 8000/tcp   # Agent API
    ufw allow 3000/tcp   # Dashboard (if available)
    ufw allow 11434/tcp  # Ollama (optional, for debugging)
    
    # Enable firewall (only if not already enabled)
    ufw --force enable
    
    echo "✓ Firewall configured"
else
    echo "⚠️  UFW not available, skipping firewall configuration"
fi

echo ""
echo "[6/6] Setting up application..."

# Copy environment file
if [ ! -f .env ]; then
    cp .env.example .env
    echo "✓ Created .env file"
fi

# Make scripts executable
chmod +x *.sh 2>/dev/null || true

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Installation Complete!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo ""
echo "1. Review configuration (optional):"
echo "   nano .env"
echo ""
echo "2. Start the application:"
echo "   docker-compose up -d"
echo ""
echo "3. Watch model download (1-2 minutes):"
echo "   docker logs -f ollama-init"
echo ""
echo "4. Check status:"
echo "   docker-compose ps"
echo ""
echo "5. Test the agent:"
echo "   curl http://localhost:8000/health | jq"
echo ""
echo "6. Access from outside:"
echo "   http://YOUR_SERVER_IP:8000"
echo "   http://YOUR_SERVER_IP:3000 (dashboard)"
echo ""
echo "Useful commands:"
echo "  docker-compose logs -f           # View logs"
echo "  docker-compose restart           # Restart all"
echo "  docker-compose down              # Stop all"
echo "  docker-compose ps                # Check status"
echo ""
echo "════════════════════════════════════════════════════════"
DEPLOY_EOF

chmod +x "$PROJECT_DIR/deploy-on-hetzner.sh"
echo "✓ Created deployment script"

# Create README for deployment
cat > "$PROJECT_DIR/DEPLOY_README.md" << 'README_EOF'
# Hetzner Deployment Package

## Quick Deployment

### On Your Local Machine

1. **Upload to Hetzner server:**
```bash
# Replace with your server IP
scp cyber-defense-agent-*.tar.gz root@YOUR_SERVER_IP:/root/
```

### On Hetzner Server

2. **SSH into server:**
```bash
ssh root@YOUR_SERVER_IP
```

3. **Extract and deploy:**
```bash
# Extract package
tar -xzf cyber-defense-agent-*.tar.gz
cd cyber-defense-agent

# Run deployment script
chmod +x deploy-on-hetzner.sh
./deploy-on-hetzner.sh
```

4. **Start application:**
```bash
docker-compose up -d
```

5. **Monitor startup:**
```bash
# Watch model download (1-2 minutes)
docker logs -f ollama-init

# Check all services
docker-compose ps
```

6. **Test it works:**
```bash
curl http://localhost:8000/health | jq
```

## Access the Application

From your browser:
- **Agent API**: http://YOUR_SERVER_IP:8000
- **Dashboard**: http://YOUR_SERVER_IP:3000
- **API Docs**: http://YOUR_SERVER_IP:8000/docs

## Configuration

### Choose LLM Mode

**Option 1: Rule-Based (Recommended - 100% accurate)**
```bash
# Edit docker-compose.yml
nano docker-compose.yml

# Change:
- USE_LLM=false
```

**Option 2: LLM Mode**
```bash
# Uses Qwen model for AI analysis
- USE_LLM=true
```

### Change Model Size

Edit `docker-compose.yml`:
```yaml
environment:
  - OLLAMA_MODEL=qwen2.5:0.5b  # Smallest (400MB)
  - OLLAMA_MODEL=qwen2.5:1.5b  # Better (900MB)
  - OLLAMA_MODEL=qwen2.5:3b    # Best (2GB)
```

## Useful Commands

```bash
# View logs
docker-compose logs -f

# Check status
docker-compose ps

# Restart services
docker-compose restart

# Stop everything
docker-compose down

# Start fresh (removes data)
docker-compose down -v
docker-compose up -d

# Check resource usage
docker stats

# Test the agent
curl -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "test",
      "status": "SUCCESS",
      "timestamp": "2025-12-02T10:00:00",
      "is_admin": false
    }
  }' | jq
```

## Troubleshooting

### Services not starting?
```bash
docker-compose logs
docker-compose restart
```

### Model not downloading?
```bash
docker exec ollama-qwen ollama pull qwen2.5:0.5b
```

### Firewall blocking access?
```bash
ufw status
ufw allow 8000/tcp
ufw allow 3000/tcp
```

### Check what's using ports?
```bash
netstat -tlnp | grep -E "8000|3000|11434"
```

## System Requirements

- **Minimum**: 2 vCPU, 4GB RAM, 20GB storage
- **Recommended**: 4 vCPU, 8GB RAM, 40GB storage
- **OS**: Ubuntu 22.04 or 24.04

## Security Notes

- Change default passwords in `.env`
- Only expose necessary ports (8000, 3000)
- Keep system updated: `apt update && apt upgrade`
- Review firewall rules: `ufw status`

## Support

For issues, check:
1. Docker logs: `docker-compose logs`
2. Service status: `docker-compose ps`
3. README.md in the package
README_EOF

echo "✓ Created deployment README"

# Create package
echo ""
echo "Creating tar.gz package..."
cd "$TEMP_DIR"
tar -czf "/tmp/$PACKAGE_NAME" cyber-defense-agent/
mv "/tmp/$PACKAGE_NAME" "$(pwd)/../$PACKAGE_NAME"

echo "✓ Package created"

# Cleanup
rm -rf "$TEMP_DIR"

echo ""
echo "════════════════════════════════════════════════════════"
echo "✅ Deployment package ready!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "Package: $PACKAGE_NAME"
echo "Size: $(du -h "$PACKAGE_NAME" | cut -f1)"
echo ""
echo "To deploy to Hetzner:"
echo ""
echo "1. Upload to server:"
echo "   scp $PACKAGE_NAME root@YOUR_SERVER_IP:/root/"
echo ""
echo "2. SSH into server:"
echo "   ssh root@YOUR_SERVER_IP"
echo ""
echo "3. Extract and deploy:"
echo "   tar -xzf $PACKAGE_NAME"
echo "   cd cyber-defense-agent"
echo "   ./deploy-on-hetzner.sh"
echo ""
echo "4. Start application:"
echo "   docker-compose up -d"
echo ""
echo "See DEPLOY_README.md in the package for full instructions."
echo "════════════════════════════════════════════════════════"
