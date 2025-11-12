/**
 * Data Processor - Normalizes and validates security data
 * Handles log parsing and data transformation for all security event types
 */

/**
 * Normalize login/authentication data
 * @param {Object} raw - Raw login data
 * @returns {Object} Normalized login data
 */
export function normalizeLoginData(raw) {
  return {
    timestamp: raw.timestamp || new Date().toISOString(),
    ip: raw.ip || raw.source_ip || 'unknown',
    username: raw.username || raw.user || 'unknown',
    success: raw.success !== undefined ? raw.success : raw.status === 'success',
    attempts: raw.attempts || 1,
    country: raw.country || raw.geolocation || raw.location || 'unknown',
    user_agent: raw.user_agent || null,
    session_id: raw.session_id || null
  };
}

/**
 * Normalize firewall log data
 * @param {Object} raw - Raw firewall data
 * @returns {Object} Normalized firewall data
 */
export function normalizeFirewallData(raw) {
  return {
    timestamp: raw.timestamp || new Date().toISOString(),
    src_ip: raw.src_ip || raw.source_ip || raw.source || 'unknown',
    dst_ip: raw.dst_ip || raw.dest_ip || raw.destination || 'unknown',
    dst_port: raw.dst_port || raw.dest_port || raw.port || 0,
    src_port: raw.src_port || raw.source_port || null,
    protocol: (raw.protocol || 'TCP').toUpperCase(),
    action: (raw.action || 'ALLOW').toUpperCase(),
    bytes: raw.bytes || raw.byte_count || 0,
    packets: raw.packets || raw.packet_count || 0,
    flags: raw.flags || null
  };
}

/**
 * Normalize patch/vulnerability data
 * @param {Object} raw - Raw patch status data
 * @returns {Object} Normalized patch data
 */
export function normalizePatchData(raw) {
  return {
    hostname: raw.hostname || raw.host || 'unknown',
    os: raw.os || raw.operating_system || 'unknown',
    missing_cves: Array.isArray(raw.missing_cves) ? raw.missing_cves : 
                  (raw.cves ? raw.cves : []),
    cvss_scores: Array.isArray(raw.cvss_scores) ? raw.cvss_scores :
                 (raw.scores ? raw.scores : []),
    days_unpatched: raw.days_unpatched || raw.age || 0,
    last_scan: raw.last_scan || raw.scan_date || new Date().toISOString(),
    criticality: raw.criticality || raw.system_criticality || 'medium'
  };
}

/**
 * Validate input data for specific analysis type
 * @param {Object|Array} data - Data to validate
 * @param {string} type - Data type (login, firewall, patch)
 * @returns {boolean} Validation result
 */
export function validateInput(data, type) {
  if (!data) {
    throw new Error(`No data provided for ${type} analysis`);
  }

  const dataArray = Array.isArray(data) ? data : [data];
  
  if (dataArray.length === 0) {
    throw new Error(`Empty data array for ${type} analysis`);
  }

  switch (type) {
    case 'login':
      dataArray.forEach((item, index) => {
        if (!item.ip && !item.source_ip) {
          throw new Error(`Login data item ${index} missing required field: ip/source_ip`);
        }
        if (!item.username && !item.user) {
          throw new Error(`Login data item ${index} missing required field: username/user`);
        }
      });
      break;

    case 'firewall':
      dataArray.forEach((item, index) => {
        if (!item.src_ip && !item.source_ip && !item.source) {
          throw new Error(`Firewall data item ${index} missing required field: src_ip/source_ip/source`);
        }
        if (!item.dst_ip && !item.dest_ip && !item.destination) {
          throw new Error(`Firewall data item ${index} missing required field: dst_ip/dest_ip/destination`);
        }
      });
      break;

    case 'patch':
      dataArray.forEach((item, index) => {
        if (!item.hostname && !item.host) {
          throw new Error(`Patch data item ${index} missing required field: hostname/host`);
        }
        if (!item.missing_cves && !item.cves) {
          throw new Error(`Patch data item ${index} missing required field: missing_cves/cves`);
        }
      });
      break;

    default:
      throw new Error(`Unknown data type: ${type}`);
  }

  return true;
}

/**
 * Normalize data based on type
 * @param {Object|Array} data - Raw data to normalize
 * @param {string} type - Data type (login, firewall, patch)
 * @returns {Array} Array of normalized data objects
 */
export function normalizeData(data, type) {
  validateInput(data, type);
  
  const dataArray = Array.isArray(data) ? data : [data];
  
  switch (type) {
    case 'login':
      return dataArray.map(normalizeLoginData);
    case 'firewall':
      return dataArray.map(normalizeFirewallData);
    case 'patch':
      return dataArray.map(normalizePatchData);
    default:
      throw new Error(`Unknown data type: ${type}`);
  }
}
