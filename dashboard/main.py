"""Cybersecurity Dashboard Web Server."""
import os
import logging
from datetime import datetime, timedelta
from typing import List, Optional
from fastapi import FastAPI, HTTPException, Query
from fastapi.responses import HTMLResponse, FileResponse
from fastapi.staticfiles import StaticFiles
from pydantic import BaseModel
from sqlalchemy import create_engine, desc, func
from sqlalchemy.orm import sessionmaker, Session
import sys

# Add parent directory to path to import models
sys.path.append('/app')
from backend.models import (
    LoginEvent, FirewallLog, PatchLevel, EventAnalysis, 
    AnalystFeedback as AnalystFeedbackModel,
    WhitelistedIP, WhitelistedUser, Base
)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="492-Energy-Defense Security Dashboard")

# Database connection
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:postgres@db:5432/cyber_events")
engine = create_engine(DATABASE_URL)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Initialize feedback tables on startup
@app.on_event("startup")
async def startup_event():
    """Initialize database tables on startup."""
    try:
        # Create feedback and whitelist tables if they don't exist
        Base.metadata.create_all(bind=engine, tables=[
            AnalystFeedbackModel.__table__,
            WhitelistedIP.__table__,
            WhitelistedUser.__table__
        ])
        logger.info("✅ Feedback and whitelist tables initialized")
    except Exception as e:
        logger.error(f"❌ Error initializing tables: {e}")


def get_db():
    """Get database session."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


class AlertSummary(BaseModel):
    """Alert summary model."""
    id: int
    event_type: str
    severity: str
    risk_score: int
    reasoning: str
    recommended_action: str
    analyzed_at: datetime
    event_details: dict


class DashboardStats(BaseModel):
    """Dashboard statistics."""
    total_events: int
    critical_alerts: int
    high_alerts: int
    medium_alerts: int
    low_alerts: int
    events_last_24h: int
    avg_risk_score: float


class AnalystFeedback(BaseModel):
    """Analyst feedback for event review."""
    alert_id: int
    action: str  # 'whitelist_ip', 'whitelist_user', 'confirmed_threat', 'false_positive'
    notes: str
    whitelist_value: Optional[str] = None  # IP address or username to whitelist


@app.get("/")
async def root():
    """Root endpoint - redirect to alerts page."""
    return HTMLResponse(content=open('/app/dashboard/static/index.html').read())


@app.get("/api/stats")
async def get_stats():
    """Get dashboard statistics."""
    db = next(get_db())
    
    try:
        # Total events analyzed
        total_events = db.query(EventAnalysis).count()
        
        # Count by severity
        critical_alerts = db.query(EventAnalysis).filter(EventAnalysis.severity == 'critical').count()
        high_alerts = db.query(EventAnalysis).filter(EventAnalysis.severity == 'high').count()
        medium_alerts = db.query(EventAnalysis).filter(EventAnalysis.severity == 'medium').count()
        low_alerts = db.query(EventAnalysis).filter(EventAnalysis.severity == 'low').count()
        
        # Events in last 24 hours
        yesterday = datetime.utcnow() - timedelta(hours=24)
        events_last_24h = db.query(EventAnalysis).filter(
            EventAnalysis.analyzed_at >= yesterday
        ).count()
        
        # Average risk score
        avg_score = db.query(func.avg(EventAnalysis.risk_score)).scalar() or 0.0
        
        return DashboardStats(
            total_events=total_events,
            critical_alerts=critical_alerts,
            high_alerts=high_alerts,
            medium_alerts=medium_alerts,
            low_alerts=low_alerts,
            events_last_24h=events_last_24h,
            avg_risk_score=round(avg_score, 1)
        )
    except Exception as e:
        logger.error(f"Error fetching stats: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/alerts")
async def get_alerts(
    severity: Optional[str] = Query(None, description="Filter by severity"),
    event_type: Optional[str] = Query(None, description="Filter by event type"),
    limit: int = Query(100, description="Maximum number of alerts to return")
):
    """Get alerts/anomalies with optional filters, sorted by severity."""
    db = next(get_db())
    
    try:
        query = db.query(EventAnalysis)
        
        # Apply filters
        if severity:
            query = query.filter(EventAnalysis.severity == severity)
        if event_type:
            query = query.filter(EventAnalysis.event_type == event_type)
        
        # Get alerts and sort by severity (critical first) then by time
        analyses = query.order_by(desc(EventAnalysis.analyzed_at)).limit(limit * 2).all()
        
        # Sort by severity priority: critical > high > medium > low
        severity_order = {'critical': 0, 'high': 1, 'medium': 2, 'low': 3}
        analyses = sorted(analyses, key=lambda x: (severity_order.get(x.severity, 4), -x.analyzed_at.timestamp()))[:limit]
        
        # Enrich with event details
        results = []
        for analysis in analyses:
            event_details = {}
            
            # Fetch original event details
            if analysis.event_type == "login":
                event = db.query(LoginEvent).filter(LoginEvent.id == analysis.event_id).first()
                if event:
                    event_details = {
                        "username": event.username,
                        "src_ip": event.src_ip,
                        "status": event.status,
                        "timestamp": event.timestamp.isoformat(),
                        "device_id": event.device_id,
                        "auth_method": event.auth_method,
                        "is_admin": event.is_admin,
                        "is_suspicious_ip": event.is_suspicious_ip,
                        "is_burst_failure": event.is_burst_failure
                    }
            elif analysis.event_type == "firewall":
                event = db.query(FirewallLog).filter(FirewallLog.id == analysis.event_id).first()
                if event:
                    event_details = {
                        "src_ip": event.src_ip,
                        "dst_ip": event.dst_ip,
                        "action": event.action,
                        "port": event.port,
                        "protocol": event.protocol,
                        "timestamp": event.timestamp.isoformat(),
                        "is_port_scan": event.is_port_scan,
                        "is_lateral_movement": event.is_lateral_movement,
                        "is_malicious_range": event.is_malicious_range,
                        "is_connection_spike": event.is_connection_spike
                    }
            elif analysis.event_type == "patch":
                event = db.query(PatchLevel).filter(PatchLevel.id == analysis.event_id).first()
                if event:
                    event_details = {
                        "device_id": event.device_id,
                        "os": event.os,
                        "last_patch_date": event.last_patch_date.isoformat(),
                        "missing_critical": event.missing_critical,
                        "missing_high": event.missing_high,
                        "update_failures": event.update_failures,
                        "is_unsupported": event.is_unsupported
                    }
            
            results.append(AlertSummary(
                id=analysis.id,
                event_type=analysis.event_type,
                severity=analysis.severity,
                risk_score=analysis.risk_score,
                reasoning=analysis.reasoning,
                recommended_action=analysis.recommended_action,
                analyzed_at=analysis.analyzed_at,
                event_details=event_details
            ))
        
        return results
    except Exception as e:
        logger.error(f"Error fetching alerts: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/api/alert/{alert_id}")
async def get_alert_details(alert_id: int):
    """Get detailed information about a specific alert."""
    db = next(get_db())
    
    try:
        analysis = db.query(EventAnalysis).filter(EventAnalysis.id == alert_id).first()
        
        if not analysis:
            raise HTTPException(status_code=404, detail="Alert not found")
        
        event_details = {}
        
        # Fetch original event details
        if analysis.event_type == "login":
            event = db.query(LoginEvent).filter(LoginEvent.id == analysis.event_id).first()
            if event:
                event_details = {
                    "username": event.username,
                    "src_ip": event.src_ip,
                    "status": event.status,
                    "timestamp": event.timestamp.isoformat(),
                    "device_id": event.device_id,
                    "auth_method": event.auth_method,
                    "is_admin": event.is_admin,
                    "is_suspicious_ip": event.is_suspicious_ip,
                    "is_burst_failure": event.is_burst_failure
                }
        elif analysis.event_type == "firewall":
            event = db.query(FirewallLog).filter(FirewallLog.id == analysis.event_id).first()
            if event:
                event_details = {
                    "src_ip": event.src_ip,
                    "dst_ip": event.dst_ip,
                    "action": event.action,
                    "port": event.port,
                    "protocol": event.protocol,
                    "timestamp": event.timestamp.isoformat(),
                    "is_port_scan": event.is_port_scan,
                    "is_lateral_movement": event.is_lateral_movement,
                    "is_malicious_range": event.is_malicious_range,
                    "is_connection_spike": event.is_connection_spike
                }
        elif analysis.event_type == "patch":
            event = db.query(PatchLevel).filter(PatchLevel.id == analysis.event_id).first()
            if event:
                event_details = {
                    "device_id": event.device_id,
                    "os": event.os,
                    "last_patch_date": event.last_patch_date.isoformat(),
                    "missing_critical": event.missing_critical,
                    "missing_high": event.missing_high,
                    "update_failures": event.update_failures,
                    "is_unsupported": event.is_unsupported
                }
        
        return AlertSummary(
            id=analysis.id,
            event_type=analysis.event_type,
            severity=analysis.severity,
            risk_score=analysis.risk_score,
            reasoning=analysis.reasoning,
            recommended_action=analysis.recommended_action,
            analyzed_at=analysis.analyzed_at,
            event_details=event_details
        )
    except HTTPException:
        raise
    except Exception as e:
        logger.error(f"Error fetching alert details: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.post("/api/feedback")
async def submit_feedback(feedback: AnalystFeedback):
    """Submit analyst feedback for an alert."""
    db = next(get_db())
    
    try:
        # Verify alert exists
        analysis = db.query(EventAnalysis).filter(EventAnalysis.id == feedback.alert_id).first()
        if not analysis:
            raise HTTPException(status_code=404, detail="Alert not found")
        
        # Store the feedback
        feedback_record = AnalystFeedbackModel(
            alert_id=feedback.alert_id,
            action=feedback.action,
            notes=feedback.notes,
            whitelist_value=feedback.whitelist_value,
            reviewed_by="analyst",
            reviewed_at=datetime.utcnow()
        )
        db.add(feedback_record)
        
        # Handle whitelist actions
        if feedback.action == "whitelist_ip" and feedback.whitelist_value:
            # Check if already whitelisted
            existing = db.query(WhitelistedIP).filter(
                WhitelistedIP.ip_address == feedback.whitelist_value
            ).first()
            
            if not existing:
                whitelist_entry = WhitelistedIP(
                    ip_address=feedback.whitelist_value,
                    reason=feedback.notes or "Analyst approved",
                    added_by="analyst"
                )
                db.add(whitelist_entry)
                logger.info(f"Added IP {feedback.whitelist_value} to whitelist")
            else:
                logger.info(f"IP {feedback.whitelist_value} already whitelisted")
        
        elif feedback.action == "whitelist_user" and feedback.whitelist_value:
            # Check if already whitelisted
            existing = db.query(WhitelistedUser).filter(
                WhitelistedUser.username == feedback.whitelist_value
            ).first()
            
            if not existing:
                whitelist_entry = WhitelistedUser(
                    username=feedback.whitelist_value,
                    reason=feedback.notes or "Analyst approved",
                    added_by="analyst"
                )
                db.add(whitelist_entry)
                logger.info(f"Added user {feedback.whitelist_value} to whitelist")
            else:
                logger.info(f"User {feedback.whitelist_value} already whitelisted")
        
        # Commit all changes
        db.commit()
        
        logger.info(f"Analyst feedback stored for alert {feedback.alert_id}: {feedback.action}")
        
        return {
            "status": "success",
            "message": "Feedback submitted successfully",
            "alert_id": feedback.alert_id,
            "action": feedback.action,
            "whitelist_value": feedback.whitelist_value
        }
    except HTTPException:
        raise
    except Exception as e:
        db.rollback()
        logger.error(f"Error submitting feedback: {e}")
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {"status": "healthy", "service": "492-Energy-Defense Dashboard"}


# Mount static files
app.mount("/static", StaticFiles(directory="/app/dashboard/static"), name="static")


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=3000)
