# Quick Start Guide

## 🚀 Get Started in 3 Steps

### Step 1: Start the System
```bash
./start.sh
```
Wait 1-2 minutes for initial setup (Qwen model download).

### Step 2: Verify It's Working
```bash
./test.sh
```

### Step 3: Monitor Activity
```bash
./manage.sh stats
```

## 📊 What Happens Next?

The system automatically:
- **Every 30 minutes**: Generates 20-80 login events, 100-300 firewall events
- **Real-time**: AI analyzes each event and assigns risk scores
- **Continuously**: Updates patch status for all devices

## 🔍 Quick Commands

```bash
# View what's happening now
./manage.sh logs-backend

# See critical events
./manage.sh critical

# Check database
./manage.sh db

# Stop everything
./manage.sh stop
```

## 📈 Understanding Results

**Severity Levels:**
- 🟢 **Low** (0-20): Normal activity
- 🟡 **Medium** (21-40): Monitor closely
- 🟠 **High** (41-70): Investigate soon
- 🔴 **Critical** (71+): Immediate action required

## 🎯 Example Events

**Critical Login Attack:**
```bash
curl -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "admin",
      "src_ip": "198.51.100.45",
      "status": "FAIL",
      "timestamp": "2025-11-14T03:22:10",
      "device_id": "UNKNOWN",
      "auth_method": "password",
      "is_burst_failure": true,
      "is_suspicious_ip": true,
      "is_admin": true
    }
  }'
```

## 🛠️ Troubleshooting

**Services not starting?**
```bash
docker-compose down -v
docker-compose up -d
```

**Need to see logs?**
```bash
./manage.sh logs
```

**Database issues?**
```bash
docker-compose restart db
```

## 📚 Learn More

- Full documentation: `README.md`
- Management tools: `./manage.sh help`
- API docs: http://localhost:8000/docs

---

**Ready to explore? Run `./test.sh` to see it in action! 🎉**
