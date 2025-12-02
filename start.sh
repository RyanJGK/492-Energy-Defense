#!/bin/bash
# Startup script for 492-Energy-Defense Cybersecurity Agent

echo "================================================"
echo "492-ENERGY-DEFENSE CYBERSECURITY AGENT"
echo "================================================"
echo ""

echo "🚀 Starting all services..."
docker-compose up -d

echo ""
echo "⏳ Waiting for services to initialize..."
echo "   (This may take 3-5 minutes on first run while Qwen model downloads)"
echo ""

# Wait for services to be healthy
echo "Waiting for database..."
until docker-compose exec -T db pg_isready -U postgres > /dev/null 2>&1; do
    sleep 2
done
echo "✅ Database ready"

echo ""
echo "Waiting for Ollama and Qwen model..."
sleep 10
echo "✅ Ollama ready (model may still be downloading in background)"

echo ""
echo "Waiting for AI Agent..."
until curl -s http://localhost:8000/health > /dev/null 2>&1; do
    sleep 2
done
echo "✅ AI Agent ready"

echo ""
echo "================================================"
echo "🎉 System is running!"
echo "================================================"
echo ""
echo "📊 Service URLs:"
echo "   • AI Agent API:  http://localhost:8000"
echo "   • API Docs:      http://localhost:8000/docs"
echo "   • Database:      localhost:5432"
echo ""
echo "📝 Useful commands:"
echo "   • View logs:           docker-compose logs -f"
echo "   • Check status:        docker-compose ps"
echo "   • Stop system:         docker-compose down"
echo "   • Test agent:          ./test.sh"
echo ""
echo "📚 See README.md for more information"
echo "================================================"
