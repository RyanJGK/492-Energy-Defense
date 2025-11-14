"""Ollama LLM client for interacting with local Mistral model."""
import time
import logging
from typing import Dict, Any, Optional
import httpx

from src.config import config

logger = logging.getLogger(__name__)


class OllamaClientError(Exception):
    """Custom exception for Ollama client errors."""
    pass


class OllamaClient:
    """Client for communicating with Ollama API."""
    
    def __init__(
        self,
        base_url: Optional[str] = None,
        model: Optional[str] = None,
        timeout: Optional[int] = None
    ):
        """
        Initialize Ollama client.
        
        Args:
            base_url: Ollama API base URL
            model: Model name to use
            timeout: Request timeout in seconds
        """
        self.base_url = base_url or config.ollama_base_url
        self.model = model or config.OLLAMA_MODEL
        self.timeout = timeout or config.OLLAMA_TIMEOUT
        self.generate_url = f"{self.base_url}/api/generate"
        
        logger.info(f"Initialized OllamaClient: {self.base_url}, model: {self.model}")
    
    def generate(
        self,
        prompt: str,
        system: Optional[str] = None,
        stream: bool = False,
        options: Optional[Dict[str, Any]] = None
    ) -> str:
        """
        Generate completion from Ollama.
        
        Args:
            prompt: User prompt
            system: System context/instructions
            stream: Enable streaming (not implemented for simplicity)
            options: Additional generation options
            
        Returns:
            Generated text response
            
        Raises:
            OllamaClientError: If generation fails
        """
        payload = {
            "model": self.model,
            "prompt": prompt,
            "stream": False,  # Disable streaming for simplicity
        }
        
        if system:
            payload["system"] = system
        
        if options:
            payload["options"] = options
        
        try:
            with httpx.Client(timeout=self.timeout) as client:
                logger.debug(f"Sending request to Ollama: {self.generate_url}")
                response = client.post(self.generate_url, json=payload)
                response.raise_for_status()
                
                result = response.json()
                
                if "response" not in result:
                    raise OllamaClientError(f"Invalid response format: {result}")
                
                logger.debug(f"Received response from Ollama")
                return result["response"]
                
        except httpx.TimeoutException as e:
            logger.error(f"Timeout connecting to Ollama: {e}")
            raise OllamaClientError(f"Ollama request timeout: {e}")
        except httpx.HTTPStatusError as e:
            logger.error(f"HTTP error from Ollama: {e}")
            raise OllamaClientError(f"Ollama HTTP error: {e.response.status_code}")
        except Exception as e:
            logger.error(f"Unexpected error calling Ollama: {e}")
            raise OllamaClientError(f"Ollama client error: {e}")
    
    def generate_with_retry(
        self,
        prompt: str,
        system: Optional[str] = None,
        max_retries: Optional[int] = None,
        retry_delay: Optional[int] = None
    ) -> str:
        """
        Generate completion with automatic retry logic.
        
        Args:
            prompt: User prompt
            system: System context
            max_retries: Maximum retry attempts
            retry_delay: Delay between retries in seconds
            
        Returns:
            Generated text response
            
        Raises:
            OllamaClientError: If all retries fail
        """
        max_retries = max_retries or config.MAX_RETRIES
        retry_delay = retry_delay or config.RETRY_DELAY
        
        last_error = None
        
        for attempt in range(max_retries):
            try:
                return self.generate(prompt=prompt, system=system)
            except OllamaClientError as e:
                last_error = e
                if attempt < max_retries - 1:
                    logger.warning(
                        f"Attempt {attempt + 1}/{max_retries} failed: {e}. "
                        f"Retrying in {retry_delay}s..."
                    )
                    time.sleep(retry_delay)
                else:
                    logger.error(f"All {max_retries} attempts failed")
        
        raise OllamaClientError(f"Failed after {max_retries} retries: {last_error}")
    
    def health_check(self) -> bool:
        """
        Check if Ollama service is available.
        
        Returns:
            True if healthy, False otherwise
        """
        try:
            with httpx.Client(timeout=5) as client:
                response = client.get(f"{self.base_url}/api/tags")
                return response.status_code == 200
        except Exception as e:
            logger.error(f"Ollama health check failed: {e}")
            return False
