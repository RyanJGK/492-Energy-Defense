"""Scheduler for running data generation every 30 minutes."""
import logging
import time
from datetime import datetime
from apscheduler.schedulers.background import BackgroundScheduler
from apscheduler.triggers.interval import IntervalTrigger
from .database import SessionLocal, init_db
from .data_generator import DataGenerator
from .event_dispatcher import EventDispatcher

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


def generate_and_dispatch_events():
    """Generate new events and dispatch them to AI agent."""
    start_time = datetime.now()
    logger.info(f"=== Starting event generation cycle at {start_time.isoformat()} ===")
    
    db = SessionLocal()
    try:
        generator = DataGenerator()
        dispatcher = EventDispatcher(db)

        # Generate login events
        login_start = datetime.now()
        login_events = generator.generate_login_events(db)
        logger.info(f"Dispatching {len(login_events)} login events to agent (in parallel)...")
        successful = dispatcher.dispatch_login_events_parallel(login_events)
        logger.info(f"Login events completed: {successful}/{len(login_events)} successful in {(datetime.now() - login_start).total_seconds():.1f}s")

        # Generate firewall events
        firewall_start = datetime.now()
        firewall_events = generator.generate_firewall_events(db)
        logger.info(f"Dispatching {len(firewall_events)} firewall events to agent (in parallel)...")
        successful = dispatcher.dispatch_firewall_events_parallel(firewall_events)
        logger.info(f"Firewall events completed: {successful}/{len(firewall_events)} successful in {(datetime.now() - firewall_start).total_seconds():.1f}s")

        # Generate/update patch levels
        patch_start = datetime.now()
        patch_events = generator.generate_patch_levels(db)
        logger.info(f"Dispatching {len(patch_events)} patch events to agent (in parallel)...")
        successful = dispatcher.dispatch_patch_events_parallel(patch_events)
        logger.info(f"Patch events completed: {successful}/{len(patch_events)} successful in {(datetime.now() - patch_start).total_seconds():.1f}s")

        total_time = (datetime.now() - start_time).total_seconds()
        logger.info(f"=== Event generation cycle completed successfully in {total_time:.1f}s ({total_time/60:.1f} minutes) ===")

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
    # Set max_instances=1 to prevent overlapping jobs
    # Set coalesce=True to combine missed runs into one execution
    scheduler.add_job(
        generate_and_dispatch_events,
        trigger=IntervalTrigger(minutes=30),
        id="event_generation",
        name="Generate and dispatch cybersecurity events",
        replace_existing=True,
        max_instances=1,  # Prevent overlapping executions
        coalesce=True,    # Combine multiple missed runs into one
        misfire_grace_time=300  # Allow up to 5 minutes grace for missed runs
    )

    # Run immediately on startup
    scheduler.add_job(
        generate_and_dispatch_events,
        id="initial_generation",
        name="Initial event generation"
    )

    scheduler.start()
    logger.info("Scheduler started. Events will be generated every 30 minutes.")
    logger.info("Note: If event generation takes longer than 30 minutes, the next run will be delayed.")

    try:
        # Keep the main thread alive
        while True:
            time.sleep(60)
    except (KeyboardInterrupt, SystemExit):
        logger.info("Shutting down scheduler...")
        scheduler.shutdown()


if __name__ == "__main__":
    start_scheduler()
