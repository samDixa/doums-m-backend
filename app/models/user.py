from sqlalchemy import Column, Integer, String, Boolean, DateTime, Date, ForeignKey, JSON
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base

class User(Base):
    __tablename__ = "users"
    
    id = Column(Integer, primary_key=True, index=True)
    first_name = Column(String(50))
    last_name = Column(String(50))
    name_prefix = Column(String(10))
    email = Column(String(100), unique=True, index=True)
    mobile = Column(String(20), unique=True, index=True)
    district = Column(String(50))
    state = Column(String(50))
    country = Column(String(50))
    work_experience = Column(JSON)
    dob = Column(Date) 
    gender = Column(String(20))
    category = Column(String(50))  # Medical Student / Medical Professional
    designation = Column(String(100))
    batch = Column(String(100))
    ug_college_state = Column(String(100))
    ug_college_name = Column(String(255))
    profile_image = Column(String(255))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now())
    
    credential = relationship("UserCredential", back_populates="user", uselist=False, cascade="all, delete-orphan")
    educations = relationship("UserEducation", back_populates="user", cascade="all, delete-orphan")
    interests = relationship("UserInterest", back_populates="user", cascade="all, delete-orphan")
    activities = relationship("UserActivity", back_populates="user", cascade="all, delete-orphan")
    # Add other relationships as needed

class UserCredential(Base):
    __tablename__ = "user_credentials"
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    hashed_password = Column(String(255), nullable=False)
    is_superuser = Column(Boolean, default=False)
    
    user = relationship("User", back_populates="credential")

class UserEducation(Base):
    __tablename__ = "user_education"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    education_level_id = Column(Integer, ForeignKey("education_levels.id", ondelete="SET NULL"))
    college_id = Column(Integer, ForeignKey("colleges.id", ondelete="SET NULL"))
    degree_name = Column(String(500))
    start_date = Column(Date, nullable=False)
    end_date = Column(Date)
    is_current = Column(Boolean, default=False)
    
    user = relationship("User", back_populates="educations")
    # Assuming education_levels and colleges are defined in another file, you can reference them by string

class UserInterest(Base):
    __tablename__ = "user_interests"
    
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    interest = Column(String(100), primary_key=True)
    
    user = relationship("User", back_populates="interests")

class OTPVerification(Base):
    __tablename__ = "otp_verifications"
    
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String(100), index=True)
    mobile = Column(String(20), index=True)
    otp_code = Column(String(10), nullable=False)
    expires_at = Column(DateTime, nullable=False)
    is_verified = Column(Boolean, default=False)
    created_at = Column(DateTime, default=func.now())

class UserActivity(Base):
    __tablename__ = "user_activities"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    activity_type = Column(String(100), nullable=False) # e.g., 'LOGIN', 'COURSE_ENROLL', 'TEST_START'
    description = Column(String(500))
    metadata_json = Column(JSON) # Additional context (e.g., course_id, test_id)
    created_at = Column(DateTime, default=func.now())
    
    user = relationship("User", back_populates="activities")
