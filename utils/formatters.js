/**
 * Utility functions for formatting output and data
 */

import chalk from 'chalk';

/**
 * Format risk level with color
 * @param {string} level - Risk level
 * @returns {string} Colored risk level
 */
export function formatRiskLevel(level) {
  switch(level) {
    case 'CRITICAL':
      return chalk.red.bold('🔴 CRITICAL');
    case 'HIGH':
      return chalk.red('🟠 HIGH');
    case 'MEDIUM':
      return chalk.yellow('🟡 MEDIUM');
    case 'LOW':
      return chalk.green('🟢 LOW');
    default:
      return chalk.gray('⚪ UNKNOWN');
  }
}

/**
 * Format threat severity with color
 * @param {string} severity - Threat severity
 * @returns {string} Colored severity
 */
export function formatSeverity(severity) {
  switch(severity) {
    case 'CRITICAL':
      return chalk.red.bold(severity);
    case 'HIGH':
      return chalk.red(severity);
    case 'MEDIUM':
      return chalk.yellow(severity);
    case 'LOW':
      return chalk.green(severity);
    default:
      return chalk.gray(severity);
  }
}

/**
 * Format analysis result for console output
 * @param {Object} result - Analysis result
 */
export function formatAnalysisResult(result) {
  console.log('\n' + '═'.repeat(60));
  console.log(chalk.cyan.bold(`📋 ${result.type.toUpperCase().replace('_', ' ')}`));
  console.log('═'.repeat(60));
  
  if (result.error) {
    console.log(chalk.red('❌ Analysis failed:'), result.error);
    return;
  }

  // Display processed summary
  if (result.processed) {
    console.log(chalk.blue('\n📊 Data Summary:'));
    for (const [key, value] of Object.entries(result.processed)) {
      console.log(`   ${key}: ${chalk.white(value)}`);
    }
  }

  // Display AI analysis
  if (result.analysis) {
    const analysis = result.analysis;
    console.log(chalk.blue('\n🤖 AI Analysis:'));
    
    if (analysis.threat_detected) {
      console.log(`   Threat Detected: ${chalk.red.bold('YES')}`);
      console.log(`   Threat Type: ${chalk.white(analysis.threat_type)}`);
      console.log(`   Severity: ${formatSeverity(analysis.severity)}`);
      console.log(`   Confidence: ${chalk.white((analysis.confidence * 100).toFixed(0) + '%')}`);
      
      console.log(chalk.blue('\n📌 Evidence:'));
      console.log(`   ${chalk.white(analysis.evidence)}`);
      
      console.log(chalk.blue('\n💭 Reasoning:'));
      console.log(`   ${chalk.white(analysis.reasoning)}`);
      
      if (analysis.mitigation && analysis.mitigation.length > 0) {
        console.log(chalk.blue('\n🛡️  Recommended Actions:'));
        analysis.mitigation.forEach((action, i) => {
          console.log(`   ${i + 1}. ${chalk.white(action)}`);
        });
      }
    } else {
      console.log(`   Threat Detected: ${chalk.green.bold('NO')}`);
      console.log(`   ${chalk.white('No significant threats detected in this data.')}`);
    }
  }
  
  console.log('\n' + '═'.repeat(60) + '\n');
}

/**
 * Format full security report
 * @param {Object} report - Full security report
 */
export function formatSecurityReport(report) {
  console.log('\n' + '═'.repeat(70));
  console.log(chalk.cyan.bold('🛡️  COMPREHENSIVE SECURITY REPORT'));
  console.log('═'.repeat(70));
  
  console.log(chalk.gray(`Generated: ${new Date(report.timestamp).toLocaleString()}\n`));
  
  // Risk Assessment
  console.log(chalk.blue.bold('📊 OVERALL RISK ASSESSMENT'));
  console.log('─'.repeat(70));
  console.log(`Risk Score: ${chalk.white.bold(report.riskAssessment.score + '/100')}`);
  console.log(`Risk Level: ${formatRiskLevel(report.riskAssessment.level)}`);
  console.log(`\n${chalk.white(report.executiveSummary)}\n`);
  
  // Contributing Factors
  if (report.riskAssessment.contributors && report.riskAssessment.contributors.length > 0) {
    console.log(chalk.blue.bold('🎯 CONTRIBUTING FACTORS'));
    console.log('─'.repeat(70));
    report.riskAssessment.contributors.forEach((factor, i) => {
      console.log(`${i + 1}. ${chalk.white(factor.source)}`);
      console.log(`   Severity: ${formatSeverity(factor.severity)}`);
      console.log(`   Threat: ${chalk.white(factor.threat)}\n`);
    });
  }
  
  // Mitigations
  if (report.mitigations && report.mitigations.length > 0) {
    console.log(chalk.blue.bold('🛡️  RECOMMENDED MITIGATIONS'));
    console.log('─'.repeat(70));
    report.mitigations.forEach((mitigation) => {
      console.log(chalk.cyan(`\n${mitigation.source}:`));
      mitigation.actions.forEach((action, i) => {
        console.log(`   ${i + 1}. ${chalk.white(action)}`);
      });
    });
    console.log();
  }
  
  console.log('═'.repeat(70) + '\n');
}

/**
 * Format table for displaying data
 * @param {Array} headers - Table headers
 * @param {Array} rows - Table rows
 */
export function formatTable(headers, rows) {
  const colWidths = headers.map((h, i) => {
    const maxContentWidth = Math.max(
      ...rows.map(r => String(r[i] || '').length),
      h.length
    );
    return maxContentWidth + 2;
  });
  
  // Header
  const headerRow = headers.map((h, i) => h.padEnd(colWidths[i])).join(' | ');
  console.log(chalk.cyan(headerRow));
  console.log(chalk.gray('─'.repeat(headerRow.length)));
  
  // Rows
  rows.forEach(row => {
    const rowStr = row.map((cell, i) => String(cell).padEnd(colWidths[i])).join(' | ');
    console.log(rowStr);
  });
}

/**
 * Format duration in human-readable format
 * @param {number} nanoseconds - Duration in nanoseconds
 * @returns {string} Formatted duration
 */
export function formatDuration(nanoseconds) {
  const ms = nanoseconds / 1000000;
  if (ms < 1000) {
    return `${ms.toFixed(0)}ms`;
  }
  return `${(ms / 1000).toFixed(2)}s`;
}

/**
 * Display loading spinner
 * @param {string} message - Loading message
 */
export function showLoading(message) {
  const frames = ['⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏'];
  let i = 0;
  
  return setInterval(() => {
    process.stdout.write(`\r${chalk.cyan(frames[i])} ${message}`);
    i = (i + 1) % frames.length;
  }, 80);
}

/**
 * Clear loading spinner
 * @param {NodeJS.Timeout} spinner - Spinner interval
 */
export function clearLoading(spinner) {
  clearInterval(spinner);
  process.stdout.write('\r' + ' '.repeat(80) + '\r');
}

export default {
  formatRiskLevel,
  formatSeverity,
  formatAnalysisResult,
  formatSecurityReport,
  formatTable,
  formatDuration,
  showLoading,
  clearLoading,
};
