"""Database models for cybersecurity events."""
from sqlalchemy import Column, Integer, String, DateTime, Boolean, Date, Text
from datetime import datetime
from .database import Base


class LoginEvent(Base):
    """Login event model."""
    __tablename__ = "login_events"

    id = Column(Integer, primary_key=True, index=True)
    username = Column(String(255), nullable=False)
    src_ip = Column(String(45), nullable=False)
    status = Column(String(20), nullable=False)  # SUCCESS or FAIL
    timestamp = Column(DateTime, default=datetime.utcnow, nullable=False)
    device_id = Column(String(255), nullable=False)
    auth_method = Column(String(50), nullable=False)
    is_burst_failure = Column(Boolean, default=False)
    is_suspicious_ip = Column(Boolean, default=False)
    is_admin = Column(Boolean, default=False)


class FirewallLog(Base):
    """Firewall log model."""
    __tablename__ = "firewall_logs"

    id = Column(Integer, primary_key=True, index=True)
    src_ip = Column(String(45), nullable=False)
    dst_ip = Column(String(45), nullable=False)
    action = Column(String(20), nullable=False)  # ALLOW or DENY
    port = Column(Integer, nullable=False)
    protocol = Column(String(20), nullable=False)
    timestamp = Column(DateTime, default=datetime.utcnow, nullable=False)
    is_port_scan = Column(Boolean, default=False)
    is_lateral_movement = Column(Boolean, default=False)
    is_malicious_range = Column(Boolean, default=False)
    is_connection_spike = Column(Boolean, default=False)


class PatchLevel(Base):
    """Patch level tracking model."""
    __tablename__ = "patch_levels"

    id = Column(Integer, primary_key=True, index=True)
    device_id = Column(String(255), unique=True, nullable=False)
    os = Column(String(100), nullable=False)
    last_patch_date = Column(Date, nullable=False)
    missing_critical = Column(Integer, default=0)
    missing_high = Column(Integer, default=0)
    update_failures = Column(Integer, default=0)
    is_unsupported = Column(Boolean, default=False)
    updated_at = Column(DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)


class EventAnalysis(Base):
    """Store AI analysis results."""
    __tablename__ = "event_analyses"

    id = Column(Integer, primary_key=True, index=True)
    event_type = Column(String(50), nullable=False)
    event_id = Column(Integer, nullable=False)
    risk_score = Column(Integer, nullable=False)
    severity = Column(String(20), nullable=False)
    reasoning = Column(Text, nullable=False)
    recommended_action = Column(Text, nullable=False)
    analyzed_at = Column(DateTime, default=datetime.utcnow, nullable=False)
