#!/usr/bin/env node

/**
 * Cybersecurity AI Agent - CLI Entry Point
 * Professional terminal interface for threat detection and analysis
 */

import fs from 'fs/promises';
import path from 'path';
import chalk from 'chalk';
import AnalysisEngine from './agent/analysisEngine.js';

class CyberSecurityCLI {
  constructor() {
    this.engine = new AnalysisEngine();
    this.samplesPath = './data/samples.json';
  }

  /**
   * Get formatted timestamp for logging
   * @returns {string} Formatted timestamp
   */
  getTimestamp() {
    return new Date().toISOString().replace('T', ' ').substring(0, 19);
  }

  /**
   * Log message with timestamp and level
   * @param {string} level - Log level
   * @param {string} message - Log message
   * @param {string} color - Chalk color function name
   */
  log(level, message, color = null) {
    const timestamp = this.getTimestamp();
    const prefix = `[${timestamp}] ${level}:`;
    
    if (color && chalk[color]) {
      console.log(chalk[color](prefix), message);
    } else {
      console.log(prefix, message);
    }
  }

  /**
   * Get color for threat level
   * @param {string} threatLevel - Threat level
   * @returns {string} Chalk color function name
   */
  getThreatColor(threatLevel) {
    switch (threatLevel) {
      case 'CRITICAL':
        return 'red';
      case 'HIGH':
        return 'yellow';
      case 'MEDIUM':
        return 'cyan';
      case 'LOW':
      default:
        return 'white';
    }
  }

  /**
   * Load sample data from file
   * @returns {Promise<Object>} Sample data
   */
  async loadSamples() {
    try {
      const data = await fs.readFile(this.samplesPath, 'utf-8');
      return JSON.parse(data);
    } catch (error) {
      throw new Error(`Failed to load sample data: ${error.message}`);
    }
  }

  /**
   * Display analysis results in professional format
   * @param {Object} result - Analysis result
   */
  displayAnalysis(result) {
    const color = this.getThreatColor(result.threat_level);
    
    console.log('');
    this.log('THREAT', chalk[color](result.threat_level) + ' severity detected', color);
    this.log('CONFIDENCE', `${result.confidence}%`);
    
    if (result.indicators && result.indicators.length > 0) {
      console.log('');
      this.log('INDICATORS', '');
      result.indicators.forEach(indicator => {
        console.log(`  - ${indicator}`);
      });
    }

    if (result.mitre_tactics && result.mitre_tactics.length > 0) {
      console.log('');
      this.log('MITRE_TACTICS', result.mitre_tactics.join(', '));
    }

    if (result.recommendations && result.recommendations.length > 0) {
      console.log('');
      this.log('RECOMMENDATIONS', '');
      result.recommendations.forEach(rec => {
        console.log(`  - ${rec}`);
      });
    }

    if (result.reasoning) {
      console.log('');
      this.log('REASONING', result.reasoning);
    }

    console.log('');
    this.log('RISK_SCORE', chalk[color](`${result.risk_score}/100`));
    console.log('');
  }

  /**
   * Display full analysis report
   * @param {Object} report - Full analysis report
   */
  displayFullReport(report) {
    console.log('');
    console.log('='.repeat(80));
    this.log('REPORT', 'COMPREHENSIVE SECURITY ANALYSIS');
    console.log('='.repeat(80));

    if (report.summary) {
      console.log('');
      this.log('SUMMARY', '');
      const summary = report.summary;
      console.log(`  Overall Risk: ${chalk[this.getThreatColor(summary.overall_risk)](summary.overall_risk)}`);
      console.log(`  Risk Score: ${summary.risk_score}/100`);
      console.log(`  Critical Findings: ${summary.critical_findings}`);
      console.log(`  High Findings: ${summary.high_findings}`);
      console.log(`  Total Findings: ${summary.total_findings}`);
      console.log(`  Immediate Action Required: ${summary.requires_immediate_action ? 'YES' : 'NO'}`);
      console.log(`  Security Posture: ${summary.security_posture}`);
    }

    if (report.analyses && report.analyses.length > 0) {
      console.log('');
      console.log('-'.repeat(80));
      this.log('DETAILED_FINDINGS', '');
      console.log('-'.repeat(80));

      report.analyses.forEach((analysis, index) => {
        console.log('');
        console.log(`${index + 1}. ${analysis.type.toUpperCase()} ANALYSIS`);
        console.log(`   Threat Level: ${chalk[this.getThreatColor(analysis.threat_level)](analysis.threat_level)}`);
        console.log(`   Confidence: ${Math.round(analysis.confidence * 100)}%`);
        
        if (analysis.indicators && analysis.indicators.length > 0) {
          console.log(`   Indicators:`);
          analysis.indicators.slice(0, 3).forEach(ind => {
            console.log(`     - ${ind}`);
          });
          if (analysis.indicators.length > 3) {
            console.log(`     ... and ${analysis.indicators.length - 3} more`);
          }
        }
      });
    }

    if (report.consolidated_mitigations && report.consolidated_mitigations.length > 0) {
      console.log('');
      console.log('-'.repeat(80));
      this.log('PRIORITIZED_ACTIONS', '');
      console.log('-'.repeat(80));
      console.log('');
      report.consolidated_mitigations.forEach((rec, index) => {
        console.log(`${index + 1}. ${rec}`);
      });
    }

    console.log('');
    console.log('='.repeat(80));
    this.log('RISK_SCORE', chalk[this.getThreatColor(report.summary?.overall_risk || 'LOW')](`${report.overall_risk_score}/100`));
    console.log('='.repeat(80));
    console.log('');
  }

  /**
   * Analyze login attempts
   */
  async analyzeLogin() {
    try {
      this.log('INFO', 'Loading login data...');
      const samples = await this.loadSamples();
      
      this.log('ANALYSIS', 'Processing login events...');
      const result = await this.engine.processData(samples.logins, 'login');
      
      this.displayAnalysis(result);
    } catch (error) {
      this.log('ERROR', error.message, 'red');
      process.exit(1);
    }
  }

  /**
   * Analyze firewall logs
   */
  async analyzeFirewall() {
    try {
      this.log('INFO', 'Loading firewall data...');
      const samples = await this.loadSamples();
      
      this.log('ANALYSIS', 'Processing firewall logs...');
      const result = await this.engine.processData(samples.firewall, 'firewall');
      
      this.displayAnalysis(result);
    } catch (error) {
      this.log('ERROR', error.message, 'red');
      process.exit(1);
    }
  }

  /**
   * Analyze patch status
   */
  async analyzePatch() {
    try {
      this.log('INFO', 'Loading patch data...');
      const samples = await this.loadSamples();
      
      this.log('ANALYSIS', 'Processing patch status...');
      const result = await this.engine.processData(samples.patches, 'patch');
      
      this.displayAnalysis(result);
    } catch (error) {
      this.log('ERROR', error.message, 'red');
      process.exit(1);
    }
  }

  /**
   * Run full analysis on all data types
   */
  async analyzeAll() {
    try {
      this.log('INFO', 'Loading all security data...');
      const samples = await this.loadSamples();
      
      this.log('ANALYSIS', 'Running comprehensive analysis...');
      const report = await this.engine.getAgent().runFullAnalysis(samples);
      
      this.displayFullReport(report);
    } catch (error) {
      this.log('ERROR', error.message, 'red');
      process.exit(1);
    }
  }

  /**
   * Run integration tests
   */
  async runTests() {
    try {
      this.log('INFO', 'Starting integration tests...');
      
      // Import and run tests
      const { run } = await import('./tests/integration.test.js');
      await run();
      
      this.log('INFO', 'All tests completed');
    } catch (error) {
      this.log('ERROR', `Test execution failed: ${error.message}`, 'red');
      process.exit(1);
    }
  }

  /**
   * Display help message
   */
  displayHelp() {
    console.log(`
Cybersecurity AI Agent - Professional Threat Detection CLI

USAGE:
  node index.js <command>

COMMANDS:
  analyze login      Analyze authentication logs for threats
  analyze firewall   Analyze firewall logs for network threats
  analyze patch      Analyze patch status for vulnerabilities
  analyze all        Run comprehensive analysis on all data types
  test              Run integration test suite
  help              Display this help message

EXAMPLES:
  node index.js analyze login
  node index.js analyze all
  node index.js test

PREREQUISITES:
  - Ollama must be running locally (http://localhost:11434)
  - Mistral model must be installed (ollama pull mistral)

For more information, see README.md
`);
  }

  /**
   * Main CLI entry point
   */
  async run() {
    const args = process.argv.slice(2);
    
    if (args.length === 0 || args[0] === 'help') {
      this.displayHelp();
      return;
    }

    const command = args[0];
    const subCommand = args[1];

    try {
      // Initialize engine
      this.log('INFO', 'Initializing Cybersecurity Agent');
      const initialized = await this.engine.initialize();
      
      if (!initialized) {
        this.log('ERROR', 'Failed to initialize agent. Check Ollama connection.', 'red');
        process.exit(1);
      }
      
      this.log('INFO', 'Connected to Ollama (mistral)');

      // Execute command
      if (command === 'analyze') {
        switch (subCommand) {
          case 'login':
            await this.analyzeLogin();
            break;
          case 'firewall':
            await this.analyzeFirewall();
            break;
          case 'patch':
            await this.analyzePatch();
            break;
          case 'all':
            await this.analyzeAll();
            break;
          default:
            this.log('ERROR', `Unknown analysis type: ${subCommand}`, 'red');
            this.displayHelp();
            process.exit(1);
        }
      } else if (command === 'test') {
        await this.runTests();
      } else {
        this.log('ERROR', `Unknown command: ${command}`, 'red');
        this.displayHelp();
        process.exit(1);
      }

      process.exit(0);
    } catch (error) {
      this.log('ERROR', `Execution failed: ${error.message}`, 'red');
      console.error(error.stack);
      process.exit(1);
    }
  }
}

// Run CLI
const cli = new CyberSecurityCLI();
cli.run();
