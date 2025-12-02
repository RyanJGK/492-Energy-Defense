#!/bin/bash
# Test script for LLM mode implementation

echo "================================================"
echo "  LLM MODE TESTING SCRIPT"
echo "================================================"
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test 1: Check if agent is running
echo -e "${YELLOW}[1/5] Checking if agent service is running...${NC}"
if curl -f -s http://localhost:8000/health > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Agent service is running${NC}"
else
    echo -e "${RED}✗ Agent service is not responding${NC}"
    echo "Run: docker-compose up -d"
    exit 1
fi
echo ""

# Test 2: Check agent mode
echo -e "${YELLOW}[2/5] Checking agent mode...${NC}"
MODE_RESPONSE=$(curl -s http://localhost:8000/health)
echo "$MODE_RESPONSE" | jq '.'
MODE=$(echo "$MODE_RESPONSE" | jq -r '.mode')
if [ "$MODE" = "LLM" ]; then
    echo -e "${GREEN}✓ Agent is in LLM mode${NC}"
else
    echo -e "${YELLOW}⚠ Agent is in $MODE mode (expected LLM)${NC}"
fi
echo ""

# Test 3: Check if Ollama is accessible
echo -e "${YELLOW}[3/5] Checking if Ollama is accessible...${NC}"
if curl -f -s http://localhost:11434/api/tags > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Ollama is accessible${NC}"
    MODELS=$(curl -s http://localhost:11434/api/tags | jq -r '.models[].name')
    if echo "$MODELS" | grep -q "qwen2.5:0.5b"; then
        echo -e "${GREEN}✓ Qwen model is loaded${NC}"
    else
        echo -e "${RED}✗ Qwen model not found${NC}"
        echo "Available models: $MODELS"
        echo "Run: docker exec ollama-qwen ollama pull qwen2.5:0.5b"
    fi
else
    echo -e "${RED}✗ Ollama is not responding${NC}"
    exit 1
fi
echo ""

# Test 4: Send a test login event (high risk)
echo -e "${YELLOW}[4/5] Testing LLM with critical login event...${NC}"
LOGIN_RESPONSE=$(curl -s -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "admin",
      "src_ip": "203.0.113.50",
      "status": "FAIL",
      "timestamp": "2025-11-19T02:30:00",
      "device_id": "WIN-LAPTOP-01",
      "auth_method": "password",
      "is_burst_failure": true,
      "is_suspicious_ip": true,
      "is_admin": true
    }
  }')

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Event analysis successful${NC}"
    echo "Response:"
    echo "$LOGIN_RESPONSE" | jq '.'
    
    SEVERITY=$(echo "$LOGIN_RESPONSE" | jq -r '.severity')
    SCORE=$(echo "$LOGIN_RESPONSE" | jq -r '.risk_score')
    echo ""
    echo -e "Severity: ${YELLOW}$SEVERITY${NC}"
    echo -e "Risk Score: ${YELLOW}$SCORE${NC}"
else
    echo -e "${RED}✗ Event analysis failed${NC}"
fi
echo ""

# Test 5: Send a test firewall event (port scan)
echo -e "${YELLOW}[5/5] Testing LLM with port scan event...${NC}"
FIREWALL_RESPONSE=$(curl -s -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "firewall",
    "data": {
      "src_ip": "203.0.113.99",
      "dst_ip": "192.168.1.100",
      "action": "DENY",
      "port": 22,
      "protocol": "TCP",
      "timestamp": "2025-11-19T03:00:00",
      "is_port_scan": true,
      "is_lateral_movement": false,
      "is_malicious_range": true,
      "is_connection_spike": true
    }
  }')

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✓ Event analysis successful${NC}"
    echo "Response:"
    echo "$FIREWALL_RESPONSE" | jq '.'
    
    SEVERITY=$(echo "$FIREWALL_RESPONSE" | jq -r '.severity')
    SCORE=$(echo "$FIREWALL_RESPONSE" | jq -r '.risk_score')
    echo ""
    echo -e "Severity: ${YELLOW}$SEVERITY${NC}"
    echo -e "Risk Score: ${YELLOW}$SCORE${NC}"
else
    echo -e "${RED}✗ Event analysis failed${NC}"
fi
echo ""

echo "================================================"
echo -e "${GREEN}Testing complete!${NC}"
echo "================================================"
echo ""
echo "Next steps:"
echo "1. Monitor backend logs: docker logs -f cyber-backend"
echo "2. Monitor agent logs: docker logs -f cyber-agent"
echo "3. Wait for next event generation cycle (every 30 minutes)"
echo ""
