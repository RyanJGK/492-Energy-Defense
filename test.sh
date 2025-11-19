#!/bin/bash
# Test script for the cybersecurity agent

echo "================================================"
echo "Testing 492-Energy-Defense Cybersecurity Agent"
echo "================================================"
echo ""

# Check if services are running
if ! docker-compose ps | grep -q "cyber-agent.*Up"; then
    echo "❌ Error: AI Agent is not running"
    echo "   Run './start.sh' first"
    exit 1
fi

echo "✅ Services are running"
echo ""

# Test 1: Health check
echo "Test 1: Health Check"
echo "--------------------"
health_response=$(curl -s http://localhost:8000/health)
if echo "$health_response" | grep -q "healthy"; then
    echo "✅ Health check passed"
    echo "   Response: $health_response"
else
    echo "❌ Health check failed"
    exit 1
fi
echo ""

# Test 2: Critical login event
echo "Test 2: Critical Login Event Analysis"
echo "--------------------------------------"
echo "Sending: Failed admin login from suspicious IP with burst failures at night"
critical_login=$(curl -s -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "admin",
      "src_ip": "198.51.100.45",
      "status": "FAIL",
      "timestamp": "2025-11-14T03:22:10",
      "device_id": "UNKNOWN-DEVICE",
      "auth_method": "password",
      "is_burst_failure": true,
      "is_suspicious_ip": true,
      "is_admin": true
    }
  }')

echo "$critical_login" | python3 -m json.tool
severity=$(echo "$critical_login" | python3 -c "import sys, json; print(json.load(sys.stdin)['severity'])" 2>/dev/null)

if [ "$severity" = "critical" ]; then
    echo "✅ Correctly identified as CRITICAL severity"
else
    echo "⚠️  Unexpected severity: $severity (expected: critical)"
fi
echo ""

# Test 3: Low-risk firewall event
echo "Test 3: Low-Risk Firewall Event Analysis"
echo "-----------------------------------------"
echo "Sending: Normal internal ALLOW event"
low_risk=$(curl -s -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "firewall",
    "data": {
      "src_ip": "192.168.1.50",
      "dst_ip": "192.168.1.100",
      "action": "ALLOW",
      "port": 443,
      "protocol": "TCP",
      "timestamp": "2025-11-14T14:30:00",
      "is_port_scan": false,
      "is_lateral_movement": false,
      "is_malicious_range": false,
      "is_connection_spike": false
    }
  }')

echo "$low_risk" | python3 -m json.tool
severity=$(echo "$low_risk" | python3 -c "import sys, json; print(json.load(sys.stdin)['severity'])" 2>/dev/null)

if [ "$severity" = "low" ]; then
    echo "✅ Correctly identified as LOW severity"
else
    echo "⚠️  Unexpected severity: $severity (expected: low)"
fi
echo ""

# Test 4: High-risk patch event
echo "Test 4: High-Risk Patch Event Analysis"
echo "---------------------------------------"
echo "Sending: System with missing critical patches and unsupported OS"
high_risk=$(curl -s -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "patch",
    "data": {
      "device_id": "WIN-SERVER-99",
      "os": "Windows Server 2012",
      "last_patch_date": "2024-01-15",
      "missing_critical": 3,
      "missing_high": 5,
      "update_failures": 2,
      "is_unsupported": true
    }
  }')

echo "$high_risk" | python3 -m json.tool
severity=$(echo "$high_risk" | python3 -c "import sys, json; print(json.load(sys.stdin)['severity'])" 2>/dev/null)

if [ "$severity" = "critical" ] || [ "$severity" = "high" ]; then
    echo "✅ Correctly identified as HIGH/CRITICAL severity"
else
    echo "⚠️  Unexpected severity: $severity (expected: high or critical)"
fi
echo ""

# Check database
echo "Test 5: Database Status"
echo "-----------------------"
event_count=$(docker-compose exec -T db psql -U postgres -d cyber_events -t -c "SELECT COUNT(*) FROM login_events;" 2>/dev/null | tr -d ' ')
analysis_count=$(docker-compose exec -T db psql -U postgres -d cyber_events -t -c "SELECT COUNT(*) FROM event_analyses;" 2>/dev/null | tr -d ' ')

if [ -n "$event_count" ]; then
    echo "✅ Database accessible"
    echo "   Login events: $event_count"
    echo "   Analyses: $analysis_count"
else
    echo "⚠️  Could not query database"
fi
echo ""

echo "================================================"
echo "✅ Testing complete!"
echo "================================================"
echo ""
echo "💡 Tips:"
echo "   • View backend logs:  docker logs -f cyber-backend"
echo "   • View agent logs:    docker logs -f cyber-agent"
echo "   • Query events:       docker exec -it cyber-events-db psql -U postgres -d cyber_events"
echo ""
