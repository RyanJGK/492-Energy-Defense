#!/bin/bash
# Create deployment package for Hetzner

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Deployment Package for Hetzner              ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

# Package name
PACKAGE_NAME="cyber-agent-deployment.tar.gz"
TEMP_DIR="cyber-agent"

echo "1. Creating temporary directory..."
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

echo "2. Copying necessary files..."

# Copy core application files
cp -r agent $TEMP_DIR/
cp -r backend $TEMP_DIR/
cp -r dashboard $TEMP_DIR/

# Copy Docker configuration
cp docker-compose.yml $TEMP_DIR/
cp docker-compose-simple.yml $TEMP_DIR/
cp .env.example $TEMP_DIR/.env

# Copy scripts
cp start.sh $TEMP_DIR/
cp test-llm-mode.sh $TEMP_DIR/
cp check-qwen-model.sh $TEMP_DIR/
cp apply-fix.sh $TEMP_DIR/
cp manage.sh $TEMP_DIR/ 2>/dev/null || true
cp test.sh $TEMP_DIR/ 2>/dev/null || true

# Copy documentation
cp README.md $TEMP_DIR/
cp FIX_QWEN_SCORING_ISSUE.md $TEMP_DIR/
cp MIGRATION_COMPLETE.md $TEMP_DIR/ 2>/dev/null || true

# Copy gitignore as reference
cp .gitignore $TEMP_DIR/

echo "3. Cleaning up Python cache files..."
find $TEMP_DIR -type d -name "__pycache__" -exec rm -rf {} + 2>/dev/null || true
find $TEMP_DIR -type f -name "*.pyc" -delete 2>/dev/null || true
find $TEMP_DIR -type f -name "*.pyo" -delete 2>/dev/null || true
find $TEMP_DIR -type f -name ".DS_Store" -delete 2>/dev/null || true

echo "4. Creating tar.gz archive..."
tar -czf $PACKAGE_NAME $TEMP_DIR/

echo "5. Cleaning up temporary directory..."
rm -rf $TEMP_DIR

echo ""
echo "✅ Package created: $PACKAGE_NAME"
echo ""

# Show package size
SIZE=$(du -h $PACKAGE_NAME | cut -f1)
echo "📦 Package size: $SIZE"
echo ""

# Show contents
echo "📋 Package contents:"
tar -tzf $PACKAGE_NAME | head -20
echo "   ... (and more)"
echo ""

echo "═══════════════════════════════════════════════════════"
echo "NEXT STEPS:"
echo "═══════════════════════════════════════════════════════"
echo ""
echo "1. Upload to Hetzner:"
echo "   scp $PACKAGE_NAME root@YOUR_SERVER_IP:/root/"
echo ""
echo "2. SSH to server:"
echo "   ssh root@YOUR_SERVER_IP"
echo ""
echo "3. Extract and run:"
echo "   tar -xzf $PACKAGE_NAME"
echo "   cd cyber-agent"
echo "   bash deploy-hetzner.sh"
echo ""

