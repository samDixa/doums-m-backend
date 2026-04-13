from sqlalchemy import Column, Integer, String, Boolean, DateTime, Date, ForeignKey, Numeric, Text, BigInteger
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base

class Course(Base):
    __tablename__ = "courses"

    id = Column(BigInteger, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    subtitle = Column(String(255)) # e.g. "Complete batch"
    description = Column(Text)
    subject = Column(String(200))
    level = Column(String(50))
    is_paid = Column(Boolean, default=False)
    price = Column(Numeric(8, 2))
    discount_percentage = Column(Numeric(4, 2), default=0.0)
    is_new = Column(Boolean, default=False)
    start_date = Column(Date)
    end_date = Column(Date)
    batch_image = Column(Text) # URL for the logo/image on the card
    whatsapp_url = Column(Text)
    info_url = Column(Text)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())
    
    modules = relationship("CourseModule", back_populates="course", cascade="all, delete-orphan")
    course_tests = relationship("CourseTest", back_populates="course", cascade="all, delete-orphan")
    tests = relationship("Test", secondary="course_tests", viewonly=True)

class CourseModule(Base):
    __tablename__ = "course_modules"

    id = Column(BigInteger, primary_key=True, index=True)
    course_id = Column(BigInteger, ForeignKey("courses.id", ondelete="CASCADE"), nullable=False)
    title = Column(String(255), nullable=False)
    sequence = Column(Integer, nullable=False)
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())
    
    course = relationship("Course", back_populates="modules")
    lessons = relationship("CourseLesson", back_populates="module", cascade="all, delete-orphan")

class CourseLesson(Base):
    __tablename__ = "course_lessons"

    id = Column(BigInteger, primary_key=True, index=True)
    module_id = Column(BigInteger, ForeignKey("course_modules.id", ondelete="CASCADE"), nullable=False)
    title = Column(String(255), nullable=False)
    lesson_type = Column(String(50), nullable=False) # e.g. video, doc, pdf
    content_url = Column(Text, nullable=False)
    duration_seconds = Column(Integer)
    sequence = Column(Integer, nullable=False)
    is_preview = Column(Boolean, default=False)
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())
    
    module = relationship("CourseModule", back_populates="lessons")

class CourseTest(Base):
    __tablename__ = "course_tests"
    
    course_id = Column(BigInteger, ForeignKey("courses.id", ondelete="CASCADE"), primary_key=True)
    test_id = Column(BigInteger, ForeignKey("tests.id", ondelete="CASCADE"), primary_key=True)
    sequence = Column(Integer)
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())
    
    course = relationship("Course", back_populates="course_tests")

class UserCourse(Base):
    __tablename__ = "user_courses"

    user_id = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    course_id = Column(BigInteger, ForeignKey("courses.id", ondelete="CASCADE"), primary_key=True)
    enrolled_at = Column(DateTime, default=func.now())
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())

class UserLessonProgress(Base):
    __tablename__ = "user_lesson_progress"

    user_id = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    lesson_id = Column(BigInteger, ForeignKey("course_lessons.id", ondelete="CASCADE"), primary_key=True)
    last_position = Column(Integer)
    completed = Column(Boolean, default=False)
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())
