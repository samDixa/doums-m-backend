from app.core.database import SessionLocal
from app.models.other import Article

db = SessionLocal()
articles = db.query(Article).all()
for a in articles:
    print(f"ID: {a.id}, Published: {a.is_published}, Clinical: {a.is_clinical_case}, Title: {a.title}")
db.close()
