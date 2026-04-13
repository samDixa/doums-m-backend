import os
import shutil
import uuid
from fastapi import APIRouter, Depends, HTTPException, File, UploadFile
from sqlalchemy.orm import Session
from app.api.dependencies import get_current_user
from app.core.database import get_db
from app.models.user import User
from app.models.test import UserGlobalPerformance
from app.schemas.profile import UserProfileResponse, UserProfileUpdate, UserPerformanceResponse

router = APIRouter()

@router.get("/me", response_model=UserProfileResponse)
def get_profile(current_user: User = Depends(get_current_user)):
    """
    Get current user profile.
    """
    return current_user

@router.put("/", response_model=UserProfileResponse)
def update_profile(
    *,
    db: Session = Depends(get_db),
    profile_in: UserProfileUpdate,
    current_user: User = Depends(get_current_user)
):
    """
    Update user profile.
    """
    update_data = profile_in.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        if hasattr(current_user, field):
            setattr(current_user, field, value)
    
    db.add(current_user)
    db.commit()
    db.refresh(current_user)
    return current_user

@router.get("/performance", response_model=UserPerformanceResponse)
def get_user_performance(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get global performance statistics for the user.
    """
    perf = db.query(UserGlobalPerformance).filter(UserGlobalPerformance.user_id == current_user.id).first()
    if not perf:
        raise HTTPException(status_code=404, detail="Performance data not found")
    return perf

@router.post("/upload-photo", response_model=UserProfileResponse)
def upload_photo(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Upload profile photo.
    """
    # Create directory if it doesn't exist
    upload_dir = "uploads/profile_pics"
    if not os.path.exists(upload_dir):
        os.makedirs(upload_dir)

    # Generate unique filename
    file_ext = os.path.splitext(file.filename)[1]
    filename = f"{uuid.uuid4()}{file_ext}"
    file_path = os.path.join(upload_dir, filename)

    # Save file
    try:
        with open(file_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Could not save file: {str(e)}")

    # Update user record
    # Note: We store the relative URL
    photo_url = f"/uploads/profile_pics/{filename}"
    current_user.profile_image = photo_url
    db.add(current_user)
    db.commit()
    db.refresh(current_user)

    return current_user
