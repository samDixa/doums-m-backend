from app.core.database import SessionLocal
from app.models.test import TestGroup, Test, Question, TestQuestion
import random

def seed_mock_tests():
    db = SessionLocal()
    try:
        # 1. Create Root Groups
        free_mock_root = db.query(TestGroup).filter(TestGroup.title == "Free Mock").first()
        if not free_mock_root:
            free_mock_root = TestGroup(title="Free Mock", sequence=1, is_active=True)
            db.add(free_mock_root)
            db.commit()
            db.refresh(free_mock_root)
            print("Created 'Free Mock' root group")

        paid_mock_root = db.query(TestGroup).filter(TestGroup.title == "Paid Mock").first()
        if not paid_mock_root:
            paid_mock_root = TestGroup(title="Paid Mock", sequence=2, is_active=True)
            db.add(paid_mock_root)
            db.commit()
            db.refresh(paid_mock_root)
            print("Created 'Paid Mock' root group")

        # 2. Add Series to Free Mock
        series_titles = [
            "AIAPGET Mock Test Series",
            "NTET 2025 Mock Test Series",
            "Abhyaas Set A : Homoeopathy Special",
            "Abhyaas Set B : Homoeopathy Special",
            "Abhyaas Set C : Homoeopathy Special"
        ]
        
        for i, title in enumerate(series_titles):
            series = db.query(TestGroup).filter(TestGroup.title == title, TestGroup.parent_id == free_mock_root.id).first()
            if not series:
                series = TestGroup(title=title, parent_id=free_mock_root.id, sequence=i+1, is_active=True)
                db.add(series)
                db.commit()
                db.refresh(series)
                print(f"Added series: {title}")

            # 3. Add Subjects/Categories to the series
            subjects = ["Pharmacy", "Organon", "Repertory", "Homoeopathic Materia Medica", "Practice of Medicine"]
            for j, sub_title in enumerate(subjects):
                subject_group = db.query(TestGroup).filter(TestGroup.title == sub_title, TestGroup.parent_id == series.id).first()
                if not subject_group:
                    subject_group = TestGroup(title=sub_title, parent_id=series.id, sequence=j+1, is_active=True)
                    db.add(subject_group)
                    db.commit()
                    db.refresh(subject_group)
                    print(f"  Added subject: {sub_title} to {title}")

                # 4. Add Mock Tests to the subject
                for k in range(1, 4):
                    test_title = f"{title} - {sub_title} - Mock {k}"
                    test = db.query(Test).filter(Test.title == test_title).first()
                    if not test:
                        test = Test(
                            title=test_title,
                            test_group_id=subject_group.id,
                            total_marks=400,
                            positive_marks=4,
                            negative_marks=1,
                            duration_seconds=3600,
                            is_paid=False,
                            is_active=True,
                            available_for_android=True
                        )
                        db.add(test)
                        db.commit()
                        db.refresh(test)
                        print(f"    Added test: {test_title}")

        print("Seeding of Mock Tests complete!")
    except Exception as e:
        print(f"Error seeding mock tests: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_mock_tests()
