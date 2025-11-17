"""Synthetic cybersecurity event data generator."""
import random
import logging
from datetime import datetime, timedelta, date
from typing import List
from sqlalchemy.orm import Session
from .models import LoginEvent, FirewallLog, PatchLevel

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


class DataGenerator:
    """Generate synthetic cybersecurity events."""

    # Sample data pools
    USERNAMES = [
        "jdoe", "asmith", "mjohnson", "rlee", "kwilliams", "dbrown",
        "admin", "root", "sysadmin", "netadmin", "service_account",
        "backup_user", "monitoring", "scanner", "developer1", "developer2"
    ]

    ADMIN_USERS = {"admin", "root", "sysadmin", "netadmin"}

    INTERNAL_IPS = [f"192.168.1.{i}" for i in range(1, 255)]
    EXTERNAL_IPS = [f"203.0.113.{i}" for i in range(1, 255)]
    MALICIOUS_IPS = [f"198.51.100.{i}" for i in range(1, 50)]

    DEVICE_IDS = [
        f"WIN-LAPTOP-{i:02d}" for i in range(1, 30)
    ] + [
        f"MAC-DESKTOP-{i:02d}" for i in range(1, 15)
    ] + [
        f"LINUX-SERVER-{i:02d}" for i in range(1, 10)
    ]

    OS_TYPES = [
        "Windows 10", "Windows 11", "Windows Server 2019", "Windows Server 2022",
        "macOS 13", "macOS 14", "Ubuntu 20.04", "Ubuntu 22.04",
        "RHEL 8", "RHEL 9", "Windows Server 2012"  # Unsupported
    ]

    UNSUPPORTED_OS = {"Windows Server 2012"}

    AUTH_METHODS = ["password", "mfa", "sso", "certificate"]

    PROTOCOLS = ["TCP", "UDP", "ICMP"]
    COMMON_PORTS = [22, 80, 443, 3389, 445, 139, 135, 3306, 5432, 8080, 8443]
    SUSPICIOUS_PORTS = [4444, 1337, 31337, 6667, 6697]

    def __init__(self):
        """Initialize generator with tracking state."""
        self.last_brute_force = datetime.now() - timedelta(hours=13)
        self.last_port_scan = datetime.now() - timedelta(hours=25)
        self.failed_login_tracker = {}  # Track failed logins per user

    def generate_login_events(self, db: Session) -> List[LoginEvent]:
        """Generate 20-80 login events with realistic patterns."""
        num_events = random.randint(20, 80)
        events = []

        # Determine if we should inject a brute-force burst
        hours_since_last_brute = (datetime.now() - self.last_brute_force).total_seconds() / 3600
        should_brute_force = hours_since_last_brute >= 12

        for i in range(num_events):
            # Random base values
            username = random.choice(self.USERNAMES)
            src_ip = random.choice(self.INTERNAL_IPS + self.EXTERNAL_IPS)
            device_id = random.choice(self.DEVICE_IDS)
            auth_method = random.choice(self.AUTH_METHODS)

            # Determine failure rate (10-20%)
            is_failed = random.random() < 0.15

            # Night time login (15-30% between 00:00-05:00)
            if random.random() < 0.22:
                hour = random.randint(0, 5)
                minute = random.randint(0, 59)
                second = random.randint(0, 59)
                timestamp = datetime.now().replace(hour=hour, minute=minute, second=second)
            else:
                timestamp = datetime.now() - timedelta(minutes=random.randint(0, 1800))

            # Admin account (5%)
            is_admin = username in self.ADMIN_USERS

            # Suspicious IP (external IPs are more suspicious)
            is_suspicious_ip = src_ip in self.EXTERNAL_IPS or src_ip in self.MALICIOUS_IPS

            # Track failed logins for burst detection
            is_burst_failure = False
            if is_failed:
                key = f"{username}_{src_ip}"
                if key not in self.failed_login_tracker:
                    self.failed_login_tracker[key] = []
                self.failed_login_tracker[key].append(timestamp)

                # Check for burst (3+ failures in 10 minutes)
                recent_failures = [
                    t for t in self.failed_login_tracker[key]
                    if (timestamp - t).total_seconds() < 600
                ]
                if len(recent_failures) >= 3:
                    is_burst_failure = True

            status = "FAIL" if is_failed else "SUCCESS"

            event = LoginEvent(
                username=username,
                src_ip=src_ip,
                status=status,
                timestamp=timestamp,
                device_id=device_id,
                auth_method=auth_method,
                is_burst_failure=is_burst_failure,
                is_suspicious_ip=is_suspicious_ip,
                is_admin=is_admin
            )
            events.append(event)

        # Inject brute-force attack if needed
        if should_brute_force:
            brute_user = random.choice(self.USERNAMES)
            brute_ip = random.choice(self.EXTERNAL_IPS)
            brute_device = random.choice(self.DEVICE_IDS)

            for j in range(15):  # 15 rapid failed attempts
                timestamp = datetime.now() - timedelta(minutes=random.randint(0, 10))
                event = LoginEvent(
                    username=brute_user,
                    src_ip=brute_ip,
                    status="FAIL",
                    timestamp=timestamp,
                    device_id=brute_device,
                    auth_method="password",
                    is_burst_failure=True,
                    is_suspicious_ip=True,
                    is_admin=(brute_user in self.ADMIN_USERS)
                )
                events.append(event)

            self.last_brute_force = datetime.now()
            logger.info(f"Injected brute-force attack targeting {brute_user} from {brute_ip}")

        db.add_all(events)
        db.commit()
        logger.info(f"Generated {len(events)} login events")
        return events

    def generate_firewall_events(self, db: Session) -> List[FirewallLog]:
        """Generate 100-300 firewall events with attack patterns."""
        num_events = random.randint(100, 300)
        events = []

        # Determine if we should inject port scan
        hours_since_last_scan = (datetime.now() - self.last_port_scan).total_seconds() / 3600
        should_port_scan = hours_since_last_scan >= 24

        for i in range(num_events):
            src_ip = random.choice(self.INTERNAL_IPS + self.EXTERNAL_IPS)
            dst_ip = random.choice(self.INTERNAL_IPS)
            port = random.choice(self.COMMON_PORTS + self.SUSPICIOUS_PORTS)
            protocol = random.choice(self.PROTOCOLS)
            action = "ALLOW" if random.random() < 0.7 else "DENY"
            timestamp = datetime.now() - timedelta(minutes=random.randint(0, 1800))

            # Flags
            is_port_scan = False
            is_lateral_movement = False
            is_malicious_range = src_ip in self.MALICIOUS_IPS
            is_connection_spike = random.random() < 0.05

            # Lateral movement (internal to internal on suspicious ports)
            if src_ip in self.INTERNAL_IPS and dst_ip in self.INTERNAL_IPS:
                if port in [3389, 445, 139] and random.random() < 0.1:
                    is_lateral_movement = True

            # Repeated denials from same IP (1-2 per day)
            if action == "DENY" and random.random() < 0.02:
                is_connection_spike = True

            event = FirewallLog(
                src_ip=src_ip,
                dst_ip=dst_ip,
                action=action,
                port=port,
                protocol=protocol,
                timestamp=timestamp,
                is_port_scan=is_port_scan,
                is_lateral_movement=is_lateral_movement,
                is_malicious_range=is_malicious_range,
                is_connection_spike=is_connection_spike
            )
            events.append(event)

        # Inject port scan if needed
        if should_port_scan:
            scanner_ip = random.choice(self.EXTERNAL_IPS)
            target_ip = random.choice(self.INTERNAL_IPS)

            for port in range(20, 100):  # Scan ports 20-99
                timestamp = datetime.now() - timedelta(seconds=random.randint(0, 300))
                event = FirewallLog(
                    src_ip=scanner_ip,
                    dst_ip=target_ip,
                    action="DENY",
                    port=port,
                    protocol="TCP",
                    timestamp=timestamp,
                    is_port_scan=True,
                    is_lateral_movement=False,
                    is_malicious_range=False,
                    is_connection_spike=True
                )
                events.append(event)

            self.last_port_scan = datetime.now()
            logger.info(f"Injected port scan from {scanner_ip} targeting {target_ip}")

        db.add_all(events)
        db.commit()
        logger.info(f"Generated {len(events)} firewall events")
        return events

    def generate_patch_levels(self, db: Session) -> List[PatchLevel]:
        """Generate or update patch level data for devices."""
        events = []

        # Check existing devices
        existing_devices = {pl.device_id for pl in db.query(PatchLevel).all()}

        for device_id in self.DEVICE_IDS:
            if device_id in existing_devices:
                # Update existing device (age patches)
                device = db.query(PatchLevel).filter(PatchLevel.device_id == device_id).first()
                
                # Randomly update some devices
                if random.random() < 0.3:
                    device.last_patch_date = date.today()
                    device.missing_critical = 0
                    device.missing_high = 0
                    device.update_failures = 0
                else:
                    # Age the patch date
                    if random.random() < 0.1:
                        days_old = random.randint(10, 30)
                        device.last_patch_date = date.today() - timedelta(days=days_old)
            else:
                # Create new device
                os_type = random.choice(self.OS_TYPES)
                is_unsupported = os_type in self.UNSUPPORTED_OS

                # 30% outdated
                if random.random() < 0.3:
                    days_old = random.randint(61, 365)
                    last_patch = date.today() - timedelta(days=days_old)
                else:
                    days_old = random.randint(0, 60)
                    last_patch = date.today() - timedelta(days=days_old)

                # missing_critical (8-10% of devices)
                missing_critical = 0
                if random.random() < 0.09:
                    missing_critical = random.randint(1, 5)

                # missing_high (15-20% of devices)
                missing_high = 0
                if random.random() < 0.175:
                    missing_high = random.randint(1, 10)

                # Update failures
                update_failures = 0
                if random.random() < 0.15:
                    update_failures = random.randint(1, 3)

                event = PatchLevel(
                    device_id=device_id,
                    os=os_type,
                    last_patch_date=last_patch,
                    missing_critical=missing_critical,
                    missing_high=missing_high,
                    update_failures=update_failures,
                    is_unsupported=is_unsupported
                )
                events.append(event)

        if events:
            db.add_all(events)
        db.commit()
        logger.info(f"Generated/updated {len(events)} patch level records")
        return events
