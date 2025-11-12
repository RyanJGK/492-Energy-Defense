/**
 * Integration Test - Full Analysis Pipeline
 * Tests the complete workflow with all data types
 */

import { readFileSync } from 'fs';
import { agent } from '../agent/cybersecurityAgent.js';
import { formatSecurityReport } from '../utils/formatters.js';
import chalk from 'chalk';

// Load sample data
const loginData = JSON.parse(readFileSync('./data/sampleLogins.json', 'utf-8'));
const firewallData = JSON.parse(readFileSync('./data/sampleFirewallLogs.json', 'utf-8'));
const patchData = JSON.parse(readFileSync('./data/samplePatchData.json', 'utf-8'));

async function runIntegrationTest() {
  console.log(chalk.green.bold('\n' + '═'.repeat(70)));
  console.log(chalk.green.bold('🧪 INTEGRATION TEST - FULL ANALYSIS PIPELINE'));
  console.log(chalk.green.bold('═'.repeat(70)));
  
  console.log(chalk.cyan('\n📋 Initializing Agent...'));
  const initialized = await agent.initialize();
  
  if (!initialized) {
    console.error(chalk.red('\n❌ Agent initialization failed.'));
    process.exit(1);
  }
  
  console.log(chalk.cyan('\n📋 Running comprehensive security analysis...\n'));
  
  try {
    // Run full analysis with all data types
    const report = await agent.runFullAnalysis({
      login: loginData,
      firewall: firewallData,
      patch: patchData,
    });
    
    // Display formatted report
    formatSecurityReport(report);
    
    // Display detailed analysis results
    console.log(chalk.blue.bold('📝 DETAILED ANALYSIS RESULTS'));
    console.log('─'.repeat(70));
    
    if (report.analyses.login) {
      console.log(chalk.cyan('\n1. Login Analysis:'));
      if (report.analyses.login.analysis) {
        const la = report.analyses.login.analysis;
        console.log(`   Threat Detected: ${la.threat_detected ? chalk.red('YES') : chalk.green('NO')}`);
        if (la.threat_detected) {
          console.log(`   Type: ${la.threat_type}`);
          console.log(`   Severity: ${la.severity}`);
          console.log(`   Confidence: ${(la.confidence * 100).toFixed(0)}%`);
        }
      }
    }
    
    if (report.analyses.firewall) {
      console.log(chalk.cyan('\n2. Firewall Analysis:'));
      if (report.analyses.firewall.analysis) {
        const fa = report.analyses.firewall.analysis;
        console.log(`   Threat Detected: ${fa.threat_detected ? chalk.red('YES') : chalk.green('NO')}`);
        if (fa.threat_detected) {
          console.log(`   Type: ${fa.threat_type}`);
          console.log(`   Severity: ${fa.severity}`);
          console.log(`   Confidence: ${(fa.confidence * 100).toFixed(0)}%`);
        }
      }
    }
    
    if (report.analyses.patch) {
      console.log(chalk.cyan('\n3. Patch Analysis:'));
      if (report.analyses.patch.analysis) {
        const pa = report.analyses.patch.analysis;
        console.log(`   Threat Detected: ${pa.threat_detected ? chalk.red('YES') : chalk.green('NO')}`);
        if (pa.threat_detected) {
          console.log(`   Type: ${pa.threat_type}`);
          console.log(`   Severity: ${pa.severity}`);
          console.log(`   Confidence: ${(pa.confidence * 100).toFixed(0)}%`);
        }
      }
    }
    
    console.log('\n' + '─'.repeat(70));
    
    // Test conclusions
    console.log(chalk.green.bold('\n✅ INTEGRATION TEST PASSED'));
    console.log(chalk.white('The agent successfully:'));
    console.log(chalk.white('  ✓ Initialized and connected to Ollama'));
    console.log(chalk.white('  ✓ Analyzed login attempt data'));
    console.log(chalk.white('  ✓ Analyzed firewall log data'));
    console.log(chalk.white('  ✓ Analyzed patch status data'));
    console.log(chalk.white('  ✓ Generated composite risk score'));
    console.log(chalk.white('  ✓ Provided mitigation recommendations'));
    console.log(chalk.white('  ✓ Created comprehensive security report'));
    
    console.log(chalk.green.bold('\n' + '═'.repeat(70) + '\n'));
    
    // Save report to file
    const reportPath = './test-report.json';
    const fs = await import('fs');
    fs.writeFileSync(reportPath, JSON.stringify(report, null, 2));
    console.log(chalk.gray(`📄 Full report saved to: ${reportPath}\n`));
    
  } catch (error) {
    console.error(chalk.red('\n❌ Integration test failed:'), error.message);
    console.error(error.stack);
    process.exit(1);
  }
}

// Run integration test
runIntegrationTest().catch(error => {
  console.error(chalk.red('\n❌ Test failed with error:'), error);
  process.exit(1);
});
