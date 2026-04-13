from fastapi import APIRouter
from app.api.routers import auth, profile, courses, lessons, tests, notifications, feed, admin, home

api_router = APIRouter()
api_router.include_router(auth.router, prefix="/auth", tags=["auth"])
api_router.include_router(profile.router, prefix="/profile", tags=["profile"])
api_router.include_router(courses.router, prefix="/courses", tags=["courses"])
api_router.include_router(lessons.router, prefix="/lessons", tags=["lessons"])
api_router.include_router(tests.router, prefix="/tests", tags=["tests"])
api_router.include_router(notifications.router, prefix="/notifications", tags=["notifications"])
api_router.include_router(feed.router, prefix="/feed", tags=["feed"])
api_router.include_router(admin.router, prefix="/admin", tags=["admin"])
api_router.include_router(home.router, prefix="/home", tags=["home"])
