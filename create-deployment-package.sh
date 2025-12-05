#!/bin/bash
# Create deployment package for Hetzner

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Deployment Package                          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

PACKAGE_NAME="cyber-defense-$(date +%Y%m%d-%H%M%S).tar.gz"

echo "Creating tar.gz package..."
echo ""

# Create temporary directory for clean packaging
TEMP_DIR=$(mktemp -d)
PROJECT_DIR="$TEMP_DIR/492-energy-defense"

mkdir -p "$PROJECT_DIR"

# Copy essential files
echo "Copying files..."
cp -r agent "$PROJECT_DIR/"
cp -r backend "$PROJECT_DIR/"
cp -r dashboard "$PROJECT_DIR/"
cp docker-compose.yml "$PROJECT_DIR/"
cp .env.example "$PROJECT_DIR/"
cp .gitignore "$PROJECT_DIR/" 2>/dev/null || true
cp README.md "$PROJECT_DIR/" 2>/dev/null || true

# Copy deployment scripts
cp start.sh "$PROJECT_DIR/" 2>/dev/null || true
cp check-qwen-model.sh "$PROJECT_DIR/" 2>/dev/null || true
cp apply-fix.sh "$PROJECT_DIR/" 2>/dev/null || true

# Create the package
cd "$TEMP_DIR"
tar -czf "$PACKAGE_NAME" 492-energy-defense/

# Move to workspace
mv "$PACKAGE_NAME" /workspace/

# Cleanup
cd /workspace
rm -rf "$TEMP_DIR"

echo ""
echo "✅ Package created: $PACKAGE_NAME"
echo ""
echo "Package size:"
du -h "/workspace/$PACKAGE_NAME"
echo ""
echo "Contents:"
tar -tzf "/workspace/$PACKAGE_NAME" | head -20
echo "..."
echo ""
echo "Next steps:"
echo "1. Copy this file to your Hetzner server:"
echo "   scp $PACKAGE_NAME root@YOUR_SERVER_IP:~/"
echo ""
echo "2. SSH into your server and extract:"
echo "   ssh root@YOUR_SERVER_IP"
echo "   tar -xzf $PACKAGE_NAME"
echo "   cd 492-energy-defense"
echo ""
echo "3. Run the setup script on the server"
echo ""
echo "See HETZNER_DEPLOY_SIMPLE.md for full instructions"

