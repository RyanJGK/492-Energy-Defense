#!/bin/bash
# Management utility for 492-Energy-Defense Cybersecurity Agent

show_help() {
    echo "================================================"
    echo "492-ENERGY-DEFENSE - Management Utility"
    echo "================================================"
    echo ""
    echo "Usage: ./manage.sh [command]"
    echo ""
    echo "Commands:"
    echo "  start         Start all services"
    echo "  stop          Stop all services"
    echo "  restart       Restart all services"
    echo "  status        Show service status"
    echo "  logs          Show all logs"
    echo "  logs-backend  Show backend logs"
    echo "  logs-agent    Show agent logs"
    echo "  logs-db       Show database logs"
    echo "  db            Connect to database"
    echo "  stats         Show event statistics"
    echo "  critical      Show critical events"
    echo "  test          Run system tests"
    echo "  clean         Stop and remove all data"
    echo "  help          Show this help message"
    echo ""
}

case "$1" in
    start)
        echo "🚀 Starting services..."
        docker-compose up -d
        echo "✅ Services started"
        ;;
    
    stop)
        echo "🛑 Stopping services..."
        docker-compose down
        echo "✅ Services stopped"
        ;;
    
    restart)
        echo "🔄 Restarting services..."
        docker-compose restart
        echo "✅ Services restarted"
        ;;
    
    status)
        echo "📊 Service Status:"
        echo "=================="
        docker-compose ps
        ;;
    
    logs)
        echo "📝 Showing all logs (Ctrl+C to exit)..."
        docker-compose logs -f
        ;;
    
    logs-backend)
        echo "📝 Showing backend logs (Ctrl+C to exit)..."
        docker logs -f cyber-backend
        ;;
    
    logs-agent)
        echo "📝 Showing agent logs (Ctrl+C to exit)..."
        docker logs -f cyber-agent
        ;;
    
    logs-db)
        echo "📝 Showing database logs (Ctrl+C to exit)..."
        docker logs -f cyber-events-db
        ;;
    
    db)
        echo "🔗 Connecting to database..."
        docker exec -it cyber-events-db psql -U postgres -d cyber_events
        ;;
    
    stats)
        echo "📊 Event Statistics:"
        echo "==================="
        docker exec -i cyber-events-db psql -U postgres -d cyber_events << 'EOF'
\echo '--- Event Counts ---'
SELECT 'Login Events' as type, COUNT(*) as count FROM login_events
UNION ALL
SELECT 'Firewall Events', COUNT(*) FROM firewall_logs
UNION ALL
SELECT 'Patch Events', COUNT(*) FROM patch_levels
UNION ALL
SELECT 'Analyses', COUNT(*) FROM event_analyses;

\echo ''
\echo '--- Severity Distribution ---'
SELECT severity, COUNT(*) as count 
FROM event_analyses 
GROUP BY severity 
ORDER BY 
  CASE severity 
    WHEN 'critical' THEN 1 
    WHEN 'high' THEN 2 
    WHEN 'medium' THEN 3 
    WHEN 'low' THEN 4 
  END;

\echo ''
\echo '--- Event Type Distribution ---'
SELECT event_type, COUNT(*) as count 
FROM event_analyses 
GROUP BY event_type;

\echo ''
\echo '--- Average Risk Scores ---'
SELECT event_type, 
       ROUND(AVG(risk_score), 2) as avg_score,
       MIN(risk_score) as min_score,
       MAX(risk_score) as max_score
FROM event_analyses 
GROUP BY event_type;
EOF
        ;;
    
    critical)
        echo "🚨 Critical and High-Risk Events:"
        echo "=================================="
        docker exec -i cyber-events-db psql -U postgres -d cyber_events << 'EOF'
SELECT 
    event_type,
    severity,
    risk_score,
    LEFT(reasoning, 80) as reasoning,
    analyzed_at
FROM event_analyses 
WHERE severity IN ('critical', 'high')
ORDER BY analyzed_at DESC
LIMIT 20;
EOF
        ;;
    
    test)
        echo "🧪 Running system tests..."
        ./test.sh
        ;;
    
    clean)
        echo "⚠️  WARNING: This will delete all data!"
        read -p "Are you sure? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            echo "🗑️  Removing all services and data..."
            docker-compose down -v
            echo "✅ Clean complete"
        else
            echo "❌ Cancelled"
        fi
        ;;
    
    help|*)
        show_help
        ;;
esac
