# Cybersecurity AI Agent

A standalone threat detection agent using Ollama Mistral for analyzing authentication logs, firewall traffic, and patch status. Provides professional-grade security analysis with actionable recommendations and risk scoring.

## Overview

This cybersecurity AI agent leverages the Mistral language model through Ollama to perform intelligent threat detection across three critical security domains:

- **Authentication Analysis**: Detects brute force attacks, credential stuffing, geographic anomalies, and off-hours access patterns
- **Firewall Analysis**: Identifies port scanning, data exfiltration, lateral movement, and command & control traffic
- **Vulnerability Assessment**: Evaluates patch status, CVE severity, exploit availability, and system exposure

The agent generates comprehensive threat assessments with MITRE ATT&CK mappings, confidence scores, and prioritized mitigation recommendations.

## Features

- **Professional Terminal Output**: Clean, timestamped logging with color-coded threat levels
- **Composite Risk Scoring**: Weighted 0-100 risk scores combining multiple security domains
- **MITRE ATT&CK Mapping**: Automatically identifies relevant tactics and techniques
- **Actionable Recommendations**: Specific, prioritized remediation steps
- **Retry Logic**: Built-in resilience with automatic retry on transient failures
- **Comprehensive Testing**: Full integration test suite with validation

## Architecture

```
┌─────────────────┐
│   CLI (index.js) │
└────────┬────────┘
         │
    ┌────▼──────────────┐
    │ Analysis Engine    │
    └────────┬──────────┘
             │
    ┌────────▼───────────────┐
    │ Cybersecurity Agent    │
    └────┬──────────────┬────┘
         │              │
    ┌────▼─────┐   ┌───▼──────────┐
    │  Ollama  │   │ Data         │
    │  Service │   │ Processor    │
    └──────────┘   └──────────────┘
```

**Flow**: CLI → Analysis Engine → Cybersecurity Agent → Ollama Service + Data Processor

1. **CLI** receives user commands and displays formatted results
2. **Analysis Engine** orchestrates workflow and aggregates findings
3. **Cybersecurity Agent** coordinates security analyses and generates risk scores
4. **Ollama Service** handles all LLM interactions with retry logic
5. **Data Processor** normalizes and validates security data

## Prerequisites

- **Node.js**: Version 18.0.0 or higher
- **Ollama**: Installed and running locally
- **Mistral Model**: Downloaded via Ollama

### Install Ollama

**macOS/Linux**:
```bash
curl -fsSL https://ollama.ai/install.sh | sh
```

**Windows**: Download from [ollama.ai](https://ollama.ai)

### Install Mistral Model

```bash
ollama pull mistral
```

### Verify Ollama is Running

```bash
ollama list
# Should show mistral in the list
```

## Installation

1. **Clone or download this repository**

2. **Install dependencies**:
```bash
npm install
```

3. **Verify setup**:
```bash
node index.js help
```

## Usage

### Basic Commands

```bash
# Analyze login attempts
node index.js analyze login

# Analyze firewall logs
node index.js analyze firewall

# Analyze patch status
node index.js analyze patch

# Run comprehensive analysis (all three)
node index.js analyze all

# Run integration tests
node index.js test

# Display help
node index.js help
```

### Sample Output

```
[2024-11-06 14:23:01] INFO: Initializing Cybersecurity Agent
[2024-11-06 14:23:02] INFO: Connected to Ollama (mistral)
[2024-11-06 14:23:03] ANALYSIS: Processing login events...

[2024-11-06 14:23:05] THREAT: HIGH severity detected
[2024-11-06 14:23:05] CONFIDENCE: 92%

[2024-11-06 14:23:05] INDICATORS:
  - 47 failed login attempts from 41.203.72.15
  - Geographic anomaly: Nigeria (unexpected location)
  - Off-hours access attempt: 02:15 UTC
  - Target account: admin (privileged)

[2024-11-06 14:23:05] MITRE_TACTICS: Credential Access, Initial Access

[2024-11-06 14:23:05] RECOMMENDATIONS:
  - Immediately block source IP 41.203.72.15 at firewall
  - Enforce multi-factor authentication for admin accounts
  - Implement rate limiting on authentication endpoints
  - Review and reset credentials for targeted accounts

[2024-11-06 14:23:05] REASONING: Multiple failed login attempts from foreign IP targeting privileged account indicates credential brute force attack. Geographic and temporal anomalies support malicious intent.

[2024-11-06 14:23:05] RISK_SCORE: 78/100
```

## Risk Scoring Methodology

The agent calculates a composite risk score (0-100) using weighted threat assessments:

### Weight Distribution

- **Login Anomalies**: 35%
- **Firewall Threats**: 40%
- **Patch Vulnerabilities**: 25%

### Threat Level Scores

- **CRITICAL**: 90 points
- **HIGH**: 70 points
- **MEDIUM**: 40 points
- **LOW**: 20 points

### Formula

```
Risk Score = Σ(Threat_Score × Confidence × Domain_Weight) / Σ(Domain_Weight)
```

### Risk Levels

- **80-100**: Critical - Immediate action required
- **60-79**: High - Prompt remediation recommended
- **40-59**: Medium - Address in planned maintenance
- **20-39**: Low - Monitor and maintain controls
- **0-19**: Minimal - Continue monitoring

## Configuration

All configuration is centralized in `config/index.js`:

### Ollama Settings

```javascript
ollama: {
  host: 'http://localhost:11434',
  model: 'mistral',
  timeout: 30000,
  retryAttempts: 3,
  retryDelay: 1000
}
```

### Security Thresholds

```javascript
thresholds: {
  failed_login_rate: 10,        // per hour
  suspicious_ports: [22, 3389, 445, 1433, 5900, 23],
  critical_cvss: 7.0,
  patch_age_critical: 30        // days
}
```

### Adjusting Weights

Edit `riskWeights` in `config/index.js` to adjust domain importance:

```javascript
riskWeights: {
  login_anomalies: 0.35,
  firewall_threats: 0.40,
  patch_vulnerabilities: 0.25
}
```

## Test Data

Sample security data is provided in `data/samples.json`:

- **4 login events**: Including brute force attempts from Nigeria, Russia, and China
- **6 firewall logs**: Port scanning, data exfiltration, and normal traffic
- **4 patch records**: Critical CVEs on SCADA, database, and web servers

### Adding Custom Data

Edit `data/samples.json` to test with your own security data. Follow the existing schema:

**Login Event**:
```json
{
  "timestamp": "2024-11-06T02:15:00Z",
  "ip": "41.203.72.15",
  "username": "admin",
  "success": false,
  "attempts": 47,
  "country": "Nigeria"
}
```

**Firewall Log**:
```json
{
  "timestamp": "2024-11-06T14:26:15Z",
  "src_ip": "192.168.1.200",
  "dst_ip": "185.220.100.240",
  "dst_port": 22,
  "protocol": "TCP",
  "bytes": 4500,
  "action": "BLOCK"
}
```

**Patch Status**:
```json
{
  "hostname": "SCADA-01",
  "os": "Windows Server 2019",
  "missing_cves": ["CVE-2024-1234"],
  "cvss_scores": [9.8],
  "days_unpatched": 45,
  "criticality": "critical"
}
```

## Testing

Run the comprehensive test suite:

```bash
node index.js test
```

Or directly:

```bash
node tests/integration.test.js
```

### Test Coverage

1. **Ollama Connectivity**: Verifies service health and model availability
2. **Login Analysis**: Tests brute force detection
3. **Firewall Analysis**: Tests port scan detection
4. **Patch Analysis**: Tests critical CVE identification
5. **Full Analysis**: Tests comprehensive reporting
6. **Risk Calculation**: Validates scoring formula

### Expected Output

```
================================================================================
[2024-11-06 14:30:00] INFO: Starting Integration Test Suite
================================================================================

[PASS] Ollama Connectivity Check (245ms)
[PASS] Login Analysis (Brute Force Detection) (3421ms)
       Detected: HIGH threat with 92% confidence
       Risk Score: 78/100
[PASS] Firewall Analysis (Port Scan Detection) (2856ms)
[PASS] Patch Analysis (Critical CVE Detection) (3105ms)
[PASS] Full Analysis (All Data Types) (8234ms)
[PASS] Risk Score Calculation Validation (12ms)

================================================================================
TEST SUMMARY
================================================================================
Total Tests: 6
Passed: 6
Failed: 0
Total Duration: 17873ms

✓ ALL TESTS PASSED
================================================================================
```

## Troubleshooting

### Ollama Connection Failed

**Error**: `Cannot connect to Ollama at http://localhost:11434`

**Solutions**:
1. Verify Ollama is running: `ollama list`
2. Check if process is running: `ps aux | grep ollama`
3. Restart Ollama: `ollama serve`

### Model Not Found

**Error**: `Model 'mistral' not found`

**Solution**: Download the model: `ollama pull mistral`

### Timeout Errors

**Error**: `Analysis failed after 3 attempts`

**Solutions**:
1. Increase timeout in `config/index.js`:
   ```javascript
   timeout: 60000  // 60 seconds
   ```
2. Use a smaller, faster model (though less accurate)
3. Check system resources (Ollama requires 4GB+ RAM)

### JSON Parse Errors

**Error**: `Failed to parse LLM response as JSON`

**Causes**: Model sometimes outputs markdown or invalid JSON

**Solution**: The system automatically retries (3 attempts). If persistent:
1. Lower temperature in `services/ollamaService.js`
2. Use more explicit JSON formatting in prompts

## Project Structure

```
cybersecurity-ai-agent/
├── agent/
│   ├── cybersecurityAgent.js    # Main agent class with analysis methods
│   └── analysisEngine.js        # Workflow coordinator and aggregator
├── services/
│   ├── ollamaService.js         # Ollama API wrapper with retry logic
│   └── dataProcessor.js         # Data normalization and validation
├── config/
│   └── index.js                 # Central configuration
├── data/
│   └── samples.json             # Test security data
├── tests/
│   └── integration.test.js      # Integration test suite
├── index.js                     # CLI entry point
├── package.json                 # Dependencies and scripts
├── README.md                    # This file
└── LICENSE                      # License file
```

## Dependencies

- **ollama** (^0.5.0): Official Ollama JavaScript client
- **chalk** (^5.3.0): Terminal color output (threat level highlighting only)

## Development

### Adding New Analysis Types

1. **Add normalizer** to `services/dataProcessor.js`:
   ```javascript
   export function normalizeNewType(raw) { ... }
   ```

2. **Add analysis method** to `agent/cybersecurityAgent.js`:
   ```javascript
   async analyzeNewType(data) { ... }
   ```

3. **Add prompt** to `config/index.js`:
   ```javascript
   prompts: {
     newTypeAnalysis: "Analyze this new data type..."
   }
   ```

4. **Update CLI** in `index.js` to support new command

### Customizing Prompts

Edit prompts in `config/index.js` to adjust analysis focus:

- Add specific indicators to look for
- Emphasize certain threat types
- Adjust output format requirements
- Include industry-specific context

## Security Considerations

- **Local Processing**: All analysis occurs locally; no data sent to external services
- **Data Privacy**: Sample data is synthetic; replace with your own security logs
- **API Keys**: Not required (Ollama runs locally)
- **Production Use**: This is a demonstration tool; enhance error handling and logging for production

## Performance

- **Login Analysis**: ~3-4 seconds per analysis
- **Firewall Analysis**: ~2-3 seconds per analysis
- **Patch Analysis**: ~3 seconds per analysis
- **Full Analysis**: ~8-10 seconds (all three combined)

*Performance depends on hardware and Ollama model size*

## Limitations

- **English Only**: Prompts and analysis in English
- **Local Model**: Requires Ollama running locally (4GB+ RAM)
- **Sample Data**: Included data is synthetic for demonstration
- **No Persistence**: Results are not saved; implement database for production
- **Single Threaded**: Analyses run sequentially (not parallelized)

## Future Enhancements

- [ ] Database integration for historical analysis
- [ ] Real-time log streaming and analysis
- [ ] Web dashboard for visualization
- [ ] Email/Slack alerting for critical threats
- [ ] Custom model fine-tuning on security data
- [ ] Multi-language support
- [ ] Parallel analysis processing
- [ ] Export to SIEM formats (CEF, LEEF)

## License

MIT License - see LICENSE file for details

## Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## Support

For issues, questions, or contributions:

1. Check existing issues/documentation
2. Verify Ollama and dependencies are correctly installed
3. Run test suite to isolate problems
4. Open an issue with detailed reproduction steps

## Acknowledgments

- **Ollama**: Local LLM runtime
- **Mistral AI**: High-quality open-source model
- **MITRE ATT&CK**: Threat intelligence framework
- **CVE Database**: Vulnerability information

---

**Built with Node.js and Ollama for professional cybersecurity threat detection**
