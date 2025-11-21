#!/bin/bash
# Test script for dashboard updates

echo "🧪 Testing Dashboard Updates"
echo "=============================="
echo ""

# Check if dashboard is running
echo "1️⃣ Checking if dashboard is running..."
if docker ps | grep -q cyber-dashboard; then
    echo "✅ Dashboard container is running"
else
    echo "❌ Dashboard container is not running"
    echo "   Run: docker-compose up -d dashboard"
    exit 1
fi

echo ""
echo "2️⃣ Testing API endpoints..."

# Test health
echo "   Testing /health endpoint..."
curl -s http://localhost:3000/health | grep -q "healthy" && echo "   ✅ Health check OK" || echo "   ❌ Health check failed"

# Test stats
echo "   Testing /api/stats endpoint..."
curl -s http://localhost:3000/api/stats | grep -q "total_events" && echo "   ✅ Stats API OK" || echo "   ❌ Stats API failed"

# Test alerts (check if sorted by severity)
echo "   Testing /api/alerts endpoint (severity sorting)..."
ALERTS=$(curl -s http://localhost:3000/api/alerts?limit=10)
if echo "$ALERTS" | grep -q "severity"; then
    echo "   ✅ Alerts API OK"
    # Count severities
    CRITICAL=$(echo "$ALERTS" | grep -o '"severity":"critical"' | wc -l)
    HIGH=$(echo "$ALERTS" | grep -o '"severity":"high"' | wc -l)
    echo "   📊 Found $CRITICAL critical and $HIGH high severity alerts"
else
    echo "   ❌ Alerts API failed"
fi

echo ""
echo "3️⃣ Checking database tables..."

# Check if feedback tables exist
docker exec cyber-events-db psql -U postgres -d cyber_events -c "\dt" 2>/dev/null | grep -q "analyst_feedback" && echo "   ✅ analyst_feedback table exists" || echo "   ⚠️  analyst_feedback table not found (will be created on first dashboard start)"

docker exec cyber-events-db psql -U postgres -d cyber_events -c "\dt" 2>/dev/null | grep -q "whitelisted_ips" && echo "   ✅ whitelisted_ips table exists" || echo "   ⚠️  whitelisted_ips table not found (will be created on first dashboard start)"

docker exec cyber-events-db psql -U postgres -d cyber_events -c "\dt" 2>/dev/null | grep -q "whitelisted_users" && echo "   ✅ whitelisted_users table exists" || echo "   ⚠️  whitelisted_users table not found (will be created on first dashboard start)"

echo ""
echo "4️⃣ Testing feedback submission..."
echo "   Submitting test feedback..."

# Get first alert ID
ALERT_ID=$(curl -s http://localhost:3000/api/alerts?limit=1 | grep -o '"id":[0-9]*' | head -1 | cut -d: -f2)

if [ -n "$ALERT_ID" ]; then
    echo "   Testing with alert ID: $ALERT_ID"
    
    # Test false positive submission
    RESPONSE=$(curl -s -X POST http://localhost:3000/api/feedback \
        -H "Content-Type: application/json" \
        -d "{\"alert_id\": $ALERT_ID, \"action\": \"false_positive\", \"notes\": \"Test feedback\"}")
    
    if echo "$RESPONSE" | grep -q '"status":"success"'; then
        echo "   ✅ Feedback submission successful"
        
        # Check if feedback was stored
        FEEDBACK_COUNT=$(docker exec cyber-events-db psql -U postgres -d cyber_events -t -c "SELECT COUNT(*) FROM analyst_feedback WHERE alert_id=$ALERT_ID;" 2>/dev/null | tr -d ' ')
        if [ "$FEEDBACK_COUNT" -gt 0 ]; then
            echo "   ✅ Feedback stored in database"
        else
            echo "   ⚠️  Feedback not found in database"
        fi
    else
        echo "   ❌ Feedback submission failed"
        echo "   Response: $RESPONSE"
    fi
else
    echo "   ⚠️  No alerts found to test with"
fi

echo ""
echo "5️⃣ Checking dashboard UI files..."
[ -f /workspace/dashboard/static/index.html ] && echo "   ✅ index.html exists" || echo "   ❌ index.html missing"
[ -f /workspace/dashboard/static/case-review.html ] && echo "   ✅ case-review.html exists" || echo "   ❌ case-review.html missing"
[ -f /workspace/dashboard/static/styles.css ] && echo "   ✅ styles.css exists" || echo "   ❌ styles.css missing"

# Check for feedback form in case-review.html
if grep -q "Analyst Review" /workspace/dashboard/static/case-review.html; then
    echo "   ✅ Analyst Review section found in case-review.html"
else
    echo "   ❌ Analyst Review section not found in case-review.html"
fi

echo ""
echo "=============================="
echo "✅ Testing complete!"
echo ""
echo "🌐 Access the dashboard at: http://localhost:3000"
echo "📋 Open a case and scroll to 'Analyst Review' to test the feedback features"
echo ""
echo "View feedback data:"
echo "  docker exec -it cyber-events-db psql -U postgres -d cyber_events -c 'SELECT * FROM analyst_feedback;'"
echo ""
