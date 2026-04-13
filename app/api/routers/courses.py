from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.api.dependencies import get_current_user, get_db, log_activity
from app.models.user import User
from app.models.course import Course, UserCourse
from app.schemas.course import CourseListResponse, CourseDetailResponse

router = APIRouter()

@router.get("/", response_model=List[CourseListResponse])
def get_courses(
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 100,
    current_user: User = Depends(get_current_user)
):
    """
    Retrieve all active courses.
    """
    courses = db.query(Course).filter(Course.is_active == True).offset(skip).limit(limit).all()
    return courses

@router.get("/{course_id}", response_model=CourseDetailResponse)
def get_course_detail(
    course_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get detailed breakdown of a course including modules and lessons.
    """
    course = db.query(Course).filter(Course.id == course_id, Course.is_active == True).first()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
    return course

@router.post("/{course_id}/enroll")
def enroll_course(
    course_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Enroll a user into a course.
    """
    course = db.query(Course).filter(Course.id == course_id, Course.is_active == True).first()
    if not course:
        raise HTTPException(status_code=404, detail="Course not found")
        
    enrollment = db.query(UserCourse).filter(
        UserCourse.course_id == course_id,
        UserCourse.user_id == current_user.id
    ).first()
    if enrollment:
        raise HTTPException(status_code=400, detail="Already enrolled in this course")
        
    new_enrollment = UserCourse(user_id=current_user.id, course_id=course_id)
    db.add(new_enrollment)
    db.commit()
    
    log_activity(
        db, 
        current_user.id, 
        "COURSE_ENROLL", 
        f"Enrolled in course: {course.title}",
        {"course_id": course_id}
    )
    
    return {"message": "Successfully enrolled"}
