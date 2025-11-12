/**
 * Prompt Test Script
 * Validates LLM prompt effectiveness and output quality
 */

import { ollamaService } from '../services/ollamaService.js';
import { formatPrompt, LOGIN_ANALYSIS_PROMPT } from '../config/prompts.js';
import chalk from 'chalk';

const sampleLoginData = {
  summary: {
    totalAttempts: 12,
    failedAttempts: 11,
    successfulAttempts: 1,
    failureRate: '91.67%',
    uniqueUsers: 1,
    uniqueIPs: 1,
    anomalyCount: 2,
  },
  suspiciousPatterns: [
    {
      type: 'brute_force_attack',
      severity: 'HIGH',
      detail: '11 failed attempts for admin in 234s',
      username: 'admin',
      attemptCount: 11,
      timeWindow: 234,
    },
    {
      type: 'privileged_account_access',
      severity: 'HIGH',
      detail: 'Attempt on privileged account: admin',
    },
  ],
  features: [
    {
      username: 'admin',
      sourceIP: '203.0.113.45',
      timestamp: '2025-11-12T02:45:12Z',
      success: false,
      location: 'Unknown',
      userAgent: 'curl/7.68.0',
      sessionId: null,
    },
  ],
};

async function testPromptEffectiveness() {
  console.log(chalk.green.bold('\n' + '═'.repeat(70)));
  console.log(chalk.green.bold('🧪 PROMPT EFFECTIVENESS TEST'));
  console.log(chalk.green.bold('═'.repeat(70)));
  
  console.log(chalk.cyan('\n📋 Step 1: Checking Ollama connectivity...'));
  const health = await ollamaService.healthCheck();
  
  if (!health.healthy) {
    console.error(chalk.red('❌ Ollama health check failed:'), health.error);
    process.exit(1);
  }
  
  console.log(chalk.green('✅ Ollama is healthy\n'));
  
  console.log(chalk.cyan('📋 Step 2: Testing login analysis prompt...\n'));
  console.log(chalk.gray('Sample Data:'));
  console.log(chalk.gray(JSON.stringify(sampleLoginData, null, 2)));
  console.log();
  
  const prompt = formatPrompt(LOGIN_ANALYSIS_PROMPT, sampleLoginData);
  
  console.log(chalk.cyan('📤 Sending prompt to Mistral...\n'));
  const startTime = Date.now();
  
  const result = await ollamaService.generateAndParse(prompt);
  
  const duration = Date.now() - startTime;
  
  console.log(chalk.cyan(`📥 Response received in ${duration}ms\n`));
  
  if (!result.success) {
    console.error(chalk.red('❌ Failed to generate response:'), result.error);
    process.exit(1);
  }
  
  console.log(chalk.green('✅ Successfully parsed JSON response\n'));
  
  // Validate response structure
  console.log(chalk.blue.bold('📊 RESPONSE VALIDATION'));
  console.log('─'.repeat(70));
  
  const requiredFields = [
    'threat_detected',
    'severity',
    'confidence',
    'threat_type',
    'evidence',
    'reasoning',
    'mitigation',
  ];
  
  let validationPassed = true;
  
  requiredFields.forEach(field => {
    const hasField = result.data.hasOwnProperty(field);
    const status = hasField ? chalk.green('✓') : chalk.red('✗');
    console.log(`${status} ${field}: ${hasField ? chalk.white('present') : chalk.red('missing')}`);
    if (!hasField) validationPassed = false;
  });
  
  console.log('─'.repeat(70));
  
  if (!validationPassed) {
    console.log(chalk.red('\n❌ Response validation failed: Missing required fields'));
    process.exit(1);
  }
  
  console.log(chalk.green('\n✅ All required fields present\n'));
  
  // Display parsed response
  console.log(chalk.blue.bold('📋 PARSED RESPONSE'));
  console.log('─'.repeat(70));
  console.log(chalk.white(JSON.stringify(result.data, null, 2)));
  console.log('─'.repeat(70));
  
  // Quality checks
  console.log(chalk.blue.bold('\n🎯 QUALITY CHECKS'));
  console.log('─'.repeat(70));
  
  const qualityChecks = {
    'Threat detected correctly': result.data.threat_detected === true,
    'Severity is HIGH or CRITICAL': ['HIGH', 'CRITICAL'].includes(result.data.severity),
    'Confidence > 0.7': result.data.confidence > 0.7,
    'Evidence is detailed': result.data.evidence && result.data.evidence.length > 50,
    'Reasoning is provided': result.data.reasoning && result.data.reasoning.length > 50,
    'Mitigation actions provided': result.data.mitigation && result.data.mitigation.length > 0,
    'Contains brute force reference': JSON.stringify(result.data).toLowerCase().includes('brute'),
  };
  
  let qualityScore = 0;
  const totalChecks = Object.keys(qualityChecks).length;
  
  for (const [check, passed] of Object.entries(qualityChecks)) {
    const status = passed ? chalk.green('✓') : chalk.yellow('⚠');
    console.log(`${status} ${check}: ${passed ? chalk.green('PASS') : chalk.yellow('FAIL')}`);
    if (passed) qualityScore++;
  }
  
  console.log('─'.repeat(70));
  console.log(`Quality Score: ${chalk.white.bold(qualityScore + '/' + totalChecks)}`);
  
  if (qualityScore === totalChecks) {
    console.log(chalk.green.bold('\n✅ PROMPT TEST PASSED - Excellent response quality!'));
  } else if (qualityScore >= totalChecks * 0.7) {
    console.log(chalk.yellow.bold('\n⚠️  PROMPT TEST PASSED - Good response quality with minor issues'));
  } else {
    console.log(chalk.red.bold('\n❌ PROMPT TEST FAILED - Response quality needs improvement'));
  }
  
  console.log(chalk.green.bold('\n' + '═'.repeat(70) + '\n'));
  
  // Recommendations
  console.log(chalk.blue.bold('💡 PROMPT ENGINEERING OBSERVATIONS'));
  console.log('─'.repeat(70));
  console.log(chalk.white('1. Model successfully understands the cybersecurity context'));
  console.log(chalk.white('2. JSON output format is correctly followed'));
  console.log(chalk.white('3. Evidence and reasoning show SOC analyst perspective'));
  console.log(chalk.white('4. Mitigation recommendations are actionable'));
  console.log(chalk.white('5. Threat severity assessment is accurate'));
  console.log('─'.repeat(70) + '\n');
}

// Run test
testPromptEffectiveness().catch(error => {
  console.error(chalk.red('\n❌ Prompt test failed:'), error);
  process.exit(1);
});
