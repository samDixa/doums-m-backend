from sqlalchemy.orm import Session
from app.core.database import SessionLocal
from app.models.other import Article
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def seed_articles():
    db = SessionLocal()
    try:
        # Check if articles already exist
        article_count = db.query(Article).count()
        if article_count > 0:
            logger.info(f"Articles exist already ({article_count}). Exiting.")
            return

        logger.info("Seeding dummy Doctor's Writings (Articles)...")
        dummy_articles = [
            Article(
                title="The Future of Homoeopathy",
                content="Homoeopathy continues to grow as an alternative form of medicine worldwide. This article discusses its future prospects...",
                is_published=True,
                is_clinical_case=False
            ),
            Article(
                title="Case Study: Chronic Migraines",
                content="A detailed clinical case analyzing the treatment of chronic migraines using individualized remedies...",
                is_published=True,
                is_clinical_case=True
            ),
            Article(
                title="Understanding Materia Medica",
                content="Materia Medica is the core of homoeopathic prescribing. Here's a deep dive into the polycrest remedies...",
                is_published=True,
                is_clinical_case=False
            ),
            Article(
                title="Pediatric Prescribing Guidelines",
                content="Treating children requires a sensitive approach to symptom gathering. A guide for new practitioners...",
                is_published=True,
                is_clinical_case=False
            )
        ]

        db.add_all(dummy_articles)
        db.commit()
        logger.info("Successfully seeded dummy articles!")
    except Exception as e:
        logger.error(f"Error seeding articles: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_articles()
