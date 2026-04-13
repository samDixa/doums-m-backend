import sys
import os
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy import create_engine

# Add parent directory to path to import app modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.config import settings
from app.models.home import HomeCategory
from app.core.database import Base

def seed_home_categories():
    engine = create_engine(settings.DATABASE_URL)
    # Ensure tables are created
    Base.metadata.create_all(bind=engine)
    
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()

    try:
        categories_data = [
            {
                "title": "NTET",
                "icon": "assets/icons/domus/ntet.png",
                "filter_categories": ["Exam"],
                "navigation_target": "NTET_SCREEN",
                "sequence": 1
            },
            {
                "title": "Entrance",
                "icon": "assets/icons/domus/entrance.png",
                "filter_categories": ["Exam"],
                "navigation_target": "ENTRANCE_SCREEN",
                "sequence": 2
            },
            {
                "title": "Subject Wise MCQ",
                "icon": "assets/icons/domus/subject_mcq.png",
                "filter_categories": ["Exam", "Study"],
                "navigation_target": "SUBJECT_MCQ_SCREEN",
                "sequence": 3
            },
            {
                "title": "Medicos Corner",
                "icon": "assets/icons/domus/medicos_corner.png",
                "filter_categories": ["Community"],
                "navigation_target": "COMMUNITY_SCREEN",
                "sequence": 4
            },
            {
                "title": "Paid Mock",
                "icon": "assets/icons/domus/paid_mock.png",
                "filter_categories": ["Exam"],
                "navigation_target": "PAID_MOCK_SCREEN",
                "sequence": 5
            },
            {
                "title": "Study Notes",
                "icon": "assets/icons/domus/study_notes.png",
                "filter_categories": ["Study"],
                "navigation_target": "STUDY_NOTES_SCREEN",
                "sequence": 6
            },
            {
                "title": "HMM",
                "icon": "assets/icons/domus/hmm.png",
                "filter_categories": ["Study", "Revision"],
                "navigation_target": "HMM_SCREEN",
                "sequence": 7
            },
            {
                "title": "Aphorism",
                "icon": "assets/icons/domus/aphorism.png",
                "filter_categories": ["Study", "Revision"],
                "navigation_target": "APHORISM_SCREEN",
                "sequence": 8
            },
            {
                "title": "OP",
                "icon": "assets/icons/domus/op.png",
                "filter_categories": ["Study"],
                "navigation_target": "OP_SCREEN",
                "sequence": 9
            },
            {
                "title": "Therapeutics",
                "icon": "assets/icons/domus/therapeutics.png",
                "filter_categories": ["Study"],
                "navigation_target": "THERAPEUTICS_SCREEN",
                "sequence": 10
            },
        ]

        for data in categories_data:
            category = db.query(HomeCategory).filter(HomeCategory.title == data["title"]).first()
            if not category:
                category = HomeCategory(**data)
                db.add(category)
                print(f"Created Home Category: {category.title}")
            else:
                # Update existing
                for key, value in data.items():
                    setattr(category, key, value)
                print(f"Updated Home Category: {category.title}")

        db.commit()
        print("Home categories seeding completed successfully!")

    except Exception as e:
        db.rollback()
        print(f"Error during seeding: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    seed_home_categories()
