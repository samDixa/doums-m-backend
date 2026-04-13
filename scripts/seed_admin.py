import sys
import os

# Add the project root to sys.path
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))

from sqlalchemy.orm import Session
from app.core.database import SessionLocal, engine, Base
from app.models.user import User, UserCredential
from app.core.security import get_password_hash

def seed_admin():
    # Ensure tables exist
    Base.metadata.create_all(bind=engine)
    db = SessionLocal()
    try:
        # Check if user already exists
        admin_email = "admin@domus.com"
        admin_password = "adminpassword123"
        
        user = db.query(User).filter(User.email == admin_email).first()
        if not user:
            print(f"Creating admin user: {admin_email}")
            user = User(
                first_name="Admin",
                last_name="System",
                email=admin_email,
                mobile="0000000000",
                district="Main",
                state="Main",
                country="India"
            )
            db.add(user)
            db.commit()
            db.refresh(user)
            
            credential = UserCredential(
                user_id=user.id,
                hashed_password=get_password_hash(admin_password),
                is_superuser=True
            )
            db.add(credential)
            db.commit()
            print("Admin user created successfully.")
        else:
            print(f"User {admin_email} already exists.")
            # Ensure it's a superuser
            if not user.credential:
                credential = UserCredential(
                    user_id=user.id,
                    hashed_password=get_password_hash(admin_password),
                    is_superuser=True
                )
                db.add(credential)
                db.commit()
            else:
                user.credential.is_superuser = True
                db.commit()
            print("Admin permissions verified.")
            
    except Exception as e:
        print(f"Error seeding admin: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    seed_admin()
