# GridGuard AI — Energy Sector Defense

**Course:** INFO 498B — Agentic Cybersecurity with AI & LLMs  
**Team:** Team 1 – Arona Cho, Cloe Cha, Paulina Teran, Ryan Kelleher  

**One-line pitch:** A unified, agentic defense system built for energy-sector cybersecurity professionals to securely manage access and detect threats in real time to protect critical infrastructure.

---

## 1) Live Demo

**Synthetic Industry:** IT events generated in the context of an Energy Company
**Status:** Up/Down  
**Test Credentials:** N/A

**Agentic System:** Rule based system for judgement of logs with Agentic Analysis done by qwen model  
**Status:** Up/Down  
**Notes:** Dashboard running on Hetzner or locally with Ollama-based analysis

**Logs/Observability:** Available via Docker logs (`docker logs cyber-agent`, `docker logs cyber-backend`)

---

## 2) Thesis & Outcome

**Original thesis (week 2):**  
Agentic AI, combined with MFA and a substation operator dashboard, can reduce incident response times to transformer anomalies by at least 10% while providing audit-ready compliance evidence for utilities.

**Final verdict:** False

**Why (top evidence):**

1. **Model Context Limitations:** Lower-tier models (Qwen 0.6B, 1.5B) could not process the full context we provided to Mistral 7B, leading to incomplete rule application and inaccurate threat labeling. Only one of several rulesets would be processed, causing the system to miss critical threats.

2. **Accuracy vs. Performance Trade-off:** While the Mistral 7B model provided accurate analysis, the computational requirements made it unsuitable for real-time detection at scale. Switching to static scripts improved speed but reduced the agentic nature of the system, contradicting our original hypothesis about AI-driven analysis.

3. **Integration Complexity:** Creating a truly unified system proved more challenging than anticipated. During Demo 3, stakeholder feedback from Puget Sound Energy cyber defense employees emphasized the critical importance of preventing users from being split across multiple tools—a challenge we addressed through role-based interfaces but which added complexity that impacted response time improvements.

---

## 3) What We Built

**Synthetic Industry:**
- Event generator producing login, firewall, and patch update events
- PostgreSQL database storing security events (4 tables: `login_events`, `firewall_logs`, `patch_levels`, `event_analyses`)
- Realistic attack patterns: brute-force attacks (every 12 hours), port scans (every 24 hours), lateral movement attempts
- Continuous operation capability (tested for 48+ hours on Hetzner)

**Agentic System:**
- AI Agent using Ollama (Mistral 7B, tested with Qwen 0.6B/1.5B)
- FastAPI-based analysis endpoint evaluating events one-by-one
- Risk scoring engine applying conditional weights (login: 0-155 pts, firewall: 0-140 pts, patch: 0-160 pts)
- Severity classification: Low (0-20), Medium (21-40), High (41-70), Critical (71+)
- Event dispatcher with parallel processing (up to 10 workers)
- Web dashboard for real-time monitoring and case review
- Automatic fallback from LLM to rule-based analysis on failure

**Key Risks Addressed (or Exercised):**
- Failed authentication and brute-force attacks on critical accounts
- Port scanning and lateral movement detection
- Missing critical patches and outdated systems
- Night-time access anomalies
- Suspicious IP ranges and device identification
- Admin account targeting

---

## 4) Roles, Auth, Data

**Roles & Permissions:**
- **SOC Analyst** → View alerts, filter by severity/type, review case details, mark false positives (dashboard interface)
- **Security Engineer** → Access API endpoints, query database, configure alert rules
- **System Administrator** → Manage Docker containers, configure database, monitor resources

**Authentication:**
- Current implementation: Synthetic environment with no authentication (educational lab)
- Database access: PostgreSQL credentials (`postgres:postgres`)
- API access: Unauthenticated FastAPI endpoints (localhost only by default)
- Role-based interfaces designed but authentication not implemented for lab environment

**Data:**
- **100% synthetic data only**
- Event generator creates realistic but fake security events
- No real credentials, organizations, or production systems involved
- Schema:
  - `login_events`: username, src_ip, status, timestamp, device_id, auth_method, boolean flags
  - `firewall_logs`: src_ip, dst_ip, port, protocol, action, timestamp, anomaly flags
  - `patch_levels`: device_id, os, last_patch_date, missing patches, update status
  - `event_analyses`: event_type, risk_score, severity, reasoning, recommended_action

---

## 5) Experiments Summary (Demos #3 - #5)

**Demo #3:**  
**Hypothesis:** Role-based interfaces can create a unified system that prevents security analysts from being split across multiple tools.  
**Setup:** Stakeholder interviews with Puget Sound Energy cyber defense employees, design of role-specific dashboards.  
**Result:** Pass – Stakeholders validated the importance of unified systems; focused our direction on streamlined workflows supporting specific user responsibilities.  
**Evidence:** Meeting notes, dashboard mockups, interface design incorporating stakeholder feedback.

**Demo #4 (continuous run):**  
**Setup:** Deployed both synthetic industry and agentic defense system on Hetzner server, ran continuously for 48 hours.  
**Uptime:** ~95.8% (brief interruption for configuration adjustment)  
**Incidents:** 287 total events generated, 23 critical alerts, 45 high-priority alerts  
**Improvement observed:** Yes – System successfully maintained continuous operation, but frontend simplification was required for effective backend connectivity. Demonstrated feasibility of cloud deployment for real-world scenarios.  
**Evidence:** Server logs, event analysis database records, uptime monitoring data.

**Demo #5 (final):**  
**What was validated:** Testing lower-tier models (Qwen 0.6B, 1.5B) as alternatives to Mistral 7B for resource efficiency.  
**Result:** Failed – Models appeared functional initially but deeper log analysis revealed incomplete context processing. Only one ruleset processed per event instead of all rules, causing critical misclassifications. Switched to hybrid approach (static scripts + Qwen analysis) but lost agentic capabilities.  
**Evidence:** Analysis logs showing incomplete rule application, comparison of detection rates between models, test results demonstrating accuracy degradation.

---

## 6) Key Results (plain text)

**Effectiveness:**
- Detection accuracy with Mistral 7B: ~92% for known attack patterns
- Detection accuracy with Qwen models: ~45-60% (unacceptable for production)
- Attack pattern recognition: Successfully identified 95% of injected brute-force and port scan attempts
- False positive rate: ~8% with rule-based analysis, ~15% with smaller LLM models
- Mean Time To Detection (MTTD): Real-time (< 5 seconds per event with Mistral)

**Reliability:**
- Uptime during 48-hour Hetzner deployment: 95.8%
- Event processing success rate: 99.1% (with LLM fallback to rules)
- Error patterns: Occasional JSON parsing failures from LLM (3-5% of requests), automatic fallback prevented data loss
- Database stability: No data loss or corruption events
- Container health: All services remained healthy throughout continuous operation

**Safety:**
- Policy violations blocked: N/A (educational environment, no enforcement implemented)
- Guardrails that mattered: 
  - LLM output validation (JSON schema enforcement)
  - Automatic fallback to deterministic rules when LLM fails
  - Risk score bounds checking (0-200 range)
  - Event type validation before processing

---

## 7) How to Use / Deploy

**Prerequisites:**
- Docker and Docker Compose installed
- 8GB+ RAM available (16GB recommended for LLM mode)
- 10GB+ free disk space (for Ollama model)
- (Optional) Hetzner Cloud account for production deployment

**Environment Variables:**
- `DATABASE_URL`: PostgreSQL connection (default: `postgresql://postgres:postgres@db:5432/cyber_events`)
- `AGENT_URL`: AI agent endpoint (default: `http://agent:8000/evaluate-event`)
- `USE_LLM`: Enable LLM mode (default: `true`, set to `false` for fast rule-based mode)
- `OLLAMA_URL`: Ollama API (default: `http://ollama:11434/api/generate`)
- `OLLAMA_MODEL`: Model name (default: `mistral`)

**Local Deploy Steps:**

```bash
# 1. Clone repository
git clone <repository-url>
cd workspace

# 2. Start all services
docker-compose up -d

# 3. Wait for initialization (5-10 minutes for first run)
# Ollama will download Mistral model (~4GB)

# 4. Verify services are healthy
docker-compose ps

# 5. Access dashboard
# Dashboard: http://localhost:3000
# Agent API: http://localhost:8000
# API Docs: http://localhost:8000/docs
```

**Hetzner Deploy Steps:**
See `HETZNER_DEPLOYMENT_GUIDE.md` for complete instructions.

**Test Steps:**

```bash
# Test agent health
curl http://localhost:8000/health

# Test event analysis
curl -X POST http://localhost:8000/evaluate-event \
  -H "Content-Type: application/json" \
  -d '{
    "type": "login",
    "data": {
      "username": "admin",
      "src_ip": "203.0.113.45",
      "status": "FAIL",
      "timestamp": "2025-12-06T03:22:10",
      "device_id": "UNKNOWN",
      "auth_method": "password",
      "is_burst_failure": true,
      "is_suspicious_ip": true,
      "is_admin": true
    }
  }'

# View generated events in database
docker exec -it cyber-events-db psql -U postgres -d cyber_events \
  -c "SELECT event_type, severity, risk_score FROM event_analyses ORDER BY analyzed_at DESC LIMIT 10;"

# Check backend logs for event generation
docker logs cyber-backend | grep "generation cycle"

# Check agent logs for analysis results
docker logs cyber-agent | grep "Analysis complete"
```

**Full test suite:** See `test.sh` for automated testing.

---

## 8) Safety, Ethics, Limits

**Data Safety:**
- Synthetic data only; no real credentials or organizational systems
- All events, users, IPs, and devices are fabricated for educational purposes
- Safe to share and demonstrate without privacy concerns

**Controls:**
- Role-based dashboard interfaces (design implemented, authentication not enforced in lab)
- Event generation throttling (30-minute cycles, reduced volume in LLM mode)
- Docker container isolation and resource limits
- LLM output validation and JSON schema enforcement
- Automatic fallback to rule-based analysis prevents total system failure

**Known Limits/Failure Modes:**
1. **Model Context Limitations:** Smaller LLMs (< 7B parameters) fail to process full context, leading to incomplete analysis
2. **LLM Variability:** Non-deterministic outputs can cause inconsistent severity classifications for similar events
3. **Resource Requirements:** Mistral 7B requires 4-8GB RAM; unsuitable for resource-constrained environments
4. **Scalability:** LLM mode limited to ~50 events per 30-minute cycle; rule-based mode handles 400+ events
5. **No Attack Prevention:** System is detective only, not preventive (does not block or remediate threats)
6. **Single Point of Failure:** Database downtime prevents all event storage and analysis
7. **False Positives:** 8-15% false positive rate requires human review
8. **Deployment Complexity:** Frontend simplification required for remote deployment

---

## 9) Final Deliverables

**1000-word paper:**  
https://docs.google.com/document/d/1MLB-avnSvTWLlgeR6PMvMUAh4qnEAzf8bnf2sfPYxO8/edit?tab=t.0#heading=h.knpcf56rqc9h

**Slides:**  
https://www.figma.com/slides/TCuRCrIIHQBrGQtWCKIysC/492-Final?node-id=1-250&t=dXKeeceEVuEa7HF4-1

**Evidence folder (logs/screens):**  
See `model_analysis/` directory containing:
- `analysis_results.csv` – Event analysis outputs
- `performance_metrics.csv` – System performance data
- `event_analyses.csv` – Complete analysis dataset
- `summary_report.txt` – Test run summary
- Performance visualizations and distribution charts

**Additional Documentation:**
- `ARCHITECTURE.md` – System architecture and data flow
- `LLM_MODE_IMPLEMENTATION.md` – LLM integration details
- `HETZNER_DEPLOYMENT_GUIDE.md` – Production deployment instructions
- `DASHBOARD_README.md` – Dashboard usage guide

---

## 10) Next Steps

**Top Improvement 1: Hybrid Intelligence Architecture**  
Implement a two-stage analysis system combining fast rule-based pre-filtering with selective LLM analysis for complex cases. Route only high-risk or ambiguous events to the LLM, reducing computational overhead by ~80% while maintaining accuracy. This addresses the scalability limitations discovered in Demo 5.

**Top Improvement 2: Fine-Tuned Domain Model**  
Fine-tune a smaller model (Qwen 3-7B) specifically on energy sector security events to improve context understanding within resource constraints. Create a curated dataset of critical infrastructure attack patterns to overcome the context processing failures observed with off-the-shelf small models.

**Top Improvement 3: Automated Remediation Integration**  
Extend from detective to preventive capabilities by integrating with access control systems. Implement automatic account lockouts, IP blocking, and alert escalation based on severity thresholds. Add authentication and role-based access control to enable production deployment with proper authorization guardrails.

---

## Project Structure

```
workspace/
├── agent/                      # AI Agent Service
│   ├── main.py                # FastAPI application with LLM/rule-based analysis
│   ├── Dockerfile
│   └── requirements.txt
├── backend/                    # Backend Service
│   ├── database.py            # Database configuration
│   ├── models.py              # SQLAlchemy models (4 tables)
│   ├── data_generator.py     # Synthetic event generation
│   ├── event_dispatcher.py   # Parallel event dispatch to agent
│   ├── scheduler.py           # 30-minute cycle scheduler
│   ├── Dockerfile
│   └── requirements.txt
├── dashboard/                  # Web Dashboard
│   ├── main.py                # Dashboard API
│   ├── static/
│   │   ├── index.html         # Alerts & Anomalies page
│   │   ├── case-review.html   # Case Review page
│   │   └── styles.css         # Modern dark theme
│   ├── Dockerfile
│   └── requirements.txt
├── model_analysis/             # Analysis Results & Evidence
│   ├── analysis_results.csv
│   ├── performance_metrics.csv
│   ├── event_analyses.csv
│   └── summary_report.txt
├── docker-compose.yml         # Service orchestration
├── README.md                  # This file
├── ARCHITECTURE.md
├── LLM_MODE_IMPLEMENTATION.md
├── HETZNER_DEPLOYMENT_GUIDE.md
└── DASHBOARD_README.md
```

---

## Quick Start

```bash
# Start the system
docker-compose up -d

# Wait 5-10 minutes for initialization

# Access dashboard
open http://localhost:3000

# Check agent health
curl http://localhost:8000/health

# View logs
docker logs -f cyber-backend  # Event generation
docker logs -f cyber-agent    # Analysis results

# Stop the system
docker-compose down
```

---

## Monitoring & Troubleshooting

**View real-time alerts:**  
Open http://localhost:3000 in your browser for the security dashboard.

**Check database:**
```bash
docker exec -it cyber-events-db psql -U postgres -d cyber_events
```

**Common Issues:**
- **Ollama not loading:** `docker exec ollama-mistral ollama pull mistral`
- **Agent not responding:** `docker-compose restart agent`
- **No events generating:** Check `docker logs cyber-backend` for errors
- **High memory usage:** Switch to rule-based mode (`USE_LLM=false`)

See `TROUBLESHOOTING.md` for detailed solutions.

---

## Performance Notes

**Event Generation:**
- LLM Mode: 23-57 events per 30-minute cycle
- Rule-Based Mode: 120-432 events per 30-minute cycle

**Analysis Speed:**
- LLM Mode (Mistral 7B): 1-5 seconds per event
- Rule-Based Mode: <0.1 seconds per event

**Resource Usage:**
- LLM Mode: 4-8GB RAM (Ollama), ~300MB (Agent), ~200MB (Backend)
- Rule-Based Mode: ~300MB (Agent), ~200MB (Backend), ~100MB (Database)

---

## Educational Use

This system is designed for:
- Cybersecurity training and education
- SOC analyst practice and skill development
- Understanding AI-assisted threat detection
- Learning event analysis and risk scoring
- Experimenting with agentic security systems
- Evaluating LLM performance in security contexts

**Not intended for production use without significant hardening and authentication implementation.**

---

## Maintainers

**Ryan Kelleher** • Contact: rjgk@uw.edu

**Team Members:**
- Arona Cho
- Cloe Cha  
- Paulina Teran
- Ryan Kelleher

**Course:** INFO 498B – Agentic Cybersecurity with AI & LLMs  
**Institution:** University of Washington  
**Academic Year:** 2024-2025

---

## License

See `LICENSE` file for details.

---

**Built for cybersecurity education and energy sector infrastructure protection research.**
