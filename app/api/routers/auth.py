from fastapi import APIRouter, Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer, OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from datetime import timedelta
from jose import jwt, JWTError

from app.api.dependencies import get_db, log_activity
from app.core.config import settings
from app.core import security
from app.models.user import User, UserCredential, OTPVerification
from app.schemas.user import (
    Token, UserCreate, UserResponse, UserLogin,
    MobileLogin, OTPVerify, OTPVerifyResponse, UserRegister
)
from datetime import datetime, timedelta
import random

router = APIRouter()

@router.post("/login", response_model=Token)
def login_access_token(
    db: Session = Depends(get_db), form_data: OAuth2PasswordRequestForm = Depends()
):
    """
    OAuth2 compatible token login, get an access token for future requests
    (Keeping this for compatibility/legacy if needed, but primary is OTP)
    """
    user = db.query(User).filter(User.email == form_data.username).first()
    if not user:
        raise HTTPException(status_code=400, detail="Incorrect email or password")
    
    credential = db.query(UserCredential).filter(UserCredential.user_id == user.id).first()
    if not credential or not security.verify_password(form_data.password, credential.hashed_password):
        raise HTTPException(status_code=400, detail="Incorrect email or password")
    
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    
    log_activity(
        db, 
        user.id, 
        "LOGIN", 
        f"User logged in via email: {user.email}",
        {"method": "email"}
    )
    
    return {
        "access_token": security.create_access_token(
            subject=user.id, expires_delta=access_token_expires
        ),
        "token_type": "bearer",
    }

@router.post("/send-otp")
def send_otp(
    *,
    db: Session = Depends(get_db),
    login_data: MobileLogin,
):
    """
    Generate and send OTP to mobile number.
    For now, it returns the OTP in the response for testing.
    """
    # Generate a 6-digit OTP
    otp_code = str(random.randint(100000, 999999))
    expires_at = datetime.utcnow() + timedelta(minutes=10)
    
    # Save to database
    db_otp = OTPVerification(
        mobile=login_data.mobile,
        otp_code=otp_code,
        expires_at=expires_at
    )
    db.add(db_otp)
    db.commit()
    
    return {"message": "OTP sent successfully", "otp": otp_code}

@router.post("/verify-otp", response_model=OTPVerifyResponse)
def verify_otp(
    *,
    db: Session = Depends(get_db),
    verify_data: OTPVerify,
):
    """
    Verify OTP and return access token if user exists.
    """
    db_otp = db.query(OTPVerification).filter(
        OTPVerification.mobile == verify_data.mobile,
        OTPVerification.otp_code == verify_data.otp,
        OTPVerification.expires_at > datetime.utcnow(),
        OTPVerification.is_verified == False
    ).order_by(OTPVerification.created_at.desc()).first()
    
    if not db_otp:
        raise HTTPException(status_code=400, detail="Invalid or expired OTP")
    
    # Mark as verified
    db_otp.is_verified = True
    db.commit()
    
    # Check if user exists
    user = db.query(User).filter(User.mobile == verify_data.mobile).first()
    
    if not user:
        return {
            "is_new_user": True,
            "access_token": None,
            "user": None
        }
    
    # User exists, return token
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    token = security.create_access_token(
        subject=user.id, expires_delta=access_token_expires
    )
    
    log_activity(
        db, 
        user.id, 
        "LOGIN", 
        f"User logged in via mobile OTP: {user.mobile}",
        {"method": "otp"}
    )
    
    return {
        "is_new_user": False,
        "access_token": token,
        "user": user
    }

@router.post("/register", response_model=OTPVerifyResponse)
def register_user(
    *,
    db: Session = Depends(get_db),
    user_in: UserRegister,
):
    """
    Register a new user after OTP verification.
    """
    # Check if mobile already exists
    user = db.query(User).filter(User.mobile == user_in.mobile).first()
    if user:
        raise HTTPException(
            status_code=400,
            detail="The user with this mobile number already exists.",
        )
    
    # Check if email already exists if provided
    if user_in.email:
        user_email = db.query(User).filter(User.email == user_in.email).first()
        if user_email:
            raise HTTPException(
                status_code=400,
                detail="The user with this email already exists.",
            )
    
    # Create User
    db_user = User(
        mobile=user_in.mobile,
        first_name=user_in.first_name,
        last_name=user_in.last_name,
        email=user_in.email,
        gender=user_in.gender,
        dob=user_in.dob,
        country=user_in.country,
        state=user_in.state,
        district=user_in.district,
        category=user_in.category,
        batch=user_in.batch,
        ug_college_state=user_in.ug_college_state,
        ug_college_name=user_in.ug_college_name
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    # Create DUMMY Credentials
    hashed_password = security.get_password_hash(str(random.random()))
    db_credential = UserCredential(user_id=db_user.id, hashed_password=hashed_password)
    db.add(db_credential)
    db.commit()
    
    # Return token
    access_token_expires = timedelta(minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES)
    token = security.create_access_token(
        subject=db_user.id, expires_delta=access_token_expires
    )
    
    return {
        "is_new_user": False,
        "access_token": token,
        "user": db_user
    }

    return {
        "is_new_user": False,
        "access_token": token,
        "user": user
    }
