/**
 * Cybersecurity Agent - Main agent class for threat analysis
 * Coordinates all security analysis operations using Ollama AI
 */

import ollamaService from '../services/ollamaService.js';
import { normalizeData } from '../services/dataProcessor.js';
import config from '../config/index.js';

class CybersecurityAgent {
  constructor() {
    this.initialized = false;
  }

  /**
   * Initialize agent and verify Ollama connectivity
   * @returns {Promise<boolean>} Initialization status
   */
  async initialize() {
    try {
      const isHealthy = await ollamaService.healthCheck();
      if (!isHealthy) {
        throw new Error('Ollama service health check failed');
      }
      this.initialized = true;
      return true;
    } catch (error) {
      console.error(`[ERROR] Agent initialization failed: ${error.message}`);
      this.initialized = false;
      return false;
    }
  }

  /**
   * Analyze login/authentication attempts for threats
   * @param {Object|Array} loginData - Login event data
   * @returns {Promise<Object>} Analysis results with threat assessment
   */
  async analyzeLoginAttempt(loginData) {
    this.ensureInitialized();
    
    try {
      const normalized = normalizeData(loginData, 'login');
      
      const analysis = await ollamaService.analyze(
        config.prompts.loginAnalysis,
        normalized,
        config.prompts.system
      );

      return {
        type: 'login',
        timestamp: new Date().toISOString(),
        data_analyzed: normalized.length,
        ...analysis
      };
    } catch (error) {
      throw new Error(`Login analysis failed: ${error.message}`);
    }
  }

  /**
   * Analyze firewall logs for network threats
   * @param {Object|Array} firewallData - Firewall log data
   * @returns {Promise<Object>} Analysis results with threat assessment
   */
  async analyzeFirewallLog(firewallData) {
    this.ensureInitialized();
    
    try {
      const normalized = normalizeData(firewallData, 'firewall');
      
      const analysis = await ollamaService.analyze(
        config.prompts.firewallAnalysis,
        normalized,
        config.prompts.system
      );

      return {
        type: 'firewall',
        timestamp: new Date().toISOString(),
        data_analyzed: normalized.length,
        ...analysis
      };
    } catch (error) {
      throw new Error(`Firewall analysis failed: ${error.message}`);
    }
  }

  /**
   * Analyze patch status for vulnerability assessment
   * @param {Object|Array} patchData - Patch status data
   * @returns {Promise<Object>} Analysis results with vulnerability assessment
   */
  async analyzePatchStatus(patchData) {
    this.ensureInitialized();
    
    try {
      const normalized = normalizeData(patchData, 'patch');
      
      const analysis = await ollamaService.analyze(
        config.prompts.patchAnalysis,
        normalized,
        config.prompts.system
      );

      return {
        type: 'patch',
        timestamp: new Date().toISOString(),
        data_analyzed: normalized.length,
        ...analysis
      };
    } catch (error) {
      throw new Error(`Patch analysis failed: ${error.message}`);
    }
  }

  /**
   * Generate composite risk score from analysis results
   * @param {Array<Object>} analysisResults - Array of analysis results
   * @returns {number} Risk score (0-100)
   */
  generateRiskScore(analysisResults) {
    if (!Array.isArray(analysisResults) || analysisResults.length === 0) {
      return 0;
    }

    let totalScore = 0;
    let totalWeight = 0;

    for (const result of analysisResults) {
      const threatScore = config.threatLevelScores[result.threat_level] || 0;
      const confidenceWeight = result.confidence || 1.0;
      
      let weight = 0;
      switch (result.type) {
        case 'login':
          weight = config.riskWeights.login_anomalies;
          break;
        case 'firewall':
          weight = config.riskWeights.firewall_threats;
          break;
        case 'patch':
          weight = config.riskWeights.patch_vulnerabilities;
          break;
        default:
          weight = 0.33;
      }

      totalScore += threatScore * confidenceWeight * weight;
      totalWeight += weight;
    }

    return totalWeight > 0 ? Math.round(totalScore / totalWeight) : 0;
  }

  /**
   * Generate consolidated mitigation recommendations
   * @param {Array<Object>} analysisResults - Array of analysis results
   * @returns {Array<string>} Prioritized list of recommendations
   */
  generateMitigations(analysisResults) {
    if (!Array.isArray(analysisResults) || analysisResults.length === 0) {
      return [];
    }

    const allRecommendations = [];
    const priorityMap = {
      'CRITICAL': 4,
      'HIGH': 3,
      'MEDIUM': 2,
      'LOW': 1
    };

    for (const result of analysisResults) {
      const priority = priorityMap[result.threat_level] || 1;
      
      if (result.recommendations && Array.isArray(result.recommendations)) {
        result.recommendations.forEach(rec => {
          allRecommendations.push({
            recommendation: rec,
            priority,
            type: result.type,
            threat_level: result.threat_level
          });
        });
      }
    }

    // Sort by priority (highest first) and remove duplicates
    allRecommendations.sort((a, b) => b.priority - a.priority);
    
    const uniqueRecommendations = [];
    const seen = new Set();
    
    for (const item of allRecommendations) {
      const key = item.recommendation.toLowerCase().trim();
      if (!seen.has(key)) {
        seen.add(key);
        uniqueRecommendations.push(`[${item.threat_level}] ${item.recommendation}`);
      }
    }

    return uniqueRecommendations;
  }

  /**
   * Run comprehensive analysis on all security data types
   * @param {Object} allData - Object containing login, firewall, and patch data
   * @returns {Promise<Object>} Comprehensive security posture report
   */
  async runFullAnalysis(allData) {
    this.ensureInitialized();

    const results = {
      timestamp: new Date().toISOString(),
      analyses: [],
      overall_risk_score: 0,
      consolidated_mitigations: [],
      summary: {}
    };

    try {
      // Run all analyses
      if (allData.logins && allData.logins.length > 0) {
        console.log(`[${this.getTimestamp()}] INFO: Analyzing login data...`);
        const loginAnalysis = await this.analyzeLoginAttempt(allData.logins);
        results.analyses.push(loginAnalysis);
      }

      if (allData.firewall && allData.firewall.length > 0) {
        console.log(`[${this.getTimestamp()}] INFO: Analyzing firewall data...`);
        const firewallAnalysis = await this.analyzeFirewallLog(allData.firewall);
        results.analyses.push(firewallAnalysis);
      }

      if (allData.patches && allData.patches.length > 0) {
        console.log(`[${this.getTimestamp()}] INFO: Analyzing patch data...`);
        const patchAnalysis = await this.analyzePatchStatus(allData.patches);
        results.analyses.push(patchAnalysis);
      }

      // Generate composite scores and recommendations
      results.overall_risk_score = this.generateRiskScore(results.analyses);
      results.consolidated_mitigations = this.generateMitigations(results.analyses);

      // Generate summary
      results.summary = {
        total_analyses: results.analyses.length,
        threat_levels: this.getThreatLevelCounts(results.analyses),
        highest_threat: this.getHighestThreat(results.analyses),
        total_indicators: this.getTotalIndicators(results.analyses),
        total_recommendations: results.consolidated_mitigations.length
      };

      return results;
    } catch (error) {
      throw new Error(`Full analysis failed: ${error.message}`);
    }
  }

  /**
   * Ensure agent is initialized before operations
   */
  ensureInitialized() {
    if (!this.initialized) {
      throw new Error('Agent not initialized. Call initialize() first.');
    }
  }

  /**
   * Get formatted timestamp for logging
   * @returns {string} Formatted timestamp
   */
  getTimestamp() {
    return new Date().toISOString().replace('T', ' ').substring(0, 19);
  }

  /**
   * Count threat levels across analyses
   * @param {Array<Object>} analyses - Array of analysis results
   * @returns {Object} Threat level counts
   */
  getThreatLevelCounts(analyses) {
    const counts = { CRITICAL: 0, HIGH: 0, MEDIUM: 0, LOW: 0 };
    analyses.forEach(a => {
      if (a.threat_level) {
        counts[a.threat_level] = (counts[a.threat_level] || 0) + 1;
      }
    });
    return counts;
  }

  /**
   * Get highest threat level from analyses
   * @param {Array<Object>} analyses - Array of analysis results
   * @returns {string} Highest threat level
   */
  getHighestThreat(analyses) {
    const priority = { CRITICAL: 4, HIGH: 3, MEDIUM: 2, LOW: 1 };
    let highest = 'LOW';
    let highestPriority = 0;
    
    analyses.forEach(a => {
      const p = priority[a.threat_level] || 0;
      if (p > highestPriority) {
        highestPriority = p;
        highest = a.threat_level;
      }
    });
    
    return highest;
  }

  /**
   * Get total count of indicators across analyses
   * @param {Array<Object>} analyses - Array of analysis results
   * @returns {number} Total indicator count
   */
  getTotalIndicators(analyses) {
    return analyses.reduce((sum, a) => 
      sum + (a.indicators ? a.indicators.length : 0), 0
    );
  }
}

export default CybersecurityAgent;
