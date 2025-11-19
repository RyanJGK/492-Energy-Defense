"""AI Agent API for cybersecurity event analysis using Ollama Mistral."""
import os
import logging
import json
import re
from typing import Dict, Any
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
import requests

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = FastAPI(title="492-Energy-Defense Cyber Event Triage Agent")

OLLAMA_URL = os.getenv("OLLAMA_URL", "http://ollama:11434/api/generate")
OLLAMA_MODEL = os.getenv("OLLAMA_MODEL", "mistral")
USE_LLM = os.getenv("USE_LLM", "true").lower() == "true"  # Enable LLM mode by default


class EventData(BaseModel):
    """Generic event data container."""
    pass


class Event(BaseModel):
    """Event structure for analysis."""
    type: str = Field(..., description="Event type: login, firewall, or patch")
    data: Dict[str, Any] = Field(..., description="Event data fields")


class AnalysisResult(BaseModel):
    """Analysis result structure."""
    event_type: str
    risk_score: int
    severity: str
    reasoning: str
    recommended_action: str


SYSTEM_PROMPT = """You are the 492-Energy-Defense Cyber Event Triage Agent, a cybersecurity analysis AI.

Your role is to analyze individual security events and return a structured JSON risk assessment.

SCORING RULES:

LOGIN EVENT WEIGHTS:
- Failed login attempt: +30
- 3rd+ failure in short time (is_burst_failure=true): +20
- Unknown/new device: +25
- Login between 00:00-05:00: +10
- Admin account (is_admin=true): +40
- Suspicious source IP (is_suspicious_ip=true): +30

FIREWALL EVENT WEIGHTS:
- Repeated denial from same IP (is_connection_spike=true): +20
- Known malicious IP range (is_malicious_range=true): +40
- Port-scan signature (is_port_scan=true): +35
- Outbound unusual port: +20
- Internal lateral movement (is_lateral_movement=true): +25
- Connection spike: +15

PATCH EVENT WEIGHTS:
- missing_critical > 0: +50
- missing_high > 0: +35
- last_patch_date older than 60 days: +15
- update_failures > 0: +20
- unsupported OS (is_unsupported=true): +40

SEVERITY MAPPING:
- 0-20: low
- 21-40: medium
- 41-70: high
- 71+: critical

OUTPUT FORMAT (MUST be valid JSON):
{
  "event_type": "login" | "firewall" | "patch",
  "risk_score": <int>,
  "severity": "low" | "medium" | "high" | "critical",
  "reasoning": "List which weights triggered and why.",
  "recommended_action": "One concrete SOC mitigation step."
}

IMPORTANT RULES:
1. Evaluate ONLY the single event provided
2. Apply scoring weights exactly as defined
3. Output ONLY the JSON object, no additional text
4. Be deterministic and consistent
5. Recommended action must be realistic and IT/SOC appropriate"""


def call_ollama(prompt: str) -> str:
    """Call Ollama API with the given prompt."""
    try:
        payload = {
            "model": OLLAMA_MODEL,
            "prompt": prompt,
            "stream": False,
            "options": {
                "temperature": 0.1,  # Low temperature for consistency
                "top_p": 0.9
            }
        }

        logger.info("Calling Ollama API...")
        response = requests.post(OLLAMA_URL, json=payload, timeout=60)
        response.raise_for_status()

        result = response.json()
        return result.get("response", "")

    except Exception as e:
        logger.error(f"Ollama API error: {e}")
        raise


def extract_json_from_response(text: str) -> Dict[str, Any]:
    """Extract JSON object from Ollama response."""
    # Try to find JSON in the response
    json_match = re.search(r'\{[^{}]*(?:\{[^{}]*\}[^{}]*)*\}', text, re.DOTALL)
    
    if json_match:
        try:
            return json.loads(json_match.group(0))
        except json.JSONDecodeError:
            pass
    
    # If no valid JSON found, raise error
    raise ValueError("No valid JSON found in response")


def analyze_event_with_llm(event_type: str, event_data: Dict[str, Any]) -> AnalysisResult:
    """Analyze event using Ollama LLM."""
    # Build the prompt with event data
    event_json = json.dumps(event_data, indent=2)
    
    prompt = f"""{SYSTEM_PROMPT}

EVENT TO ANALYZE:
Type: {event_type}
Data:
{event_json}

Analyze this event and respond with ONLY a JSON object following the exact format specified above."""

    logger.info(f"Calling Ollama LLM for {event_type} event analysis...")
    
    # Call Ollama
    response_text = call_ollama(prompt)
    
    # Extract JSON from response
    result_dict = extract_json_from_response(response_text)
    
    # Validate and create AnalysisResult
    return AnalysisResult(
        event_type=result_dict.get("event_type", event_type),
        risk_score=result_dict.get("risk_score", 0),
        severity=result_dict.get("severity", "low"),
        reasoning=result_dict.get("reasoning", "LLM analysis completed"),
        recommended_action=result_dict.get("recommended_action", "Review event details")
    )


def analyze_login_event(data: Dict[str, Any]) -> AnalysisResult:
    """Analyze login event and calculate risk score."""
    score = 0
    reasons = []

    # Failed login: +30
    if data.get("status") == "FAIL":
        score += 30
        reasons.append("Failed login attempt (+30)")

    # Burst failure: +20
    if data.get("is_burst_failure"):
        score += 20
        reasons.append("3rd+ failure in short time window (+20)")

    # Night time (check timestamp hour)
    timestamp = data.get("timestamp", "")
    if timestamp:
        try:
            hour = int(timestamp.split("T")[1].split(":")[0])
            if 0 <= hour <= 5:
                score += 10
                reasons.append("Login during 00:00-05:00 hours (+10)")
        except:
            pass

    # Admin account: +40
    if data.get("is_admin"):
        score += 40
        reasons.append("Admin account targeted (+40)")

    # Suspicious IP: +30
    if data.get("is_suspicious_ip"):
        score += 30
        reasons.append("Suspicious source IP detected (+30)")

    # Determine severity
    if score <= 20:
        severity = "low"
    elif score <= 40:
        severity = "medium"
    elif score <= 70:
        severity = "high"
    else:
        severity = "critical"

    # Generate reasoning
    reasoning = "; ".join(reasons) if reasons else "Normal login activity detected"

    # Recommended action
    if severity == "critical":
        action = "IMMEDIATE: Lock account, investigate source IP, review all recent activity from this user/IP"
    elif severity == "high":
        action = "Investigate login source, verify user identity, consider temporary account restriction"
    elif severity == "medium":
        action = "Monitor account for additional suspicious activity, verify with user if unexpected"
    else:
        action = "Continue normal monitoring, log event for baseline analysis"

    return AnalysisResult(
        event_type="login",
        risk_score=score,
        severity=severity,
        reasoning=reasoning,
        recommended_action=action
    )


def analyze_firewall_event(data: Dict[str, Any]) -> AnalysisResult:
    """Analyze firewall event and calculate risk score."""
    score = 0
    reasons = []

    # Connection spike/repeated denial: +20
    if data.get("is_connection_spike"):
        score += 20
        reasons.append("Repeated connection attempts/denials detected (+20)")

    # Malicious IP range: +40
    if data.get("is_malicious_range"):
        score += 40
        reasons.append("Known malicious IP range detected (+40)")

    # Port scan: +35
    if data.get("is_port_scan"):
        score += 35
        reasons.append("Port scanning activity detected (+35)")

    # Lateral movement: +25
    if data.get("is_lateral_movement"):
        score += 25
        reasons.append("Internal lateral movement detected (+25)")

    # Suspicious ports
    suspicious_ports = [4444, 1337, 31337, 6667, 6697]
    if data.get("port") in suspicious_ports:
        score += 20
        reasons.append(f"Unusual port {data.get('port')} detected (+20)")

    # Determine severity
    if score <= 20:
        severity = "low"
    elif score <= 40:
        severity = "medium"
    elif score <= 70:
        severity = "high"
    else:
        severity = "critical"

    # Generate reasoning
    reasoning = "; ".join(reasons) if reasons else "Normal firewall activity detected"

    # Recommended action
    if severity == "critical":
        action = "IMMEDIATE: Block source IP, isolate affected systems, conduct full network scan"
    elif severity == "high":
        action = "Block suspicious IP, investigate destination systems, review firewall rules"
    elif severity == "medium":
        action = "Monitor source IP, verify legitimacy of connection attempts, update IDS rules"
    else:
        action = "Continue normal monitoring, maintain firewall logs for analysis"

    return AnalysisResult(
        event_type="firewall",
        risk_score=score,
        severity=severity,
        reasoning=reasoning,
        recommended_action=action
    )


def analyze_patch_event(data: Dict[str, Any]) -> AnalysisResult:
    """Analyze patch level event and calculate risk score."""
    score = 0
    reasons = []

    # Missing critical patches: +50
    if data.get("missing_critical", 0) > 0:
        score += 50
        reasons.append(f"{data.get('missing_critical')} critical patches missing (+50)")

    # Missing high patches: +35
    if data.get("missing_high", 0) > 0:
        score += 35
        reasons.append(f"{data.get('missing_high')} high-priority patches missing (+35)")

    # Outdated patches (>60 days)
    last_patch = data.get("last_patch_date", "")
    if last_patch:
        try:
            from datetime import datetime, date
            if isinstance(last_patch, str):
                patch_date = datetime.fromisoformat(last_patch).date()
            else:
                patch_date = last_patch
            days_old = (date.today() - patch_date).days
            if days_old > 60:
                score += 15
                reasons.append(f"Patches outdated by {days_old} days (+15)")
        except:
            pass

    # Update failures: +20
    if data.get("update_failures", 0) > 0:
        score += 20
        reasons.append(f"{data.get('update_failures')} update failures detected (+20)")

    # Unsupported OS: +40
    if data.get("is_unsupported"):
        score += 40
        reasons.append(f"Unsupported OS: {data.get('os')} (+40)")

    # Determine severity
    if score <= 20:
        severity = "low"
    elif score <= 40:
        severity = "medium"
    elif score <= 70:
        severity = "high"
    else:
        severity = "critical"

    # Generate reasoning
    reasoning = "; ".join(reasons) if reasons else "System patch level acceptable"

    # Recommended action
    if severity == "critical":
        action = "URGENT: Isolate system, apply critical patches immediately, scan for exploitation signs"
    elif severity == "high":
        action = "Schedule emergency patching within 24 hours, restrict system access until patched"
    elif severity == "medium":
        action = "Schedule patching within 1 week, monitor system for suspicious activity"
    else:
        action = "Continue normal patch management schedule, maintain update monitoring"

    return AnalysisResult(
        event_type="patch",
        risk_score=score,
        severity=severity,
        reasoning=reasoning,
        recommended_action=action
    )


@app.post("/evaluate-event", response_model=AnalysisResult)
async def evaluate_event(event: Event) -> AnalysisResult:
    """
    Evaluate a cybersecurity event and return risk assessment.
    
    Mode determined by USE_LLM environment variable:
    - USE_LLM=true: Uses Ollama/Mistral LLM for intelligent analysis
    - USE_LLM=false: Uses deterministic rule-based scoring
    """
    logger.info(f"Received {event.type} event for analysis (LLM mode: {USE_LLM})")

    try:
        if USE_LLM:
            # Use LLM for intelligent analysis
            logger.info("Using LLM-based analysis...")
            result = analyze_event_with_llm(event.type, event.data)
        else:
            # Use deterministic rule-based analysis
            logger.info("Using rule-based analysis...")
            if event.type == "login":
                result = analyze_login_event(event.data)
            elif event.type == "firewall":
                result = analyze_firewall_event(event.data)
            elif event.type == "patch":
                result = analyze_patch_event(event.data)
            else:
                raise HTTPException(status_code=400, detail=f"Unknown event type: {event.type}")

        logger.info(f"Analysis complete: {result.severity} severity, score {result.risk_score}")
        return result

    except Exception as e:
        logger.error(f"Analysis error: {e}", exc_info=True)
        # Fallback to rule-based if LLM fails
        if USE_LLM:
            logger.warning("LLM analysis failed, falling back to rule-based analysis")
            try:
                if event.type == "login":
                    result = analyze_login_event(event.data)
                elif event.type == "firewall":
                    result = analyze_firewall_event(event.data)
                elif event.type == "patch":
                    result = analyze_patch_event(event.data)
                else:
                    raise HTTPException(status_code=400, detail=f"Unknown event type: {event.type}")
                return result
            except:
                pass
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/health")
async def health_check():
    """Health check endpoint."""
    return {
        "status": "healthy", 
        "service": "492-Energy-Defense Cyber Event Triage Agent",
        "mode": "LLM" if USE_LLM else "Rule-based",
        "ollama_url": OLLAMA_URL if USE_LLM else "N/A",
        "model": OLLAMA_MODEL if USE_LLM else "N/A"
    }


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "service": "492-Energy-Defense Cyber Event Triage Agent",
        "version": "2.0.0",
        "status": "operational",
        "analysis_mode": "LLM-powered" if USE_LLM else "Rule-based",
        "llm_model": OLLAMA_MODEL if USE_LLM else None
    }


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
