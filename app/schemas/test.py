from pydantic import BaseModel
from typing import Optional, List, Dict, Any
from datetime import datetime

class QuestionBase(BaseModel):
    id: int
    question_text: str
    option_a: str
    option_b: str
    option_c: str
    option_d: str

class QuestionDetailResponse(QuestionBase):
    description: Optional[str] = None
    subject: Optional[str] = None
    topic: Optional[str] = None
    correct_option: str
    selected_option: Optional[str] = None # The option selected by the current user
    option_stats: Dict[str, float] = {"A": 0, "B": 0, "C": 0, "D": 0}

    class Config:
        from_attributes = True

class TestBase(BaseModel):
    id: int
    title: str
    total_marks: Optional[int] = None
    negative_marks: Optional[int] = None
    positive_marks: Optional[int] = None
    duration_seconds: Optional[int] = None
    is_paid: bool = False
    price: float = 0.0

class TestListResponse(TestBase):
    class Config:
        from_attributes = True

class TestDetailResponse(TestBase):
    is_featured: bool
    total_attempts: int

    class Config:
        from_attributes = True

class AnswerSubmit(BaseModel):
    question_id: int
    selected_option: str # A, B, C, D or None
    time_spent: int

class TestSubmitRequest(BaseModel):
    answers: List[AnswerSubmit]
    time_taken_seconds: int

class TestAttemptResponse(BaseModel):
    id: int
    test_id: int
    attempt_number: int
    started_at: datetime
    submitted_at: Optional[datetime] = None
    score: int
    accuracy: float

    class Config:
        from_attributes = True

class TestGroupBase(BaseModel):
    id: int
    title: str
    description: Optional[str] = None
    price: float = 0.0
    image: Optional[str] = None
    parent_id: Optional[int] = None
    sequence: Optional[int] = None
    is_active: bool

    class Config:
        from_attributes = True

class TestGroupDetailResponse(TestGroupBase):
    children: List['TestGroupDetailResponse'] = []
    tests: List[TestListResponse] = []

    class Config:
        from_attributes = True

# Update forward refs
TestGroupDetailResponse.update_forward_refs()
