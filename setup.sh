#!/bin/bash
# Quick setup script for AI Agent Service

set -e

BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}AI Agent Service Setup${NC}"
echo -e "${BLUE}================================${NC}\n"

# Check Docker
echo -e "${BLUE}[1/5]${NC} Checking Docker installation..."
if ! command -v docker &> /dev/null; then
    echo -e "${YELLOW}⚠ Docker not found. Please install Docker first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker found${NC}\n"

# Check Docker Compose
echo -e "${BLUE}[2/5]${NC} Checking Docker Compose..."
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo -e "${YELLOW}⚠ Docker Compose not found. Please install Docker Compose first.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker Compose found${NC}\n"

# Build and start services
echo -e "${BLUE}[3/5]${NC} Building and starting services..."
docker-compose up -d --build
echo -e "${GREEN}✓ Services started${NC}\n"

# Wait for Ollama to be ready
echo -e "${BLUE}[4/5]${NC} Waiting for Ollama service to be ready..."
sleep 10
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if docker exec ollama curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then
        echo -e "${GREEN}✓ Ollama is ready${NC}\n"
        break
    fi
    attempt=$((attempt + 1))
    echo -n "."
    sleep 2
done

if [ $attempt -eq $max_attempts ]; then
    echo -e "\n${YELLOW}⚠ Ollama health check timed out${NC}"
    echo -e "You may need to wait longer or check logs: docker-compose logs ollama\n"
fi

# Pull Mistral model
echo -e "${BLUE}[5/5]${NC} Pulling Mistral model (this may take a few minutes)..."
if docker exec ollama ollama list | grep -q mistral; then
    echo -e "${GREEN}✓ Mistral model already exists${NC}\n"
else
    docker exec ollama ollama pull mistral
    echo -e "${GREEN}✓ Mistral model downloaded${NC}\n"
fi

# Display status
echo -e "${BLUE}================================${NC}"
echo -e "${GREEN}Setup completed successfully!${NC}"
echo -e "${BLUE}================================${NC}\n"

echo "Service URLs:"
echo "  • API Service:  http://localhost:8000"
echo "  • Health Check: http://localhost:8000/health"
echo "  • API Docs:     http://localhost:8000/docs"
echo ""

echo "Quick test:"
echo "  curl http://localhost:8000/health"
echo ""

echo "Example query:"
echo "  curl -X POST http://localhost:8000/query \\"
echo "    -H 'Content-Type: application/json' \\"
echo "    -d '{\"query\": \"What is SSH?\"}'"
echo ""

echo "Run tests:"
echo "  ./test_agent.sh"
echo ""

echo "View logs:"
echo "  docker-compose logs -f"
echo ""
