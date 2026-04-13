from pydantic import BaseModel, EmailStr
from typing import Optional

from datetime import date

class Token(BaseModel):
    access_token: str
    token_type: str

class TokenPayload(BaseModel):
    sub: Optional[str] = None

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserCreate(BaseModel):
    email: EmailStr
    password: str
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    mobile: Optional[str] = None

class UserResponse(BaseModel):
    id: int
    email: Optional[EmailStr] = None
    first_name: Optional[str] = None
    last_name: Optional[str] = None
    mobile: Optional[str] = None
    gender: Optional[str] = None
    dob: Optional[date] = None
    country: Optional[str] = None
    state: Optional[str] = None
    district: Optional[str] = None
    category: Optional[str] = None
    designation: Optional[str] = None
    batch: Optional[str] = None
    ug_college_state: Optional[str] = None
    ug_college_name: Optional[str] = None

    class Config:
        from_attributes = True

class MobileLogin(BaseModel):
    mobile: str

class OTPVerify(BaseModel):
    mobile: str
    otp: str

class OTPVerifyResponse(BaseModel):
    is_new_user: bool
    access_token: Optional[str] = None
    token_type: Optional[str] = "bearer"
    user: Optional[UserResponse] = None

class UserRegister(BaseModel):
    mobile: str
    first_name: str
    last_name: Optional[str] = None
    email: Optional[EmailStr] = None
    gender: Optional[str] = None
    dob: Optional[date] = None
    country: Optional[str] = None
    state: Optional[str] = None
    district: Optional[str] = None
    category: Optional[str] = None
    designation: Optional[str] = None
    batch: Optional[str] = None
    ug_college_state: Optional[str] = None
    ug_college_name: Optional[str] = None

