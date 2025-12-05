#!/bin/bash
# Post-deployment health check
# Can be run locally or on server

SERVER="${1:-localhost}"

echo "╔══════════════════════════════════════════════════════════╗"
echo "║  Health Check: $SERVER"
echo "╚══════════════════════════════════════════════════════════╝"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to check service
check_service() {
    local name=$1
    local url=$2
    
    if curl -f -s "$url" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ $name is healthy${NC}"
        return 0
    else
        echo -e "${RED}✗ $name is not responding${NC}"
        return 1
    fi
}

echo "Checking services on $SERVER..."
echo ""

# Check Agent
echo -e "${YELLOW}[1/5] Agent API...${NC}"
if check_service "Agent" "http://$SERVER:8000/health"; then
    AGENT_INFO=$(curl -s http://$SERVER:8000/health)
    MODE=$(echo "$AGENT_INFO" | jq -r '.mode' 2>/dev/null || echo "unknown")
    MODEL=$(echo "$AGENT_INFO" | jq -r '.model' 2>/dev/null || echo "unknown")
    echo "  Mode: $MODE"
    echo "  Model: $MODEL"
fi
echo ""

# Check Dashboard (optional)
echo -e "${YELLOW}[2/5] Dashboard...${NC}"
if check_service "Dashboard" "http://$SERVER:3000/health"; then
    echo "  URL: http://$SERVER:3000"
else
    echo "  (Optional service)"
fi
echo ""

# Check Ollama (if LLM mode)
echo -e "${YELLOW}[3/5] Ollama API...${NC}"
if curl -f -s "http://$SERVER:11434/api/tags" > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Ollama is accessible${NC}"
    MODELS=$(curl -s "http://$SERVER:11434/api/tags" | jq -r '.models[].name' 2>/dev/null | head -3)
    if [ ! -z "$MODELS" ]; then
        echo "  Models loaded:"
        echo "$MODELS" | while read model; do
            echo "    - $model"
        done
    fi
else
    echo -e "${YELLOW}⚠ Ollama not accessible (may be internal only)${NC}"
fi
echo ""

# Test event analysis
echo -e "${YELLOW}[4/5] Testing event analysis...${NC}"
TEST_RESULT=$(curl -s -X POST http://$SERVER:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "test",
      "status": "SUCCESS",
      "timestamp": "2025-12-02T10:00:00",
      "is_admin": false
    }
  }' 2>&1)

if echo "$TEST_RESULT" | jq . > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Event analysis working${NC}"
    SEVERITY=$(echo "$TEST_RESULT" | jq -r '.severity' 2>/dev/null)
    SCORE=$(echo "$TEST_RESULT" | jq -r '.risk_score' 2>/dev/null)
    echo "  Test result: severity=$SEVERITY, score=$SCORE"
else
    echo -e "${RED}✗ Event analysis failed${NC}"
    echo "  Error: $TEST_RESULT"
fi
echo ""

# Check Docker containers (if running on server)
echo -e "${YELLOW}[5/5] Docker containers...${NC}"
if command -v docker &> /dev/null; then
    CONTAINERS=$(docker ps --format "table {{.Names}}\t{{.Status}}" | grep -E "cyber|ollama")
    if [ ! -z "$CONTAINERS" ]; then
        echo "$CONTAINERS"
    else
        echo -e "${YELLOW}⚠ No containers found (may not be on server)${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Docker not available (running remotely)${NC}"
fi
echo ""

echo "════════════════════════════════════════════════════════════"
echo "Health check complete!"
echo ""
echo "Quick links:"
echo "  • API Docs:  http://$SERVER:8000/docs"
echo "  • Dashboard: http://$SERVER:3000"
echo "  • Health:    http://$SERVER:8000/health"
echo ""
