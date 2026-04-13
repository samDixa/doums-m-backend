from pydantic import BaseModel, EmailStr
from typing import Optional, List, Dict, Any
from datetime import date

class UserProfileUpdate(BaseModel):
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    name_prefix: Optional[str] = None
    district: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    dob: Optional[date] = None
    gender: Optional[str] = None
    category: Optional[str] = None
    batch: Optional[str] = None
    ug_college_state: Optional[str] = None
    ug_college_name: Optional[str] = None
    work_experience: Optional[List[Dict[str, Any]]] = None

class UserProfileResponse(BaseModel):
    id: int
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    mobile: Optional[str] = None
    district: Optional[str] = None
    state: Optional[str] = None
    country: Optional[str] = None
    dob: Optional[date] = None
    gender: Optional[str] = None
    category: Optional[str] = None
    batch: Optional[str] = None
    ug_college_state: Optional[str] = None
    ug_college_name: Optional[str] = None
    profile_image: Optional[str] = None
    work_experience: Optional[List[Dict[str, Any]]] = None

    class Config:
        from_attributes = True

class UserPerformanceResponse(BaseModel):
    tests_attempted: int
    tests_completed: int
    total_score: int
    total_questions: int
    avg_accuracy: float
    avg_time_per_question: Optional[float] = None
    global_score: float
    global_rank: Optional[int] = None
    percentile: Optional[float] = None

    class Config:
        from_attributes = True
