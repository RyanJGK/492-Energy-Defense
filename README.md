# AI Agent Service - Local Ollama Mistral

A production-ready, fully local AI Agent service powered by Ollama's Mistral model, designed for IT infrastructure and cybersecurity analysis in the energy sector.

## Features

- 🚀 **FastAPI** - Modern, high-performance API framework
- 🤖 **Ollama + Mistral** - Local AI inference with no cloud dependencies
- 🐳 **Docker** - Fully containerized with docker-compose
- 🔒 **Security-focused** - Non-root containers, health checks, proper isolation
- 🔄 **Retry Logic** - Automatic retry with exponential backoff
- 📊 **Health Monitoring** - Comprehensive health check endpoints
- 🎯 **IT/Cybersecurity** - Pre-configured context for energy sector operations

## Architecture

```
┌─────────────────┐
│   FastAPI App   │  Port 8000
│   (Python 3.11) │
└────────┬────────┘
         │
         │ HTTP
         ▼
┌─────────────────┐
│  Ollama Service │  Port 11434
│  (Mistral Model)│
└─────────────────┘
```

## Project Structure

```
.
├── src/
│   ├── agent/
│   │   ├── __init__.py
│   │   ├── agent_core.py       # Agent logic
│   │   └── llm_client.py       # Ollama client with retry
│   ├── api/
│   │   ├── __init__.py
│   │   └── server.py           # FastAPI endpoints
│   ├── config.py               # Configuration
│   └── main.py                 # Entry point
├── Dockerfile                  # Python service container
├── docker-compose.yml          # Multi-container orchestration
├── requirements.txt            # Python dependencies
└── README.md
```

## Prerequisites

- Docker 20.10+
- Docker Compose 2.0+
- 8GB RAM minimum (16GB recommended for Mistral)
- Linux server (Ubuntu 20.04+ recommended)

## Quick Start

### 1. Clone and Build

```bash
# Clone the repository
git clone <repo-url>
cd <repo-dir>

# Build and start services
docker-compose up -d
```

### 2. Download Mistral Model

The first time you run the service, you need to pull the Mistral model:

```bash
# Access the Ollama container
docker exec -it ollama ollama pull mistral

# Verify the model is downloaded
docker exec -it ollama ollama list
```

Expected output:
```
NAME            ID              SIZE    MODIFIED
mistral:latest  f974a74358d6    4.1 GB  2 minutes ago
```

### 3. Verify Services

```bash
# Check container status
docker-compose ps

# Check health
curl http://localhost:8000/health

# Expected response:
# {
#   "status": "healthy",
#   "details": {
#     "agent": "healthy",
#     "ollama": "healthy",
#     "model": "mistral"
#   }
# }
```

## API Usage

### Root Endpoint

```bash
curl http://localhost:8000/
```

Response:
```json
{
  "service": "AI Agent",
  "version": "1.0.0",
  "status": "running",
  "model": "mistral"
}
```

### Process Query

```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What are the best practices for securing SSH access in industrial control systems?"
  }'
```

Response:
```json
{
  "response": "Here are key best practices for securing SSH access in ICS environments:\n\n1. **Use Key-Based Authentication**: Disable password authentication and use SSH keys with strong passphrases...\n\n2. **Implement Network Segmentation**: Place SSH gateways in DMZ zones...\n\n3. **Enable Multi-Factor Authentication (MFA)**: Add an additional layer of security...\n\n4. **Monitor and Log Access**: Implement comprehensive logging and SIEM integration...\n\n5. **Regular Updates and Patching**: Keep SSH software up to date..."
}
```

### Custom Context Query

For specialized queries with custom system context:

```bash
curl -X POST http://localhost:8000/query/custom \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Explain SCADA vulnerabilities",
    "context": "You are a cybersecurity expert specializing in industrial control systems."
  }'
```

### Health Check

```bash
curl http://localhost:8000/health
```

## Example Queries

### Cybersecurity Analysis

```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Analyze this log entry: Failed password for root from 192.168.1.100 port 22 ssh2"
  }'
```

### Infrastructure Advisory

```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What firewall rules should I implement for a SCADA system?"
  }'
```

### Threat Detection

```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "Identify potential security issues in this configuration: PermitRootLogin yes, PasswordAuthentication yes"
  }'
```

## Configuration

Environment variables can be set in `docker-compose.yml`:

| Variable | Default | Description |
|----------|---------|-------------|
| `OLLAMA_HOST` | `ollama` | Ollama service hostname |
| `OLLAMA_PORT` | `11434` | Ollama API port |
| `OLLAMA_MODEL` | `mistral` | Model name to use |
| `OLLAMA_TIMEOUT` | `120` | Request timeout (seconds) |
| `API_HOST` | `0.0.0.0` | API bind address |
| `API_PORT` | `8000` | API port |
| `MAX_RETRIES` | `3` | Maximum retry attempts |
| `RETRY_DELAY` | `2` | Delay between retries (seconds) |

## Production Deployment

### Security Best Practices

1. **Remove public Ollama port exposure**:
   ```yaml
   # In docker-compose.yml, comment out:
   # ports:
   #   - "11434:11434"
   ```

2. **Use reverse proxy** (Nginx/Caddy):
   ```nginx
   server {
       listen 443 ssl;
       server_name your-domain.com;
       
       location / {
           proxy_pass http://localhost:8000;
           proxy_set_header Host $host;
           proxy_set_header X-Real-IP $remote_addr;
       }
   }
   ```

3. **Enable firewall**:
   ```bash
   ufw allow 8000/tcp
   ufw enable
   ```

4. **Implement rate limiting** (API or reverse proxy level)

5. **Enable TLS/SSL** for all external communication

### Resource Requirements

**Minimum**:
- 4 CPU cores
- 8 GB RAM
- 20 GB disk space

**Recommended**:
- 8 CPU cores
- 16 GB RAM
- 50 GB SSD

### GPU Support (Optional)

For faster inference with NVIDIA GPUs:

1. Install [nvidia-docker2](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html)

2. Uncomment GPU section in `docker-compose.yml`:
   ```yaml
   deploy:
     resources:
       reservations:
         devices:
           - driver: nvidia
             count: 1
             capabilities: [gpu]
   ```

3. Restart services:
   ```bash
   docker-compose down
   docker-compose up -d
   ```

## Monitoring

### View Logs

```bash
# All services
docker-compose logs -f

# Agent only
docker-compose logs -f agent

# Ollama only
docker-compose logs -f ollama
```

### Container Stats

```bash
docker stats
```

### Health Monitoring

Set up automated health checks:

```bash
#!/bin/bash
# health-check.sh

HEALTH_URL="http://localhost:8000/health"
RESPONSE=$(curl -s $HEALTH_URL)

if echo "$RESPONSE" | grep -q '"status":"healthy"'; then
    echo "✓ Service is healthy"
    exit 0
else
    echo "✗ Service is unhealthy"
    echo "$RESPONSE"
    exit 1
fi
```

## Troubleshooting

### Ollama Service Not Starting

```bash
# Check logs
docker-compose logs ollama

# Restart service
docker-compose restart ollama

# Check available models
docker exec -it ollama ollama list
```

### Agent Cannot Connect to Ollama

```bash
# Verify network connectivity
docker exec -it ai_agent ping ollama

# Check Ollama health
docker exec -it ollama curl http://localhost:11434/api/tags
```

### Out of Memory Errors

Reduce model size or increase Docker memory limit:

```bash
# Use smaller model
docker exec -it ollama ollama pull mistral:7b-instruct-v0.2-q4_0

# Update docker-compose.yml
environment:
  - OLLAMA_MODEL=mistral:7b-instruct-v0.2-q4_0
```

### Slow Response Times

- **Enable GPU support** (see GPU section)
- **Increase timeout**: `OLLAMA_TIMEOUT=300`
- **Use quantized models**: smaller, faster models

## Development

### Local Development Without Docker

```bash
# Install dependencies
pip install -r requirements.txt

# Start Ollama separately
ollama serve

# Pull model
ollama pull mistral

# Run the API
python -m src.main
```

### Testing

```bash
# Test basic query
python -c "
from src.agent import Agent
agent = Agent()
response = agent.process_query('Hello, how are you?')
print(response)
"
```

## Maintenance

### Update Services

```bash
# Pull latest images
docker-compose pull

# Rebuild and restart
docker-compose up -d --build
```

### Backup Models

```bash
# Backup Ollama models
docker run --rm -v ollama_models:/data -v $(pwd):/backup \
  alpine tar czf /backup/ollama_models_backup.tar.gz /data
```

### Clean Up

```bash
# Stop services
docker-compose down

# Remove all data (caution!)
docker-compose down -v

# Remove unused images
docker image prune -a
```

## API Documentation

Once running, access interactive API docs:

- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Support

For issues, questions, or contributions, please refer to the project repository.

## License

See [LICENSE](LICENSE) file for details.

---

**Note**: This service is designed for local deployment only. Never expose Ollama ports to the public internet without proper authentication and encryption.
