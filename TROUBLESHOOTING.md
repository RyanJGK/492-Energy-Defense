# Troubleshooting Guide

## Issue: Ollama Container Unhealthy

### Symptoms
- `Container ollama-mistral is unhealthy`
- System gets stuck on "Waiting for AI Agent..."
- Agent container doesn't start

### Quick Fix Options

#### **Option 1: Use the Simple Version (Recommended)**

The AI agent uses deterministic rule-based scoring and doesn't actually need Ollama. Use the simplified docker-compose:

```bash
# Stop current containers
docker-compose down

# Use simple version without Ollama
docker-compose -f docker-compose-simple.yml up -d

# Or make it the default
cp docker-compose-simple.yml docker-compose.yml
docker-compose up -d
```

✅ **This is the fastest option and works perfectly!**

---

#### **Option 2: Fix Ollama Health Check**

I've updated the main `docker-compose.yml` with more lenient settings. Try this:

```bash
# Stop and remove everything
docker-compose down -v

# Pull latest changes to docker-compose.yml
# (it now has longer health check timeouts)

# Start again
docker-compose up -d

# Wait 2-3 minutes for Ollama to fully start
sleep 120

# Check status
docker-compose ps
```

**Changes made:**
- ✅ Increased Ollama start_period to 120s (was 60s)
- ✅ Increased retries to 10 (was 3)
- ✅ Changed agent to not wait for Ollama health (just started)
- ✅ Changed backend to not wait for agent health (just started)

---

#### **Option 3: Disable Ollama Completely**

Edit `docker-compose.yml` and comment out the ollama service:

```yaml
# Comment out or remove these sections:
#  ollama:
#    ...
#  ollama-init:
#    ...
```

And remove the ollama dependency from agent service:

```yaml
agent:
  # Remove this:
  # depends_on:
  #   ollama:
  #     condition: service_started
```

---

## Diagnostic Commands

### 1. Check What's Running
```bash
docker-compose ps
```

### 2. View Ollama Logs
```bash
docker logs ollama-mistral
```

### 3. Check Ollama Health
```bash
docker inspect ollama-mistral | grep -A 10 "Health"
```

### 4. Test Ollama API Manually
```bash
curl http://localhost:11434/api/tags
```

### 5. Check Agent Logs
```bash
docker logs cyber-agent
```

### 6. Run Troubleshooting Script
```bash
./troubleshoot.sh
```

---

## Common Issues & Solutions

### Issue: Ollama Takes Too Long to Start

**Solution:** Increase the wait time in `start.sh`:

```bash
# Edit start.sh and change:
sleep 10
# To:
sleep 60
```

### Issue: Insufficient Memory

**Error:** Ollama container killed or OOM errors

**Solution:** Reduce memory in docker-compose.yml:

```yaml
ollama:
  deploy:
    resources:
      limits:
        memory: 4G  # Reduced from 8G
      reservations:
        memory: 2G  # Reduced from 4G
```

### Issue: Port Already in Use

**Error:** "port is already allocated"

**Solution:** Change ports in docker-compose.yml:

```yaml
ports:
  - "8001:8000"  # Agent
  - "5433:5432"  # Database
  - "11435:11434" # Ollama
```

### Issue: curl Not Found in Container

**Solution:** The updated docker-compose.yml uses `CMD-SHELL` which should fix this.

---

## Testing Individual Components

### Test Database Only
```bash
docker-compose up -d db
docker exec -it cyber-events-db psql -U postgres -d cyber_events
```

### Test Agent Only
```bash
docker-compose up -d agent
curl http://localhost:8000/health
```

### Test Agent Analysis
```bash
curl -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "test",
      "src_ip": "192.168.1.1",
      "status": "SUCCESS",
      "timestamp": "2025-11-14T12:00:00",
      "device_id": "TEST-01",
      "auth_method": "password",
      "is_burst_failure": false,
      "is_suspicious_ip": false,
      "is_admin": false
    }
  }'
```

---

## Complete Reset

If all else fails, start fresh:

```bash
# Stop everything
docker-compose down -v

# Remove images
docker rmi $(docker images 'workspace*' -q) 2>/dev/null

# Clear build cache
docker builder prune -f

# Use simple version
docker-compose -f docker-compose-simple.yml up -d --build
```

---

## Understanding the Architecture

The system has two operational modes:

### Mode 1: Full Setup (with Ollama)
- More complex, longer startup
- Ollama provides LLM capabilities (currently unused)
- ~5-10 minute first startup
- Requires 8GB+ RAM

### Mode 2: Simple Setup (without Ollama) ⭐ **Recommended**
- Fast startup (~30 seconds)
- Uses deterministic rule-based scoring
- Fully functional for the educational purpose
- Only needs ~2GB RAM

**The agent already uses deterministic rules, so Ollama is optional!**

---

## Which Version Should I Use?

**Use `docker-compose-simple.yml` if:**
- ✅ You want fast startup
- ✅ You have limited RAM (<8GB)
- ✅ You're just learning/testing
- ✅ You don't need LLM features

**Use regular `docker-compose.yml` if:**
- You want to experiment with Ollama integration
- You have plenty of RAM (8GB+)
- You want the full architecture
- You're willing to wait for model downloads

---

## Still Having Issues?

1. Check Docker is running: `docker ps`
2. Check Docker version: `docker --version` (need 20.10+)
3. Check available memory: `free -h` (Linux) or Activity Monitor (Mac)
4. View all logs: `docker-compose logs`
5. Try the simple version: `docker-compose -f docker-compose-simple.yml up -d`

---

**Need more help? Check the logs and README.md for additional guidance.**
