from app.core.database import SessionLocal
from app.models.home import Category, SubCategory, HomeBanner, HomeCategory, HomeFeaturedBatch
from app.models.course import Course
from app.models.test import Test, Question
from app.models.notification import Notification
from app.models.other import Article
import random

def seed_data():
    db = SessionLocal()
    try:
        # 1. Add Categories
        if db.query(Category).count() == 0:
            cat1 = Category(title="Academic", sequence=1)
            cat2 = Category(title="Clinical", sequence=2)
            db.add_all([cat1, cat2])
            db.commit()
            print("Categories seeded")

        # 2. Add Subcategories
        if db.query(SubCategory).count() == 0:
            academic = db.query(Category).filter(Category.title == "Academic").first()
            if academic:
                sc1 = SubCategory(category_id=academic.id, title="Anatomy", icon="anatomy_icon", sequence=1)
                sc2 = SubCategory(category_id=academic.id, title="Physiology", icon="physio_icon", sequence=2)
                db.add_all([sc1, sc2])
                db.commit()
                print("Subcategories seeded")

        # 3. Add Banners
        if db.query(HomeBanner).count() == 0:
            b1 = HomeBanner(image_url="https://img.freepik.com/free-vector/medical-healthcare-banner-template_23-2148906520.jpg", sequence=1)
            db.add(b1)
            db.commit()
            print("Banners seeded")

        # 4. Add Course and Featured Batch
        if db.query(Course).count() == 0:
            c1 = Course(
                id=1,
                title="NEET PG 2026 Ultimate Batch",
                subtitle="Complete Preparation",
                description="Comprehensive course for NEET PG aspirants",
                batch_image="https://img.freepik.com/free-vector/online-medical-course-concept_23-2148530374.jpg",
                price=2499,
                is_active=True
            )
            db.add(c1)
            db.commit()
            db.refresh(c1)
            
            fb1 = HomeFeaturedBatch(course_id=c1.id, sequence=1, is_active=True)
            db.add(fb1)
            db.commit()
            print("Course and Featured Batch seeded")

        # 5. Add Home Categories
        if db.query(HomeCategory).count() == 0:
            hc1 = HomeCategory(title="Mock Tests", icon="quiz", navigation_target="TEST_SECTION", sequence=1)
            hc2 = HomeCategory(title="Previous Papers", icon="history", navigation_target="PAPER_SECTION", sequence=2)
            db.add_all([hc1, hc2])
            db.commit()
            print("Home Categories seeded")

        # 6. Add Notifications
        if db.query(Notification).count() == 0:
            n1 = Notification(id=1, title="New Course Launched!", message="Enroll now in the NEET PG Ultimate Batch.", type="in_app", is_global=True, reference_type="global", reference_id=0)
            db.add(n1)
            db.commit()
            print("Notifications seeded")

        # 7. Add Articles
        if db.query(Article).count() == 0:
            a1 = Article(id=1, title="Benefits of Homeopathy in 2026", content="Homeopathy continues to grow...", is_published=True)
            db.add(a1)
            db.commit()
            print("Articles seeded")

        print("Seeding complete successfully!")
    except Exception as e:
        print(f"Error seeding: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_data()
