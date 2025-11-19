# Event Generation Fix Summary

## Problems Identified

The event generation was NOT running every 30 minutes as expected. Analysis of the logs revealed:

1. **Initial run took too long**: The first event generation cycle processed 434 events (63 login + 319 firewall + 52 patch) sequentially, taking much longer than 30 minutes.

2. **Scheduler was skipping runs**: APScheduler logged warnings about "missed" runs:
   - Run at 21:01:51 missed by ~9 minutes
   - Run at 23:01:51 missed by ~8 minutes  
   - Run at 00:31:51 missed by ~18 minutes

3. **Root cause**: When a job takes longer than the interval (30 minutes), APScheduler skips subsequent runs to prevent overlapping executions.

4. **SQLAlchemy thread-safety issue** (discovered during fix): SQLAlchemy sessions are not thread-safe. Using a single session across multiple threads causes errors like:
   - "This session is provisioning a new connection; concurrent operations are not permitted"
   - "Method 'commit()' can't be called here; method 'commit()' is already in progress"

## Changes Made

### 1. Scheduler Configuration (`backend/scheduler.py`)

Added these parameters to prevent job overlap and handle missed runs gracefully:

```python
scheduler.add_job(
    generate_and_dispatch_events,
    trigger=IntervalTrigger(minutes=30),
    id="event_generation",
    name="Generate and dispatch cybersecurity events",
    replace_existing=True,
    max_instances=1,        # Prevent overlapping executions
    coalesce=True,          # Combine multiple missed runs into one
    misfire_grace_time=300  # Allow up to 5 minutes grace for missed runs
)
```

### 2. Parallel Event Dispatching (`backend/event_dispatcher.py`)

Implemented parallel processing using `ThreadPoolExecutor` to dispatch events concurrently:

- `dispatch_login_events_parallel()` - Dispatch login events in parallel
- `dispatch_firewall_events_parallel()` - Dispatch firewall events in parallel  
- `dispatch_patch_events_parallel()` - Dispatch patch events in parallel

**Thread-safety solution**:
1. **Eager loading**: Convert SQLAlchemy objects to dictionaries before passing to threads (avoids lazy loading issues)
2. **Per-thread sessions**: Each worker thread creates its own database session via `_send_event_with_session()`
3. **Proper cleanup**: Sessions are closed in `finally` blocks to prevent connection leaks

**Configuration**: 
- Default: 10 concurrent workers
- Configurable via `DISPATCH_WORKERS` environment variable

**Expected improvement**: ~10x faster event processing (from 30+ minutes down to ~3-5 minutes)

### 3. Enhanced Logging

Added detailed timing logs to track performance:

```
=== Starting event generation cycle at 2025-11-19T00:00:00 ===
Dispatching 63 login events to agent (in parallel)...
Login events completed: 63/63 successful in 12.3s
...
=== Event generation cycle completed successfully in 180.5s (3.0 minutes) ===
```

### 4. Database Connection Test Script

Created `/workspace/test_db_connection.sh` to verify database connectivity and check event counts.

**Fixed command**: Use `from backend.database import engine` (not just `from database`)

## Testing Instructions

### 1. Restart the backend container to apply changes:

```bash
docker-compose restart backend
# OR if using docker compose v2:
docker compose restart backend
```

### 2. Monitor the logs to see the new timing information:

```bash
docker logs -f cyber-backend
```

You should see:
- Clear start/end timestamps for each cycle
- Timing for each event type (login, firewall, patch)
- Total cycle time in seconds and minutes
- Success/failure counts for each event type

### 3. Verify database connection:

```bash
./test_db_connection.sh
```

### 4. Verify events are being generated every 30 minutes:

Watch the logs for messages like:
```
=== Starting event generation cycle at [timestamp] ===
```

These should appear approximately every 30 minutes (or immediately after the previous cycle completes if it ran long).

## Expected Behavior

- **Normal operation**: Event generation completes in 3-5 minutes, next run starts 30 minutes after the previous run started.
- **If generation takes > 30 minutes**: The next run will start immediately after completion (no missed runs, thanks to `coalesce=True`).
- **Parallel processing**: Events are now dispatched 10 at a time instead of one-by-one.

## Monitoring Tips

Watch for these log patterns to confirm proper operation:

```bash
# See when cycles start
docker logs cyber-backend | grep "Starting event generation cycle"

# See total timing for each cycle
docker logs cyber-backend | grep "completed successfully in"

# Check for missed runs (should be minimal now)
docker logs cyber-backend | grep "missed by"
```

## Performance Tuning

If event generation is still too slow, you can increase parallelism:

Edit `docker-compose.yml` and add:
```yaml
services:
  backend:
    environment:
      - DISPATCH_WORKERS=20  # Increase from default 10
```

Then restart: `docker-compose restart backend`
