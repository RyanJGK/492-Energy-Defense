#!/bin/bash
# Create deployment package for Hetzner

echo "╔════════════════════════════════════════════════════════╗"
echo "║  Creating Deployment Package                          ║"
echo "╚════════════════════════════════════════════════════════╝"
echo ""

PACKAGE_NAME="cyber-defense-agent-$(date +%Y%m%d-%H%M%S).tar.gz"
TEMP_DIR="cyber-defense-deploy"

echo "Creating temporary directory..."
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

echo "Copying project files..."
# Copy essential files
cp -r agent $TEMP_DIR/
cp -r backend $TEMP_DIR/
cp -r dashboard $TEMP_DIR/
cp docker-compose.yml $TEMP_DIR/
cp docker-compose-simple.yml $TEMP_DIR/
cp .env.example $TEMP_DIR/
cp .gitignore $TEMP_DIR/

# Copy scripts
cp start.sh $TEMP_DIR/
cp test-llm-mode.sh $TEMP_DIR/
cp check-qwen-model.sh $TEMP_DIR/
cp apply-fix.sh $TEMP_DIR/ 2>/dev/null || true
cp troubleshoot.sh $TEMP_DIR/

# Copy documentation
cp README.md $TEMP_DIR/
cp PROJECT_SUMMARY.md $TEMP_DIR/
cp FIX_QWEN_SCORING_ISSUE.md $TEMP_DIR/ 2>/dev/null || true
cp MIGRATION_COMPLETE.md $TEMP_DIR/ 2>/dev/null || true

echo "Creating tar.gz archive..."
tar -czf $PACKAGE_NAME $TEMP_DIR/

echo "Cleaning up..."
rm -rf $TEMP_DIR

echo ""
echo "✅ Deployment package created: $PACKAGE_NAME"
echo ""
echo "Package size:"
ls -lh $PACKAGE_NAME

echo ""
echo "════════════════════════════════════════════════════════"
echo "Next Steps:"
echo "════════════════════════════════════════════════════════"
echo ""
echo "1. Transfer to Hetzner server:"
echo "   scp $PACKAGE_NAME root@YOUR_SERVER_IP:/root/"
echo ""
echo "2. Or use SCP with password:"
echo "   scp $PACKAGE_NAME root@YOUR_SERVER_IP:/root/"
echo "   (You'll be prompted for password)"
echo ""
echo "3. Or upload via Hetzner web console / SFTP client"
echo ""
echo "4. On the server, run:"
echo "   tar -xzf $PACKAGE_NAME"
echo "   cd cyber-defense-deploy"
echo "   bash setup-server.sh"
echo ""

