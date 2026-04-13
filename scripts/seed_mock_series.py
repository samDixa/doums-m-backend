import sys
import os
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy import create_engine

# Add parent directory to path to import app modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.config import settings
from app.models.test import Test, Question, TestGroup, TestQuestion

def seed_mock_series():
    engine = create_engine(settings.DATABASE_URL)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()

    try:
        # 1. Create Top-Level Groups if they don't exist
        for group_title in ["Free Mock", "Paid Mock"]:
            group = db.query(TestGroup).filter(TestGroup.title == group_title, TestGroup.parent_id == None).first()
            if not group:
                group = TestGroup(title=group_title, is_active=True, sequence=1 if "Free" in group_title else 2)
                db.add(group)
                db.commit()
                db.refresh(group)
                print(f"Created Root Group: {group.title}")

            # 2. Create sub-series for "Free Mock"
            if group_title == "Free Mock":
                series_data = [
                    ("AIAPGET Mock Test Series", "assets/icons/domus/paid_mock.png"),
                    ("NTET 2025 Mock Test Series", "assets/icons/domus/ntet.png"),
                    ("Abhyaas Set A : Homoeopathy Special", "assets/icons/domus/hmm.png"),
                ]
                
                for title, icon in series_data:
                    series = db.query(TestGroup).filter(TestGroup.title == title, TestGroup.parent_id == group.id).first()
                    if not series:
                        series = TestGroup(title=title, parent_id=group.id, is_active=True)
                        db.add(series)
                        db.commit()
                        db.refresh(series)
                        print(f"  Created Series: {series.title}")

                    # 3. Create categories for each series (e.g., Anatomy, Physiology)
                    categories = ["Pharmacy", "Organon", "Repertory"] if "AIAPGET" in title else ["Anatomy", "Physiology"]
                    for cat_title in categories:
                        cat = db.query(TestGroup).filter(TestGroup.title == cat_title, TestGroup.parent_id == series.id).first()
                        if not cat:
                            cat = TestGroup(title=cat_title, parent_id=series.id, is_active=True)
                            db.add(cat)
                            db.commit()
                            db.refresh(cat)
                            print(f"    Created Category: {cat.title}")

                        # 4. Create Tests for each category
                        for i in range(1, 4):
                            test_title = f"{title} - {cat_title} - Mock {i}"
                            test = db.query(Test).filter(Test.title == test_title).first()
                            if not test:
                                test = Test(
                                    title=test_title,
                                    test_group_id=cat.id,
                                    total_marks=400,
                                    duration_seconds=3600,
                                    positive_marks=4,
                                    negative_marks=1,
                                    is_active=True,
                                    test_image=icon # Storing icon path in test_image for now
                                )
                                db.add(test)
                                print(f"      Created Test: {test.title}")

        db.commit()
        print("Mock series seeding completed successfully!")

    except Exception as e:
        db.rollback()
        print(f"Error during seeding: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    seed_mock_series()
