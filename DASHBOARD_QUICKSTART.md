# Dashboard Quick Start Guide

## 🚀 Get Started in 3 Steps

### 1. Start the System

```bash
docker-compose up -d
```

Wait 2-3 minutes for all services to initialize.

### 2. Open the Dashboard

Open your browser and navigate to:

**http://localhost:3000**

### 3. Explore

- **Main Page**: View all alerts and anomalies in real-time
- **Case Review**: Click "View Full Details" on any alert to see complete analysis

## 📊 What You'll See

### Alerts & Anomalies Page
- Live statistics cards showing critical/high/medium alerts
- Filterable list of all security events
- Color-coded severity indicators
- Auto-refreshes every 30 seconds

### Case Review Page
- Detailed analysis for each incident
- AI reasoning and risk scoring
- Recommended actions
- Complete event details
- Timeline of the incident

## 🎯 Common Tasks

### Filter Critical Alerts Only
1. Go to http://localhost:3000
2. In the "Severity" dropdown, select "Critical"
3. View only critical severity alerts

### Review a Specific Case
1. Click "View Full Details" on any alert card
2. See complete analysis, recommendations, and timeline
3. Use "Back to Alerts" to return

### Check Real-time Stats
- Critical Alerts count (red card)
- High Priority count (orange card)
- Medium Priority count (yellow card)
- Total Events in last 24h (blue card)

## 🔄 Viewing Live Data

The dashboard reads from the PostgreSQL database where the AI agent stores its analysis results. As new events are generated and analyzed (every 30 minutes by default), they will appear in the dashboard.

### Manual Refresh
Click the "🔄 Refresh" button in the top right corner

### Auto-refresh
The page automatically refreshes every 30 seconds

## 📱 Access from Other Devices

To access the dashboard from other computers on your network:

1. Find your computer's IP address:
   ```bash
   # Linux/Mac
   ip addr show | grep inet
   
   # Windows
   ipconfig
   ```

2. Access from other device:
   ```
   http://YOUR_IP_ADDRESS:3000
   ```

## 🛑 Stopping the Dashboard

```bash
docker-compose stop dashboard
```

## 🔄 Restarting the Dashboard

```bash
docker-compose restart dashboard
```

## 📋 Verify Dashboard is Running

```bash
# Check status
docker ps | grep cyber-dashboard

# Check health
curl http://localhost:3000/health

# View logs
docker logs cyber-dashboard
```

## ⚡ Tips

1. **Best viewed on desktop**: The dashboard is optimized for larger screens
2. **Keep browser tab open**: Auto-refresh only works when the tab is active
3. **Filter by type**: Use event type filter to focus on Login/Firewall/Patch events
4. **Combine filters**: You can filter by both severity AND event type

## 🎓 For Learning

Use the dashboard to:
- Understand how AI analyzes security events
- Learn about different risk factors
- Practice incident response
- See real-time threat detection in action

---

For more details, see [DASHBOARD_README.md](DASHBOARD_README.md)
