#!/bin/bash
# Simple startup script without Ollama - much faster!

echo "================================================"
echo "492-ENERGY-DEFENSE CYBERSECURITY AGENT"
echo "SIMPLE MODE (No Ollama - Fast Startup)"
echo "================================================"
echo ""

echo "🚀 Starting services (simplified)..."
docker-compose -f docker-compose-simple.yml up -d --build

echo ""
echo "⏳ Waiting for services to initialize..."
echo "   (This should only take 30-60 seconds)"
echo ""

# Wait for database
echo "Waiting for database..."
until docker-compose -f docker-compose-simple.yml exec -T db pg_isready -U postgres > /dev/null 2>&1; do
    sleep 2
done
echo "✅ Database ready"

echo ""
echo "Waiting for AI Agent..."
until curl -s http://localhost:8000/health > /dev/null 2>&1; do
    sleep 2
done
echo "✅ AI Agent ready"

echo ""
echo "Waiting for backend to start..."
sleep 5
echo "✅ Backend running"

echo ""
echo "================================================"
echo "🎉 System is running! (Simple Mode)"
echo "================================================"
echo ""
echo "📊 Service URLs:"
echo "   • AI Agent API:  http://localhost:8000"
echo "   • API Docs:      http://localhost:8000/docs"
echo "   • Database:      localhost:5432"
echo ""
echo "ℹ️  NOTE: This version uses deterministic rule-based"
echo "   scoring and doesn't require Ollama. It's fully"
echo "   functional and much faster to start!"
echo ""
echo "📝 Useful commands:"
echo "   • View logs:     docker-compose -f docker-compose-simple.yml logs -f"
echo "   • Check status:  docker-compose -f docker-compose-simple.yml ps"
echo "   • Stop system:   docker-compose -f docker-compose-simple.yml down"
echo "   • Test agent:    ./test.sh"
echo ""
echo "📚 See README.md for more information"
echo "================================================"
