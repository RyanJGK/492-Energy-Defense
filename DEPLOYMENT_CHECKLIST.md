# Deployment Checklist

Use this checklist to deploy the AI Agent service to production.

## Pre-Deployment

### Requirements Verification
- [ ] Docker 20.10+ installed
- [ ] Docker Compose 2.0+ installed
- [ ] Minimum 8GB RAM available
- [ ] Minimum 20GB disk space
- [ ] Ports 8000 and 11434 available (or configured differently)

### Security Review
- [ ] Review `.env` configuration
- [ ] Disable public Ollama port in `docker-compose.yml` (remove port mapping)
- [ ] Configure firewall rules (allow only necessary ports)
- [ ] Set up reverse proxy (Nginx/Caddy) with SSL/TLS
- [ ] Review container security settings
- [ ] Verify non-root user execution

## Initial Deployment

### Setup Steps
```bash
# 1. Clone repository
git clone <repo-url>
cd <repo-dir>

# 2. Configure environment (optional)
cp .env.example .env
# Edit .env with your settings

# 3. Run automated setup
./setup.sh
```

### Manual Verification
- [ ] Services started: `docker-compose ps`
- [ ] Health check passing: `curl http://localhost:8000/health`
- [ ] Ollama responding: `docker exec ollama ollama list`
- [ ] Mistral model downloaded
- [ ] API documentation accessible: `http://localhost:8000/docs`

### Testing
- [ ] Run test suite: `./test_agent.sh`
- [ ] Test basic query manually
- [ ] Test health endpoint
- [ ] Verify error handling (empty query, invalid input)
- [ ] Load test (optional but recommended)

## Production Configuration

### Security Hardening
- [ ] Configure reverse proxy (Nginx/Caddy)
```nginx
server {
    listen 443 ssl http2;
    server_name your-domain.com;
    
    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;
    
    location / {
        proxy_pass http://localhost:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

- [ ] Enable firewall
```bash
ufw allow 80/tcp
ufw allow 443/tcp
ufw enable
```

- [ ] Implement rate limiting (in reverse proxy or API)
- [ ] Set up authentication (API keys, OAuth, etc.)
- [ ] Enable HTTPS/TLS everywhere

### Monitoring Setup
- [ ] Configure log aggregation (ELK, Loki, etc.)
- [ ] Set up health check monitoring
```bash
# Example: Add to crontab
*/5 * * * * /usr/local/bin/health-check.sh >> /var/log/agent-health.log 2>&1
```

- [ ] Configure alerting (email, Slack, PagerDuty)
- [ ] Set up metrics collection (Prometheus, Grafana)

### Backup Configuration
- [ ] Backup Ollama models
```bash
docker run --rm -v ollama_models:/data -v /backup:/backup \
  alpine tar czf /backup/ollama_models_$(date +%Y%m%d).tar.gz /data
```

- [ ] Backup configuration files
- [ ] Set up automated backup schedule
- [ ] Test restore procedure

## Post-Deployment

### Validation
- [ ] Service accessible from expected locations
- [ ] SSL/TLS certificate valid
- [ ] Health checks passing
- [ ] Logs being collected
- [ ] Metrics being recorded
- [ ] Alerts configured and working

### Documentation
- [ ] Document deployment configuration
- [ ] Update internal wiki/docs with service details
- [ ] Share API documentation with team
- [ ] Document troubleshooting procedures
- [ ] Create runbook for common operations

### Team Training
- [ ] Train team on API usage
- [ ] Share example queries
- [ ] Explain monitoring dashboards
- [ ] Review incident response procedures

## Ongoing Maintenance

### Regular Tasks
- [ ] Monitor service health daily
- [ ] Review logs weekly
- [ ] Check disk space weekly
- [ ] Update dependencies monthly
- [ ] Review security advisories
- [ ] Test backups monthly

### Update Procedure
```bash
# 1. Backup current state
docker-compose down
# Backup volumes

# 2. Pull updates
git pull origin main
docker-compose pull

# 3. Rebuild and restart
docker-compose up -d --build

# 4. Verify
curl http://localhost:8000/health
./test_agent.sh
```

### Incident Response
- [ ] Document incident response plan
- [ ] Test rollback procedure
- [ ] Prepare emergency contacts list
- [ ] Document escalation paths

## Performance Optimization (Optional)

### GPU Support
- [ ] Install nvidia-docker2
- [ ] Uncomment GPU section in docker-compose.yml
- [ ] Verify GPU utilization
- [ ] Benchmark performance improvement

### Resource Tuning
- [ ] Monitor resource usage
- [ ] Adjust container resource limits
- [ ] Tune Ollama model parameters
- [ ] Optimize query timeout settings

## Compliance & Audit

### Security Compliance
- [ ] Review access logs
- [ ] Audit user permissions
- [ ] Document security controls
- [ ] Schedule security assessments

### Operational Compliance
- [ ] Document system architecture
- [ ] Maintain change log
- [ ] Review SLA requirements
- [ ] Document DR procedures

## Sign-Off

### Deployment Team
- [ ] Developer: _____________________ Date: _______
- [ ] DevOps: _______________________ Date: _______
- [ ] Security: _____________________ Date: _______
- [ ] Manager: ______________________ Date: _______

### Production Ready
- [ ] All checklist items completed
- [ ] Documentation updated
- [ ] Team trained
- [ ] Monitoring active
- [ ] Backups configured

---

**Status**: Ready for Production ✅

**Deployed By**: _________________

**Deployment Date**: _____________

**Environment**: [ ] Development [ ] Staging [ ] Production

**Notes**:
_____________________________________________________________
_____________________________________________________________
_____________________________________________________________
