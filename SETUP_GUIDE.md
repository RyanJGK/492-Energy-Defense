# 🚀 Quick Setup Guide

Follow these steps to get the Cybersecurity AI Agent running in minutes.

## Step 1: Install Prerequisites

### Install Node.js (18 or later)

```bash
# Check if Node.js is installed
node --version

# If not installed, download from: https://nodejs.org/
```

### Install Ollama

```bash
# Visit https://ollama.ai/download and follow instructions for your OS

# Or on Linux/Mac:
curl -fsSL https://ollama.ai/install.sh | sh

# On Windows: Download installer from website
```

## Step 2: Set Up the Project

```bash
# Navigate to project directory
cd cybersecurity-ai-agent

# Install Node.js dependencies
npm install
```

## Step 3: Start Ollama and Pull Model

```bash
# Terminal 1: Start Ollama service
ollama serve

# Terminal 2: Pull Mistral model (one-time, ~4GB download)
ollama pull mistral

# Verify model is installed
ollama list
```

## Step 4: Verify Installation

```bash
# Check system health
node index.js health

# Expected output:
# ✅ System is healthy!
#    Ollama: Running
#    Model: mistral (Available)
```

## Step 5: Run Your First Analysis

```bash
# Run comprehensive analysis on sample data
node index.js analyze --type all

# This will analyze:
# - Login attempts (brute force detection)
# - Firewall logs (port scan detection)
# - Patch status (vulnerability detection)
```

## Step 6: Explore Features

```bash
# Show all available commands
node index.js --help

# Show usage examples
node index.js examples

# Run tests
npm test

# Check agent status
node index.js status
```

## 📊 Understanding the Output

When you run an analysis, you'll see:

1. **Data Summary**: Statistics about the data processed
2. **AI Analysis**: Threat detection results from Mistral
3. **Evidence**: Specific indicators of compromise
4. **Reasoning**: Why the AI identified this as a threat
5. **Mitigation**: Recommended actions to address the threat

### Example Output

```
🤖 AI Analysis:
   Threat Detected: YES
   Threat Type: Brute Force Attack
   Severity: HIGH
   Confidence: 95%

📌 Evidence:
   12 failed login attempts for 'admin' from IP 203.0.113.45 in 4 minutes

🛡️  Recommended Actions:
   1. Block source IP immediately
   2. Enable account lockout policy
   3. Implement MFA for admin accounts
```

## 🎯 Next Steps

### Analyze Your Own Data

Create a JSON file matching one of these formats:

**Login Data** (`my-logins.json`):
```json
[
  {
    "username": "user1",
    "sourceIP": "192.168.1.100",
    "timestamp": "2025-11-12T10:00:00Z",
    "success": false
  }
]
```

**Firewall Logs** (`my-firewall.json`):
```json
[
  {
    "sourceIP": "203.0.113.45",
    "destinationPort": 22,
    "action": "block",
    "protocol": "SSH"
  }
]
```

**Patch Status** (`my-patches.json`):
```json
[
  {
    "hostname": "SERVER-01",
    "os": "Windows Server 2019",
    "lastPatched": "2025-10-01T00:00:00Z",
    "missingPatches": []
  }
]
```

Then analyze:
```bash
node index.js analyze --type login --file my-logins.json
```

### Customize Configuration

Edit `.env` to adjust:
- Risk score thresholds
- Analysis weights
- Model parameters
- Detection thresholds

```bash
cp .env.example .env
nano .env  # or your preferred editor
```

### Run Advanced Tests

```bash
# Test individual functions
node index.js test --function login
node index.js test --function firewall
node index.js test --function patch

# Test full pipeline
npm run test:integration

# Test AI prompt quality
npm run test:prompts
```

## 🐛 Troubleshooting

### Issue: "Cannot connect to Ollama"

**Solution:**
```bash
# Make sure Ollama is running
ollama serve

# Check if accessible
curl http://localhost:11434/api/tags
```

### Issue: "Model 'mistral' not found"

**Solution:**
```bash
# Pull the model
ollama pull mistral

# Verify
ollama list
```

### Issue: Slow performance

**Solution:**
```bash
# Use a smaller model
ollama pull mistral:7b-instruct

# Update .env to use the new model
echo "OLLAMA_MODEL=mistral:7b-instruct" >> .env
```

### Issue: JSON parse errors

**Solution:**
- Lower temperature in `.env`: `MODEL_TEMPERATURE=0.2`
- Try a different model: `ollama pull llama2`
- Run prompt test: `npm run test:prompts`

## 📚 Learn More

- Read the full [README.md](README.md) for detailed documentation
- Explore `config/prompts.js` to see prompt engineering
- Check `agent/cybersecurityAgent.js` to understand the architecture
- Review sample data in `data/` directory

## ✅ Checklist

- [ ] Node.js 18+ installed
- [ ] Ollama installed and running
- [ ] Mistral model pulled
- [ ] Dependencies installed (`npm install`)
- [ ] Health check passed (`node index.js health`)
- [ ] First analysis completed (`node index.js analyze --type all`)
- [ ] Tests passed (`npm test`)

Once all items are checked, you're ready to use the agent! 🎉

## 💡 Tips

1. **Start Simple**: Begin with the sample data before using your own
2. **Read Output Carefully**: The AI provides detailed reasoning for each threat
3. **Adjust Thresholds**: Tune detection sensitivity in `.env` for your environment
4. **Combine Analyses**: Use `--type all` for comprehensive security assessment
5. **Review Prompts**: Understanding the prompts helps interpret results

## 🆘 Need Help?

If you encounter issues:

1. Check the troubleshooting section above
2. Review the [README.md](README.md) documentation
3. Verify all prerequisites are installed correctly
4. Run the health check: `node index.js health`
5. Run tests to identify specific issues: `npm test`

---

**Ready to secure your systems! 🛡️**
