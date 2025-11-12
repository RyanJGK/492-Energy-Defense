/**
 * Test Script - Individual Agent Function Tests
 * Tests each analysis function independently
 */

import { readFileSync } from 'fs';
import { agent } from '../agent/cybersecurityAgent.js';
import { formatAnalysisResult } from '../utils/formatters.js';
import chalk from 'chalk';

// Load sample data
const loginData = JSON.parse(readFileSync('./data/sampleLogins.json', 'utf-8'));
const firewallData = JSON.parse(readFileSync('./data/sampleFirewallLogs.json', 'utf-8'));
const patchData = JSON.parse(readFileSync('./data/samplePatchData.json', 'utf-8'));

async function testLoginAnalysis() {
  console.log(chalk.cyan.bold('\n🧪 TEST 1: Login Attempt Analysis'));
  console.log(chalk.gray('Testing with sample login data containing brute force attempt...\n'));
  
  try {
    const result = await agent.analyzeLoginAttempt(loginData);
    formatAnalysisResult(result);
    return result;
  } catch (error) {
    console.error(chalk.red('❌ Test failed:'), error.message);
    return null;
  }
}

async function testFirewallAnalysis() {
  console.log(chalk.cyan.bold('\n🧪 TEST 2: Firewall Log Analysis'));
  console.log(chalk.gray('Testing with sample firewall logs containing port scan...\n'));
  
  try {
    const result = await agent.analyzeFirewallLog(firewallData);
    formatAnalysisResult(result);
    return result;
  } catch (error) {
    console.error(chalk.red('❌ Test failed:'), error.message);
    return null;
  }
}

async function testPatchAnalysis() {
  console.log(chalk.cyan.bold('\n🧪 TEST 3: Patch Status Analysis'));
  console.log(chalk.gray('Testing with sample patch data containing vulnerabilities...\n'));
  
  try {
    const result = await agent.analyzePatchStatus(patchData);
    formatAnalysisResult(result);
    return result;
  } catch (error) {
    console.error(chalk.red('❌ Test failed:'), error.message);
    return null;
  }
}

async function testRiskScoreGeneration(loginResult, firewallResult, patchResult) {
  console.log(chalk.cyan.bold('\n🧪 TEST 4: Risk Score Generation'));
  console.log(chalk.gray('Calculating composite risk score from all analyses...\n'));
  
  try {
    const riskScore = agent.generateRiskScore();
    
    console.log('═'.repeat(60));
    console.log(chalk.blue('📊 Risk Score Results:'));
    console.log(`   Overall Score: ${chalk.white.bold(riskScore.score + '/100')}`);
    console.log(`   Risk Level: ${chalk.white(riskScore.level)}`);
    console.log(`   Analyses Used: ${chalk.white(riskScore.availableAnalyses)}`);
    
    if (riskScore.contributors && riskScore.contributors.length > 0) {
      console.log(chalk.blue('\n   Contributing Factors:'));
      riskScore.contributors.forEach((factor, i) => {
        console.log(`   ${i + 1}. ${factor.source} - ${factor.severity} - ${factor.threat}`);
      });
    }
    console.log('═'.repeat(60));
    
    return riskScore;
  } catch (error) {
    console.error(chalk.red('❌ Test failed:'), error.message);
    return null;
  }
}

async function testMitigationGeneration() {
  console.log(chalk.cyan.bold('\n🧪 TEST 5: Mitigation Generation'));
  console.log(chalk.gray('Generating actionable recommendations...\n'));
  
  try {
    const mitigations = agent.generateMitigations();
    
    console.log('═'.repeat(60));
    console.log(chalk.blue('🛡️  Generated Mitigations:'));
    
    if (mitigations.length === 0) {
      console.log(chalk.yellow('   No mitigations generated (no threats detected)'));
    } else {
      mitigations.forEach((mitigation) => {
        console.log(chalk.cyan(`\n   ${mitigation.source}:`));
        mitigation.actions.forEach((action, i) => {
          console.log(`   ${i + 1}. ${action}`);
        });
      });
    }
    console.log('═'.repeat(60));
    
    return mitigations;
  } catch (error) {
    console.error(chalk.red('❌ Test failed:'), error.message);
    return null;
  }
}

// Main test execution
async function runTests() {
  console.log(chalk.green.bold('\n' + '═'.repeat(70)));
  console.log(chalk.green.bold('🧪 CYBERSECURITY AGENT - INDIVIDUAL FUNCTION TESTS'));
  console.log(chalk.green.bold('═'.repeat(70)));
  
  // Initialize agent
  console.log(chalk.cyan('\n📋 Step 1: Initializing Agent...'));
  const initialized = await agent.initialize();
  
  if (!initialized) {
    console.error(chalk.red('\n❌ Agent initialization failed. Cannot proceed with tests.'));
    process.exit(1);
  }
  
  let passedTests = 0;
  let totalTests = 5;
  
  // Run individual tests
  const loginResult = await testLoginAnalysis();
  if (loginResult && !loginResult.error) passedTests++;
  
  const firewallResult = await testFirewallAnalysis();
  if (firewallResult && !firewallResult.error) passedTests++;
  
  const patchResult = await testPatchAnalysis();
  if (patchResult && !patchResult.error) passedTests++;
  
  const riskScore = await testRiskScoreGeneration(loginResult, firewallResult, patchResult);
  if (riskScore && !riskScore.error) passedTests++;
  
  const mitigations = await testMitigationGeneration();
  if (mitigations !== null) passedTests++;
  
  // Summary
  console.log(chalk.green.bold('\n' + '═'.repeat(70)));
  console.log(chalk.green.bold('📊 TEST SUMMARY'));
  console.log(chalk.green.bold('═'.repeat(70)));
  console.log(`Tests Passed: ${chalk.white.bold(passedTests + '/' + totalTests)}`);
  
  if (passedTests === totalTests) {
    console.log(chalk.green.bold('\n✅ All tests passed successfully!'));
  } else {
    console.log(chalk.yellow.bold(`\n⚠️  ${totalTests - passedTests} test(s) failed.`));
  }
  console.log(chalk.green.bold('═'.repeat(70) + '\n'));
}

// Run tests
runTests().catch(error => {
  console.error(chalk.red('\n❌ Test suite failed:'), error);
  process.exit(1);
});
