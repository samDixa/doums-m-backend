from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Text, BigInteger
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base

class College(Base):
    __tablename__ = "colleges"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    city = Column(String(100))
    state = Column(String(100))
    country = Column(String(100))
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime(timezone=True), default=func.now())
    updated_at = Column(DateTime(timezone=True), default=func.now(), onupdate=func.now())

class EducationLevel(Base):
    __tablename__ = "education_levels"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=False, unique=True)

class Page(Base):
    __tablename__ = "pages"
    id = Column(BigInteger, primary_key=True, index=True)
    page_key = Column(String(200), unique=True, nullable=False)
    page_type = Column(String(50))
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())

class GlobalPageVisitor(Base):
    __tablename__ = "global_page_visitors"
    page_id = Column(BigInteger, ForeignKey("pages.id", ondelete="CASCADE"), primary_key=True)
    visitors_count = Column(Integer, nullable=False, default=0)
    last_visited_at = Column(DateTime)
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())

class PageUniqueVisitor(Base):
    __tablename__ = "page_unique_visitors"
    page_id = Column(BigInteger, ForeignKey("pages.id", ondelete="CASCADE"), primary_key=True)
    user_id = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    first_visited_at = Column(DateTime, default=func.now())

class UserPageVisit(Base):
    __tablename__ = "user_page_visits"
    id = Column(BigInteger, primary_key=True, index=True)
    user_id = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    page_id = Column(BigInteger, ForeignKey("pages.id", ondelete="CASCADE"), nullable=False)
    visited_at = Column(DateTime, default=func.now())
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())

class Article(Base):
    """Helper table since an explicit articles table wasn't in the dump but is required in DH Plan."""
    __tablename__ = "articles"
    id = Column(BigInteger, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    content = Column(Text, nullable=False)
    author_id = Column(BigInteger, ForeignKey("users.id", ondelete="SET NULL"))
    is_published = Column(Boolean, default=False)
    is_clinical_case = Column(Boolean, default=False)
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())
    
    author = relationship("User")
