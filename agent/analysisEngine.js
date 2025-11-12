/**
 * Analysis Engine - Coordinates multi-step analysis workflow
 * Orchestrates data processing, LLM analysis, and result aggregation
 */

import { ollamaService } from '../services/ollamaService.js';
import { processLoginData, processFirewallData, processPatchData } from '../services/dataProcessor.js';
import { formatPrompt, LOGIN_ANALYSIS_PROMPT, FIREWALL_ANALYSIS_PROMPT, PATCH_ANALYSIS_PROMPT } from '../config/prompts.js';
import { agentConfig } from '../config/agentConfig.js';

class AnalysisEngine {
  constructor() {
    this.results = {
      login: null,
      firewall: null,
      patch: null,
    };
  }

  /**
   * Run login analysis workflow
   * @param {Array|Object} loginData - Raw login data
   * @returns {Promise<Object>} Analysis results
   */
  async analyzeLogin(loginData) {
    console.log('🔍 Starting login analysis...');
    
    try {
      // Step 1: Process and normalize data
      console.log('  📊 Processing login data...');
      const processed = processLoginData(loginData);
      console.log(`  ✓ Processed ${processed.totalAttempts} login attempts`);
      console.log(`  ✓ Failed: ${processed.failedAttempts}, Successful: ${processed.successfulAttempts}`);
      console.log(`  ✓ Detected ${processed.suspiciousPatterns.length} suspicious patterns`);

      // Step 2: Prepare context for LLM
      const context = {
        summary: processed.summary,
        suspiciousPatterns: processed.suspiciousPatterns,
        features: processed.features.slice(0, 20), // Limit to avoid token overflow
      };

      // Step 3: Send to LLM for analysis
      console.log('  🤖 Sending to AI for threat analysis...');
      const prompt = formatPrompt(LOGIN_ANALYSIS_PROMPT, context);
      const llmResult = await ollamaService.generateAndParse(prompt);

      if (!llmResult.success) {
        throw new Error(`LLM analysis failed: ${llmResult.error}`);
      }

      console.log('  ✅ AI analysis complete');

      // Step 4: Enhance results with processed data
      const result = {
        type: 'login_analysis',
        timestamp: new Date().toISOString(),
        processed: processed.summary,
        analysis: llmResult.data,
        rawData: processed,
        metadata: llmResult.metadata,
      };

      this.results.login = result;
      return result;

    } catch (error) {
      console.error('  ❌ Login analysis failed:', error.message);
      return {
        type: 'login_analysis',
        timestamp: new Date().toISOString(),
        error: error.message,
        success: false,
      };
    }
  }

  /**
   * Run firewall log analysis workflow
   * @param {Array|Object} firewallData - Raw firewall logs
   * @returns {Promise<Object>} Analysis results
   */
  async analyzeFirewall(firewallData) {
    console.log('🔍 Starting firewall analysis...');
    
    try {
      // Step 1: Process and normalize data
      console.log('  📊 Processing firewall logs...');
      const processed = processFirewallData(firewallData);
      console.log(`  ✓ Processed ${processed.totalEvents} firewall events`);
      console.log(`  ✓ Blocked: ${processed.blockedEvents}, Allowed: ${processed.allowedEvents}`);
      console.log(`  ✓ Detected ${processed.threatIndicators.length} threat indicators`);

      // Step 2: Prepare context for LLM
      const context = {
        summary: processed.summary,
        threatIndicators: processed.threatIndicators,
        features: processed.features.slice(0, 20),
      };

      // Step 3: Send to LLM for analysis
      console.log('  🤖 Sending to AI for threat analysis...');
      const prompt = formatPrompt(FIREWALL_ANALYSIS_PROMPT, context);
      const llmResult = await ollamaService.generateAndParse(prompt);

      if (!llmResult.success) {
        throw new Error(`LLM analysis failed: ${llmResult.error}`);
      }

      console.log('  ✅ AI analysis complete');

      // Step 4: Enhance results
      const result = {
        type: 'firewall_analysis',
        timestamp: new Date().toISOString(),
        processed: processed.summary,
        analysis: llmResult.data,
        rawData: processed,
        metadata: llmResult.metadata,
      };

      this.results.firewall = result;
      return result;

    } catch (error) {
      console.error('  ❌ Firewall analysis failed:', error.message);
      return {
        type: 'firewall_analysis',
        timestamp: new Date().toISOString(),
        error: error.message,
        success: false,
      };
    }
  }

  /**
   * Run patch status analysis workflow
   * @param {Array|Object} patchData - Raw patch data
   * @returns {Promise<Object>} Analysis results
   */
  async analyzePatch(patchData) {
    console.log('🔍 Starting patch analysis...');
    
    try {
      // Step 1: Process and normalize data
      console.log('  📊 Processing patch data...');
      const processed = processPatchData(patchData);
      console.log(`  ✓ Analyzed ${processed.totalSystems} systems`);
      console.log(`  ✓ Found ${processed.summary.totalVulnerabilities} vulnerabilities`);
      console.log(`  ✓ Critical: ${processed.criticalVulnerabilities}, High: ${processed.highVulnerabilities}`);

      // Step 2: Prepare context for LLM
      const context = {
        summary: processed.summary,
        vulnerabilities: processed.vulnerabilities.slice(0, 20),
        features: processed.features,
      };

      // Step 3: Send to LLM for analysis
      console.log('  🤖 Sending to AI for vulnerability analysis...');
      const prompt = formatPrompt(PATCH_ANALYSIS_PROMPT, context);
      const llmResult = await ollamaService.generateAndParse(prompt);

      if (!llmResult.success) {
        throw new Error(`LLM analysis failed: ${llmResult.error}`);
      }

      console.log('  ✅ AI analysis complete');

      // Step 4: Enhance results
      const result = {
        type: 'patch_analysis',
        timestamp: new Date().toISOString(),
        processed: processed.summary,
        analysis: llmResult.data,
        rawData: processed,
        metadata: llmResult.metadata,
      };

      this.results.patch = result;
      return result;

    } catch (error) {
      console.error('  ❌ Patch analysis failed:', error.message);
      return {
        type: 'patch_analysis',
        timestamp: new Date().toISOString(),
        error: error.message,
        success: false,
      };
    }
  }

  /**
   * Calculate composite risk score from all analyses
   * @returns {Object} Risk score and assessment
   */
  calculateCompositeRisk() {
    const weights = agentConfig.analysisWeights;
    let totalScore = 0;
    let availableAnalyses = 0;

    // Calculate weighted scores
    if (this.results.login?.analysis) {
      const score = this.calculateThreatScore(this.results.login.analysis);
      totalScore += score * weights.loginAnomalies;
      availableAnalyses++;
    }

    if (this.results.firewall?.analysis) {
      const score = this.calculateThreatScore(this.results.firewall.analysis);
      totalScore += score * weights.firewallThreats;
      availableAnalyses++;
    }

    if (this.results.patch?.analysis) {
      const score = this.calculateThreatScore(this.results.patch.analysis);
      totalScore += score * weights.patchVulnerabilities;
      availableAnalyses++;
    }

    if (availableAnalyses === 0) {
      return {
        score: 0,
        level: 'UNKNOWN',
        error: 'No analysis results available',
      };
    }

    // Normalize score if not all analyses are available
    const normalizedScore = availableAnalyses < 3 
      ? totalScore / availableAnalyses * 3 
      : totalScore;

    return {
      score: Math.round(normalizedScore),
      level: this.getRiskLevel(normalizedScore),
      availableAnalyses,
      contributors: this.getContributingFactors(),
    };
  }

  /**
   * Calculate threat score from analysis result
   * @param {Object} analysis - Analysis result
   * @returns {number} Score (0-100)
   */
  calculateThreatScore(analysis) {
    if (!analysis.threat_detected) {
      return 0;
    }

    const severityScores = {
      'CRITICAL': 95,
      'HIGH': 75,
      'MEDIUM': 50,
      'LOW': 25,
    };

    const baseScore = severityScores[analysis.severity] || 50;
    const confidence = analysis.confidence || 0.5;

    return baseScore * confidence;
  }

  /**
   * Get risk level from score
   * @param {number} score - Risk score
   * @returns {string} Risk level
   */
  getRiskLevel(score) {
    const thresholds = agentConfig.riskThresholds;
    
    if (score >= thresholds.critical) return 'CRITICAL';
    if (score >= thresholds.high) return 'HIGH';
    if (score >= thresholds.medium) return 'MEDIUM';
    return 'LOW';
  }

  /**
   * Get contributing factors to risk score
   * @returns {Array} Contributing factors
   */
  getContributingFactors() {
    const factors = [];

    if (this.results.login?.analysis?.threat_detected) {
      factors.push({
        source: 'Login Analysis',
        severity: this.results.login.analysis.severity,
        threat: this.results.login.analysis.threat_type,
      });
    }

    if (this.results.firewall?.analysis?.threat_detected) {
      factors.push({
        source: 'Firewall Analysis',
        severity: this.results.firewall.analysis.severity,
        threat: this.results.firewall.analysis.threat_type,
      });
    }

    if (this.results.patch?.analysis?.threat_detected) {
      factors.push({
        source: 'Patch Analysis',
        severity: this.results.patch.analysis.severity,
        threat: this.results.patch.analysis.threat_type,
      });
    }

    return factors;
  }

  /**
   * Aggregate all mitigation recommendations
   * @returns {Array} All mitigations
   */
  getAllMitigations() {
    const mitigations = [];

    if (this.results.login?.analysis?.mitigation) {
      mitigations.push({
        source: 'Login Analysis',
        actions: this.results.login.analysis.mitigation,
      });
    }

    if (this.results.firewall?.analysis?.mitigation) {
      mitigations.push({
        source: 'Firewall Analysis',
        actions: this.results.firewall.analysis.mitigation,
      });
    }

    if (this.results.patch?.analysis?.mitigation) {
      mitigations.push({
        source: 'Patch Analysis',
        actions: this.results.patch.analysis.mitigation,
      });
    }

    return mitigations;
  }

  /**
   * Get full analysis report
   * @returns {Object} Complete report
   */
  getFullReport() {
    const riskAssessment = this.calculateCompositeRisk();
    const mitigations = this.getAllMitigations();

    return {
      timestamp: new Date().toISOString(),
      riskAssessment,
      analyses: {
        login: this.results.login,
        firewall: this.results.firewall,
        patch: this.results.patch,
      },
      mitigations,
      executiveSummary: this.generateExecutiveSummary(riskAssessment),
    };
  }

  /**
   * Generate executive summary
   * @param {Object} riskAssessment - Risk assessment results
   * @returns {string} Executive summary
   */
  generateExecutiveSummary(riskAssessment) {
    const { score, level, contributors } = riskAssessment;
    
    if (contributors.length === 0) {
      return 'No significant security threats detected.';
    }

    const threatCount = contributors.length;
    const criticalThreats = contributors.filter(c => c.severity === 'CRITICAL').length;
    
    let summary = `Overall Risk Score: ${score}/100 (${level}). `;
    summary += `Detected ${threatCount} security concern${threatCount > 1 ? 's' : ''}.`;
    
    if (criticalThreats > 0) {
      summary += ` ${criticalThreats} CRITICAL threat${criticalThreats > 1 ? 's' : ''} requiring immediate attention.`;
    }

    return summary;
  }

  /**
   * Reset analysis results
   */
  reset() {
    this.results = {
      login: null,
      firewall: null,
      patch: null,
    };
  }
}

export default AnalysisEngine;
