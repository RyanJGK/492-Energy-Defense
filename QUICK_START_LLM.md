# Quick Start Guide - LLM Mode

## What Changed?

✅ **LLM Mode Enabled**: The agent now uses Ollama/Qwen AI for intelligent event analysis  
✅ **Reduced Events**: Only 23-57 events per cycle (instead of 120-432) to prevent overload  
✅ **Smart Fallback**: If LLM fails, automatically switches to rule-based analysis  

---

## How to Deploy

### Option 1: Fresh Start (Recommended)

```bash
# Stop everything
docker-compose down

# Rebuild agent with new LLM code
docker-compose build agent

# Start all services
docker-compose up -d

# Wait for Ollama to pull Qwen model (may take 1-2 minutes)
docker logs -f ollama-init

# When you see "Qwen model ready!", press Ctrl+C
```

### Option 2: Quick Restart

```bash
# Rebuild and restart just the agent
docker-compose build agent
docker-compose restart agent backend
```

---

## Verify It's Working

### Step 1: Check Agent Mode

```bash
curl http://localhost:8000/health | jq
```

**Expected output:**
```json
{
  "status": "healthy",
  "service": "492-Energy-Defense Cyber Event Triage Agent",
  "mode": "LLM",
  "ollama_url": "http://ollama:11434/api/generate",
  "model": "qwen2.5:0.5b"
}
```

✅ If you see `"mode": "LLM"`, it's working!

### Step 2: Run Test Script

```bash
./test-llm-mode.sh
```

This will:
- ✓ Check if agent is running
- ✓ Verify LLM mode is enabled
- ✓ Test Ollama connectivity
- ✓ Send test events and show LLM analysis

### Step 3: Monitor Event Processing

```bash
# Watch backend generate and dispatch events
docker logs -f cyber-backend

# In another terminal, watch agent analyze events
docker logs -f cyber-agent
```

**What to look for in agent logs:**
```
INFO: Received login event for analysis (LLM mode: True)
INFO: Using LLM-based analysis...
INFO: Calling Ollama LLM for login event analysis...
INFO: Analysis complete: critical severity, score 95
```

---

## Performance Expectations

### Event Volumes (Per 30-min cycle)
- **Login events**: 5-15 (was 20-80)
- **Firewall events**: 10-30 (was 100-300)
- **Patch checks**: 8-12 devices (was all 52)
- **Total**: ~23-57 events (was 120-432)

### Timing
- **LLM analysis**: 1-5 seconds per event
- **Cycle duration**: 1-2 minutes (was 30+ minutes)
- **Next cycle**: 30 minutes after start

### Resources
- **Memory**: 4-8GB for Ollama (same as before)
- **CPU**: Moderate during cycles
- **Disk**: Same as before

---

## Toggle Between Modes

### Switch to Rule-Based (Fast)

Edit `docker-compose.yml`:
```yaml
environment:
  - USE_LLM=false  # Disable LLM, use fast rules
```

Then:
```bash
docker-compose restart agent
```

### Switch Back to LLM

Edit `docker-compose.yml`:
```yaml
environment:
  - USE_LLM=true  # Enable LLM
```

Then:
```bash
docker-compose restart agent
```

---

## Troubleshooting

### Problem: "Connection refused" to Ollama

**Solution:**
```bash
# Check if Ollama is running
docker ps | grep ollama

# Restart Ollama
docker-compose restart ollama

# Pull Qwen model
docker exec ollama-qwen ollama pull qwen2.5:0.5b
```

### Problem: LLM responses are slow

**Solution:** This is normal. LLM takes 1-5 seconds per event. If too slow:

1. Reduce parallel workers in `docker-compose.yml`:
```yaml
backend:
  environment:
    - DISPATCH_WORKERS=5  # Reduce from 10
```

2. Or switch to rule-based mode temporarily

### Problem: "No valid JSON found in response"

**Solution:** The LLM sometimes returns invalid JSON. The system automatically falls back to rule-based analysis for that event. This is expected and handled gracefully.

### Problem: Too few events

**Solution:** If you want more events, edit `backend/data_generator.py`:
```python
num_events = random.randint(15, 30)  # Increase from 5-15
```

But monitor performance - more events = slower cycles.

---

## Compare LLM vs Rule-Based

### Test the Difference

Send the same event in both modes:

**1. LLM Mode** (intelligent, contextual):
```bash
curl -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "admin",
      "src_ip": "203.0.113.50",
      "status": "FAIL",
      "timestamp": "2025-11-19T02:30:00",
      "is_admin": true,
      "is_burst_failure": true,
      "is_suspicious_ip": true
    }
  }' | jq
```

**LLM Response Example:**
```json
{
  "risk_score": 95,
  "severity": "critical",
  "reasoning": "Failed admin login from suspicious external IP with burst pattern during night hours. Multiple red flags indicate possible brute-force attack targeting privileged account.",
  "recommended_action": "IMMEDIATE: Lock admin account, block source IP, conduct full security audit"
}
```

**2. Rule-Based Mode** (fast, deterministic):

Set `USE_LLM=false`, restart agent, send same event.

**Rule-Based Response Example:**
```json
{
  "risk_score": 120,
  "severity": "critical",
  "reasoning": "Failed login attempt (+30); 3rd+ failure in short time window (+20); Admin account targeted (+40); Suspicious source IP detected (+30)",
  "recommended_action": "IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP"
}
```

**Notice the difference:**
- **LLM**: Natural language, contextual understanding
- **Rules**: Exact scoring, itemized reasons

Both are valid! Choose based on your needs.

---

## What's Next?

The system is now running in LLM mode and will:

1. ✅ Generate 23-57 events every 30 minutes
2. ✅ Send each event to Ollama/Qwen for AI analysis
3. ✅ Store analysis results in the database
4. ✅ Fall back to rules if LLM fails

### Monitor the System

```bash
# Backend (event generation)
docker logs -f cyber-backend

# Agent (LLM analysis)
docker logs -f cyber-agent

# Database (stored results)
docker exec cyber-backend python -c "
from backend.database import SessionLocal
from backend.models import EventAnalysis
db = SessionLocal()
count = db.query(EventAnalysis).count()
print(f'Total analyses in database: {count}')
db.close()
"
```

### View Analysis Results

```bash
# Show last 10 analyses
docker exec cyber-backend python -c "
from backend.database import SessionLocal
from backend.models import EventAnalysis
db = SessionLocal()
analyses = db.query(EventAnalysis).order_by(EventAnalysis.analyzed_at.desc()).limit(10).all()
for a in analyses:
    print(f'{a.event_type}: {a.severity} (score {a.risk_score})')
    print(f'  Reason: {a.reasoning}')
    print()
db.close()
"
```

---

## Summary

✅ **LLM Mode Active** - Using Qwen AI for intelligent analysis  
✅ **Reduced Load** - Only ~30-50 events per cycle  
✅ **Fast Cycles** - Complete in 1-2 minutes  
✅ **Robust** - Falls back to rules if LLM fails  
✅ **Toggleable** - Switch modes with environment variable  

**Everything is ready to go!** 🚀

For detailed technical information, see: `LLM_MODE_IMPLEMENTATION.md`
