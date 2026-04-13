import sys
import os
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.database import Base, engine
from app.models.home import Category, SubCategory, SubCategoryLecture, SubCategoryNote, SubCategoryTest
from app.models.user import User
from app.models.course import Course

def create_tables():
    print("Creating new tables...")
    try:
        # This will create tables for imported models if they do not exist
        Base.metadata.create_all(bind=engine)
        print("Success: Database tables created/verified.")
    except Exception as e:
        print(f"Error creating tables: {e}")

if __name__ == "__main__":
    create_tables()
