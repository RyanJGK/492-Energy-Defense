# API Examples and Usage

This document provides practical examples for using the AI Agent service.

## Table of Contents
- [Basic Queries](#basic-queries)
- [IT Infrastructure](#it-infrastructure)
- [Cybersecurity Analysis](#cybersecurity-analysis)
- [Log Analysis](#log-analysis)
- [Configuration Review](#configuration-review)
- [Threat Intelligence](#threat-intelligence)

---

## Basic Queries

### Hello World
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{"query": "Hello, introduce yourself"}'
```

### Service Information
```bash
curl http://localhost:8000/
```

### Health Check
```bash
curl http://localhost:8000/health
```

---

## IT Infrastructure

### Network Security
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What are the essential firewall rules for a SCADA system in an energy facility?"
  }'
```

### System Hardening
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Provide a checklist for hardening a Linux server in an industrial environment"
  }'
```

### Backup Strategy
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What backup strategy should we implement for critical infrastructure systems?"
  }'
```

---

## Cybersecurity Analysis

### SSH Security Best Practices
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "List 5 critical SSH security best practices for industrial control systems"
  }'
```

### Vulnerability Assessment
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What are common vulnerabilities in SCADA systems and how can they be mitigated?"
  }'
```

### Incident Response
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What are the first steps when detecting a potential security breach in an OT network?"
  }'
```

### Zero Trust Architecture
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "How can we implement zero trust principles in an energy sector IT environment?"
  }'
```

---

## Log Analysis

### Failed Login Analysis
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Analyze this log: Failed password for root from 192.168.1.100 port 22 ssh2. What actions should I take?"
  }'
```

### Suspicious Network Traffic
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "I see unusual traffic to port 4444 from multiple internal hosts. What could this indicate?"
  }'
```

### Repeated Authentication Failures
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "We have 50 failed login attempts from 10.0.0.50 in the last hour. Is this a brute force attack?"
  }'
```

---

## Configuration Review

### SSH Configuration Review
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Review this SSH config: PermitRootLogin yes, PasswordAuthentication yes, Port 22. What are the security issues?"
  }'
```

### Firewall Rules Review
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Review these iptables rules: ACCEPT all on 0.0.0.0/0, ACCEPT tcp port 22, ACCEPT tcp port 80. What is wrong?"
  }'
```

### TLS Configuration
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What TLS versions and cipher suites should we use for securing HTTPS on our industrial web interfaces?"
  }'
```

---

## Threat Intelligence

### Ransomware Prevention
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What preventive measures should we implement to protect against ransomware in an energy facility?"
  }'
```

### APT Detection
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What are indicators of Advanced Persistent Threats (APT) in industrial networks?"
  }'
```

### Supply Chain Security
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "How can we secure our supply chain for industrial control system components?"
  }'
```

---

## Custom Context Example

For specialized contexts beyond the default IT/cybersecurity focus:

```bash
curl -X POST http://localhost:8000/query/custom \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Explain the OSI model",
    "context": "You are a network engineering instructor. Explain concepts clearly with practical examples."
  }'
```

---

## Batch Testing with jq

Process multiple queries and extract responses:

```bash
# Create a queries file
cat > queries.json << 'EOF'
[
  {"query": "What is two-factor authentication?"},
  {"query": "Explain DMZ in network security"},
  {"query": "What is a SIEM system?"}
]
EOF

# Process each query
cat queries.json | jq -c '.[]' | while read query; do
  echo "Query: $(echo $query | jq -r '.query')"
  curl -s -X POST http://localhost:8000/query \
    -H "Content-Type: application/json" \
    -d "$query" | jq -r '.response'
  echo "---"
done
```

---

## Python Client Example

```python
import requests

API_URL = "http://localhost:8000"

def query_agent(question: str) -> str:
    """Send a query to the AI agent."""
    response = requests.post(
        f"{API_URL}/query",
        json={"query": question}
    )
    response.raise_for_status()
    return response.json()["response"]

# Example usage
if __name__ == "__main__":
    questions = [
        "What is network segmentation?",
        "How do I secure a REST API?",
        "Explain the principle of least privilege"
    ]
    
    for q in questions:
        print(f"\nQ: {q}")
        print(f"A: {query_agent(q)}\n")
        print("-" * 80)
```

---

## JavaScript/Node.js Client Example

```javascript
const axios = require('axios');

const API_URL = 'http://localhost:8000';

async function queryAgent(question) {
  const response = await axios.post(`${API_URL}/query`, {
    query: question
  });
  return response.data.response;
}

// Example usage
(async () => {
  const questions = [
    'What is defense in depth?',
    'Explain VPN security',
    'What are security zones in OT networks?'
  ];

  for (const q of questions) {
    console.log(`\nQ: ${q}`);
    const answer = await queryAgent(q);
    console.log(`A: ${answer}\n`);
    console.log('-'.repeat(80));
  }
})();
```

---

## Performance Tips

1. **Batch similar queries** - Keep context warm
2. **Use specific questions** - Get more focused responses
3. **Monitor response times** - Adjust timeout if needed
4. **Enable GPU** - For faster inference (see README)
5. **Use smaller models** - If speed is critical (e.g., mistral:7b-instruct-q4_0)

---

## Error Handling

### Empty Query
```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{"query": ""}'
# Returns: 400 Bad Request
```

### Service Unavailable
```bash
# If Ollama is down, you'll get:
# 503 Service Unavailable
# {"detail": "AI service unavailable: ..."}
```

### Timeout
If a query takes too long:
```bash
# Increase timeout in docker-compose.yml:
# environment:
#   - OLLAMA_TIMEOUT=300
```

---

For more information, see the main [README.md](README.md).
