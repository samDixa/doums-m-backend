from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session

from app.api.dependencies import get_current_user
from app.core.database import get_db
from app.models.user import User
from app.models.course import CourseLesson, UserLessonProgress
from app.schemas.course import CourseLessonBase, LessonProgressUpdate

router = APIRouter()

@router.get("/{lesson_id}", response_model=CourseLessonBase)
def get_lesson(
    lesson_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get a lesson detail. Real implementations should verify the user is enrolled.
    """
    lesson = db.query(CourseLesson).filter(CourseLesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
    
    # In a full system, verify enrollment here via UserCourse tables etc.
    return lesson

@router.post("/{lesson_id}/progress")
def update_lesson_progress(
    lesson_id: int,
    progress_in: LessonProgressUpdate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Update lesson progress for the current user.
    """
    lesson = db.query(CourseLesson).filter(CourseLesson.id == lesson_id).first()
    if not lesson:
        raise HTTPException(status_code=404, detail="Lesson not found")
        
    progress = db.query(UserLessonProgress).filter(
        UserLessonProgress.lesson_id == lesson_id,
        UserLessonProgress.user_id == current_user.id
    ).first()
    
    if progress:
        if progress_in.last_position is not None:
            progress.last_position = progress_in.last_position
        if progress_in.completed is not None:
            progress.completed = progress_in.completed
    else:
        progress = UserLessonProgress(
            user_id=current_user.id,
            lesson_id=lesson_id,
            last_position=progress_in.last_position,
            completed=progress_in.completed or False
        )
        db.add(progress)
        
    db.commit()
    return {"message": "Progress updated"}
