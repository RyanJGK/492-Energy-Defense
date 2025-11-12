/**
 * Central configuration for Cybersecurity AI Agent
 * Contains all settings for Ollama, risk scoring, thresholds, and prompts
 */

export default {
  ollama: {
    host: 'http://localhost:11434',
    model: 'mistral',
    timeout: 30000,
    retryAttempts: 3,
    retryDelay: 1000
  },

  riskWeights: {
    login_anomalies: 0.35,
    firewall_threats: 0.40,
    patch_vulnerabilities: 0.25
  },

  thresholds: {
    failed_login_rate: 10,  // per hour
    suspicious_ports: [22, 3389, 445, 1433, 5900, 23],
    critical_cvss: 7.0,
    high_cvss: 5.0,
    patch_age_critical: 30,  // days
    patch_age_high: 14,
    data_exfil_threshold: 100000  // bytes
  },

  prompts: {
    system: `You are a senior cybersecurity analyst specializing in threat detection and incident response. 
Analyze the provided security data and respond ONLY with valid JSON format.
Required fields: threat_level, confidence, indicators, mitre_tactics, recommendations, reasoning.
Use professional security terminology. Minimize speculation. Be concise and actionable.`,

    loginAnalysis: `Analyze these authentication events for security threats. Look for:
- Brute force attacks (multiple failed attempts)
- Geographic anomalies (unexpected locations)
- Off-hours access patterns
- Credential stuffing indicators
- Privileged account abuse

Respond ONLY with valid JSON in this exact format:
{
  "threat_level": "CRITICAL|HIGH|MEDIUM|LOW",
  "confidence": 0.0-1.0,
  "indicators": ["list of specific threat indicators found"],
  "mitre_tactics": ["relevant MITRE ATT&CK tactics"],
  "recommendations": ["actionable mitigation steps"],
  "reasoning": "brief explanation of threat assessment"
}`,

    firewallAnalysis: `Review these firewall logs for attack patterns. Identify:
- Port scanning activities
- DDoS patterns
- Data exfiltration attempts
- Lateral movement
- Command and control traffic
- Suspicious protocol usage

Respond ONLY with valid JSON in this exact format:
{
  "threat_level": "CRITICAL|HIGH|MEDIUM|LOW",
  "confidence": 0.0-1.0,
  "indicators": ["list of specific threat indicators found"],
  "mitre_tactics": ["relevant MITRE ATT&CK tactics"],
  "recommendations": ["actionable mitigation steps"],
  "reasoning": "brief explanation of threat assessment"
}`,

    patchAnalysis: `Assess vulnerability risk from patch status. Evaluate:
- CVE severity scores
- Exploit availability
- System criticality
- Patch age
- Attack surface exposure

Respond ONLY with valid JSON in this exact format:
{
  "threat_level": "CRITICAL|HIGH|MEDIUM|LOW",
  "confidence": 0.0-1.0,
  "indicators": ["list of specific vulnerabilities and risks"],
  "mitre_tactics": ["relevant MITRE ATT&CK tactics"],
  "recommendations": ["actionable remediation steps"],
  "reasoning": "brief explanation of vulnerability assessment"
}`
  },

  threatLevelScores: {
    CRITICAL: 90,
    HIGH: 70,
    MEDIUM: 40,
    LOW: 20
  }
};
