"""Configuration settings for the AI Agent service."""
import os
from typing import Optional


class Config:
    """Application configuration."""
    
    # Ollama settings
    OLLAMA_HOST: str = os.getenv("OLLAMA_HOST", "ollama")
    OLLAMA_PORT: int = int(os.getenv("OLLAMA_PORT", "11434"))
    OLLAMA_MODEL: str = os.getenv("OLLAMA_MODEL", "mistral")
    OLLAMA_TIMEOUT: int = int(os.getenv("OLLAMA_TIMEOUT", "120"))
    
    # API settings
    API_HOST: str = os.getenv("API_HOST", "0.0.0.0")
    API_PORT: int = int(os.getenv("API_PORT", "8000"))
    API_WORKERS: int = int(os.getenv("API_WORKERS", "1"))
    
    # Agent settings
    MAX_RETRIES: int = int(os.getenv("MAX_RETRIES", "3"))
    RETRY_DELAY: int = int(os.getenv("RETRY_DELAY", "2"))
    
    # System context for IT/Cybersecurity
    SYSTEM_CONTEXT: str = """You are an AI assistant specialized in IT infrastructure and cybersecurity analysis.
You provide clear, actionable insights for energy sector operations.
Focus on security best practices, threat detection, and operational efficiency.
Be concise and technical when appropriate."""
    
    @property
    def ollama_base_url(self) -> str:
        """Get the full Ollama API base URL."""
        return f"http://{self.OLLAMA_HOST}:{self.OLLAMA_PORT}"


config = Config()
