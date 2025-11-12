/**
 * Ollama Service - Wrapper for Ollama API interactions
 * Handles all LLM communication with built-in retry logic and health checks
 */

import { Ollama } from 'ollama';
import config from '../config/index.js';

class OllamaService {
  constructor() {
    this.client = new Ollama({ host: config.ollama.host });
    this.model = config.ollama.model;
    this.timeout = config.ollama.timeout;
    this.retryAttempts = config.ollama.retryAttempts;
    this.retryDelay = config.ollama.retryDelay;
  }

  /**
   * Check if Ollama service is available and model is loaded
   * @returns {Promise<boolean>} Connection status
   */
  async healthCheck() {
    try {
      const models = await this.client.list();
      const modelExists = models.models.some(m => m.name.includes(this.model));
      
      if (!modelExists) {
        console.error(`[ERROR] Model '${this.model}' not found. Run: ollama pull ${this.model}`);
        return false;
      }
      
      return true;
    } catch (error) {
      console.error(`[ERROR] Cannot connect to Ollama at ${config.ollama.host}: ${error.message}`);
      return false;
    }
  }

  /**
   * Analyze security data using Ollama with retry logic
   * @param {string} prompt - Analysis prompt
   * @param {Object} data - Security data to analyze
   * @param {string} systemPrompt - System context prompt
   * @returns {Promise<Object>} Parsed analysis results
   */
  async analyze(prompt, data, systemPrompt = config.prompts.system) {
    const fullPrompt = `${prompt}\n\nData to analyze:\n${JSON.stringify(data, null, 2)}`;
    
    for (let attempt = 1; attempt <= this.retryAttempts; attempt++) {
      try {
        const response = await this.client.generate({
          model: this.model,
          prompt: fullPrompt,
          system: systemPrompt,
          stream: false,
          options: {
            temperature: 0.3,  // Lower temperature for more consistent outputs
            top_p: 0.9
          }
        });

        // Parse and validate JSON response
        const result = this.parseResponse(response.response);
        this.validateAnalysisResult(result);
        
        return result;
      } catch (error) {
        if (attempt === this.retryAttempts) {
          throw new Error(`Analysis failed after ${this.retryAttempts} attempts: ${error.message}`);
        }
        
        console.warn(`[WARN] Attempt ${attempt}/${this.retryAttempts} failed, retrying in ${this.retryDelay}ms...`);
        await this.sleep(this.retryDelay);
      }
    }
  }

  /**
   * Parse LLM response, handling various formats
   * @param {string} response - Raw LLM response
   * @returns {Object} Parsed JSON object
   */
  parseResponse(response) {
    try {
      // Remove markdown code blocks if present
      let cleaned = response.trim();
      cleaned = cleaned.replace(/```json\s*/g, '').replace(/```\s*/g, '');
      
      // Try to find JSON object in response
      const jsonMatch = cleaned.match(/\{[\s\S]*\}/);
      if (jsonMatch) {
        return JSON.parse(jsonMatch[0]);
      }
      
      return JSON.parse(cleaned);
    } catch (error) {
      throw new Error(`Failed to parse LLM response as JSON: ${error.message}\nResponse: ${response}`);
    }
  }

  /**
   * Validate that analysis result has required fields
   * @param {Object} result - Parsed analysis result
   */
  validateAnalysisResult(result) {
    const requiredFields = ['threat_level', 'confidence', 'indicators', 'recommendations', 'reasoning'];
    const missingFields = requiredFields.filter(field => !(field in result));
    
    if (missingFields.length > 0) {
      throw new Error(`Analysis result missing required fields: ${missingFields.join(', ')}`);
    }

    // Validate threat_level
    const validLevels = ['CRITICAL', 'HIGH', 'MEDIUM', 'LOW'];
    if (!validLevels.includes(result.threat_level)) {
      throw new Error(`Invalid threat_level: ${result.threat_level}. Must be one of: ${validLevels.join(', ')}`);
    }

    // Validate confidence
    if (typeof result.confidence !== 'number' || result.confidence < 0 || result.confidence > 1) {
      throw new Error(`Invalid confidence: ${result.confidence}. Must be a number between 0 and 1`);
    }

    // Ensure arrays
    if (!Array.isArray(result.indicators)) {
      result.indicators = [result.indicators].filter(Boolean);
    }
    if (!Array.isArray(result.recommendations)) {
      result.recommendations = [result.recommendations].filter(Boolean);
    }
    if (!result.mitre_tactics || !Array.isArray(result.mitre_tactics)) {
      result.mitre_tactics = [];
    }
  }

  /**
   * Sleep utility for retry delays
   * @param {number} ms - Milliseconds to sleep
   */
  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

export default new OllamaService();
