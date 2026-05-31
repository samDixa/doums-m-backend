from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Numeric, Text, BigInteger, JSON
from sqlalchemy.orm import relationship, backref
from sqlalchemy.sql import func
from app.core.database import Base

class TestGroup(Base):
    __tablename__ = "test_groups"

    id = Column(Integer, primary_key=True, index=True)
    parent_id = Column(Integer, ForeignKey("test_groups.id"))
    title = Column(String, nullable=False)
    description = Column(Text)
    price = Column(Numeric(8, 2), default=0.0)
    image = Column(Text)
    sequence = Column(Integer)
    is_active = Column(Boolean, default=True, nullable=False)

    children = relationship("TestGroup", backref=backref("parent", remote_side="TestGroup.id"), lazy="joined")
    tests = relationship("Test", back_populates="group")

class Test(Base):
    __tablename__ = "tests"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, unique=True, nullable=False)
    test_group_id = Column(Integer, ForeignKey("test_groups.id", ondelete="SET NULL"))
    available_for_web = Column(Boolean, default=False)
    available_for_android = Column(Boolean, default=False)
    available_for_ios = Column(Boolean, default=False)
    total_marks = Column(Integer)
    is_discounted = Column(Boolean, default=False)
    discount_percentage = Column(Numeric(4, 2))
    is_paid = Column(Boolean, default=False)
    price = Column(Numeric(8, 2), default=0.0)
    is_active = Column(Boolean, default=False)
    negative_marks = Column(Integer)
    positive_marks = Column(Integer)
    reattempt_allowed = Column(Boolean, default=True)
    duration_seconds = Column(Integer)
    is_featured = Column(Boolean, default=False)
    test_image = Column(Text)
    total_attempts = Column(Integer, default=0)
    average_rating = Column(Numeric(3, 2))
    people_rated = Column(Integer, default=0)
    valid_from = Column(DateTime(timezone=True), default=func.now())
    valid_till = Column(DateTime(timezone=True))
    created_at = Column(DateTime(timezone=True), default=func.now())
    updated_at = Column(DateTime(timezone=True), default=func.now(), onupdate=func.now())
    
    group = relationship("TestGroup", back_populates="tests")
    questions = relationship("TestQuestion", back_populates="test", cascade="all, delete-orphan")

class Question(Base):
    __tablename__ = "questions"

    id = Column(Integer, primary_key=True, index=True)
    question_text = Column(Text, nullable=False)
    option_a = Column(Text, nullable=False)
    option_b = Column(Text, nullable=False)
    option_c = Column(Text, nullable=False)
    option_d = Column(Text, nullable=False)
    description = Column(Text)
    is_active = Column(Boolean, default=True, nullable=False)
    subject = Column(String(200))
    topic = Column(String(200))
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())

    # Correct option logic isn't explicitly defined in DB from the dump, so it's probably missing or implied in description/tags.
    # To make MCQs work we ideally need a 'correct_option' field. Let's add it.
    correct_option = Column(String(1), nullable=False, default="A") # (A, B, C, D) 
    # Or daily mcq flag
    is_daily_mcq = Column(Boolean, default=False)

class TestQuestion(Base):
    __tablename__ = "test_questions"

    id = Column(Integer, primary_key=True, index=True)
    test_id = Column(BigInteger, ForeignKey("tests.id", ondelete="CASCADE"), nullable=False)
    question_id = Column(BigInteger, ForeignKey("questions.id"), nullable=False)
    sequence = Column(Integer)

    test = relationship("Test", back_populates="questions")
    question = relationship("Question")

class TestCategory(Base):
    __tablename__ = "test_categories"

    id = Column(Integer, primary_key=True, index=True)
    code = Column(String, unique=True, nullable=False)
    label = Column(String, nullable=False)

class TestCategoryMap(Base):
    __tablename__ = "test_categories_map"

    test_id = Column(BigInteger, ForeignKey("tests.id", ondelete="CASCADE"), primary_key=True)
    test_category_id = Column(BigInteger, ForeignKey("test_categories.id", ondelete="CASCADE"), primary_key=True)

class TestAttempt(Base):
    __tablename__ = "test_attempts"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    test_id = Column(BigInteger, ForeignKey("tests.id"), nullable=False)
    attempt_number = Column(Integer, nullable=False)
    started_at = Column(DateTime, nullable=False, default=func.now())
    submitted_at = Column(DateTime)
    time_taken_seconds = Column(Integer)
    score = Column(Integer, nullable=False, default=0)
    accuracy = Column(Numeric(5, 2), nullable=False, default=0.0)
    rank = Column(Integer)
    percentile = Column(Numeric(5, 2))

    user_answers = relationship("UserAnswer", back_populates="attempt", cascade="all, delete-orphan")
    test = relationship("Test")
    user = relationship("User")

class UserAnswer(Base):
    __tablename__ = "user_answers"

    id = Column(Integer, primary_key=True, index=True)
    test_attempt_id = Column(BigInteger, ForeignKey("test_attempts.id", ondelete="CASCADE"), nullable=False)
    question_id = Column(BigInteger, ForeignKey("questions.id"), nullable=False)
    selected_option_id = Column(BigInteger) # Deprecated, prefer selected_option
    is_correct = Column(Boolean)
    time_spent = Column(Integer)
    behaviour = Column(JSON)
    selected_option = Column(String(1))

    attempt = relationship("TestAttempt", back_populates="user_answers")
    question = relationship("Question")

class UserGlobalPerformance(Base):
    __tablename__ = "user_global_performance"

    user_id = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), primary_key=True)
    tests_attempted = Column(Integer, nullable=False, default=0)
    tests_completed = Column(Integer, nullable=False, default=0)
    total_score = Column(Integer, nullable=False, default=0)
    total_questions = Column(Integer, nullable=False, default=0)
    avg_accuracy = Column(Numeric(5, 2), nullable=False, default=0.0)
    avg_time_per_question = Column(Numeric(8, 2))
    global_score = Column(Numeric(8, 2), nullable=False, default=0.0)
    global_rank = Column(Integer)
    percentile = Column(Numeric(5, 2))
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())

class DailyMCQVote(Base):
    __tablename__ = "daily_mcq_votes"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    question_id = Column(BigInteger, ForeignKey("questions.id", ondelete="CASCADE"), nullable=False)
    selected_option = Column(String(1), nullable=False) # A, B, C, D
    created_at = Column(DateTime, default=func.now())

    user = relationship("User")
    question = relationship("Question")
