"""Main entry point for the AI Agent service."""
import uvicorn
from src.config import config


def main():
    """Start the FastAPI server."""
    uvicorn.run(
        "src.api.server:app",
        host=config.API_HOST,
        port=config.API_PORT,
        workers=config.API_WORKERS,
        log_level="info",
        access_log=True
    )


if __name__ == "__main__":
    main()
