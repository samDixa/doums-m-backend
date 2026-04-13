from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime, date

class CourseLessonBase(BaseModel):
    id: int
    title: str
    lesson_type: str
    content_url: Optional[str] = None
    duration_seconds: Optional[int] = None
    sequence: int
    is_preview: bool

class CourseModuleBase(BaseModel):
    id: int
    title: str
    sequence: int
    lessons: List[CourseLessonBase] = []

    class Config:
        orm_mode = True

class CourseBase(BaseModel):
    id: int
    title: str
    subtitle: Optional[str] = None
    description: Optional[str] = None
    subject: Optional[str] = None
    level: Optional[str] = None
    is_paid: bool
    price: Optional[float] = None
    discount_percentage: Optional[float] = 0.0
    is_new: bool = False
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    batch_image: Optional[str] = None
    whatsapp_url: Optional[str] = None
    info_url: Optional[str] = None
    is_active: bool

class CourseListResponse(CourseBase):
    class Config:
        orm_mode = True

class TestBase(BaseModel):
    id: int
    title: str
    duration_seconds: Optional[int] = None
    total_marks: Optional[int] = None
    is_active: bool

    class Config:
        orm_mode = True

class CourseDetailResponse(CourseBase):
    modules: List[CourseModuleBase] = []
    tests: List[TestBase] = []

    class Config:
        orm_mode = True

class LessonProgressUpdate(BaseModel):
    last_position: Optional[int] = None
    completed: Optional[bool] = False
