#!/bin/bash
# Test deployment package locally before deploying to Hetzner

echo "╔══════════════════════════════════════════════════════════╗"
echo "║  Testing Deployment Package                              ║"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}[1/5] Checking required files...${NC}"
REQUIRED_FILES=(
    "deploy/hetzner-setup.sh"
    "deploy/deploy-to-hetzner.sh"
    "deploy/health-check.sh"
    "docker-compose.yml"
    "agent/main.py"
    "backend/scheduler.py"
)

ALL_PRESENT=true
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo -e "${GREEN}✓ $file${NC}"
    else
        echo -e "${RED}✗ $file (missing)${NC}"
        ALL_PRESENT=false
    fi
done

if [ "$ALL_PRESENT" = false ]; then
    echo -e "${RED}Some files are missing!${NC}"
    exit 1
fi
echo ""

echo -e "${YELLOW}[2/5] Checking scripts are executable...${NC}"
for script in deploy/*.sh; do
    if [ -x "$script" ]; then
        echo -e "${GREEN}✓ $script${NC}"
    else
        echo -e "${YELLOW}⚠ Making $script executable...${NC}"
        chmod +x "$script"
    fi
done
echo ""

echo -e "${YELLOW}[3/5] Validating docker-compose.yml...${NC}"
if docker compose config > /dev/null 2>&1; then
    echo -e "${GREEN}✓ docker-compose.yml is valid${NC}"
else
    echo -e "${RED}✗ docker-compose.yml has errors${NC}"
    docker compose config
    exit 1
fi
echo ""

echo -e "${YELLOW}[4/5] Checking Python syntax...${NC}"
PYTHON_FILES=(agent/main.py backend/scheduler.py backend/data_generator.py)
for file in "${PYTHON_FILES[@]}"; do
    if python3 -m py_compile "$file" 2>/dev/null; then
        echo -e "${GREEN}✓ $file${NC}"
    else
        echo -e "${RED}✗ $file has syntax errors${NC}"
        python3 -m py_compile "$file"
    fi
done
echo ""

echo -e "${YELLOW}[5/5] Estimating deployment package size...${NC}"
SIZE=$(du -sh . --exclude='.git' --exclude='node_modules' 2>/dev/null | cut -f1)
echo "Package size: $SIZE"
echo ""

echo "════════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ Deployment package is ready!${NC}"
echo "════════════════════════════════════════════════════════════"
echo ""
echo "Next steps:"
echo "1. Create a Hetzner server"
echo "2. Run: ./deploy/deploy-to-hetzner.sh YOUR_SERVER_IP"
echo ""
echo "See deploy/DEPLOYMENT_QUICKSTART.md for instructions"
echo ""
