"""Initialize feedback and whitelist tables."""
import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from backend.database import engine, Base
from backend.models import AnalystFeedback, WhitelistedIP, WhitelistedUser

def init_feedback_tables():
    """Create feedback and whitelist tables if they don't exist."""
    try:
        Base.metadata.create_all(bind=engine, tables=[
            AnalystFeedback.__table__,
            WhitelistedIP.__table__,
            WhitelistedUser.__table__
        ])
        print("✅ Feedback and whitelist tables initialized successfully")
    except Exception as e:
        print(f"❌ Error initializing tables: {e}")

if __name__ == "__main__":
    init_feedback_tables()
