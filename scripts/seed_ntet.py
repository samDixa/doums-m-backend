import sys
import os
from sqlalchemy.orm import Session, sessionmaker
from sqlalchemy import create_engine

# Add parent directory to path to import app modules
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from app.core.config import settings
from app.core.database import Base, get_db
from app.models.course import Course, CourseModule, CourseLesson, CourseTest
from app.models.test import Test, Question, TestGroup, TestQuestion

def seed_ntet():
    # Use the same database URL as the app
    engine = create_engine(settings.DATABASE_URL)
    SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
    db = SessionLocal()

    try:
        # 1. Create Course
        ntet = db.query(Course).filter(Course.title == "NTET").first()
        if not ntet:
            ntet = Course(
                title="NTET",
                description="National Teachers Eligibility Test (Homoeopathy) preparation course.",
                subject="Homoeopathy",
                level="National",
                is_paid=False,
                is_active=True
            )
            db.add(ntet)
            db.commit()
            db.refresh(ntet)
            print(f"Created Course: {ntet.title}")

        # 2. Create Modules (Chapters)
        for i in range(1, 6):
            module_title = f"Physics Chapter {i}"
            module = db.query(CourseModule).filter(CourseModule.title == module_title, CourseModule.course_id == ntet.id).first()
            if not module:
                module = CourseModule(
                    course_id=ntet.id,
                    title=module_title,
                    sequence=i
                )
                db.add(module)
                db.commit()
                db.refresh(module)
                print(f"  Created Module: {module.title}")

            # 3. Create Lessons for each module
            # Lecture
            lesson_lecture = db.query(CourseLesson).filter(CourseLesson.title == f"Lecture {i}", CourseLesson.module_id == module.id).first()
            if not lesson_lecture:
                lesson_lecture = CourseLesson(
                    module_id=module.id,
                    title=f"Lecture {i}",
                    lesson_type="video",
                    content_url="https://example.com/videos/physics_ch1_lec1.mp4",
                    duration_seconds=4559, # 1:15:59
                    sequence=1,
                    is_preview=True
                )
                db.add(lesson_lecture)
                print(f"    Added Lesson: {lesson_lecture.title} (Video)")

            # Notes
            lesson_notes = db.query(CourseLesson).filter(CourseLesson.title == f"Notes {i}", CourseLesson.module_id == module.id).first()
            if not lesson_notes:
                lesson_notes = CourseLesson(
                    module_id=module.id,
                    title=f"Notes {i}",
                    lesson_type="pdf",
                    content_url="https://example.com/notes/physics_ch1.pdf",
                    sequence=2,
                    is_preview=False
                )
                db.add(lesson_notes)
                print(f"    Added Lesson: {lesson_notes.title} (PDF)")

            # 4. Create Mock Test for each module
            test_title = f"Physics Chapter {i} || Mock Test {i}"
            test = db.query(Test).filter(Test.title == test_title).first()
            if not test:
                test = Test(
                    title=test_title,
                    total_marks=100,
                    duration_seconds=3600,
                    is_active=True
                )
                db.add(test)
                db.commit()
                db.refresh(test)
                print(f"    Created Test: {test.title}")
            
            # Map test to course
            course_test = db.query(CourseTest).filter(CourseTest.course_id == ntet.id, CourseTest.test_id == test.id).first()
            if not course_test:
                course_test = CourseTest(
                    course_id=ntet.id,
                    test_id=test.id,
                    sequence=i
                )
                db.add(course_test)
                print(f"      Linked Test to Course")

        db.commit()
        print("Seeding completed successfully!")

    except Exception as e:
        db.rollback()
        print(f"Error during seeding: {e}")
    finally:
        db.close()

if __name__ == "__main__":
    seed_ntet()
