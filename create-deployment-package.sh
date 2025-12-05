#!/bin/bash
# Create deployment package for Hetzner

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Deployment Package                          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

PACKAGE_NAME="cyber-defense-$(date +%Y%m%d-%H%M%S).tar.gz"

echo "Creating tar.gz package..."
echo ""

# Create temporary directory
TEMP_DIR=$(mktemp -d)
PROJECT_DIR="$TEMP_DIR/492-energy-defense"

# Copy project files
mkdir -p "$PROJECT_DIR"
rsync -av \
  --exclude='.git' \
  --exclude='*.pyc' \
  --exclude='__pycache__' \
  --exclude='*.log' \
  --exclude='.env' \
  --exclude='venv' \
  --exclude='node_modules' \
  --exclude='terminals' \
  ./ "$PROJECT_DIR/"

# Create the tarball
cd "$TEMP_DIR"
tar -czf "/workspace/$PACKAGE_NAME" 492-energy-defense/

# Cleanup
cd /workspace
rm -rf "$TEMP_DIR"

# Get file size
SIZE=$(du -h "$PACKAGE_NAME" | cut -f1)

echo "✅ Package created successfully!"
echo ""
echo "Package: $PACKAGE_NAME"
echo "Size: $SIZE"
echo ""
echo "Next steps:"
echo "1. Upload this file to your Hetzner server:"
echo "   scp $PACKAGE_NAME root@YOUR_SERVER_IP:/root/"
echo ""
echo "2. SSH into your server:"
echo "   ssh root@YOUR_SERVER_IP"
echo ""
echo "3. Extract and run setup:"
echo "   cd /root"
echo "   tar -xzf $PACKAGE_NAME"
echo "   cd 492-energy-defense"
echo "   bash setup-hetzner.sh"
echo ""

