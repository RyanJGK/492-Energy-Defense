"""Core agent logic for processing user queries."""
import logging
from typing import Optional, Dict, Any

from src.agent.llm_client import OllamaClient, OllamaClientError
from src.config import config

logger = logging.getLogger(__name__)


class Agent:
    """AI Agent that processes queries using Ollama Mistral model."""
    
    def __init__(
        self,
        llm_client: Optional[OllamaClient] = None,
        system_context: Optional[str] = None
    ):
        """
        Initialize the agent.
        
        Args:
            llm_client: Ollama client instance
            system_context: System context for the agent
        """
        self.llm_client = llm_client or OllamaClient()
        self.system_context = system_context or config.SYSTEM_CONTEXT
        logger.info("Agent initialized")
    
    def process_query(self, query: str) -> str:
        """
        Process a user query and return the response.
        
        Args:
            query: User input query
            
        Returns:
            Generated response from the model
            
        Raises:
            OllamaClientError: If processing fails
        """
        if not query or not query.strip():
            raise ValueError("Query cannot be empty")
        
        logger.info(f"Processing query: {query[:100]}...")
        
        try:
            # Generate response with retry logic
            response = self.llm_client.generate_with_retry(
                prompt=query,
                system=self.system_context
            )
            
            logger.info("Query processed successfully")
            return response.strip()
            
        except OllamaClientError as e:
            logger.error(f"Failed to process query: {e}")
            raise
    
    def process_with_custom_context(
        self,
        query: str,
        custom_context: str
    ) -> str:
        """
        Process query with custom system context.
        
        Args:
            query: User input query
            custom_context: Custom system context for this query
            
        Returns:
            Generated response from the model
        """
        logger.info("Processing query with custom context")
        
        try:
            response = self.llm_client.generate_with_retry(
                prompt=query,
                system=custom_context
            )
            return response.strip()
        except OllamaClientError as e:
            logger.error(f"Failed to process query with custom context: {e}")
            raise
    
    def health_check(self) -> Dict[str, Any]:
        """
        Check agent and LLM health.
        
        Returns:
            Health status dictionary
        """
        ollama_healthy = self.llm_client.health_check()
        
        return {
            "agent": "healthy",
            "ollama": "healthy" if ollama_healthy else "unhealthy",
            "model": self.llm_client.model
        }
