# 492-ENERGY-DEFENSE CYBERSECURITY AGENT

A Dockerized local IT-security simulation system for educational purposes. This project simulates real-world cybersecurity events and uses an AI agent (Ollama Mistral) to analyze and triage security incidents in real-time.

## 🆕 NEW: Security Dashboard with Analyst Review

**View your security alerts in a modern web interface!**

Access the dashboard at **http://localhost:3000** after starting the system.

- 🚨 **Alerts & Anomalies**: Real-time security event monitoring (sorted by severity)
- 📋 **Case Review**: Detailed incident analysis with feedback capabilities
- ✅ **Analyst Review**: Whitelist IPs/users, mark false positives, confirm threats
- 📊 **Statistics**: Live metrics and severity tracking
- 🎨 **Modern UI**: Energy-dashboard inspired design

[Quick Start Guide](DASHBOARD_QUICKSTART.md) | [Full Documentation](DASHBOARD_README.md) | [Latest Updates](DASHBOARD_UPDATES.md)

## 🏗️ Architecture

The system consists of two main components:

### 1. AI Agent (Ollama Mistral)
- **Purpose**: Analyzes security events one-by-one and returns structured JSON risk assessments
- **Technology**: FastAPI + Ollama Mistral
- **Location**: `./agent/`
- **Port**: 8000

### 2. Backend Database + Data Generator
- **Purpose**: Generates synthetic security events every 30 minutes and dispatches them for analysis
- **Technology**: PostgreSQL + Python + APScheduler
- **Location**: `./backend/`
- **Database Port**: 5432

## 📊 Event Types

The system simulates three types of cybersecurity events:

### 🔐 Login Events
Tracks authentication attempts with the following attributes:
- Username, source IP, status (SUCCESS/FAIL)
- Device ID, authentication method
- Flags: burst failures, suspicious IPs, admin accounts
- Night-time login detection (00:00-05:00)

**Risk Factors:**
- Failed login: +30 points
- 3rd+ failure in short time: +20 points
- Unknown/new device: +25 points
- Night-time login: +10 points
- Admin account: +40 points
- Suspicious IP: +30 points

### 🔥 Firewall Events
Monitors network traffic with:
- Source/destination IPs, ports, protocols
- Actions (ALLOW/DENY)
- Flags: port scans, lateral movement, malicious ranges

**Risk Factors:**
- Repeated denials: +20 points
- Malicious IP range: +40 points
- Port scan detected: +35 points
- Unusual outbound port: +20 points
- Lateral movement: +25 points
- Connection spike: +15 points

### 🛡️ Patch Level Events
Tracks system patch status:
- Device ID, OS type, last patch date
- Missing critical/high patches
- Update failures, unsupported OS

**Risk Factors:**
- Missing critical patches: +50 points
- Missing high patches: +35 points
- Outdated (>60 days): +15 points
- Update failures: +20 points
- Unsupported OS: +40 points

## 📈 Severity Levels

Risk scores map to severity levels:
- **0-20**: Low
- **21-40**: Medium
- **41-70**: High
- **71+**: Critical

## 🚀 Quick Start

### Prerequisites
- Docker and Docker Compose installed
- At least 8GB RAM available (4GB reserved for Ollama)
- 10GB free disk space

### Installation

1. **Clone the repository:**
```bash
git clone <repository-url>
cd workspace
```

2. **Start all services:**
```bash
docker-compose up -d
```

3. **Wait for initialization:**
The first startup will:
- Pull the Mistral AI model (~4GB, takes 5-10 minutes)
- Initialize the PostgreSQL database
- Start generating events immediately

4. **Check status:**
```bash
docker-compose ps
```

All services should show as "healthy" or "running".

### Accessing the Services

- **Security Dashboard**: http://localhost:3000 🆕
  - Modern web interface for viewing alerts and cases
  - Real-time statistics and filtering
  - See [DASHBOARD_QUICKSTART.md](DASHBOARD_QUICKSTART.md) for details

- **AI Agent API**: http://localhost:8000
  - Health check: http://localhost:8000/health
  - API docs: http://localhost:8000/docs

- **PostgreSQL Database**: localhost:5432
  - Username: `postgres`
  - Password: `postgres`
  - Database: `cyber_events`

- **Ollama API**: http://localhost:11434

## 📁 Project Structure

```
workspace/
├── agent/                      # AI Agent Service
│   ├── Dockerfile
│   ├── main.py                # FastAPI application
│   └── requirements.txt
├── backend/                    # Backend Service
│   ├── Dockerfile
│   ├── database.py            # Database configuration
│   ├── models.py              # SQLAlchemy models
│   ├── data_generator.py     # Event generation logic
│   ├── event_dispatcher.py   # Sends events to AI agent
│   ├── scheduler.py           # APScheduler (runs every 30 min)
│   └── requirements.txt
├── dashboard/                  # Web Dashboard (NEW)
│   ├── Dockerfile
│   ├── main.py                # Dashboard API
│   ├── requirements.txt
│   └── static/
│       ├── index.html         # Alerts & Anomalies page
│       ├── case-review.html   # Case Review page
│       └── styles.css         # Modern dark theme
├── model_analysis/                       # 🔍 Data Analysis & Model Performance
│   ├── ANALYSIS.md
│   ├── analysis.ipynb
│   ├── analysis_results.csv
│   ├── backup_20251121.sql
│   ├── event_analyses.csv
│   ├── firewall_logs.csv
│   ├── login_events.csv
│   ├── performance_analysis.png
│   ├── performance_metrics.csv
│   ├── public_event_analyses.csv
│   ├── risk_score_distribution_custom.png
│   ├── risk_score_distribution_data.csv
│   ├── selected_data.sql
│   ├── sql_combine_and_analysis_script
│   └── summary_report.txt
├── docker-compose.yml         # Service orchestration
├── README.md
├── DASHBOARD_README.md        # Dashboard documentation
└── DASHBOARD_QUICKSTART.md    # Quick start guide
```

## 🔧 Configuration

### Environment Variables

**Backend:**
- `DATABASE_URL`: PostgreSQL connection string (default: `postgresql://postgres:postgres@db:5432/cyber_events`)
- `AGENT_URL`: AI Agent endpoint (default: `http://agent:8000/evaluate-event`)

**Agent:**
- `OLLAMA_URL`: Ollama API endpoint (default: `http://ollama:11434/api/generate`)
- `OLLAMA_MODEL`: Model to use (default: `mistral`)

## 🔍 Monitoring Events

### Web Dashboard (Recommended) 🆕

The easiest way to view events is through the **Security Dashboard**:

1. Open http://localhost:3000 in your browser
2. View real-time alerts and statistics
3. Filter by severity or event type
4. Click any alert to see detailed analysis

See [DASHBOARD_QUICKSTART.md](DASHBOARD_QUICKSTART.md) for details.

### View Database Events

Connect to the database:
```bash
docker exec -it cyber-events-db psql -U postgres -d cyber_events
```

Query events:
```sql
-- View recent login events
SELECT * FROM login_events ORDER BY timestamp DESC LIMIT 10;

-- View high-risk analyses
SELECT * FROM event_analyses WHERE severity IN ('high', 'critical') ORDER BY analyzed_at DESC;

-- Count events by type
SELECT event_type, COUNT(*) FROM event_analyses GROUP BY event_type;
```

### View Logs

```bash
# Backend logs (event generation)
docker logs -f cyber-backend

# Agent logs (analysis results)
docker logs -f cyber-agent

# Dashboard logs
docker logs -f cyber-dashboard

# Ollama logs
docker logs -f ollama-mistral
```

## 📊 Data Generation Schedule

Events are generated every **30 minutes** with the following quantities:

- **Login Events**: 20-80 per cycle
  - 10-20% failed logins
  - 1 brute-force burst every 12 hours
  - 15-30% night-time logins
  - 5% admin accounts

- **Firewall Events**: 100-300 per cycle
  - Random ALLOW/DENY mix
  - 1 port scan every 24 hours
  - 1-2 lateral movement attempts per day

- **Patch Events**: Updated continuously
  - 30% devices outdated
  - 8-10% missing critical patches
  - 15-20% missing high patches

## 🧪 Testing the Agent

Send a manual event to the agent:

```bash
curl -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "admin",
      "src_ip": "203.0.113.45",
      "status": "FAIL",
      "timestamp": "2025-11-14T03:22:10",
      "device_id": "UNKNOWN-DEVICE",
      "auth_method": "password",
      "is_burst_failure": true,
      "is_suspicious_ip": true,
      "is_admin": true
    }
  }'
```

Expected response:
```json
{
  "event_type": "login",
  "risk_score": 120,
  "severity": "critical",
  "reasoning": "Failed login attempt (+30); 3rd+ failure in short time window (+20); Login during 00:00-05:00 hours (+10); Admin account targeted (+40); Suspicious source IP detected (+30)",
  "recommended_action": "IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP"
}
```

## 🛑 Stopping the System

```bash
# Stop all services
docker-compose down

# Stop and remove all data
docker-compose down -v
```

## 🔄 Restarting Services

```bash
# Restart all services
docker-compose restart

# Restart specific service
docker-compose restart backend
docker-compose restart agent
```

## 📝 Troubleshooting

### Ollama model not loading
```bash
# Manually pull the model
docker exec -it ollama-mistral ollama pull mistral
```

### Database connection errors
```bash
# Check if database is healthy
docker-compose ps db

# Restart database
docker-compose restart db
```

### Agent not responding
```bash
# Check agent logs
docker logs cyber-agent

# Verify Ollama is running
curl http://localhost:11434/api/tags
```

### Events not generating
```bash
# Check backend logs
docker logs cyber-backend

# Verify database connection
docker exec cyber-backend python -c "from database import engine; print(engine.url)"
```

## 🎓 Educational Use

This system is designed for:
- Cybersecurity training and education
- SOC analyst practice
- Understanding security event analysis
- Learning AI-assisted threat detection
- Experimenting with different event patterns

## 🔒 Security Notes

**This is a simulation system for educational purposes only.**

- Uses synthetic data only
- Should be run in isolated environments
- Not intended for production use
- Default credentials should be changed if exposed

## 📚 API Documentation

When the agent is running, visit http://localhost:8000/docs for interactive API documentation powered by Swagger UI.

## 🤝 Contributing

This project was created for the 492-Energy-Defense cybersecurity course. Contributions and improvements are welcome!

## 📄 License

See LICENSE file for details.

## 🆘 Support

For issues or questions:
1. Check the logs: `docker-compose logs`
2. Verify all services are healthy: `docker-compose ps`
3. Review this README's troubleshooting section

---

**Built with ❤️ for cybersecurity education**
