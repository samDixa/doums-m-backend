from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime, date

class CourseCreate(BaseModel):
    title: str
    subtitle: Optional[str] = None
    description: Optional[str] = None
    subject: Optional[str] = None
    level: Optional[str] = None
    is_paid: bool = False
    price: Optional[float] = None
    discount_percentage: Optional[float] = 0.0
    is_new: bool = False
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    batch_image: Optional[str] = None
    whatsapp_url: Optional[str] = None
    info_url: Optional[str] = None
    is_active: bool = True

class CourseUpdate(BaseModel):
    title: Optional[str] = None
    subtitle: Optional[str] = None
    description: Optional[str] = None
    subject: Optional[str] = None
    level: Optional[str] = None 
    is_paid: Optional[bool] = None
    price: Optional[float] = None
    discount_percentage: Optional[float] = None
    is_new: Optional[bool] = None
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    batch_image: Optional[str] = None
    whatsapp_url: Optional[str] = None
    info_url: Optional[str] = None
    is_active: Optional[bool] = None

class ModuleCreate(BaseModel):
    course_id: int
    title: str
    sequence: int

class ModuleUpdate(BaseModel):
    title: Optional[str] = None
    sequence: Optional[int] = None

class LessonCreate(BaseModel):
    module_id: int
    title: str
    lesson_type: str
    content_url: str
    duration_seconds: Optional[int] = None
    sequence: int
    is_preview: bool = False

class LessonUpdate(BaseModel):
    title: Optional[str] = None
    lesson_type: Optional[str] = None
    content_url: Optional[str] = None
    duration_seconds: Optional[int] = None
    sequence: Optional[int] = None
    is_preview: Optional[bool] = None

class QuestionCreate(BaseModel):
    question_text: str
    option_a: str
    option_b: str
    option_c: str
    option_d: str
    correct_option: str
    description: Optional[str] = None
    subject: Optional[str] = None
    topic: Optional[str] = None
    is_daily_mcq: bool = False

class QuestionUpdate(BaseModel):
    question_text: Optional[str] = None
    option_a: Optional[str] = None
    option_b: Optional[str] = None
    option_c: Optional[str] = None
    option_d: Optional[str] = None
    correct_option: Optional[str] = None
    description: Optional[str] = None
    subject: Optional[str] = None
    topic: Optional[str] = None
    is_daily_mcq: Optional[bool] = None

class QuestionAdminResponse(QuestionCreate):
    id: int
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True

class TestCreate(BaseModel):
    title: str
    total_marks: Optional[int] = None
    negative_marks: Optional[int] = None
    positive_marks: Optional[int] = None
    duration_seconds: Optional[int] = None
    test_group_id: Optional[int] = None
    is_paid: bool = False
    price: float = 0.0

class TestUpdate(BaseModel):
    title: Optional[str] = None
    total_marks: Optional[int] = None
    negative_marks: Optional[int] = None
    positive_marks: Optional[int] = None
    duration_seconds: Optional[int] = None
    test_group_id: Optional[int] = None
    is_paid: Optional[bool] = None
    price: Optional[float] = None

class TestGroupCreate(BaseModel):
    title: str
    parent_id: Optional[int] = None
    description: Optional[str] = None
    price: float = 0.0
    image: Optional[str] = None
    sequence: int = 0
    is_active: bool = True

class TestGroupUpdate(BaseModel):
    title: Optional[str] = None
    parent_id: Optional[int] = None
    description: Optional[str] = None
    price: Optional[float] = None
    image: Optional[str] = None
    sequence: Optional[int] = None
    is_active: Optional[bool] = None

class HomeFeaturedBatchCreate(BaseModel):
    course_id: int
    sequence: int = 0
    is_active: bool = True

class HomeFeaturedBatchUpdate(BaseModel):
    course_id: Optional[int] = None
    sequence: Optional[int] = None
    is_active: Optional[bool] = None

class ArticleCreate(BaseModel):
    title: str
    content: str
    is_published: bool = True
    is_clinical_case: bool = False

class NotificationCreate(BaseModel):
    title: str
    message: str
    type: str # "in_app" or "push"
    is_global: bool = True
    reference_type: Optional[str] = None
    reference_id: int = 0

class UserAdminResponse(BaseModel):
    id: int
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: str
    mobile: Optional[str] = None
    created_at: Optional[datetime] = None
    is_superuser: bool = False

    class Config:
        from_attributes = True

class UserAdminCreate(BaseModel):
    email: str
    password: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    mobile: Optional[str] = None
    is_superuser: bool = False

class UserAdminUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    mobile: Optional[str] = None
    is_superuser: Optional[bool] = None
    password: Optional[str] = None

class UserActivityResponse(BaseModel):
    id: int
    activity_type: str
    description: Optional[str] = None
    metadata_json: Optional[dict] = None
    created_at: datetime

    class Config:
        from_attributes = True

class UserEducationResponse(BaseModel):
    id: int
    degree_name: Optional[str] = None
    start_date: Optional[date] = None
    end_date: Optional[date] = None
    is_current: Optional[bool] = None

    class Config:
        from_attributes = True

class UserInterestResponse(BaseModel):
    interest: str

    class Config:
        from_attributes = True

class UserDetailAdminResponse(UserAdminResponse):
    name_prefix: Optional[str] = None
    district: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    dob: Optional[date] = None
    gender: Optional[str] = None
    category: Optional[str] = None
    designation: Optional[str] = None
    batch: Optional[str] = None
    ug_college_state: Optional[str] = None
    ug_college_name: Optional[str] = None
    profile_image: Optional[str] = None
    updated_at: Optional[datetime] = None
    
    educations: Optional[List[UserEducationResponse]] = []
    interests: Optional[List[UserInterestResponse]] = []
    activities: Optional[List[UserActivityResponse]] = []

    class Config:
        from_attributes = True

class UserStatsResponse(BaseModel):
    total_logins: int
    courses_enrolled: int
    tests_attempted: int
    avg_test_score: float
    last_active: Optional[datetime] = None
    most_active_feature: Optional[str] = None # e.g., 'MOCK_TESTS', 'COURSES'
    
    class Config:
        from_attributes = True
