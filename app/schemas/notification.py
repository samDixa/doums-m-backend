from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class NotificationBase(BaseModel):
    id: int
    title: str
    message: str
    type: str # e.g. "push", "in_app"
    is_global: bool
    reference_type: Optional[str] = None
    reference_id: int
    created_at: datetime

class UserNotificationResponse(BaseModel):
    id: int
    notification: NotificationBase
    is_read: bool

    class Config:
        orm_mode = True

class NotificationReadRequest(BaseModel):
    notification_ids: List[int]

class ArticleResponse(BaseModel):
    id: int
    title: str
    content: str
    is_clinical_case: bool
    created_at: datetime

    class Config:
        orm_mode = True
