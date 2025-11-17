"""Event dispatcher to send events to AI agent for analysis."""
import os
import logging
import requests
from typing import Dict, Any
from datetime import datetime
from sqlalchemy.orm import Session
from .models import LoginEvent, FirewallLog, PatchLevel, EventAnalysis

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

AGENT_URL = os.getenv("AGENT_URL", "http://agent:8000/evaluate-event")
TIMEOUT = 30  # seconds


class EventDispatcher:
    """Dispatch events to AI agent for analysis."""

    def __init__(self, db: Session):
        """Initialize dispatcher with database session."""
        self.db = db

    def dispatch_login_event(self, event: LoginEvent) -> Dict[str, Any]:
        """Send login event to AI agent."""
        payload = {
            "type": "login",
            "data": {
                "username": event.username,
                "src_ip": event.src_ip,
                "status": event.status,
                "timestamp": event.timestamp.isoformat(),
                "device_id": event.device_id,
                "auth_method": event.auth_method,
                "is_burst_failure": event.is_burst_failure,
                "is_suspicious_ip": event.is_suspicious_ip,
                "is_admin": event.is_admin
            }
        }
        return self._send_event(payload, "login", event.id)

    def dispatch_firewall_event(self, event: FirewallLog) -> Dict[str, Any]:
        """Send firewall event to AI agent."""
        payload = {
            "type": "firewall",
            "data": {
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
        }
        return self._send_event(payload, "firewall", event.id)

    def dispatch_patch_event(self, event: PatchLevel) -> Dict[str, Any]:
        """Send patch level event to AI agent."""
        payload = {
            "type": "patch",
            "data": {
                "device_id": event.device_id,
                "os": event.os,
                "last_patch_date": event.last_patch_date.isoformat(),
                "missing_critical": event.missing_critical,
                "missing_high": event.missing_high,
                "update_failures": event.update_failures,
                "is_unsupported": event.is_unsupported
            }
        }
        return self._send_event(payload, "patch", event.id)

    def _send_event(self, payload: Dict[str, Any], event_type: str, event_id: int) -> Dict[str, Any]:
        """Send event to agent and store analysis result."""
        try:
            logger.info(f"Dispatching {event_type} event {event_id} to agent")
            response = requests.post(AGENT_URL, json=payload, timeout=TIMEOUT)
            response.raise_for_status()

            result = response.json()
            
            # Validate response
            if not all(k in result for k in ["event_type", "risk_score", "severity", "reasoning", "recommended_action"]):
                logger.error(f"Invalid response format from agent: {result}")
                return {"error": "Invalid response format"}

            # Store analysis result
            analysis = EventAnalysis(
                event_type=event_type,
                event_id=event_id,
                risk_score=result["risk_score"],
                severity=result["severity"],
                reasoning=result["reasoning"],
                recommended_action=result["recommended_action"],
                analyzed_at=datetime.utcnow()
            )
            self.db.add(analysis)
            self.db.commit()

            logger.info(f"Event {event_id} analyzed: severity={result['severity']}, score={result['risk_score']}")
            return result

        except requests.exceptions.RequestException as e:
            logger.error(f"Failed to dispatch event {event_id}: {e}")
            return {"error": str(e)}
        except Exception as e:
            logger.error(f"Unexpected error dispatching event {event_id}: {e}")
            return {"error": str(e)}

    def dispatch_all_pending(self):
        """Dispatch all events that haven't been analyzed yet."""
        # Find login events without analysis
        analyzed_login_ids = {a.event_id for a in self.db.query(EventAnalysis).filter(
            EventAnalysis.event_type == "login"
        ).all()}
        pending_logins = self.db.query(LoginEvent).filter(
            ~LoginEvent.id.in_(analyzed_login_ids)
        ).all()

        for event in pending_logins:
            self.dispatch_login_event(event)

        # Find firewall events without analysis
        analyzed_firewall_ids = {a.event_id for a in self.db.query(EventAnalysis).filter(
            EventAnalysis.event_type == "firewall"
        ).all()}
        pending_firewalls = self.db.query(FirewallLog).filter(
            ~FirewallLog.id.in_(analyzed_firewall_ids)
        ).all()

        for event in pending_firewalls:
            self.dispatch_firewall_event(event)

        # Find patch events without analysis
        analyzed_patch_ids = {a.event_id for a in self.db.query(EventAnalysis).filter(
            EventAnalysis.event_type == "patch"
        ).all()}
        pending_patches = self.db.query(PatchLevel).filter(
            ~PatchLevel.id.in_(analyzed_patch_ids)
        ).all()

        for event in pending_patches:
            self.dispatch_patch_event(event)
