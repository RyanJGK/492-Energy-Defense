#!/bin/bash
# Test script for AI Agent Service

set -e

BASE_URL="http://localhost:8000"
BLUE='\033[0;34m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}AI Agent Service Test Script${NC}"
echo -e "${BLUE}================================${NC}\n"

# Test 1: Root endpoint
echo -e "${BLUE}[TEST 1]${NC} Testing root endpoint..."
response=$(curl -s ${BASE_URL}/)
if echo "$response" | grep -q "AI Agent"; then
    echo -e "${GREEN}✓ PASSED${NC} - Root endpoint responding\n"
else
    echo -e "${RED}✗ FAILED${NC} - Root endpoint not responding\n"
    exit 1
fi

# Test 2: Health check
echo -e "${BLUE}[TEST 2]${NC} Testing health check..."
response=$(curl -s ${BASE_URL}/health)
if echo "$response" | grep -q '"status":"healthy"'; then
    echo -e "${GREEN}✓ PASSED${NC} - Service is healthy\n"
else
    echo -e "${RED}✗ FAILED${NC} - Service is unhealthy"
    echo "$response\n"
    exit 1
fi

# Test 3: Simple query
echo -e "${BLUE}[TEST 3]${NC} Testing simple query..."
response=$(curl -s -X POST ${BASE_URL}/query \
    -H "Content-Type: application/json" \
    -d '{"query": "What is cybersecurity?"}')

if echo "$response" | grep -q '"response"'; then
    echo -e "${GREEN}✓ PASSED${NC} - Query endpoint working"
    echo "Response preview: $(echo $response | jq -r '.response' | head -c 100)...\n"
else
    echo -e "${RED}✗ FAILED${NC} - Query endpoint not working"
    echo "$response\n"
    exit 1
fi

# Test 4: IT/Security query
echo -e "${BLUE}[TEST 4]${NC} Testing cybersecurity query..."
response=$(curl -s -X POST ${BASE_URL}/query \
    -H "Content-Type: application/json" \
    -d '{
        "query": "List three best practices for SSH security"
    }')

if echo "$response" | grep -q '"response"'; then
    echo -e "${GREEN}✓ PASSED${NC} - Cybersecurity query working"
    echo "Response:"
    echo "$response" | jq -r '.response'
    echo ""
else
    echo -e "${RED}✗ FAILED${NC} - Query failed"
    echo "$response\n"
    exit 1
fi

# Test 5: Empty query validation
echo -e "${BLUE}[TEST 5]${NC} Testing empty query validation..."
response=$(curl -s -w "\n%{http_code}" -X POST ${BASE_URL}/query \
    -H "Content-Type: application/json" \
    -d '{"query": ""}')

status_code=$(echo "$response" | tail -n1)
if [ "$status_code" -eq 422 ] || [ "$status_code" -eq 400 ]; then
    echo -e "${GREEN}✓ PASSED${NC} - Empty query validation working\n"
else
    echo -e "${RED}✗ FAILED${NC} - Expected 400/422, got $status_code\n"
fi

echo -e "${BLUE}================================${NC}"
echo -e "${GREEN}All tests completed successfully!${NC}"
echo -e "${BLUE}================================${NC}"
