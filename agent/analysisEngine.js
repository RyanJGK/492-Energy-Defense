/**
 * Analysis Engine - Workflow coordinator for security analysis
 * Handles data processing orchestration, aggregation, and output formatting
 */

import CybersecurityAgent from './cybersecurityAgent.js';
import config from '../config/index.js';

class AnalysisEngine {
  constructor() {
    this.agent = new CybersecurityAgent();
  }

  /**
   * Initialize the analysis engine
   * @returns {Promise<boolean>} Initialization status
   */
  async initialize() {
    return await this.agent.initialize();
  }

  /**
   * Process security data with normalization, analysis, and scoring
   * @param {Object|Array} rawData - Raw security data
   * @param {string} type - Data type (login, firewall, patch)
   * @returns {Promise<Object>} Formatted analysis result
   */
  async processData(rawData, type) {
    try {
      let analysis;
      
      switch (type) {
        case 'login':
          analysis = await this.agent.analyzeLoginAttempt(rawData);
          break;
        case 'firewall':
          analysis = await this.agent.analyzeFirewallLog(rawData);
          break;
        case 'patch':
          analysis = await this.agent.analyzePatchStatus(rawData);
          break;
        default:
          throw new Error(`Unknown analysis type: ${type}`);
      }

      // Calculate individual risk score
      const riskScore = this.agent.generateRiskScore([analysis]);
      
      return this.formatOutput(analysis, riskScore);
    } catch (error) {
      throw new Error(`Data processing failed for ${type}: ${error.message}`);
    }
  }

  /**
   * Aggregate findings from multiple analyses into single report
   * @param {Array<Object>} results - Array of analysis results
   * @returns {Object} Aggregated report
   */
  aggregateFindings(results) {
    if (!Array.isArray(results) || results.length === 0) {
      return {
        status: 'no_data',
        message: 'No analysis results to aggregate'
      };
    }

    const aggregated = {
      timestamp: new Date().toISOString(),
      total_analyses: results.length,
      analyses_by_type: this.groupByType(results),
      overall_risk_score: this.calculateRiskScore(results),
      threat_distribution: this.agent.getThreatLevelCounts(results),
      all_indicators: this.collectAllIndicators(results),
      all_mitre_tactics: this.collectAllMitreTactics(results),
      consolidated_recommendations: this.agent.generateMitigations(results),
      summary: this.generateExecutiveSummary(results)
    };

    return aggregated;
  }

  /**
   * Calculate composite risk score from multiple analyses
   * @param {Array<Object>} findings - Array of analysis findings
   * @returns {number} Composite risk score (0-100)
   */
  calculateRiskScore(findings) {
    return this.agent.generateRiskScore(findings);
  }

  /**
   * Format analysis output for display
   * @param {Object} analysis - Raw analysis result
   * @param {number} riskScore - Calculated risk score
   * @returns {Object} Formatted output
   */
  formatOutput(analysis, riskScore) {
    return {
      timestamp: analysis.timestamp,
      type: analysis.type,
      threat_level: analysis.threat_level,
      confidence: Math.round(analysis.confidence * 100),
      risk_score: riskScore,
      data_analyzed: analysis.data_analyzed,
      indicators: analysis.indicators || [],
      mitre_tactics: analysis.mitre_tactics || [],
      recommendations: analysis.recommendations || [],
      reasoning: analysis.reasoning || 'No reasoning provided'
    };
  }

  /**
   * Group analysis results by type
   * @param {Array<Object>} results - Analysis results
   * @returns {Object} Grouped results
   */
  groupByType(results) {
    const grouped = {
      login: [],
      firewall: [],
      patch: []
    };

    results.forEach(result => {
      if (result.type && grouped[result.type]) {
        grouped[result.type].push(result);
      }
    });

    return grouped;
  }

  /**
   * Collect all unique indicators from results
   * @param {Array<Object>} results - Analysis results
   * @returns {Array<string>} Unique indicators
   */
  collectAllIndicators(results) {
    const allIndicators = new Set();
    
    results.forEach(result => {
      if (result.indicators && Array.isArray(result.indicators)) {
        result.indicators.forEach(ind => allIndicators.add(ind));
      }
    });

    return Array.from(allIndicators);
  }

  /**
   * Collect all unique MITRE tactics from results
   * @param {Array<Object>} results - Analysis results
   * @returns {Array<string>} Unique MITRE tactics
   */
  collectAllMitreTactics(results) {
    const allTactics = new Set();
    
    results.forEach(result => {
      if (result.mitre_tactics && Array.isArray(result.mitre_tactics)) {
        result.mitre_tactics.forEach(tactic => allTactics.add(tactic));
      }
    });

    return Array.from(allTactics);
  }

  /**
   * Generate executive summary from analysis results
   * @param {Array<Object>} results - Analysis results
   * @returns {Object} Executive summary
   */
  generateExecutiveSummary(results) {
    const riskScore = this.calculateRiskScore(results);
    const threatCounts = this.agent.getThreatLevelCounts(results);
    const highestThreat = this.agent.getHighestThreat(results);
    
    let riskLevel = 'LOW';
    if (riskScore >= 80) riskLevel = 'CRITICAL';
    else if (riskScore >= 60) riskLevel = 'HIGH';
    else if (riskScore >= 40) riskLevel = 'MEDIUM';

    const criticalCount = threatCounts.CRITICAL || 0;
    const highCount = threatCounts.HIGH || 0;
    const totalThreats = criticalCount + highCount + (threatCounts.MEDIUM || 0) + (threatCounts.LOW || 0);

    return {
      overall_risk: riskLevel,
      risk_score: riskScore,
      highest_threat: highestThreat,
      critical_findings: criticalCount,
      high_findings: highCount,
      total_findings: totalThreats,
      requires_immediate_action: criticalCount > 0 || riskScore >= 80,
      security_posture: this.getSecurityPostureDescription(riskScore)
    };
  }

  /**
   * Get security posture description based on risk score
   * @param {number} riskScore - Risk score (0-100)
   * @returns {string} Security posture description
   */
  getSecurityPostureDescription(riskScore) {
    if (riskScore >= 80) {
      return 'Critical security issues detected. Immediate action required.';
    } else if (riskScore >= 60) {
      return 'High risk detected. Prompt remediation recommended.';
    } else if (riskScore >= 40) {
      return 'Moderate risk level. Address findings in planned maintenance.';
    } else if (riskScore >= 20) {
      return 'Low risk detected. Monitor and maintain current security controls.';
    } else {
      return 'Minimal security concerns. Continue monitoring.';
    }
  }

  /**
   * Get the agent instance
   * @returns {CybersecurityAgent} Agent instance
   */
  getAgent() {
    return this.agent;
  }
}

export default AnalysisEngine;
