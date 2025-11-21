# 492-Energy-Defense Security Dashboard

A modern web interface for monitoring and reviewing cybersecurity alerts analyzed by the AI agent.

## 🎯 Overview

The Security Dashboard provides a real-time view of all security events analyzed by the 492-Energy-Defense system. It features:

- **Alerts & Anomalies Page**: Live feed of security alerts with severity filtering
- **Case Review Page**: Detailed analysis of individual security incidents
- **Real-time Statistics**: Dashboard showing critical metrics and event counts
- **Auto-refresh**: Automatically updates every 30 seconds

## 🚀 Quick Start

### Start the Dashboard

The dashboard is included in the main docker-compose configuration:

```bash
docker-compose up -d
```

### Access the Dashboard

Once running, access the dashboard at:

**http://localhost:3000**

### Available Pages

1. **Alerts & Anomalies** (http://localhost:3000)
   - View all recent security alerts
   - Filter by severity (Critical, High, Medium, Low)
   - Filter by event type (Login, Firewall, Patch)
   - See real-time statistics

2. **Case Review** (http://localhost:3000/static/case-review.html)
   - Browse all cases
   - View detailed analysis for each incident
   - See complete event details
   - Review AI recommendations

## 📊 Dashboard Features

### Statistics Cards

The dashboard displays real-time metrics:
- **Critical Alerts**: Number of critical severity events
- **High Priority**: Number of high severity events
- **Medium Priority**: Number of medium severity events
- **Total Events (24h)**: Events analyzed in the last 24 hours

### Alert Cards

Each alert displays:
- Event type (Login 🔐, Firewall 🔥, Patch 🛡️)
- Severity level with color coding
- Risk score
- AI analysis reasoning
- Recommended action
- Event-specific details

### Severity Color Coding

- 🔴 **Critical** (Risk Score 71+): Red
- 🟠 **High** (Risk Score 41-70): Orange
- 🟡 **Medium** (Risk Score 21-40): Yellow
- 🟢 **Low** (Risk Score 0-20): Green

## 🔧 Configuration

### Environment Variables

The dashboard uses the following environment variable (set in docker-compose.yml):

- `DATABASE_URL`: PostgreSQL connection string (default: `postgresql://postgres:postgres@db:5432/cyber_events`)

### Port Configuration

The dashboard runs on port **3000** by default. To change this, edit the docker-compose.yml:

```yaml
dashboard:
  ports:
    - "8080:3000"  # Change 8080 to your preferred port
```

## 📡 API Endpoints

The dashboard provides the following API endpoints:

### GET /api/stats
Get dashboard statistics
```json
{
  "total_events": 150,
  "critical_alerts": 5,
  "high_alerts": 12,
  "medium_alerts": 25,
  "low_alerts": 108,
  "events_last_24h": 75,
  "avg_risk_score": 32.5
}
```

### GET /api/alerts
Get all alerts with optional filters

Query Parameters:
- `severity`: Filter by severity (critical, high, medium, low)
- `event_type`: Filter by type (login, firewall, patch)
- `limit`: Maximum number of results (default: 100)

Example:
```bash
curl "http://localhost:3000/api/alerts?severity=critical&limit=10"
```

### GET /api/alert/{alert_id}
Get detailed information about a specific alert

Example:
```bash
curl "http://localhost:3000/api/alert/123"
```

## 🎨 User Interface

### Modern Dark Theme

The dashboard features a modern dark theme optimized for Security Operations Centers (SOC):
- Dark blue/navy background
- High contrast text for readability
- Color-coded severity indicators
- Smooth animations and transitions

### Responsive Design

The dashboard is fully responsive and works on:
- Desktop computers
- Tablets
- Mobile devices

### Auto-refresh

The alerts page automatically refreshes every 30 seconds to show the latest events.

## 📋 Use Cases

### SOC Analyst Workflow

1. **Monitor Alerts**: Start on the Alerts & Anomalies page to see incoming threats
2. **Filter Critical**: Use severity filter to focus on critical/high priority events
3. **Review Cases**: Click "View Full Details" to see complete analysis
4. **Take Action**: Follow the AI-recommended actions for each incident

### Training & Education

- Use the dashboard to demonstrate real-time threat detection
- Show how AI analyzes different types of security events
- Teach students about risk scoring and severity classification
- Practice incident response workflows

### Demonstration & Reporting

- Show live security event analysis to stakeholders
- Generate screenshots of critical incidents
- Demonstrate AI-powered security operations
- Track security metrics over time

## 🔍 Viewing Docker Logs

To see the raw analysis data in docker logs:

```bash
# View backend logs (event generation and dispatch)
docker logs -f cyber-backend

# View agent logs (AI analysis results)
docker logs -f cyber-agent

# View dashboard logs
docker logs -f cyber-dashboard
```

## 🛠️ Troubleshooting

### Dashboard not loading

Check if the container is running:
```bash
docker ps | grep cyber-dashboard
```

Check dashboard logs:
```bash
docker logs cyber-dashboard
```

### No data showing

1. Ensure the backend is generating events:
```bash
docker logs cyber-backend
```

2. Check database connection:
```bash
docker exec cyber-dashboard curl http://localhost:3000/health
```

3. Verify events exist in database:
```bash
docker exec -it cyber-events-db psql -U postgres -d cyber_events -c "SELECT COUNT(*) FROM event_analyses;"
```

### Connection errors

Restart the dashboard service:
```bash
docker-compose restart dashboard
```

## 🔄 Updating the Dashboard

To update the dashboard after making changes:

```bash
# Rebuild and restart
docker-compose up -d --build dashboard

# Or restart without rebuilding
docker-compose restart dashboard
```

## 📊 Data Flow

```
Event Generation (Backend)
    ↓
AI Analysis (Agent)
    ↓
Database Storage (PostgreSQL)
    ↓
Dashboard API (FastAPI)
    ↓
Web Interface (HTML/JS)
```

## 🎓 Educational Value

The dashboard helps students learn:
- Security event monitoring
- Risk assessment visualization
- Incident response workflows
- SOC operations
- Real-time threat analysis
- Security metrics and KPIs

## 🔒 Security Notes

- This is a **simulation system** for educational purposes
- Should be run in **isolated environments** only
- Uses **synthetic data** only
- Default credentials should be changed if exposed to networks

## 📞 Support

For issues or questions:
1. Check dashboard health: http://localhost:3000/health
2. Review logs: `docker logs cyber-dashboard`
3. Verify database connectivity
4. Check the main README.md for system-wide troubleshooting

## 🎉 Features Summary

✅ **Real-time Alert Monitoring**
✅ **Severity-based Filtering**
✅ **Event Type Classification**
✅ **Detailed Case Review**
✅ **AI Analysis Display**
✅ **Responsive Design**
✅ **Auto-refresh**
✅ **Modern Dark Theme**
✅ **RESTful API**
✅ **Docker Integration**

---

**Built with ❤️ for cybersecurity education**

Part of the 492-Energy-Defense Cybersecurity Agent System
