# 🚀 START HERE - 492-Energy-Defense System

## Quick Launch

```bash
# Start everything
docker-compose up -d

# Wait 2-3 minutes for initialization
# Then open the dashboard:
```

**http://localhost:3000** 🎯

## What You'll See

### Security Dashboard (Port 3000)
A modern web interface showing:
- 🔴 Critical alerts
- 🟠 High priority events  
- 🟡 Medium priority events
- 📊 Real-time statistics
- 🔍 Filterable event list
- 📋 Detailed case reviews

### Behind the Scenes
The system is:
- Generating security events every 30 minutes
- Analyzing them with AI (Mistral LLM)
- Storing results in PostgreSQL
- Displaying them in the dashboard

## Navigation

### For First-Time Users
1. ✅ Start with [DASHBOARD_QUICKSTART.md](DASHBOARD_QUICKSTART.md)
2. Explore the web interface at http://localhost:3000
3. Try filtering by severity and event type
4. Click "View Full Details" on any alert

### For System Details
- [README.md](README.md) - Complete system documentation
- [DASHBOARD_README.md](DASHBOARD_README.md) - Dashboard features
- [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md) - Technical overview

## Key Features

✨ **Real-time Monitoring**: Events are analyzed as they're generated
🤖 **AI-Powered**: Mistral LLM analyzes each security event
📊 **Visual Dashboard**: Modern web UI for SOC-style monitoring
🔍 **Smart Filtering**: Filter by severity, event type, and more
📋 **Case Management**: Detailed review of each security incident
🐳 **Fully Dockerized**: One command to start everything

## Services Running

Once started, you have access to:

| Service | URL | Purpose |
|---------|-----|---------|
| Dashboard | http://localhost:3000 | Main web interface |
| Agent API | http://localhost:8000 | AI analysis endpoint |
| Database | localhost:5432 | PostgreSQL data store |

## Common Commands

```bash
# Check status
docker-compose ps

# View dashboard logs
docker logs -f cyber-dashboard

# View backend logs (event generation)
docker logs -f cyber-backend

# View agent logs (AI analysis)
docker logs -f cyber-agent

# Stop everything
docker-compose down

# Restart everything
docker-compose restart
```

## Troubleshooting

### Dashboard not loading?
```bash
# Check if container is running
docker ps | grep cyber-dashboard

# View logs
docker logs cyber-dashboard

# Restart
docker-compose restart dashboard
```

### No data showing?
```bash
# Check if events are being generated
docker logs cyber-backend | grep "Generated"

# Check database
docker exec -it cyber-events-db psql -U postgres -d cyber_events -c "SELECT COUNT(*) FROM event_analyses;"
```

### Fresh start?
```bash
# Stop and remove everything (including data)
docker-compose down -v

# Start fresh
docker-compose up -d
```

## Learning Path

### Day 1: Explore
- Start the system
- Open the dashboard
- Watch alerts appear
- Click through cases

### Day 2: Understand
- Read about event types in README.md
- Study the risk scoring system
- Review AI analysis reasoning
- Learn about severity levels

### Day 3: Experiment
- Try different filters
- Look for patterns in the data
- Compare different event types
- Explore the API endpoints

### Day 4: Deep Dive
- Check the database directly
- View raw logs
- Understand the architecture
- Study the AI prompts

## Educational Value

This system teaches:
- 🎓 Security event analysis
- 🤖 AI-assisted threat detection
- 📊 Risk scoring methodologies
- 🔍 Incident investigation
- 💼 SOC operations
- 🐳 Docker container orchestration

## Support

Questions? Issues?
1. Check the logs: `docker-compose logs`
2. Read TROUBLESHOOTING.md
3. Review DASHBOARD_README.md
4. Check service health: `docker-compose ps`

---

**Ready to begin?**

```bash
docker-compose up -d
```

Then open **http://localhost:3000** and start exploring! 🚀

---

**Built for cybersecurity education** | 492-Energy-Defense Course
