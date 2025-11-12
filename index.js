#!/usr/bin/env node

/**
 * Cybersecurity AI Agent - CLI Interface
 * Main entry point for the application
 */

import { program } from 'commander';
import { readFileSync } from 'fs';
import { agent } from './agent/cybersecurityAgent.js';
import { formatAnalysisResult, formatSecurityReport } from './utils/formatters.js';
import chalk from 'chalk';

// Package info
const packageJson = JSON.parse(readFileSync('./package.json', 'utf-8'));

program
  .name('cybersecurity-agent')
  .description('Standalone cybersecurity AI agent using Ollama (Mistral model)')
  .version(packageJson.version);

/**
 * Analyze command - Run specific analysis types
 */
program
  .command('analyze')
  .description('Run security analysis on data')
  .option('-t, --type <type>', 'Analysis type: login, firewall, patch, or all', 'all')
  .option('-f, --file <path>', 'Path to custom data file (JSON)')
  .option('--login <path>', 'Path to login data file')
  .option('--firewall <path>', 'Path to firewall data file')
  .option('--patch <path>', 'Path to patch data file')
  .action(async (options) => {
    try {
      console.log(chalk.cyan.bold('\n🛡️  Cybersecurity AI Agent'));
      console.log(chalk.gray(`Version ${packageJson.version}\n`));
      
      // Initialize agent
      const initialized = await agent.initialize();
      if (!initialized) {
        process.exit(1);
      }
      
      const type = options.type.toLowerCase();
      
      // Load data
      let loginData, firewallData, patchData;
      
      if (type === 'login' || type === 'all') {
        const loginPath = options.login || options.file || './data/sampleLogins.json';
        console.log(chalk.gray(`Loading login data from: ${loginPath}`));
        loginData = JSON.parse(readFileSync(loginPath, 'utf-8'));
      }
      
      if (type === 'firewall' || type === 'all') {
        const firewallPath = options.firewall || options.file || './data/sampleFirewallLogs.json';
        console.log(chalk.gray(`Loading firewall data from: ${firewallPath}`));
        firewallData = JSON.parse(readFileSync(firewallPath, 'utf-8'));
      }
      
      if (type === 'patch' || type === 'all') {
        const patchPath = options.patch || options.file || './data/samplePatchData.json';
        console.log(chalk.gray(`Loading patch data from: ${patchPath}\n`));
        patchData = JSON.parse(readFileSync(patchPath, 'utf-8'));
      }
      
      // Run analysis
      if (type === 'all') {
        const report = await agent.runFullAnalysis({
          login: loginData,
          firewall: firewallData,
          patch: patchData,
        });
        formatSecurityReport(report);
      } else if (type === 'login') {
        const result = await agent.analyzeLoginAttempt(loginData);
        formatAnalysisResult(result);
      } else if (type === 'firewall') {
        const result = await agent.analyzeFirewallLog(firewallData);
        formatAnalysisResult(result);
      } else if (type === 'patch') {
        const result = await agent.analyzePatchStatus(patchData);
        formatAnalysisResult(result);
      } else {
        console.error(chalk.red('❌ Invalid analysis type. Use: login, firewall, patch, or all'));
        process.exit(1);
      }
      
    } catch (error) {
      console.error(chalk.red('\n❌ Analysis failed:'), error.message);
      if (error.code === 'ENOENT') {
        console.error(chalk.yellow('💡 Tip: Make sure the data file exists and the path is correct'));
      }
      process.exit(1);
    }
  });

/**
 * Test command - Run test functions
 */
program
  .command('test')
  .description('Run agent tests')
  .option('-f, --function <name>', 'Test specific function: login, firewall, patch, risk, or all')
  .action(async (options) => {
    const functionName = options.function || 'all';
    
    try {
      console.log(chalk.cyan.bold('\n🧪 Running Tests...\n'));
      
      // Initialize agent
      const initialized = await agent.initialize();
      if (!initialized) {
        process.exit(1);
      }
      
      // Load test data
      const loginData = JSON.parse(readFileSync('./data/sampleLogins.json', 'utf-8'));
      const firewallData = JSON.parse(readFileSync('./data/sampleFirewallLogs.json', 'utf-8'));
      const patchData = JSON.parse(readFileSync('./data/samplePatchData.json', 'utf-8'));
      
      if (functionName === 'all' || functionName === 'login') {
        console.log(chalk.cyan('Testing Login Analysis...'));
        const result = await agent.analyzeLoginAttempt(loginData);
        console.log(result.error ? chalk.red('❌ Failed') : chalk.green('✅ Passed'));
      }
      
      if (functionName === 'all' || functionName === 'firewall') {
        console.log(chalk.cyan('Testing Firewall Analysis...'));
        const result = await agent.analyzeFirewallLog(firewallData);
        console.log(result.error ? chalk.red('❌ Failed') : chalk.green('✅ Passed'));
      }
      
      if (functionName === 'all' || functionName === 'patch') {
        console.log(chalk.cyan('Testing Patch Analysis...'));
        const result = await agent.analyzePatchStatus(patchData);
        console.log(result.error ? chalk.red('❌ Failed') : chalk.green('✅ Passed'));
      }
      
      if (functionName === 'all' || functionName === 'risk') {
        console.log(chalk.cyan('Testing Risk Score Generation...'));
        const riskScore = agent.generateRiskScore();
        console.log(riskScore.error ? chalk.red('❌ Failed') : chalk.green('✅ Passed'));
        console.log(`   Risk Score: ${riskScore.score}/100 (${riskScore.level})`);
      }
      
      console.log(chalk.green.bold('\n✅ Tests completed!\n'));
      
    } catch (error) {
      console.error(chalk.red('\n❌ Test failed:'), error.message);
      process.exit(1);
    }
  });

/**
 * Status command - Show agent status and capabilities
 */
program
  .command('status')
  .description('Show agent status and capabilities')
  .action(async () => {
    console.log(chalk.cyan.bold('\n🤖 Cybersecurity AI Agent Status'));
    console.log('═'.repeat(60));
    
    // Check Ollama health
    console.log(chalk.blue('\n📡 Connectivity Check:'));
    const { ollamaService } = await import('./services/ollamaService.js');
    const health = await ollamaService.healthCheck();
    
    if (health.healthy) {
      console.log(chalk.green('   ✓ Ollama: Connected'));
      console.log(chalk.green(`   ✓ Model: ${health.model} (Ready)`));
    } else {
      console.log(chalk.red('   ✗ Ollama: Disconnected'));
      console.log(chalk.red(`   ✗ Error: ${health.error}`));
    }
    
    // Show capabilities
    console.log(chalk.blue('\n🎯 Capabilities:'));
    const capabilities = [
      'Login Attempt Analysis - Detect brute force, credential stuffing',
      'Firewall Log Analysis - Identify port scans, intrusion attempts',
      'Patch Status Analysis - Find critical vulnerabilities, EOL software',
      'Risk Score Calculation - Composite 0-100 security risk assessment',
      'Mitigation Generation - Actionable security recommendations',
    ];
    
    capabilities.forEach((cap, i) => {
      console.log(chalk.white(`   ${i + 1}. ${cap}`));
    });
    
    // Show configuration
    const { agentConfig } = await import('./config/agentConfig.js');
    console.log(chalk.blue('\n⚙️  Configuration:'));
    console.log(chalk.white(`   Ollama Host: ${agentConfig.ollama.host}`));
    console.log(chalk.white(`   Model: ${agentConfig.ollama.model}`));
    console.log(chalk.white(`   Temperature: ${agentConfig.ollama.temperature}`));
    console.log(chalk.white(`   Risk Thresholds: Critical=${agentConfig.riskThresholds.critical}, High=${agentConfig.riskThresholds.high}`));
    
    console.log('\n' + '═'.repeat(60) + '\n');
  });

/**
 * Examples command - Show usage examples
 */
program
  .command('examples')
  .description('Show usage examples')
  .action(() => {
    console.log(chalk.cyan.bold('\n📖 Usage Examples\n'));
    
    console.log(chalk.blue('1. Analyze login attempts (sample data):'));
    console.log(chalk.white('   node index.js analyze --type login\n'));
    
    console.log(chalk.blue('2. Analyze firewall logs (sample data):'));
    console.log(chalk.white('   node index.js analyze --type firewall\n'));
    
    console.log(chalk.blue('3. Analyze patch status (sample data):'));
    console.log(chalk.white('   node index.js analyze --type patch\n'));
    
    console.log(chalk.blue('4. Run comprehensive analysis (all types):'));
    console.log(chalk.white('   node index.js analyze --type all\n'));
    
    console.log(chalk.blue('5. Analyze custom data file:'));
    console.log(chalk.white('   node index.js analyze --type login --file ./my-data.json\n'));
    
    console.log(chalk.blue('6. Run tests:'));
    console.log(chalk.white('   node index.js test --function all\n'));
    
    console.log(chalk.blue('7. Check agent status:'));
    console.log(chalk.white('   node index.js status\n'));
    
    console.log(chalk.blue('8. Run full test suite:'));
    console.log(chalk.white('   npm test\n'));
    
    console.log(chalk.gray('For more information, see README.md\n'));
  });

/**
 * Health command - Check system health
 */
program
  .command('health')
  .description('Check Ollama and model availability')
  .action(async () => {
    console.log(chalk.cyan.bold('\n🏥 Health Check\n'));
    
    const { ollamaService } = await import('./services/ollamaService.js');
    const health = await ollamaService.healthCheck();
    
    if (health.healthy) {
      console.log(chalk.green('✅ System is healthy!'));
      console.log(chalk.white(`   Ollama: Running`));
      console.log(chalk.white(`   Model: ${health.model} (Available)`));
      console.log(chalk.green('\n   Ready to analyze security data.\n'));
    } else {
      console.log(chalk.red('❌ System check failed!'));
      console.log(chalk.white(`   Error: ${health.error}\n`));
      console.log(chalk.yellow('📋 Troubleshooting:'));
      console.log(chalk.white('   1. Start Ollama: ollama serve'));
      console.log(chalk.white('   2. Pull model: ollama pull mistral'));
      console.log(chalk.white('   3. Verify connectivity to http://localhost:11434\n'));
      process.exit(1);
    }
  });

// Default help
if (process.argv.length === 2) {
  console.log(chalk.cyan.bold('\n🛡️  Cybersecurity AI Agent'));
  console.log(chalk.gray(`Version ${packageJson.version}\n`));
  console.log(chalk.white('Usage: node index.js [command] [options]\n'));
  console.log(chalk.white('Commands:'));
  console.log(chalk.white('  analyze     Run security analysis'));
  console.log(chalk.white('  test        Run agent tests'));
  console.log(chalk.white('  status      Show agent status'));
  console.log(chalk.white('  health      Check system health'));
  console.log(chalk.white('  examples    Show usage examples'));
  console.log(chalk.white('  help        Display help\n'));
  console.log(chalk.gray('Quick start: node index.js analyze --type all\n'));
  console.log(chalk.gray('For more info: node index.js --help\n'));
  process.exit(0);
}

program.parse();
