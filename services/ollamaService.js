/**
 * Ollama Service - Interface to local Ollama instance
 * Handles all communication with the Mistral model
 */

import axios from 'axios';
import { agentConfig } from '../config/agentConfig.js';

class OllamaService {
  constructor() {
    this.host = agentConfig.ollama.host;
    this.model = agentConfig.ollama.model;
    this.temperature = agentConfig.ollama.temperature;
    this.maxTokens = agentConfig.ollama.maxTokens;
    this.maxRetries = 3;
    this.retryDelay = 1000; // milliseconds
  }

  /**
   * Check if Ollama service is healthy and model is available
   * @returns {Promise<{healthy: boolean, model: string, error?: string}>}
   */
  async healthCheck() {
    try {
      // Check if Ollama is running
      const response = await axios.get(`${this.host}/api/tags`, {
        timeout: 5000,
      });

      // Check if our model is available
      const models = response.data.models || [];
      const modelAvailable = models.some(m => m.name.includes(this.model));

      if (!modelAvailable) {
        return {
          healthy: false,
          model: this.model,
          error: `Model '${this.model}' not found. Available models: ${models.map(m => m.name).join(', ')}`,
        };
      }

      return {
        healthy: true,
        model: this.model,
      };
    } catch (error) {
      return {
        healthy: false,
        model: this.model,
        error: `Cannot connect to Ollama at ${this.host}. Error: ${error.message}`,
      };
    }
  }

  /**
   * Generate a response from the model (non-streaming)
   * @param {string} prompt - The prompt to send
   * @param {Object} options - Additional options
   * @returns {Promise<Object>} Response from model
   */
  async generate(prompt, options = {}) {
    const requestData = {
      model: this.model,
      prompt: prompt,
      stream: false,
      options: {
        temperature: options.temperature || this.temperature,
        num_predict: options.maxTokens || this.maxTokens,
      },
    };

    let lastError;
    for (let attempt = 1; attempt <= this.maxRetries; attempt++) {
      try {
        if (agentConfig.logging.debug) {
          console.log(`🔄 Ollama request (attempt ${attempt}/${this.maxRetries})`);
        }

        const response = await axios.post(
          `${this.host}/api/generate`,
          requestData,
          {
            timeout: 60000, // 60 seconds
            headers: {
              'Content-Type': 'application/json',
            },
          }
        );

        if (agentConfig.logging.debug) {
          console.log(`✅ Ollama response received (${response.data.response?.length || 0} chars)`);
        }

        return {
          success: true,
          response: response.data.response,
          model: response.data.model,
          context: response.data.context,
          totalDuration: response.data.total_duration,
          loadDuration: response.data.load_duration,
          promptEvalCount: response.data.prompt_eval_count,
          evalCount: response.data.eval_count,
        };
      } catch (error) {
        lastError = error;
        console.warn(`⚠️  Attempt ${attempt} failed: ${error.message}`);
        
        if (attempt < this.maxRetries) {
          await this.sleep(this.retryDelay * attempt);
        }
      }
    }

    // All retries failed
    return {
      success: false,
      error: `Failed after ${this.maxRetries} attempts: ${lastError.message}`,
    };
  }

  /**
   * Generate with streaming (for real-time output)
   * @param {string} prompt - The prompt to send
   * @param {Function} onChunk - Callback for each chunk
   * @returns {Promise<Object>} Complete response
   */
  async generateStream(prompt, onChunk) {
    const requestData = {
      model: this.model,
      prompt: prompt,
      stream: true,
      options: {
        temperature: this.temperature,
        num_predict: this.maxTokens,
      },
    };

    try {
      const response = await axios.post(
        `${this.host}/api/generate`,
        requestData,
        {
          responseType: 'stream',
          timeout: 60000,
        }
      );

      let fullResponse = '';
      let buffer = '';

      return new Promise((resolve, reject) => {
        response.data.on('data', (chunk) => {
          buffer += chunk.toString();
          
          // Process complete JSON objects
          const lines = buffer.split('\n');
          buffer = lines.pop(); // Keep incomplete line in buffer

          for (const line of lines) {
            if (line.trim()) {
              try {
                const data = JSON.parse(line);
                if (data.response) {
                  fullResponse += data.response;
                  if (onChunk) {
                    onChunk(data.response);
                  }
                }
                
                if (data.done) {
                  resolve({
                    success: true,
                    response: fullResponse,
                    model: data.model,
                  });
                }
              } catch (e) {
                // Ignore JSON parse errors for incomplete chunks
              }
            }
          }
        });

        response.data.on('error', (error) => {
          reject({
            success: false,
            error: error.message,
          });
        });
      });
    } catch (error) {
      return {
        success: false,
        error: error.message,
      };
    }
  }

  /**
   * Parse JSON response from model
   * @param {string} response - Raw response from model
   * @returns {Object|null} Parsed JSON or null if failed
   */
  parseJSON(response) {
    try {
      // Try to extract JSON from markdown code blocks
      const jsonMatch = response.match(/```json\n?([\s\S]*?)\n?```/);
      if (jsonMatch) {
        return JSON.parse(jsonMatch[1]);
      }

      // Try to find JSON object in response
      const objectMatch = response.match(/\{[\s\S]*\}/);
      if (objectMatch) {
        return JSON.parse(objectMatch[0]);
      }

      // Try parsing the whole response
      return JSON.parse(response);
    } catch (error) {
      console.error('❌ Failed to parse JSON response:', error.message);
      console.error('Raw response:', response.substring(0, 500));
      return null;
    }
  }

  /**
   * Generate and parse JSON response
   * @param {string} prompt - The prompt to send
   * @returns {Promise<Object>} Parsed response
   */
  async generateAndParse(prompt) {
    const result = await this.generate(prompt);
    
    if (!result.success) {
      return {
        success: false,
        error: result.error,
      };
    }

    const parsed = this.parseJSON(result.response);
    
    if (!parsed) {
      return {
        success: false,
        error: 'Failed to parse JSON from model response',
        rawResponse: result.response,
      };
    }

    return {
      success: true,
      data: parsed,
      rawResponse: result.response,
      metadata: {
        model: result.model,
        totalDuration: result.totalDuration,
        evalCount: result.evalCount,
      },
    };
  }

  /**
   * Sleep utility for retry delays
   * @param {number} ms - Milliseconds to sleep
   */
  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

// Export singleton instance
export const ollamaService = new OllamaService();
export default ollamaService;
