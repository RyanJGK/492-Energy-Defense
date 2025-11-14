"""FastAPI server for AI Agent service."""
import logging
from typing import Dict, Any
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException, status
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field

from src.agent import Agent
from src.agent.llm_client import OllamaClientError
from src.config import config

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Global agent instance
agent: Agent = None


@asynccontextmanager
async def lifespan(app: FastAPI):
    """Lifespan context manager for startup/shutdown."""
    global agent
    
    # Startup
    logger.info("Starting AI Agent service...")
    agent = Agent()
    logger.info("Agent initialized successfully")
    
    yield
    
    # Shutdown
    logger.info("Shutting down AI Agent service...")


# Initialize FastAPI app
app = FastAPI(
    title="AI Agent Service",
    description="Local AI Agent powered by Ollama Mistral model for IT/Cybersecurity analysis",
    version="1.0.0",
    lifespan=lifespan
)


# Request/Response models
class QueryRequest(BaseModel):
    """Request model for agent queries."""
    query: str = Field(..., min_length=1, description="User query to process")
    
    class Config:
        json_schema_extra = {
            "example": {
                "query": "What are the best practices for securing SSH access?"
            }
        }


class QueryResponse(BaseModel):
    """Response model for agent queries."""
    response: str = Field(..., description="Agent's response to the query")
    
    class Config:
        json_schema_extra = {
            "example": {
                "response": "Here are the best practices for securing SSH access..."
            }
        }


class HealthResponse(BaseModel):
    """Response model for health check."""
    status: str
    details: Dict[str, Any]


class ErrorResponse(BaseModel):
    """Response model for errors."""
    error: str
    detail: str


# API Endpoints
@app.get("/", response_model=Dict[str, str])
async def root() -> Dict[str, str]:
    """Root endpoint with service information."""
    return {
        "service": "AI Agent",
        "version": "1.0.0",
        "status": "running",
        "model": config.OLLAMA_MODEL
    }


@app.get("/health", response_model=HealthResponse, status_code=status.HTTP_200_OK)
async def health_check() -> HealthResponse:
    """
    Health check endpoint.
    
    Returns service and Ollama health status.
    """
    try:
        health_status = agent.health_check()
        
        overall_status = "healthy" if health_status["ollama"] == "healthy" else "degraded"
        
        return HealthResponse(
            status=overall_status,
            details=health_status
        )
    except Exception as e:
        logger.error(f"Health check failed: {e}")
        return JSONResponse(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            content={
                "status": "unhealthy",
                "details": {"error": str(e)}
            }
        )


@app.post("/query", response_model=QueryResponse, status_code=status.HTTP_200_OK)
async def process_query(request: QueryRequest) -> QueryResponse:
    """
    Process a user query through the AI agent.
    
    Args:
        request: Query request containing the user's question
        
    Returns:
        Agent's response to the query
        
    Raises:
        HTTPException: If processing fails
    """
    try:
        logger.info(f"Received query request: {request.query[:50]}...")
        
        # Process query through agent
        response_text = agent.process_query(request.query)
        
        return QueryResponse(response=response_text)
        
    except ValueError as e:
        logger.warning(f"Invalid query: {e}")
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=str(e)
        )
    except OllamaClientError as e:
        logger.error(f"Ollama error: {e}")
        raise HTTPException(
            status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
            detail=f"AI service unavailable: {e}"
        )
    except Exception as e:
        logger.error(f"Unexpected error: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Internal server error: {e}"
        )


@app.post("/query/custom", response_model=QueryResponse, status_code=status.HTTP_200_OK)
async def process_query_custom_context(
    query: str = Field(..., description="User query"),
    context: str = Field(..., description="Custom system context")
) -> QueryResponse:
    """
    Process a query with custom system context.
    
    Allows overriding the default IT/cybersecurity context.
    """
    try:
        logger.info("Processing query with custom context")
        
        response_text = agent.process_with_custom_context(query, context)
        
        return QueryResponse(response=response_text)
        
    except Exception as e:
        logger.error(f"Error processing custom query: {e}")
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=str(e)
        )


# Error handlers
@app.exception_handler(404)
async def not_found_handler(request, exc):
    """Handle 404 errors."""
    return JSONResponse(
        status_code=404,
        content={"error": "Not Found", "detail": "The requested endpoint does not exist"}
    )


@app.exception_handler(500)
async def internal_error_handler(request, exc):
    """Handle 500 errors."""
    logger.error(f"Internal server error: {exc}")
    return JSONResponse(
        status_code=500,
        content={"error": "Internal Server Error", "detail": "An unexpected error occurred"}
    )
