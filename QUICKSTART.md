# Quick Start Guide

Get the AI Agent service running in **5 minutes**.

## Prerequisites
- Docker and Docker Compose installed
- 8GB+ RAM available
- Linux/macOS/Windows with WSL2

## Setup (Automated)

```bash
# Run the setup script
./setup.sh
```

This will:
1. ✓ Check Docker installation
2. ✓ Build and start all services
3. ✓ Download the Mistral model
4. ✓ Verify everything is working

## Setup (Manual)

```bash
# 1. Start services
docker-compose up -d

# 2. Download Mistral model
docker exec -it ollama ollama pull mistral

# 3. Verify health
curl http://localhost:8000/health
```

## First Query

```bash
curl -X POST http://localhost:8000/query \
  -H "Content-Type: application/json" \
  -d '{
    "query": "What are SSH security best practices?"
  }'
```

## Test Everything

```bash
./test_agent.sh
```

## Access API Documentation

Open in browser:
- **Swagger UI**: http://localhost:8000/docs
- **ReDoc**: http://localhost:8000/redoc

## Common Commands

```bash
# View logs
docker-compose logs -f

# Restart services
docker-compose restart

# Stop services
docker-compose down

# Stop and remove all data
docker-compose down -v
```

## Troubleshooting

### Service not starting?
```bash
docker-compose logs
```

### Model not downloading?
```bash
docker exec -it ollama ollama pull mistral
```

### Connection refused?
Wait 30 seconds for services to fully start, then try again.

## Next Steps

- Read [README.md](README.md) for detailed documentation
- Check [EXAMPLES.md](EXAMPLES.md) for more query examples
- Review configuration in `docker-compose.yml`

## Production Deployment

See the **Production Deployment** section in [README.md](README.md) for:
- Security hardening
- Resource requirements
- GPU support
- Monitoring setup

---

**Need help?** Check the full [README.md](README.md) or review logs with `docker-compose logs`.
