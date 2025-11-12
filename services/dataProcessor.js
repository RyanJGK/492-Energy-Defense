/**
 * Data Processing Layer
 * Normalizes and processes different log formats for AI analysis
 */

import { agentConfig } from '../config/agentConfig.js';

/**
 * Process and normalize login attempt data
 * @param {Array|Object} loginData - Raw login data
 * @returns {Object} Processed data with extracted features
 */
export function processLoginData(loginData) {
  const logs = Array.isArray(loginData) ? loginData : [loginData];
  
  const processed = {
    totalAttempts: logs.length,
    failedAttempts: 0,
    successfulAttempts: 0,
    uniqueUsers: new Set(),
    uniqueIPs: new Set(),
    suspiciousPatterns: [],
    features: [],
  };

  // Extract features from each log entry
  logs.forEach(log => {
    processed.uniqueUsers.add(log.username);
    processed.uniqueIPs.add(log.sourceIP);

    if (log.success === false || log.status === 'failed') {
      processed.failedAttempts++;
    } else {
      processed.successfulAttempts++;
    }

    // Check for suspicious patterns
    const suspiciousPatterns = detectLoginAnomalies(log);
    processed.suspiciousPatterns.push(...suspiciousPatterns);

    // Extract relevant features
    processed.features.push({
      username: log.username,
      sourceIP: log.sourceIP,
      timestamp: log.timestamp,
      success: log.success || log.status === 'success',
      location: log.location || log.geoLocation,
      userAgent: log.userAgent,
      sessionId: log.sessionId,
    });
  });

  // Detect brute force patterns
  const bruteForceDetected = detectBruteForce(processed.features);
  if (bruteForceDetected) {
    processed.suspiciousPatterns.push(bruteForceDetected);
  }

  return {
    ...processed,
    uniqueUsers: Array.from(processed.uniqueUsers),
    uniqueIPs: Array.from(processed.uniqueIPs),
    summary: generateLoginSummary(processed),
  };
}

/**
 * Detect login anomalies in a single log entry
 * @param {Object} log - Single login log
 * @returns {Array} Array of detected anomalies
 */
function detectLoginAnomalies(log) {
  const anomalies = [];
  const config = agentConfig.loginAnalysis;

  // Check for off-hours access
  if (log.timestamp) {
    const hour = new Date(log.timestamp).getHours();
    if (hour >= config.suspiciousHoursStart && hour < config.suspiciousHoursEnd) {
      anomalies.push({
        type: 'off_hours_access',
        severity: 'MEDIUM',
        detail: `Login attempt at ${hour}:00 (suspicious hours)`,
      });
    }
  }

  // Check for privileged accounts
  const privilegedKeywords = ['admin', 'root', 'administrator', 'sa'];
  if (privilegedKeywords.some(keyword => log.username?.toLowerCase().includes(keyword))) {
    anomalies.push({
      type: 'privileged_account_access',
      severity: 'HIGH',
      detail: `Attempt on privileged account: ${log.username}`,
    });
  }

  // Check for suspicious locations
  if (log.location && isSuspiciousLocation(log.location)) {
    anomalies.push({
      type: 'suspicious_location',
      severity: 'MEDIUM',
      detail: `Login from flagged location: ${log.location}`,
    });
  }

  return anomalies;
}

/**
 * Detect brute force attack patterns
 * @param {Array} features - Processed login features
 * @returns {Object|null} Brute force detection result
 */
function detectBruteForce(features) {
  const config = agentConfig.loginAnalysis;
  const userAttempts = {};

  features.forEach(log => {
    if (!userAttempts[log.username]) {
      userAttempts[log.username] = [];
    }
    userAttempts[log.username].push(log);
  });

  // Check each user's attempts
  for (const [username, attempts] of Object.entries(userAttempts)) {
    const failedAttempts = attempts.filter(a => !a.success);
    
    if (failedAttempts.length >= config.bruteForceThreshold) {
      // Check if attempts are within the time window
      const timestamps = failedAttempts
        .map(a => new Date(a.timestamp).getTime())
        .sort((a, b) => a - b);
      
      const timeSpan = (timestamps[timestamps.length - 1] - timestamps[0]) / 1000;
      
      if (timeSpan <= config.bruteForceWindow) {
        return {
          type: 'brute_force_attack',
          severity: 'HIGH',
          detail: `${failedAttempts.length} failed attempts for ${username} in ${Math.round(timeSpan)}s`,
          username,
          attemptCount: failedAttempts.length,
          timeWindow: Math.round(timeSpan),
        };
      }
    }
  }

  return null;
}

/**
 * Generate summary for login data
 */
function generateLoginSummary(processed) {
  return {
    totalAttempts: processed.totalAttempts,
    failedAttempts: processed.failedAttempts,
    successfulAttempts: processed.successfulAttempts,
    failureRate: (processed.failedAttempts / processed.totalAttempts * 100).toFixed(2) + '%',
    uniqueUsers: processed.uniqueUsers.length,
    uniqueIPs: processed.uniqueIPs.length,
    anomalyCount: processed.suspiciousPatterns.length,
  };
}

/**
 * Process and normalize firewall log data
 * @param {Array|Object} firewallData - Raw firewall logs
 * @returns {Object} Processed data with threat indicators
 */
export function processFirewallData(firewallData) {
  const logs = Array.isArray(firewallData) ? firewallData : [firewallData];
  
  const processed = {
    totalEvents: logs.length,
    blockedEvents: 0,
    allowedEvents: 0,
    uniqueSourceIPs: new Set(),
    uniqueDestPorts: new Set(),
    threatIndicators: [],
    features: [],
  };

  logs.forEach(log => {
    processed.uniqueSourceIPs.add(log.sourceIP);
    processed.uniqueDestPorts.add(log.destinationPort);

    if (log.action === 'block' || log.action === 'deny' || log.blocked) {
      processed.blockedEvents++;
    } else {
      processed.allowedEvents++;
    }

    // Detect firewall threats
    const threats = detectFirewallThreats(log);
    processed.threatIndicators.push(...threats);

    processed.features.push({
      sourceIP: log.sourceIP,
      destinationIP: log.destinationIP,
      destinationPort: log.destinationPort,
      protocol: log.protocol,
      action: log.action,
      timestamp: log.timestamp,
      bytes: log.bytes,
    });
  });

  // Detect port scanning
  const portScanDetected = detectPortScan(processed.features);
  if (portScanDetected) {
    processed.threatIndicators.push(portScanDetected);
  }

  // Detect repeated blocks
  const repeatedBlocks = detectRepeatedBlocks(processed.features);
  processed.threatIndicators.push(...repeatedBlocks);

  return {
    ...processed,
    uniqueSourceIPs: Array.from(processed.uniqueSourceIPs),
    uniqueDestPorts: Array.from(processed.uniqueDestPorts),
    summary: generateFirewallSummary(processed),
  };
}

/**
 * Detect firewall threats in a single log
 */
function detectFirewallThreats(log) {
  const threats = [];
  const config = agentConfig.firewallAnalysis;

  // Check for suspicious ports
  if (config.suspiciousPorts.includes(log.destinationPort)) {
    threats.push({
      type: 'suspicious_port_access',
      severity: 'MEDIUM',
      detail: `Access attempt to sensitive port ${log.destinationPort}`,
    });
  }

  // Check for high-risk protocols
  if (config.highRiskProtocols.includes(log.protocol?.toUpperCase())) {
    threats.push({
      type: 'high_risk_protocol',
      severity: 'HIGH',
      detail: `Use of high-risk protocol: ${log.protocol}`,
    });
  }

  return threats;
}

/**
 * Detect port scanning activity
 */
function detectPortScan(features) {
  const config = agentConfig.firewallAnalysis;
  const ipPortMap = {};

  features.forEach(log => {
    if (!ipPortMap[log.sourceIP]) {
      ipPortMap[log.sourceIP] = new Set();
    }
    ipPortMap[log.sourceIP].add(log.destinationPort);
  });

  // Check if any IP accessed too many different ports
  for (const [ip, ports] of Object.entries(ipPortMap)) {
    if (ports.size >= config.portScanThreshold) {
      return {
        type: 'port_scan_detected',
        severity: 'HIGH',
        detail: `IP ${ip} accessed ${ports.size} different ports`,
        sourceIP: ip,
        portsScanned: Array.from(ports),
      };
    }
  }

  return null;
}

/**
 * Detect repeated blocked attempts from same IP
 */
function detectRepeatedBlocks(features) {
  const config = agentConfig.firewallAnalysis;
  const ipBlockCount = {};
  const threats = [];

  features.forEach(log => {
    if (log.action === 'block' || log.action === 'deny') {
      ipBlockCount[log.sourceIP] = (ipBlockCount[log.sourceIP] || 0) + 1;
    }
  });

  for (const [ip, count] of Object.entries(ipBlockCount)) {
    if (count >= config.blockedIPThreshold) {
      threats.push({
        type: 'repeated_block_attempts',
        severity: 'MEDIUM',
        detail: `IP ${ip} blocked ${count} times`,
        sourceIP: ip,
        blockCount: count,
      });
    }
  }

  return threats;
}

/**
 * Generate firewall summary
 */
function generateFirewallSummary(processed) {
  return {
    totalEvents: processed.totalEvents,
    blockedEvents: processed.blockedEvents,
    allowedEvents: processed.allowedEvents,
    blockRate: (processed.blockedEvents / processed.totalEvents * 100).toFixed(2) + '%',
    uniqueSourceIPs: processed.uniqueSourceIPs.length,
    uniquePorts: processed.uniqueDestPorts.length,
    threatCount: processed.threatIndicators.length,
  };
}

/**
 * Process and normalize patch status data
 * @param {Array|Object} patchData - Raw patch data
 * @returns {Object} Processed vulnerability analysis
 */
export function processPatchData(patchData) {
  const systems = Array.isArray(patchData) ? patchData : [patchData];
  
  const processed = {
    totalSystems: systems.length,
    criticalVulnerabilities: 0,
    highVulnerabilities: 0,
    mediumVulnerabilities: 0,
    lowVulnerabilities: 0,
    vulnerabilities: [],
    features: [],
  };

  systems.forEach(system => {
    const vulns = analyzeSystemVulnerabilities(system);
    processed.vulnerabilities.push(...vulns);

    vulns.forEach(vuln => {
      switch(vuln.severity) {
        case 'CRITICAL':
          processed.criticalVulnerabilities++;
          break;
        case 'HIGH':
          processed.highVulnerabilities++;
          break;
        case 'MEDIUM':
          processed.mediumVulnerabilities++;
          break;
        default:
          processed.lowVulnerabilities++;
      }
    });

    processed.features.push({
      hostname: system.hostname,
      os: system.os,
      lastPatched: system.lastPatched,
      missingPatches: system.missingPatches || [],
      installedPatches: system.installedPatches || [],
      complianceStatus: system.complianceStatus,
    });
  });

  return {
    ...processed,
    summary: generatePatchSummary(processed),
  };
}

/**
 * Analyze vulnerabilities for a single system
 */
function analyzeSystemVulnerabilities(system) {
  const config = agentConfig.patchAnalysis;
  const vulnerabilities = [];

  // Calculate days since last patch
  const daysSinceLastPatch = system.lastPatched
    ? Math.floor((Date.now() - new Date(system.lastPatched)) / (1000 * 60 * 60 * 24))
    : 999;

  // Check patch age
  if (daysSinceLastPatch > config.criticalPatchAge) {
    vulnerabilities.push({
      type: 'outdated_system',
      severity: 'CRITICAL',
      detail: `System ${system.hostname} not patched for ${daysSinceLastPatch} days`,
      system: system.hostname,
      daysSinceLastPatch,
    });
  } else if (daysSinceLastPatch > config.highPatchAge) {
    vulnerabilities.push({
      type: 'outdated_system',
      severity: 'HIGH',
      detail: `System ${system.hostname} not patched for ${daysSinceLastPatch} days`,
      system: system.hostname,
      daysSinceLastPatch,
    });
  }

  // Check missing patches for CVEs
  if (system.missingPatches) {
    system.missingPatches.forEach(patch => {
      if (patch.cveScore || patch.cvssScore) {
        const score = patch.cveScore || patch.cvssScore;
        let severity = 'LOW';
        
        if (score >= config.cveScoreThresholds.critical) {
          severity = 'CRITICAL';
        } else if (score >= config.cveScoreThresholds.high) {
          severity = 'HIGH';
        } else if (score >= config.cveScoreThresholds.medium) {
          severity = 'MEDIUM';
        }

        vulnerabilities.push({
          type: 'missing_patch',
          severity,
          detail: `${system.hostname}: Missing patch ${patch.patchId} (CVE: ${patch.cveId}, Score: ${score})`,
          system: system.hostname,
          patchId: patch.patchId,
          cveId: patch.cveId,
          cveScore: score,
        });
      }
    });
  }

  // Check for end-of-life software
  if (system.eol === true || system.endOfLife === true) {
    vulnerabilities.push({
      type: 'end_of_life',
      severity: 'HIGH',
      detail: `System ${system.hostname} running end-of-life software: ${system.os}`,
      system: system.hostname,
      software: system.os,
    });
  }

  return vulnerabilities;
}

/**
 * Generate patch summary
 */
function generatePatchSummary(processed) {
  const totalVulns = processed.criticalVulnerabilities + 
                    processed.highVulnerabilities + 
                    processed.mediumVulnerabilities + 
                    processed.lowVulnerabilities;

  return {
    totalSystems: processed.totalSystems,
    totalVulnerabilities: totalVulns,
    critical: processed.criticalVulnerabilities,
    high: processed.highVulnerabilities,
    medium: processed.mediumVulnerabilities,
    low: processed.lowVulnerabilities,
  };
}

/**
 * Validate input data structure
 * @param {Object} data - Data to validate
 * @param {string} type - Data type (login/firewall/patch)
 * @returns {boolean} True if valid
 */
export function validateInputData(data, type) {
  if (!data) {
    console.error('❌ No data provided');
    return false;
  }

  const logs = Array.isArray(data) ? data : [data];

  switch(type) {
    case 'login':
      return logs.every(log => log.username && log.sourceIP);
    case 'firewall':
      return logs.every(log => log.sourceIP && log.destinationPort);
    case 'patch':
      return logs.every(log => log.hostname && log.os);
    default:
      return false;
  }
}

/**
 * Check if location is suspicious
 * @param {string} location - Location string
 * @returns {boolean}
 */
function isSuspiciousLocation(location) {
  // Simple heuristic - could be enhanced with threat intelligence
  const flaggedCountries = ['Unknown', 'Tor Exit Node'];
  return flaggedCountries.some(flagged => 
    location.toLowerCase().includes(flagged.toLowerCase())
  );
}

export default {
  processLoginData,
  processFirewallData,
  processPatchData,
  validateInputData,
};
