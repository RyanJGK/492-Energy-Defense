#!/bin/bash
# Troubleshooting script for 492-Energy-Defense

echo "╔════════════════════════════════════════════════════╗"
echo "║  TROUBLESHOOTING GUIDE                            ║"
echo "╚════════════════════════════════════════════════════╝"
echo ""

echo "Step 1: Check container status"
echo "================================"
docker-compose ps
echo ""

echo "Step 2: Check Ollama logs"
echo "=========================="
echo "Recent Ollama logs:"
docker logs ollama-qwen --tail 30
echo ""

echo "Step 3: Check Ollama health"
echo "============================"
docker inspect ollama-qwen --format='{{json .State.Health}}' 2>/dev/null | python3 -m json.tool 2>/dev/null || echo "Health check info not available"
echo ""

echo "Step 4: Test Ollama API directly"
echo "================================="
echo "Trying to connect to Ollama API..."
curl -s http://localhost:11434/api/tags 2>&1 | head -20
echo ""

echo "Step 5: Check AI Agent logs"
echo "============================"
echo "Recent Agent logs:"
docker logs cyber-agent --tail 20 2>/dev/null || echo "Agent not running yet"
echo ""

echo "Step 6: Check resource usage"
echo "============================="
docker stats --no-stream 2>/dev/null | grep -E "CONTAINER|ollama|agent" || echo "Docker stats not available"
echo ""

echo "═══════════════════════════════════════════════════"
echo "COMMON FIXES"
echo "═══════════════════════════════════════════════════"
echo ""
echo "Fix 1: Restart Ollama"
echo "  $ docker-compose restart ollama"
echo ""
echo "Fix 2: Increase wait time and restart"
echo "  $ docker-compose down"
echo "  $ docker-compose up -d"
echo "  $ sleep 60  # Wait longer"
echo ""
echo "Fix 3: Check if Ollama is actually running"
echo "  $ docker logs ollama-qwen"
echo ""
echo "Fix 4: Manually pull Qwen model"
echo "  $ docker exec ollama-qwen ollama pull qwen2.5:0.5b"
echo ""
echo "Fix 5: Use updated docker-compose.yml"
echo "  The updated version has more lenient health checks"
echo ""
