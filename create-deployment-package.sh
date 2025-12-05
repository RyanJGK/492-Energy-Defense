#!/bin/bash
# Create a clean deployment package for Hetzner

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Deployment Package                          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Package name
PACKAGE_NAME="cyber-defense-$(date +%Y%m%d-%H%M%S).tar.gz"

echo "📦 Creating package: $PACKAGE_NAME"
echo ""

# Create temporary directory for clean package
TEMP_DIR=$(mktemp -d)
DEPLOY_DIR="$TEMP_DIR/492-energy-defense"

echo "📋 Copying files..."

# Create deployment directory structure
mkdir -p "$DEPLOY_DIR"

# Copy necessary files
cp -r agent "$DEPLOY_DIR/"
cp -r backend "$DEPLOY_DIR/"
cp -r dashboard "$DEPLOY_DIR/"
cp docker-compose.yml "$DEPLOY_DIR/"
cp .env.example "$DEPLOY_DIR/.env"
cp .gitignore "$DEPLOY_DIR/" 2>/dev/null || true

# Copy utility scripts
cp start.sh "$DEPLOY_DIR/" 2>/dev/null || true
cp test-llm-mode.sh "$DEPLOY_DIR/" 2>/dev/null || true
cp check-qwen-model.sh "$DEPLOY_DIR/" 2>/dev/null || true
cp apply-fix.sh "$DEPLOY_DIR/" 2>/dev/null || true

# Copy essential documentation
cp README.md "$DEPLOY_DIR/" 2>/dev/null || true
cp FIX_QWEN_SCORING_ISSUE.md "$DEPLOY_DIR/" 2>/dev/null || true

# Make scripts executable
chmod +x "$DEPLOY_DIR"/*.sh 2>/dev/null || true

echo "✓ Files copied"
echo ""

# Create the tar.gz archive
echo "📦 Creating tar.gz archive..."
cd "$TEMP_DIR"
tar -czf "$PACKAGE_NAME" 492-energy-defense/

# Move to workspace
mv "$PACKAGE_NAME" /workspace/

# Cleanup
cd /workspace
rm -rf "$TEMP_DIR"

echo "✓ Archive created"
echo ""

# Get file size
SIZE=$(du -h "/workspace/$PACKAGE_NAME" | cut -f1)

echo "════════════════════════════════════════════════════════"
echo "✅ Package created successfully!"
echo "════════════════════════════════════════════════════════"
echo ""
echo "📦 Package: $PACKAGE_NAME"
echo "📊 Size: $SIZE"
echo "📍 Location: /workspace/$PACKAGE_NAME"
echo ""
echo "Next steps:"
echo "1. Upload to Hetzner: scp $PACKAGE_NAME root@YOUR_IP:~/"
echo "2. SSH to server: ssh root@YOUR_IP"
echo "3. Extract: tar -xzf $PACKAGE_NAME"
echo "4. Deploy: cd 492-energy-defense && ./start.sh"
echo ""

