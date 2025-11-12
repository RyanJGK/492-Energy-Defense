/**
 * Configuration for the Cybersecurity AI Agent
 * All thresholds, weights, and parameters can be adjusted here
 */

import dotenv from 'dotenv';
dotenv.config();

export const agentConfig = {
  // Ollama Configuration
  ollama: {
    host: process.env.OLLAMA_HOST || 'http://localhost:11434',
    model: process.env.OLLAMA_MODEL || 'mistral',
    temperature: parseFloat(process.env.MODEL_TEMPERATURE) || 0.3,
    maxTokens: parseInt(process.env.MODEL_MAX_TOKENS) || 2000,
  },

  // Risk Score Thresholds (0-100)
  riskThresholds: {
    critical: parseInt(process.env.RISK_THRESHOLD_CRITICAL) || 80,
    high: parseInt(process.env.RISK_THRESHOLD_HIGH) || 60,
    medium: parseInt(process.env.RISK_THRESHOLD_MEDIUM) || 40,
    low: parseInt(process.env.RISK_THRESHOLD_LOW) || 20,
  },

  // Analysis Weights for Composite Risk Score
  analysisWeights: {
    loginAnomalies: parseFloat(process.env.WEIGHT_LOGIN_ANOMALIES) || 0.35,
    firewallThreats: parseFloat(process.env.WEIGHT_FIREWALL_THREATS) || 0.40,
    patchVulnerabilities: parseFloat(process.env.WEIGHT_PATCH_VULNERABILITIES) || 0.25,
  },

  // Login Analysis Parameters
  loginAnalysis: {
    maxFailedAttempts: 5,
    suspiciousHoursStart: 0, // Midnight
    suspiciousHoursEnd: 6,   // 6 AM
    bruteForceThreshold: 10,  // Attempts in short time
    bruteForceWindow: 300,    // Seconds (5 minutes)
  },

  // Firewall Analysis Parameters
  firewallAnalysis: {
    portScanThreshold: 10,    // Different ports accessed
    blockedIPThreshold: 5,    // Times same IP blocked
    suspiciousPorts: [22, 23, 3389, 445, 135], // SSH, Telnet, RDP, SMB
    highRiskProtocols: ['TELNET', 'FTP', 'SMB'],
  },

  // Patch Analysis Parameters
  patchAnalysis: {
    criticalPatchAge: 30,     // Days before critical
    highPatchAge: 60,         // Days before high
    mediumPatchAge: 90,       // Days before medium
    cveScoreThresholds: {
      critical: 9.0,
      high: 7.0,
      medium: 4.0,
    },
  },

  // Logging
  logging: {
    level: process.env.LOG_LEVEL || 'info',
    debug: process.env.ENABLE_DEBUG === 'true',
  },
};

/**
 * Get risk level label from score
 * @param {number} score - Risk score (0-100)
 * @returns {string} Risk level
 */
export function getRiskLevel(score) {
  const { critical, high, medium } = agentConfig.riskThresholds;
  
  if (score >= critical) return 'CRITICAL';
  if (score >= high) return 'HIGH';
  if (score >= medium) return 'MEDIUM';
  return 'LOW';
}

/**
 * Validate configuration on startup
 * @returns {boolean} True if valid
 */
export function validateConfig() {
  const weights = agentConfig.analysisWeights;
  const sum = weights.loginAnomalies + weights.firewallThreats + weights.patchVulnerabilities;
  
  if (Math.abs(sum - 1.0) > 0.01) {
    console.warn('⚠️  Analysis weights do not sum to 1.0. Actual sum:', sum);
    return false;
  }
  
  return true;
}

export default agentConfig;
