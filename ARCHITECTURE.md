# System Architecture

## 🏗️ Component Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                    492-ENERGY-DEFENSE SYSTEM                    │
└─────────────────────────────────────────────────────────────────┘

┌──────────────────────┐         ┌──────────────────────┐
│   BACKEND SERVICE    │         │    AI AGENT SERVICE  │
│   (Port: Internal)   │◄───────►│    (Port: 8000)      │
├──────────────────────┤         ├──────────────────────┤
│ • Data Generator     │  HTTP   │ • FastAPI            │
│ • Event Dispatcher   │  POST   │ • Event Analyzer     │
│ • APScheduler        │  /eval  │ • Risk Scorer        │
│ • Runs every 30 min  │         │ • JSON Response      │
└──────────┬───────────┘         └──────────┬───────────┘
           │                                │
           │ Stores                        │ Optionally uses
           │ Events                        │ (currently rule-based)
           ▼                                ▼
┌──────────────────────┐         ┌──────────────────────┐
│  POSTGRESQL DB       │         │   OLLAMA SERVICE     │
│  (Port: 5432)        │         │   (Port: 11434)      │
├──────────────────────┤         ├──────────────────────┤
│ Tables:              │         │ • Qwen Model         │
│ • login_events       │         │ • LLM Inference      │
│ • firewall_logs      │         │ • 4GB+ RAM           │
│ • patch_levels       │         └──────────────────────┘
│ • event_analyses     │
└──────────────────────┘
```

## 🔄 Data Flow

### Event Generation Cycle (Every 30 Minutes)

```
1. SCHEDULER TRIGGERS
   └─> Backend Service (scheduler.py)

2. DATA GENERATION
   ├─> Generate 20-80 Login Events
   ├─> Generate 100-300 Firewall Events
   └─> Update Patch Levels
       └─> Store in PostgreSQL

3. EVENT DISPATCH (One-by-one)
   └─> For each event:
       ├─> POST to AI Agent (/evaluate-event)
       ├─> Receive JSON analysis
       └─> Store analysis in event_analyses table

4. CONTINUOUS MONITORING
   └─> Results available in database
```

## 📊 Event Processing Pipeline

```
┌─────────────┐
│ Login Event │──┐
└─────────────┘  │
                 │
┌─────────────┐  │    ┌──────────────┐    ┌──────────────┐
│Firewall Event├──┼───►│ Event        │───►│  AI Agent    │
└─────────────┘  │    │ Dispatcher   │    │  Analyzer    │
                 │    └──────────────┘    └──────┬───────┘
┌─────────────┐  │                               │
│ Patch Event │──┘                               │
└─────────────┘                                  │
                                                 ▼
                                      ┌──────────────────┐
                                      │  Risk Assessment │
                                      ├──────────────────┤
                                      │ • risk_score     │
                                      │ • severity       │
                                      │ • reasoning      │
                                      │ • recommended_   │
                                      │   action         │
                                      └──────────────────┘
```

## 🎯 Risk Scoring Engine

### Algorithm Flow

```
INPUT: Single Event
  │
  ├─> Parse Event Type (login/firewall/patch)
  │
  ├─> Initialize score = 0
  │
  ├─> Apply Conditional Weights
  │   ├─> Check condition 1 → Add weight if true
  │   ├─> Check condition 2 → Add weight if true
  │   ├─> Check condition 3 → Add weight if true
  │   └─> ... (all conditions)
  │
  ├─> Calculate Severity
  │   ├─> 0-20:   low
  │   ├─> 21-40:  medium
  │   ├─> 41-70:  high
  │   └─> 71+:    critical
  │
  ├─> Generate Reasoning (list triggered conditions)
  │
  └─> Generate Recommended Action (based on severity)

OUTPUT: JSON Risk Assessment
```

## 🔐 Security Event Types Detail

### Login Event Analysis

```
INPUT DATA:
  • username
  • src_ip
  • status (SUCCESS/FAIL)
  • timestamp
  • device_id
  • auth_method
  • is_burst_failure (boolean)
  • is_suspicious_ip (boolean)
  • is_admin (boolean)

ANALYSIS CHECKS:
  1. Status == "FAIL" → +30
  2. is_burst_failure == true → +20
  3. Hour between 00:00-05:00 → +10
  4. is_admin == true → +40
  5. is_suspicious_ip == true → +30

EXAMPLE OUTPUT:
  {
    "event_type": "login",
    "risk_score": 120,
    "severity": "critical",
    "reasoning": "Failed login (+30); 3rd+ failure (+20); 
                  Night login (+10); Admin account (+40); 
                  Suspicious IP (+30)",
    "recommended_action": "IMMEDIATE: Lock account, investigate 
                          source IP, review all recent activity"
  }
```

### Firewall Event Analysis

```
INPUT DATA:
  • src_ip
  • dst_ip
  • action (ALLOW/DENY)
  • port
  • protocol
  • timestamp
  • is_port_scan (boolean)
  • is_lateral_movement (boolean)
  • is_malicious_range (boolean)
  • is_connection_spike (boolean)

ANALYSIS CHECKS:
  1. is_connection_spike == true → +20
  2. is_malicious_range == true → +40
  3. is_port_scan == true → +35
  4. is_lateral_movement == true → +25
  5. port in [4444, 1337, ...] → +20
```

### Patch Event Analysis

```
INPUT DATA:
  • device_id
  • os
  • last_patch_date
  • missing_critical
  • missing_high
  • update_failures
  • is_unsupported (boolean)

ANALYSIS CHECKS:
  1. missing_critical > 0 → +50
  2. missing_high > 0 → +35
  3. (today - last_patch_date) > 60 days → +15
  4. update_failures > 0 → +20
  5. is_unsupported == true → +40
```

## 🐳 Docker Service Dependencies

```
┌────────────────────────────────────────────────────┐
│                 Docker Network                      │
│              (cyber-defense-network)                │
│                                                     │
│  ┌──────────┐                                      │
│  │ Postgres │ ◄─── Backend depends on DB          │
│  └────┬─────┘                                      │
│       │                                            │
│  ┌────▼─────┐                                      │
│  │  Ollama  │ ◄─── Agent depends on Ollama        │
│  └────┬─────┘                                      │
│       │                                            │
│  ┌────▼─────┐                                      │
│  │  Agent   │ ◄─── Backend depends on Agent       │
│  └────┬─────┘                                      │
│       │                                            │
│  ┌────▼─────┐                                      │
│  │ Backend  │ ◄─── Starts after all ready         │
│  └──────────┘                                      │
│                                                     │
└─────────────────────────────────────────────────────┘
```

## 📦 Volume Management

```
postgres_data/          # Persistent database storage
  └─> Tables: login_events, firewall_logs, 
              patch_levels, event_analyses

ollama_data/           # Qwen model storage (~400MB)
  └─> Models: qwen2.5:0.5b (downloaded on first run)
```

## 🔌 Network Ports

```
Host Machine              Docker Network
─────────────────────────────────────────

localhost:5432      ◄──► db:5432        (PostgreSQL)
localhost:8000      ◄──► agent:8000     (AI Agent API)
localhost:11434     ◄──► ollama:11434   (Ollama API)

Internal only:
  backend:* (no exposed ports, internal service)
```

## 🎯 Key Design Decisions

### 1. Event-by-Event Processing
- **Why**: Meets spec requirement for single-event analysis
- **How**: Dispatcher sends individual POST requests
- **Benefit**: Real-time analysis, no batch delays

### 2. Deterministic Scoring
- **Why**: Fast, consistent, predictable results
- **How**: Rule-based weight application
- **Benefit**: No LLM latency, perfect for education

### 3. Separate Services
- **Why**: Microservices architecture
- **How**: Independent containers with clear interfaces
- **Benefit**: Scalable, maintainable, testable

### 4. 30-Minute Cycles
- **Why**: Balance between data volume and realism
- **How**: APScheduler with interval trigger
- **Benefit**: Manageable event rates for learning

### 5. Attack Pattern Injection
- **Why**: Simulate real-world threats
- **How**: Timed injections (brute-force, port scans)
- **Benefit**: Demonstrates critical severity events

## 🚀 Startup Sequence

```
1. docker-compose up
   ├─> Start Postgres (wait for healthy)
   ├─> Start Ollama (wait for healthy)
   ├─> Download Qwen model (ollama-init)
   ├─> Start Agent (wait for healthy)
   └─> Start Backend
       ├─> Initialize database tables
       ├─> Run first event generation cycle
       └─> Schedule future cycles (every 30 min)

2. System Ready
   └─> Events generating and being analyzed
```

## 📈 Performance Characteristics

- **Event Generation**: 120-380 events per 30-minute cycle
- **Analysis Speed**: <1 second per event (deterministic)
- **Database Size**: ~1MB per day (varies with event volume)
- **Memory Usage**: 
  - Backend: ~200MB
  - Agent: ~300MB
  - Ollama: 4-8GB
  - Database: ~100MB
- **CPU Usage**: Low (spikes during 30-min cycles)

## 🔒 Security Considerations

This is an **educational simulation** system:
- ✅ Uses synthetic data only
- ✅ No real credentials
- ✅ Isolated Docker network
- ✅ No external network access required
- ⚠️ Default passwords (change in production!)
- ⚠️ No authentication on APIs (by design)

---

**Architecture designed for educational clarity and ease of use! 🎓**
