from sqlalchemy import Column, Integer, String, Boolean, JSON, ForeignKey, DateTime, BigInteger
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base

class Category(Base):
    __tablename__ = "categories"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    sequence = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=func.now())
    
    sub_categories = relationship("SubCategory", back_populates="category", cascade="all, delete-orphan")

class SubCategory(Base):
    __tablename__ = "sub_categories"

    id = Column(Integer, primary_key=True, index=True)
    category_id = Column(Integer, ForeignKey("categories.id", ondelete="CASCADE"), nullable=False)
    title = Column(String, nullable=False)
    icon = Column(String, nullable=False)
    sequence = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=func.now())
    
    category = relationship("Category", back_populates="sub_categories")
    lectures = relationship("SubCategoryLecture", back_populates="sub_category", cascade="all, delete-orphan")
    notes = relationship("SubCategoryNote", back_populates="sub_category", cascade="all, delete-orphan")
    tests = relationship("SubCategoryTest", back_populates="sub_category", cascade="all, delete-orphan")

class SubCategoryLecture(Base):
    __tablename__ = "sub_category_lectures"

    id = Column(Integer, primary_key=True, index=True)
    sub_category_id = Column(Integer, ForeignKey("sub_categories.id", ondelete="CASCADE"), nullable=False)
    title = Column(String, nullable=False)
    video_url = Column(String, nullable=False)
    sequence = Column(Integer, default=0)
    created_at = Column(DateTime, default=func.now())
    
    sub_category = relationship("SubCategory", back_populates="lectures")

class SubCategoryNote(Base):
    __tablename__ = "sub_category_notes"

    id = Column(Integer, primary_key=True, index=True)
    sub_category_id = Column(Integer, ForeignKey("sub_categories.id", ondelete="CASCADE"), nullable=False)
    title = Column(String, nullable=False)
    pdf_url = Column(String, nullable=False)
    sequence = Column(Integer, default=0)
    created_at = Column(DateTime, default=func.now())
    
    sub_category = relationship("SubCategory", back_populates="notes")

class SubCategoryTest(Base):
    __tablename__ = "sub_category_tests"

    id = Column(Integer, primary_key=True, index=True)
    sub_category_id = Column(Integer, ForeignKey("sub_categories.id", ondelete="CASCADE"), nullable=False)
    test_id = Column(Integer, ForeignKey("tests.id", ondelete="CASCADE"), nullable=False)
    sequence = Column(Integer, default=0)
    created_at = Column(DateTime, default=func.now())
    
    sub_category = relationship("SubCategory", back_populates="tests")

# Keeping legacy HomeCategory for backward compatibility during migration
class HomeCategory(Base):
    __tablename__ = "home_categories"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, nullable=False)
    icon = Column(String, nullable=False)
    filter_categories = Column(JSON, default=[])
    navigation_target = Column(String, nullable=False)
    navigation_args = Column(JSON, default={})
    sequence = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)

class HomeBanner(Base):
    __tablename__ = "home_banners"

    id = Column(Integer, primary_key=True, index=True)
    image_url = Column(String, nullable=False)
    navigation_target = Column(String, nullable=True) # e.g. "COURSE_1", "TEST_2"
    navigation_args = Column(JSON, default={})
    sequence = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)

class HomeFeaturedBatch(Base):
    __tablename__ = "home_featured_batches"

    id = Column(Integer, primary_key=True, index=True)
    course_id = Column(BigInteger, ForeignKey("courses.id", ondelete="CASCADE"), nullable=False)
    sequence = Column(Integer, default=0)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=func.now())

    course = relationship("Course")
