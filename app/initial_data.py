from sqlalchemy.orm import Session
from app.core.database import SessionLocal
from app.models.user import User, UserCredential
from app.core.security import get_password_hash
import logging

logger = logging.getLogger(__name__)

def init_db():
    db = SessionLocal()
    try:
        # Define admin credentials
        admin_email = "admin@domus.com"
        admin_password = "adminpassword123"
        
        # Check if user already exists
        user = db.query(User).filter(User.email == admin_email).first()
        if not user:
            logger.info(f"Bootstrapping admin user: {admin_email}")
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
            logger.info("Admin user bootstrapped successfully.")
        else:
            logger.info(f"Admin user {admin_email} already exists. Verifying permissions.")
            # Ensure it's a superuser and has credentials
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
            logger.info("Admin permissions verified.")
            
    except Exception as e:
        logger.error(f"Error bootstrapping admin: {e}")
        db.rollback()
    finally:
        db.close()

if __name__ == "__main__":
    init_db()
