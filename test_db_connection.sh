#!/bin/bash
# Test database connection from backend container

echo "Testing database connection..."
docker exec cyber-backend python -c "from backend.database import engine; print('Database URL:', engine.url); print('Connection successful!')"

echo ""
echo "Checking event counts in database..."
docker exec cyber-backend python -c "
from backend.database import SessionLocal
from backend.models import LoginEvent, FirewallLog, PatchLevel, EventAnalysis

db = SessionLocal()
try:
    login_count = db.query(LoginEvent).count()
    firewall_count = db.query(FirewallLog).count()
    patch_count = db.query(PatchLevel).count()
    analysis_count = db.query(EventAnalysis).count()
    
    print(f'Login Events: {login_count}')
    print(f'Firewall Logs: {firewall_count}')
    print(f'Patch Levels: {patch_count}')
    print(f'Event Analyses: {analysis_count}')
finally:
    db.close()
"
