/**
 * Integration Test Suite
 * Tests Ollama connectivity, data processing, and analysis functionality
 */

import fs from 'fs/promises';
import AnalysisEngine from '../agent/analysisEngine.js';
import ollamaService from '../services/ollamaService.js';
import config from '../config/index.js';

class TestRunner {
  constructor() {
    this.engine = new AnalysisEngine();
    this.samples = null;
    this.testResults = [];
  }

  /**
   * Get formatted timestamp
   * @returns {string} Formatted timestamp
   */
  getTimestamp() {
    return new Date().toISOString().replace('T', ' ').substring(0, 19);
  }

  /**
   * Log test result
   * @param {string} testName - Name of the test
   * @param {boolean} passed - Test result
   * @param {number} duration - Test duration in ms
   * @param {string} error - Error message if failed
   */
  logTest(testName, passed, duration, error = null) {
    const status = passed ? '[PASS]' : '[FAIL]';
    const statusColor = passed ? '\x1b[32m' : '\x1b[31m';
    const resetColor = '\x1b[0m';
    
    console.log(`${statusColor}${status}${resetColor} ${testName} (${duration}ms)`);
    
    if (error) {
      console.log(`       Error: ${error}`);
    }

    this.testResults.push({ testName, passed, duration, error });
  }

  /**
   * Assert helper function
   * @param {boolean} condition - Condition to assert
   * @param {string} message - Error message if assertion fails
   */
  assert(condition, message) {
    if (!condition) {
      throw new Error(message);
    }
  }

  /**
   * Load sample data
   */
  async loadSamples() {
    const data = await fs.readFile('./data/samples.json', 'utf-8');
    this.samples = JSON.parse(data);
  }

  /**
   * Test 1: Ollama connectivity check
   */
  async testOllamaConnectivity() {
    const startTime = Date.now();
    const testName = 'Ollama Connectivity Check';

    try {
      const isHealthy = await ollamaService.healthCheck();
      this.assert(isHealthy, 'Ollama service health check failed');
      
      const duration = Date.now() - startTime;
      this.logTest(testName, true, duration);
    } catch (error) {
      const duration = Date.now() - startTime;
      this.logTest(testName, false, duration, error.message);
      throw error;
    }
  }

  /**
   * Test 2: Login analysis with brute force sample
   */
  async testLoginAnalysis() {
    const startTime = Date.now();
    const testName = 'Login Analysis (Brute Force Detection)';

    try {
      // Use first login sample (brute force from Nigeria)
      const loginSample = [this.samples.logins[0]];
      const result = await this.engine.processData(loginSample, 'login');

      // Validations
      this.assert(result.type === 'login', 'Result type should be login');
      this.assert(result.threat_level, 'Result should have threat_level');
      this.assert(result.confidence > 0, 'Result should have confidence > 0');
      this.assert(Array.isArray(result.indicators), 'Result should have indicators array');
      this.assert(Array.isArray(result.recommendations), 'Result should have recommendations array');
      this.assert(typeof result.risk_score === 'number', 'Result should have numeric risk_score');
      this.assert(result.risk_score >= 0 && result.risk_score <= 100, 'Risk score should be 0-100');

      console.log(`       Detected: ${result.threat_level} threat with ${result.confidence}% confidence`);
      console.log(`       Risk Score: ${result.risk_score}/100`);

      const duration = Date.now() - startTime;
      this.logTest(testName, true, duration);
    } catch (error) {
      const duration = Date.now() - startTime;
      this.logTest(testName, false, duration, error.message);
      throw error;
    }
  }

  /**
   * Test 3: Firewall analysis with port scan sample
   */
  async testFirewallAnalysis() {
    const startTime = Date.now();
    const testName = 'Firewall Analysis (Port Scan Detection)';

    try {
      // Use firewall samples with blocked suspicious ports
      const firewallSamples = this.samples.firewall.filter(f => f.action === 'BLOCK');
      const result = await this.engine.processData(firewallSamples, 'firewall');

      // Validations
      this.assert(result.type === 'firewall', 'Result type should be firewall');
      this.assert(result.threat_level, 'Result should have threat_level');
      this.assert(result.confidence > 0, 'Result should have confidence > 0');
      this.assert(Array.isArray(result.indicators), 'Result should have indicators array');
      this.assert(Array.isArray(result.recommendations), 'Result should have recommendations array');
      this.assert(typeof result.risk_score === 'number', 'Result should have numeric risk_score');

      console.log(`       Detected: ${result.threat_level} threat with ${result.confidence}% confidence`);
      console.log(`       Risk Score: ${result.risk_score}/100`);

      const duration = Date.now() - startTime;
      this.logTest(testName, true, duration);
    } catch (error) {
      const duration = Date.now() - startTime;
      this.logTest(testName, false, duration, error.message);
      throw error;
    }
  }

  /**
   * Test 4: Patch analysis with critical CVE sample
   */
  async testPatchAnalysis() {
    const startTime = Date.now();
    const testName = 'Patch Analysis (Critical CVE Detection)';

    try {
      // Use critical patch samples
      const patchSamples = this.samples.patches.filter(p => p.criticality === 'critical');
      const result = await this.engine.processData(patchSamples, 'patch');

      // Validations
      this.assert(result.type === 'patch', 'Result type should be patch');
      this.assert(result.threat_level, 'Result should have threat_level');
      this.assert(result.confidence > 0, 'Result should have confidence > 0');
      this.assert(Array.isArray(result.indicators), 'Result should have indicators array');
      this.assert(Array.isArray(result.recommendations), 'Result should have recommendations array');
      this.assert(typeof result.risk_score === 'number', 'Result should have numeric risk_score');

      console.log(`       Detected: ${result.threat_level} threat with ${result.confidence}% confidence`);
      console.log(`       Risk Score: ${result.risk_score}/100`);

      const duration = Date.now() - startTime;
      this.logTest(testName, true, duration);
    } catch (error) {
      const duration = Date.now() - startTime;
      this.logTest(testName, false, duration, error.message);
      throw error;
    }
  }

  /**
   * Test 5: Full analysis combining all three data types
   */
  async testFullAnalysis() {
    const startTime = Date.now();
    const testName = 'Full Analysis (All Data Types)';

    try {
      const report = await this.engine.getAgent().runFullAnalysis(this.samples);

      // Validations
      this.assert(report.analyses, 'Report should have analyses array');
      this.assert(report.analyses.length === 3, 'Should have 3 analyses (login, firewall, patch)');
      this.assert(typeof report.overall_risk_score === 'number', 'Should have overall risk score');
      this.assert(report.overall_risk_score >= 0 && report.overall_risk_score <= 100, 
                  'Overall risk score should be 0-100');
      this.assert(Array.isArray(report.consolidated_mitigations), 
                  'Should have consolidated mitigations');
      this.assert(report.summary, 'Should have summary');
      this.assert(report.summary.overall_risk, 'Summary should have overall risk');

      console.log(`       Overall Risk: ${report.summary.overall_risk}`);
      console.log(`       Risk Score: ${report.overall_risk_score}/100`);
      console.log(`       Total Findings: ${report.summary.total_findings}`);
      console.log(`       Critical: ${report.summary.critical_findings}, High: ${report.summary.high_findings}`);

      const duration = Date.now() - startTime;
      this.logTest(testName, true, duration);
    } catch (error) {
      const duration = Date.now() - startTime;
      this.logTest(testName, false, duration, error.message);
      throw error;
    }
  }

  /**
   * Test 6: Risk score calculation validation
   */
  async testRiskScoreCalculation() {
    const startTime = Date.now();
    const testName = 'Risk Score Calculation Validation';

    try {
      // Create mock analysis results with known threat levels
      const mockAnalyses = [
        {
          type: 'login',
          threat_level: 'CRITICAL',
          confidence: 1.0,
          indicators: ['test'],
          recommendations: ['test']
        },
        {
          type: 'firewall',
          threat_level: 'HIGH',
          confidence: 0.9,
          indicators: ['test'],
          recommendations: ['test']
        },
        {
          type: 'patch',
          threat_level: 'MEDIUM',
          confidence: 0.8,
          indicators: ['test'],
          recommendations: ['test']
        }
      ];

      const riskScore = this.engine.getAgent().generateRiskScore(mockAnalyses);

      // Validations
      this.assert(typeof riskScore === 'number', 'Risk score should be a number');
      this.assert(riskScore >= 0 && riskScore <= 100, 'Risk score should be 0-100');
      this.assert(riskScore > 50, 'Risk score should be > 50 for CRITICAL/HIGH/MEDIUM threats');

      console.log(`       Calculated Risk Score: ${riskScore}/100`);
      
      // Verify weighted calculation
      const expectedScore = Math.round(
        (config.threatLevelScores.CRITICAL * 1.0 * config.riskWeights.login_anomalies +
         config.threatLevelScores.HIGH * 0.9 * config.riskWeights.firewall_threats +
         config.threatLevelScores.MEDIUM * 0.8 * config.riskWeights.patch_vulnerabilities) /
        (config.riskWeights.login_anomalies + config.riskWeights.firewall_threats + 
         config.riskWeights.patch_vulnerabilities)
      );

      console.log(`       Expected Score (formula): ${expectedScore}/100`);
      this.assert(Math.abs(riskScore - expectedScore) < 2, 
                  'Risk score should match weighted formula (within 2 points)');

      const duration = Date.now() - startTime;
      this.logTest(testName, true, duration);
    } catch (error) {
      const duration = Date.now() - startTime;
      this.logTest(testName, false, duration, error.message);
      throw error;
    }
  }

  /**
   * Run all tests
   */
  async runAll() {
    console.log('');
    console.log('='.repeat(80));
    console.log(`[${this.getTimestamp()}] INFO: Starting Integration Test Suite`);
    console.log('='.repeat(80));
    console.log('');

    try {
      // Initialize engine
      console.log(`[${this.getTimestamp()}] INFO: Initializing Analysis Engine`);
      const initialized = await this.engine.initialize();
      if (!initialized) {
        throw new Error('Failed to initialize analysis engine');
      }
      console.log(`[${this.getTimestamp()}] INFO: Engine initialized successfully`);
      console.log('');

      // Load samples
      console.log(`[${this.getTimestamp()}] INFO: Loading test data`);
      await this.loadSamples();
      console.log(`[${this.getTimestamp()}] INFO: Test data loaded`);
      console.log('');

      // Run tests sequentially
      console.log(`[${this.getTimestamp()}] INFO: Running tests...`);
      console.log('');

      await this.testOllamaConnectivity();
      await this.testLoginAnalysis();
      await this.testFirewallAnalysis();
      await this.testPatchAnalysis();
      await this.testFullAnalysis();
      await this.testRiskScoreCalculation();

      // Summary
      console.log('');
      console.log('='.repeat(80));
      console.log('TEST SUMMARY');
      console.log('='.repeat(80));

      const passed = this.testResults.filter(t => t.passed).length;
      const failed = this.testResults.filter(t => !t.passed).length;
      const totalDuration = this.testResults.reduce((sum, t) => sum + t.duration, 0);

      console.log(`Total Tests: ${this.testResults.length}`);
      console.log(`Passed: ${passed}`);
      console.log(`Failed: ${failed}`);
      console.log(`Total Duration: ${totalDuration}ms`);
      console.log('');

      if (failed === 0) {
        console.log('\x1b[32m✓ ALL TESTS PASSED\x1b[0m');
      } else {
        console.log('\x1b[31m✗ SOME TESTS FAILED\x1b[0m');
        process.exit(1);
      }

      console.log('='.repeat(80));
      console.log('');

    } catch (error) {
      console.log('');
      console.log('\x1b[31m[ERROR]\x1b[0m Test suite failed:', error.message);
      console.error(error.stack);
      process.exit(1);
    }
  }
}

// Export run function for CLI
export async function run() {
  const runner = new TestRunner();
  await runner.runAll();
}

// Run if called directly
if (import.meta.url === `file://${process.argv[1]}`) {
  run();
}
