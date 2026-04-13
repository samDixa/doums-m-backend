from app.core.database import Base
from app.models.user import User, UserCredential, UserEducation, UserInterest, OTPVerification
from app.models.course import Course, CourseModule, CourseLesson, CourseTest, UserCourse, UserLessonProgress
from app.models.test import TestGroup, Test, Question, TestQuestion, TestCategory, TestCategoryMap, TestAttempt, UserAnswer, UserGlobalPerformance
from app.models.notification import Notification, NotificationTarget, UserNotification
from app.models.other import College, EducationLevel, Page, GlobalPageVisitor, PageUniqueVisitor, UserPageVisit, Article

# Export all models so that Alembic and FastAPI can easily discover them
__all__ = [
    "Base", "User", "UserCredential", "UserEducation", "UserInterest", "OTPVerification",
    "Course", "CourseModule", "CourseLesson", "CourseTest", "UserCourse", "UserLessonProgress",
    "TestGroup", "Test", "Question", "TestQuestion", "TestCategory", "TestCategoryMap", "TestAttempt", "UserAnswer", "UserGlobalPerformance",
    "Notification", "NotificationTarget", "UserNotification",
    "College", "EducationLevel", "Page", "GlobalPageVisitor", "PageUniqueVisitor", "UserPageVisit", "Article"
]
