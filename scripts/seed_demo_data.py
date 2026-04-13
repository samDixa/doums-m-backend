import sys
import os
import random

# Add the project root to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy.orm import Session
from app.core.database import SessionLocal, engine, Base
from app.models.user import User, UserCredential
from app.models.course import Course, CourseModule, CourseLesson
from app.models.test import Test, Question
from app.models.notification import Notification
from app.core.security import get_password_hash

def seed_data():
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        print("Seeding dummy data for demonstration...")

        # 1. Seed Courses
        courses_data = [
            ("Human Anatomy & Physiology", "Comprehensive guide to human structure and function."),
            ("Biochemistry Essentials", "Core concepts in medical biochemistry."),
            ("Pharmacology 101", "Introduction to drug mechanisms and clinical use."),
            ("Medical Ethics", "Principles of ethical decision making in healthcare."),
            ("Clinical Pathology", "Diagnostic medicine and disease mechanisms."),
            ("Neuroscience", "Deep dive into the nervous system."),
            ("Microbiology", "Study of medically relevant microorganisms."),
            ("Immunology", "Complexities of the human immune system."),
            ("Emergency Medicine", "Rapid response and critical care fundamentals."),
            ("Surgical Principles", "Introduction to operative techniques and safety.")
        ]

        for title, desc in courses_data:
            course = db.query(Course).filter(Course.title == title).first()
            if not course:
                course = Course(title=title, description=desc, price=random.randint(499, 2999), is_active=True)
                db.add(course)
                db.flush()
                
                # Add 2-3 modules per course
                for i in range(1, random.randint(3, 5)):
                    module = CourseModule(course_id=course.id, title=f"Module {i}: Advanced Topics", sequence=i)
                    db.add(module)
                    db.flush()
                    
                    # Add lessons
                    for j in range(1, random.randint(3, 6)):
                        lesson = CourseLesson(
                            module_id=module.id, 
                            title=f"Lesson {j}: Detailed Analysis", 
                            lesson_type="video",
                            content_url="https://example.com/demo.mp4",
                            sequence=j,
                            duration_seconds=random.randint(300, 1800)
                        )
                        db.add(lesson)

        # 2. Seed Tests
        tests_data = ["Internal Medicine Final", "Anatomy Midterm", "Pharmacology Quiz", "Surgical Skills Test", "Bio Ethics Exam"]
        for title in tests_data:
            test = db.query(Test).filter(Test.title == title).first()
            if not test:
                test = Test(title=title, is_active=True, duration_seconds=random.randint(1800, 5400))
                db.add(test)
                db.flush()
                
                # Add Questions
                for i in range(1, 11):
                    q = Question(
                        question_text=f"Sample Medical Question {i}?",
                        option_a="Option A (Correct)",
                        option_b="Option B",
                        option_c="Option C",
                        option_d="Option D",
                        correct_option="A",
                        description="Correct because medical logic."
                    )
                    db.add(q)


        # 3. Seed Students
        for i in range(1, 51):
            email = f"student{i}@example.com"
            if not db.query(User).filter(User.email == email).first():
                user = User(
                    first_name=f"Student",
                    last_name=str(i),
                    email=email,
                    mobile=f"999999{i:04d}",
                    district="Sample City",
                    state="Sample State",
                    country="India"
                )
                db.add(user)
                db.flush()
                
                credential = UserCredential(
                    user_id=user.id,
                    hashed_password=get_password_hash("password123"),
                    is_superuser=False
                )
                db.add(credential)

        # 4. Seed Notifications
        for i in range(1, 21):
            n = Notification(
                title=f"Platform Update {i}",
                message=f"Transmission {i}: New medical resources added to the database.",
                type="in_app",
                is_global=True,
                reference_id=0
            )
            db.add(n)

        db.commit()
        print("Full demo data seeded successfully.")
    except Exception as e:
        print(f"Error seeding data: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_data()
