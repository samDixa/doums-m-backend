from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.api.dependencies import get_current_user
from app.core.database import get_db
from app.models.user import User
from app.models.notification import UserNotification
from app.schemas.notification import UserNotificationResponse, NotificationReadRequest

router = APIRouter()

@router.get("/", response_model=List[UserNotificationResponse])
def get_notifications(
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 50,
    current_user: User = Depends(get_current_user)
):
    """
    Get notifications for the current user.
    """
    notifications = db.query(UserNotification).filter(
        UserNotification.user_id == current_user.id
    ).order_by(UserNotification.delivered_at.desc()).offset(skip).limit(limit).all()
    
    return notifications

@router.post("/read")
def mark_notifications_read(
    request: NotificationReadRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Mark notifications as read.
    """
    from datetime import datetime
    
    notifications = db.query(UserNotification).filter(
        UserNotification.id.in_(request.notification_ids),
        UserNotification.user_id == current_user.id
    ).all()
    
    for notification in notifications:
        notification.is_read = True
        notification.read_at = datetime.utcnow()
        
    db.commit()
    return {"message": "Notifications marked as read"}
