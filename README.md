# 🛡️ Cybersecurity AI Agent

A standalone cybersecurity AI agent powered by Ollama and the Mistral model. This agent performs intelligent threat detection and security analysis on login attempts, firewall logs, and patch status data—completely offline using local LLM inference.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Node.js](https://img.shields.io/badge/Node.js-18%2B-green.svg)](https://nodejs.org/)
[![Ollama](https://img.shields.io/badge/Ollama-Required-blue.svg)](https://ollama.ai/)

## 🎯 Features

- **Login Attempt Analysis**: Detect brute force attacks, credential stuffing, off-hours access, and geographic anomalies
- **Firewall Log Analysis**: Identify port scans, intrusion attempts, suspicious protocol usage, and repeated blocks
- **Patch Status Analysis**: Find critical vulnerabilities, missing patches, EOL software, and compliance gaps
- **Risk Scoring**: Calculate composite 0-100 risk scores with severity levels (Critical/High/Medium/Low)
- **Mitigation Recommendations**: Generate actionable security recommendations based on detected threats
- **Offline Operation**: Works completely offline using local Ollama—no external API calls
- **Production-Quality Code**: Modular architecture, error handling, logging, and comprehensive tests

## 📁 Project Structure

```
cybersecurity-ai-agent/
├── agent/                      # Core AI agent logic
│   ├── cybersecurityAgent.js  # Main agent class
│   └── analysisEngine.js      # Multi-step analysis workflow
├── services/                   # Business logic services
│   ├── ollamaService.js       # Ollama/Mistral integration
│   └── dataProcessor.js       # Data normalization & feature extraction
├── config/                     # Configuration files
│   ├── agentConfig.js         # Agent settings & thresholds
│   └── prompts.js             # LLM prompts & templates
├── utils/                      # Helper utilities
│   └── formatters.js          # Output formatting & display
├── data/                       # Sample test datasets
│   ├── sampleLogins.json      # Login attempt samples
│   ├── sampleFirewallLogs.json # Firewall log samples
│   └── samplePatchData.json   # Patch status samples
├── tests/                      # Test suite
│   ├── testAgent.js           # Individual function tests
│   ├── testIntegration.js     # Full pipeline integration test
│   └── testPrompts.js         # LLM prompt effectiveness test
├── index.js                    # CLI interface
├── package.json                # Dependencies
├── .env.example               # Environment configuration template
└── README.md                  # This file
```

## 🚀 Quick Start

### Prerequisites

1. **Node.js 18+** installed
2. **Ollama** installed and running
3. **Mistral model** pulled in Ollama

### Installation

```bash
# 1. Clone or download this project
cd cybersecurity-ai-agent

# 2. Install dependencies
npm install

# 3. Install Ollama (if not already installed)
# Visit: https://ollama.ai/download

# 4. Start Ollama service
ollama serve

# 5. Pull Mistral model (in a new terminal)
ollama pull mistral

# 6. (Optional) Copy and configure environment variables
cp .env.example .env
```

### First Run

```bash
# Check system health
node index.js health

# Run comprehensive analysis with sample data
node index.js analyze --type all
```

## 📖 Usage

### Command-Line Interface

```bash
# Show all available commands
node index.js --help

# Show usage examples
node index.js examples

# Check agent status and capabilities
node index.js status
```

### Analysis Commands

#### 1. Analyze All Data Types (Recommended)

```bash
node index.js analyze --type all
```

Runs comprehensive analysis on login, firewall, and patch data, then generates a complete security report with composite risk score.

#### 2. Analyze Login Attempts

```bash
node index.js analyze --type login
```

Detects:
- Brute force attacks (rapid failed login attempts)
- Credential stuffing patterns
- Off-hours access attempts
- Geographic anomalies (impossible travel)
- Privileged account targeting

#### 3. Analyze Firewall Logs

```bash
node index.js analyze --type firewall
```

Detects:
- Port scanning activities
- Intrusion attempts
- Suspicious protocol usage (SMB, Telnet, FTP)
- Repeated blocked connections
- High-risk port access attempts

#### 4. Analyze Patch Status

```bash
node index.js analyze --type patch
```

Identifies:
- Critical unpatched vulnerabilities
- High CVSS score CVEs
- End-of-life software
- Compliance violations
- Missing security patches

#### 5. Analyze Custom Data

```bash
# Analyze your own data files
node index.js analyze --type login --file ./my-login-data.json
node index.js analyze --type firewall --file ./my-firewall-logs.json
node index.js analyze --type patch --file ./my-patch-data.json

# Analyze multiple custom files at once
node index.js analyze --type all --login ./custom-logins.json --firewall ./custom-firewall.json --patch ./custom-patches.json
```

### Testing

```bash
# Run all tests
npm test

# Run individual function tests
node index.js test --function all

# Run specific function test
node index.js test --function login
node index.js test --function firewall
node index.js test --function patch
node index.js test --function risk

# Run integration test (full pipeline)
npm run test:integration

# Test prompt effectiveness
npm run test:prompts
```

## 📊 Data Formats

### Login Data Format

```json
[
  {
    "username": "john.doe",
    "sourceIP": "192.168.1.50",
    "timestamp": "2025-11-12T09:15:23Z",
    "success": true,
    "location": "New York, USA",
    "userAgent": "Mozilla/5.0...",
    "sessionId": "sess_12345"
  }
]
```

**Required fields**: `username`, `sourceIP`  
**Optional fields**: `timestamp`, `success`, `location`, `userAgent`, `sessionId`

### Firewall Log Format

```json
[
  {
    "sourceIP": "203.0.113.88",
    "destinationIP": "172.16.0.5",
    "destinationPort": 22,
    "protocol": "SSH",
    "action": "block",
    "timestamp": "2025-11-12T02:30:15Z",
    "bytes": 0
  }
]
```

**Required fields**: `sourceIP`, `destinationPort`  
**Optional fields**: `destinationIP`, `protocol`, `action`, `timestamp`, `bytes`

### Patch Data Format

```json
[
  {
    "hostname": "PROD-WEB-01",
    "os": "Windows Server 2019",
    "lastPatched": "2025-07-01T00:00:00Z",
    "missingPatches": [
      {
        "patchId": "KB5012170",
        "cveId": "CVE-2022-30190",
        "cveScore": 9.8,
        "description": "Remote Code Execution Vulnerability"
      }
    ],
    "complianceStatus": "Non-Compliant",
    "eol": false
  }
]
```

**Required fields**: `hostname`, `os`  
**Optional fields**: `lastPatched`, `missingPatches`, `complianceStatus`, `eol`

## 🎨 Sample Output

### Login Analysis Example

```
═══════════════════════════════════════════════════════════
📋 LOGIN_ANALYSIS
═══════════════════════════════════════════════════════════

📊 Data Summary:
   totalAttempts: 20
   failedAttempts: 12
   successfulAttempts: 8
   failureRate: 60.00%
   uniqueUsers: 5
   uniqueIPs: 8
   anomalyCount: 3

🤖 AI Analysis:
   Threat Detected: YES
   Threat Type: Brute Force Attack
   Severity: HIGH
   Confidence: 95%

📌 Evidence:
   12 failed login attempts for 'admin' account from IP 203.0.113.45 
   within 4 minutes. Attack pattern indicates automated password guessing.

💭 Reasoning:
   Rapid successive failed attempts on privileged account from single 
   source IP indicates brute force attack. Attack velocity (3 attempts/min)
   exceeds normal user behavior threshold.

🛡️  Recommended Actions:
   1. Block source IP 203.0.113.45 immediately at firewall
   2. Enable account lockout policy (5 failed attempts)
   3. Implement multi-factor authentication for admin accounts
   4. Review security logs for successful breaches
```

### Comprehensive Security Report

```
═════════════════════════════════════════════════════════════════
🛡️  COMPREHENSIVE SECURITY REPORT
═════════════════════════════════════════════════════════════════

📊 OVERALL RISK ASSESSMENT
─────────────────────────────────────────────────────────────────
Risk Score: 78/100
Risk Level: 🟠 HIGH

Overall Risk Score: 78/100 (HIGH). Detected 3 security concerns.
1 CRITICAL threat requiring immediate attention.

🎯 CONTRIBUTING FACTORS
─────────────────────────────────────────────────────────────────
1. Login Analysis
   Severity: HIGH
   Threat: Brute Force Attack

2. Firewall Analysis
   Severity: HIGH
   Threat: Network Port Scan

3. Patch Analysis
   Severity: CRITICAL
   Threat: Critical Unpatched Vulnerability

🛡️  RECOMMENDED MITIGATIONS
─────────────────────────────────────────────────────────────────

Firewall Analysis:
   1. Block source IP at perimeter firewall
   2. Add IP to threat intelligence blocklist
   3. Monitor for follow-up attacks
   4. Review IDS/IPS signatures

Login Analysis:
   1. Enable account lockout policy
   2. Implement MFA for admin accounts
   3. Review firewall rules
   4. Consider requiring re-authentication

Patch Analysis:
   1. Emergency patch deployment for KB5012170
   2. Isolate system until patched if possible
   3. Review WAF rules for exploitation attempts
   4. Implement compensating controls immediately
```

## ⚙️ Configuration

Configuration is managed through environment variables and the `config/agentConfig.js` file.

### Environment Variables (.env)

```bash
# Ollama Configuration
OLLAMA_HOST=http://localhost:11434
OLLAMA_MODEL=mistral

# Risk Score Thresholds (0-100)
RISK_THRESHOLD_CRITICAL=80
RISK_THRESHOLD_HIGH=60
RISK_THRESHOLD_MEDIUM=40
RISK_THRESHOLD_LOW=20

# Analysis Weights (must sum to 1.0)
WEIGHT_LOGIN_ANOMALIES=0.35
WEIGHT_FIREWALL_THREATS=0.40
WEIGHT_PATCH_VULNERABILITIES=0.25

# Model Parameters
MODEL_TEMPERATURE=0.3
MODEL_MAX_TOKENS=2000
```

### Risk Scoring Methodology

The agent calculates a composite risk score (0-100) using weighted analysis:

1. **Firewall Threats (40%)**: Network-level security events
2. **Login Anomalies (35%)**: Authentication security events
3. **Patch Vulnerabilities (25%)**: System vulnerability posture

Each analysis generates a threat score based on:
- **Severity**: Critical (95), High (75), Medium (50), Low (25)
- **Confidence**: AI model's confidence level (0.0-1.0)
- **Formula**: `Score = Severity × Confidence`

Final composite score determines risk level:
- **Critical**: 80-100 (Immediate action required)
- **High**: 60-79 (Urgent attention needed)
- **Medium**: 40-59 (Should be addressed soon)
- **Low**: 0-39 (Monitor and track)

## 🧠 Prompt Engineering

The agent uses carefully crafted prompts to make Mistral act as a cybersecurity expert:

### Key Prompt Engineering Strategies

1. **Role Definition**: Agent is defined as "expert cybersecurity analyst with SOC experience"
2. **Structured Output**: Prompts enforce JSON response format for reliable parsing
3. **Few-Shot Learning**: Each prompt includes 2+ examples showing desired analysis
4. **Industry Terminology**: Uses correct security terminology (CVE, CVSS, RCE, etc.)
5. **Evidence-Based**: Requires the model to provide evidence and reasoning
6. **Actionable Mitigations**: Requests specific, implementable security actions
7. **False Positive Reduction**: Prompts emphasize realistic threat assessment

### Example System Prompt

```
You are an expert cybersecurity analyst with extensive experience in Security 
Operations Center (SOC) operations, threat detection, and incident response.

Guidelines:
- Be precise and technical in your assessments
- Always provide evidence-based reasoning
- Use security industry terminology correctly
- Consider false positive reduction in your analysis
- Provide specific, actionable mitigation steps

Output Format: Always respond with valid JSON containing your analysis.
```

See `config/prompts.js` for complete prompt templates.

## 🔧 Architecture

### Component Overview

```
┌─────────────────────────────────────────────────────────┐
│                    CLI Interface                         │
│                    (index.js)                           │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│              CybersecurityAgent                          │
│           (agent/cybersecurityAgent.js)                 │
│  • Initialize agent                                      │
│  • Coordinate analyses                                   │
│  • Generate risk scores                                  │
└────────────────────┬────────────────────────────────────┘
                     │
┌────────────────────▼────────────────────────────────────┐
│              AnalysisEngine                              │
│           (agent/analysisEngine.js)                     │
│  • Orchestrate workflow                                  │
│  • Calculate composite scores                            │
│  • Aggregate results                                     │
└──────┬──────────────┬──────────────┬───────────────────┘
       │              │              │
   ┌───▼───┐     ┌───▼────┐     ┌──▼─────┐
   │ Data  │     │ Ollama │     │ Config │
   │Process│     │Service │     │ Prompts│
   └───────┘     └────────┘     └────────┘
```

### Analysis Workflow

1. **Data Ingestion**: Load and validate input data
2. **Data Processing**: Normalize formats, extract features, detect patterns
3. **AI Analysis**: Send context to Mistral via Ollama for intelligent analysis
4. **Result Parsing**: Extract structured JSON from LLM response
5. **Risk Calculation**: Calculate composite risk scores
6. **Report Generation**: Format and display comprehensive security report

## 🧪 Testing

The project includes a comprehensive test suite:

### Test Coverage

- ✅ Individual function tests (login, firewall, patch analysis)
- ✅ Integration tests (full analysis pipeline)
- ✅ Prompt effectiveness tests (LLM output quality)
- ✅ Data processor tests (feature extraction)
- ✅ Risk scoring tests (composite calculation)

### Running Tests

```bash
# Quick test
node index.js test --function all

# Detailed individual tests
npm test

# Integration test
npm run test:integration

# Prompt quality test
npm run test:prompts
```

## 🔒 Security Considerations

- **Offline Operation**: All analysis happens locally—no data leaves your machine
- **No API Keys**: No external API calls or credentials required
- **Data Privacy**: Sample data is fictional and safe for testing
- **Model Safety**: Mistral runs locally with no telemetry
- **Input Validation**: All inputs are validated before processing

## 🐛 Troubleshooting

### "Cannot connect to Ollama"

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# If not running, start Ollama
ollama serve
```

### "Model 'mistral' not found"

```bash
# Pull the Mistral model
ollama pull mistral

# Verify installation
ollama list
```

### "JSON parse error"

This usually means the LLM output wasn't valid JSON. Try:
- Adjusting `MODEL_TEMPERATURE` (lower = more consistent)
- Using a different model: `ollama pull llama2`
- Running the prompt test: `npm run test:prompts`

### "Memory errors or slow performance"

```bash
# Use a smaller model
ollama pull mistral:7b-instruct

# Or increase memory limit
export NODE_OPTIONS="--max-old-space-size=4096"
```

## 📚 Additional Resources

- [Ollama Documentation](https://github.com/ollama/ollama)
- [Mistral AI Documentation](https://docs.mistral.ai/)
- [CVSS Scoring System](https://www.first.org/cvss/)
- [MITRE ATT&CK Framework](https://attack.mitre.org/)

## 🤝 Contributing

This is a school project, but suggestions and improvements are welcome! Feel free to:

1. Fork the repository
2. Create a feature branch
3. Make your improvements
4. Submit a pull request

## 📝 License

MIT License - See LICENSE file for details

## 👨‍💻 Author

Created as a cybersecurity AI agent demonstration project showcasing:
- Local LLM integration with Ollama
- Prompt engineering for security analysis
- Modular Node.js architecture
- Real-world threat detection patterns

## 🎓 Educational Use

This project demonstrates:

1. **AI/ML Integration**: How to integrate local LLMs into applications
2. **Prompt Engineering**: Effective prompt design for domain-specific tasks
3. **Security Analysis**: Real-world threat detection patterns and methodologies
4. **Software Architecture**: Production-quality modular design patterns
5. **Testing Practices**: Comprehensive test coverage and validation

Perfect for:
- Computer Science students learning AI integration
- Cybersecurity students studying threat detection
- Anyone interested in building practical AI applications

---

**⚠️ Disclaimer**: This is an educational project. While it demonstrates real security analysis patterns, it should not be used as the sole security solution for production environments. Always use comprehensive security tools and consult with security professionals for production deployments.

## 🚀 Next Steps

1. **Try the sample analyses**: Run `node index.js analyze --type all`
2. **Explore the code**: Start with `agent/cybersecurityAgent.js`
3. **Modify the prompts**: Edit `config/prompts.js` to customize analysis
4. **Add your own data**: Create JSON files matching the data formats above
5. **Experiment with models**: Try different Ollama models (`llama2`, `codellama`, etc.)

Happy analyzing! 🛡️
