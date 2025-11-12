/**
 * Cybersecurity AI Agent - Main agent class
 * Coordinates all security analysis operations
 */

import AnalysisEngine from './analysisEngine.js';
import { ollamaService } from '../services/ollamaService.js';
import { validateInputData } from '../services/dataProcessor.js';
import { agentConfig, getRiskLevel } from '../config/agentConfig.js';

class CybersecurityAgent {
  constructor() {
    this.analysisEngine = new AnalysisEngine();
    this.initialized = false;
  }

  /**
   * Initialize the agent - check Ollama connectivity and model availability
   * @returns {Promise<boolean>} True if initialization successful
   */
  async initialize() {
    console.log('🤖 Initializing Cybersecurity AI Agent...');
    console.log(`   Model: ${agentConfig.ollama.model}`);
    console.log(`   Ollama Host: ${agentConfig.ollama.host}`);

    // Health check
    const health = await ollamaService.healthCheck();
    
    if (!health.healthy) {
      console.error('❌ Initialization failed:', health.error);
      console.error('\n📋 Troubleshooting steps:');
      console.error('   1. Make sure Ollama is running: ollama serve');
      console.error(`   2. Pull the ${agentConfig.ollama.model} model: ollama pull ${agentConfig.ollama.model}`);
      console.error('   3. Check Ollama is accessible at', agentConfig.ollama.host);
      return false;
    }

    console.log('✅ Agent initialized successfully');
    console.log(`   Model "${health.model}" is ready\n`);
    this.initialized = true;
    return true;
  }

  /**
   * Analyze login attempts for suspicious patterns
   * @param {Array|Object} loginData - Login attempt data
   * @returns {Promise<Object>} Analysis results
   */
  async analyzeLoginAttempt(loginData) {
    if (!this.initialized) {
      throw new Error('Agent not initialized. Call initialize() first.');
    }

    if (!validateInputData(loginData, 'login')) {
      throw new Error('Invalid login data format. Required fields: username, sourceIP');
    }

    return await this.analysisEngine.analyzeLogin(loginData);
  }

  /**
   * Analyze firewall logs for potential threats
   * @param {Array|Object} firewallData - Firewall log data
   * @returns {Promise<Object>} Analysis results
   */
  async analyzeFirewallLog(firewallData) {
    if (!this.initialized) {
      throw new Error('Agent not initialized. Call initialize() first.');
    }

    if (!validateInputData(firewallData, 'firewall')) {
      throw new Error('Invalid firewall data format. Required fields: sourceIP, destinationPort');
    }

    return await this.analysisEngine.analyzeFirewall(firewallData);
  }

  /**
   * Analyze patch status for vulnerabilities
   * @param {Array|Object} patchData - Patch status data
   * @returns {Promise<Object>} Analysis results
   */
  async analyzePatchStatus(patchData) {
    if (!this.initialized) {
      throw new Error('Agent not initialized. Call initialize() first.');
    }

    if (!validateInputData(patchData, 'patch')) {
      throw new Error('Invalid patch data format. Required fields: hostname, os');
    }

    return await this.analysisEngine.analyzePatch(patchData);
  }

  /**
   * Generate composite risk score from all analyses
   * @param {Object} analysisResults - Optional pre-computed analysis results
   * @returns {Object} Risk score and breakdown
   */
  generateRiskScore(analysisResults = null) {
    if (analysisResults) {
      // If analysis results provided, use them
      // This allows for standalone risk calculation
      const tempEngine = new AnalysisEngine();
      if (analysisResults.login) tempEngine.results.login = analysisResults.login;
      if (analysisResults.firewall) tempEngine.results.firewall = analysisResults.firewall;
      if (analysisResults.patch) tempEngine.results.patch = analysisResults.patch;
      return tempEngine.calculateCompositeRisk();
    }

    return this.analysisEngine.calculateCompositeRisk();
  }

  /**
   * Generate actionable mitigation recommendations
   * @param {Object} threats - Threat analysis results
   * @returns {Object} Prioritized mitigations
   */
  generateMitigations(threats = null) {
    if (threats) {
      // If specific threats provided, generate targeted mitigations
      return this.generateTargetedMitigations(threats);
    }

    // Otherwise, get all mitigations from current analyses
    const allMitigations = this.analysisEngine.getAllMitigations();
    return this.prioritizeMitigations(allMitigations);
  }

  /**
   * Generate targeted mitigations for specific threats
   * @param {Object} threats - Specific threat information
   * @returns {Object} Targeted mitigations
   */
  generateTargetedMitigations(threats) {
    const mitigations = {
      immediate: [],
      shortTerm: [],
      longTerm: [],
    };

    // Categorize mitigations based on threat severity
    const severity = threats.severity || 'MEDIUM';
    
    switch(severity) {
      case 'CRITICAL':
        mitigations.immediate.push('Isolate affected systems immediately');
        mitigations.immediate.push('Initiate incident response procedure');
        mitigations.immediate.push('Notify security team and management');
        break;
      case 'HIGH':
        mitigations.immediate.push('Block malicious IPs/sources');
        mitigations.immediate.push('Review and strengthen access controls');
        break;
      case 'MEDIUM':
        mitigations.shortTerm.push('Schedule security patch deployment');
        mitigations.shortTerm.push('Enhance monitoring for similar patterns');
        break;
      default:
        mitigations.longTerm.push('Review security policies');
        mitigations.longTerm.push('Conduct security awareness training');
    }

    return mitigations;
  }

  /**
   * Prioritize mitigations by urgency
   * @param {Array} allMitigations - All mitigation recommendations
   * @returns {Object} Prioritized mitigations
   */
  prioritizeMitigations(allMitigations) {
    const prioritized = {
      critical: [],
      high: [],
      medium: [],
      low: [],
    };

    allMitigations.forEach(mitigation => {
      const source = mitigation.source;
      const actions = mitigation.actions || [];
      
      // Categorize by source severity
      if (source.includes('Critical') || source.includes('Firewall')) {
        prioritized.critical.push(...actions.slice(0, 2)); // Top 2 actions
        prioritized.high.push(...actions.slice(2));
      } else if (source.includes('Login')) {
        prioritized.high.push(...actions.slice(0, 2));
        prioritized.medium.push(...actions.slice(2));
      } else {
        prioritized.medium.push(...actions);
      }
    });

    return prioritized;
  }

  /**
   * Run comprehensive security analysis on all data types
   * @param {Object} data - Object containing login, firewall, and patch data
   * @returns {Promise<Object>} Complete security report
   */
  async runFullAnalysis(data) {
    console.log('═══════════════════════════════════════════════════════');
    console.log('🛡️  COMPREHENSIVE SECURITY ANALYSIS');
    console.log('═══════════════════════════════════════════════════════\n');

    const results = {};

    // Analyze login data if provided
    if (data.login) {
      results.login = await this.analyzeLoginAttempt(data.login);
    }

    // Analyze firewall data if provided
    if (data.firewall) {
      results.firewall = await this.analyzeFirewallLog(data.firewall);
    }

    // Analyze patch data if provided
    if (data.patch) {
      results.patch = await this.analyzePatchStatus(data.patch);
    }

    // Generate comprehensive report
    const report = this.analysisEngine.getFullReport();

    console.log('\n═══════════════════════════════════════════════════════');
    console.log('📊 RISK ASSESSMENT');
    console.log('═══════════════════════════════════════════════════════');
    console.log(`Overall Risk Score: ${report.riskAssessment.score}/100`);
    console.log(`Risk Level: ${report.riskAssessment.level}`);
    console.log(`\n${report.executiveSummary}\n`);

    return report;
  }

  /**
   * Get agent capabilities and status
   * @returns {Object} Agent information
   */
  getStatus() {
    return {
      initialized: this.initialized,
      model: agentConfig.ollama.model,
      host: agentConfig.ollama.host,
      capabilities: [
        'Login Attempt Analysis',
        'Firewall Log Analysis',
        'Patch Status Analysis',
        'Risk Score Calculation',
        'Mitigation Generation',
      ],
      thresholds: agentConfig.riskThresholds,
      weights: agentConfig.analysisWeights,
    };
  }

  /**
   * Reset agent state
   */
  reset() {
    this.analysisEngine.reset();
  }
}

// Export singleton instance
export const agent = new CybersecurityAgent();
export default CybersecurityAgent;
