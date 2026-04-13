from sqlalchemy import Column, Integer, String, Boolean, DateTime, ForeignKey, Text, BigInteger
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func
from app.core.database import Base

class Notification(Base):
    __tablename__ = "notifications"

    id = Column(BigInteger, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    message = Column(Text, nullable=False)
    type = Column(String(50), nullable=False)
    is_global = Column(Boolean, default=False)
    reference_type = Column(String(50))
    reference_id = Column(BigInteger, nullable=False)
    created_at = Column(DateTime, default=func.now())
    updated_at = Column(DateTime, default=func.now(), onupdate=func.now())
    
    targets = relationship("NotificationTarget", back_populates="notification", cascade="all, delete-orphan")
    user_notifications = relationship("UserNotification", back_populates="notification", cascade="all, delete-orphan")

class NotificationTarget(Base):
    __tablename__ = "notification_targets"

    notification_id = Column(BigInteger, ForeignKey("notifications.id", ondelete="CASCADE"), primary_key=True)
    target_type = Column(String(50), nullable=False, primary_key=True)
    target_value = Column(String(200), nullable=False, primary_key=True)

    notification = relationship("Notification", back_populates="targets")

class UserNotification(Base):
    __tablename__ = "user_notifications"

    id = Column(BigInteger, primary_key=True, index=True)
    user_id = Column(BigInteger, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    notification_id = Column(BigInteger, ForeignKey("notifications.id", ondelete="CASCADE"), nullable=False)
    is_read = Column(Boolean, default=False)
    delivered_at = Column(DateTime, default=func.now())
    read_at = Column(DateTime)
    
    notification = relationship("Notification", back_populates="user_notifications")
    user = relationship("User")
