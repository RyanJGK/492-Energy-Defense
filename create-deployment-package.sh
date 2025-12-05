#!/bin/bash
# Create deployment package for Hetzner

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Deployment Package for Hetzner              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Package name with timestamp
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
PACKAGE_NAME="cyber-defense-${TIMESTAMP}.tar.gz"

echo "Creating archive..."

# Create tar.gz excluding unnecessary files
tar -czf "$PACKAGE_NAME" \
  --exclude='.git' \
  --exclude='*.pyc' \
  --exclude='__pycache__' \
  --exclude='*.log' \
  --exclude='.env' \
  --exclude='venv' \
  --exclude='node_modules' \
  --exclude='*.tar.gz' \
  --exclude='ollama_data' \
  --exclude='postgres_data' \
  .

if [ $? -eq 0 ]; then
    SIZE=$(du -h "$PACKAGE_NAME" | cut -f1)
    echo "✅ Package created successfully!"
    echo ""
    echo "Package: $PACKAGE_NAME"
    echo "Size: $SIZE"
    echo ""
    echo "Next steps:"
    echo "1. Upload to Hetzner: scp $PACKAGE_NAME root@YOUR_IP:/root/"
    echo "2. SSH to server: ssh root@YOUR_IP"
    echo "3. Extract: tar -xzf $PACKAGE_NAME"
    echo "4. Run setup: cd cyber-defense && ./hetzner-setup.sh"
    echo ""
else
    echo "❌ Failed to create package"
    exit 1
fi
