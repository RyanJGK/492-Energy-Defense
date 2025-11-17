"""Scheduler for running data generation every 30 minutes."""
import logging
import time
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
from .database import SessionLocal, init_db
from .data_generator import DataGenerator
from .event_dispatcher import EventDispatcher

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def generate_and_dispatch_events():
    """Generate new events and dispatch them to AI agent."""
    logger.info("Starting event generation cycle")
    
    db = SessionLocal()
    try:
        generator = DataGenerator()
        dispatcher = EventDispatcher(db)

        # Generate login events
        login_events = generator.generate_login_events(db)
        for event in login_events:
            dispatcher.dispatch_login_event(event)

        # Generate firewall events
        firewall_events = generator.generate_firewall_events(db)
        for event in firewall_events:
            dispatcher.dispatch_firewall_event(event)

        # Generate/update patch levels
        patch_events = generator.generate_patch_levels(db)
        for event in patch_events:
            dispatcher.dispatch_patch_event(event)

        logger.info("Event generation cycle completed successfully")

    except Exception as e:
        logger.error(f"Error in event generation cycle: {e}", exc_info=True)
    finally:
        db.close()


def start_scheduler():
    """Start the APScheduler to run every 30 minutes."""
    logger.info("Initializing database...")
    init_db()

    logger.info("Starting scheduler...")
    scheduler = BackgroundScheduler()
    
    # Run every 30 minutes
    scheduler.add_job(
        generate_and_dispatch_events,
        trigger=IntervalTrigger(minutes=30),
        id="event_generation",
        name="Generate and dispatch cybersecurity events",
        replace_existing=True
    )

    # Run immediately on startup
    scheduler.add_job(
        generate_and_dispatch_events,
        id="initial_generation",
        name="Initial event generation"
    )

    scheduler.start()
    logger.info("Scheduler started. Events will be generated every 30 minutes.")

    try:
        # Keep the main thread alive
        while True:
            time.sleep(60)
    except (KeyboardInterrupt, SystemExit):
        logger.info("Shutting down scheduler...")
        scheduler.shutdown()


if __name__ == "__main__":
    start_scheduler()
