from fastapi import APIRouter, Depends, HTTPException, UploadFile, File, Form
from sqlalchemy.orm import Session
import os
import uuid
from app.api.dependencies import get_current_admin_user
from app.core.database import get_db
from app.core import security
from app.models.user import User, UserCredential

from app.models.course import Course, CourseModule, CourseLesson
from app.models.test import Test, Question
from app.models.other import Article
from app.models.notification import Notification
from app.schemas.admin import (
    CourseCreate, CourseUpdate, ModuleCreate, ModuleUpdate, LessonCreate, LessonUpdate,
    QuestionCreate, QuestionUpdate, QuestionAdminResponse, TestCreate, TestUpdate, ArticleCreate, NotificationCreate,
    HomeFeaturedBatchCreate, HomeFeaturedBatchUpdate,
    UserAdminResponse, UserAdminCreate, UserAdminUpdate,
    UserDetailAdminResponse, UserActivityResponse, UserStatsResponse
)
from app.models.user import UserActivity
from app.models.course import UserCourse
from app.models.test import TestAttempt, UserGlobalPerformance
from sqlalchemy import func
from typing import List
from app.models.home import (
    HomeBanner, Category, SubCategory, 
    SubCategoryLecture, SubCategoryNote, SubCategoryTest,
    HomeFeaturedBatch
)
from app.schemas.home import (
    BannerCreate, BannerResponse,
    CategoryCreate, CategoryUpdate, CategoryResponse,
    SubCategoryCreate, SubCategoryUpdate, SubCategoryResponse,
    SubCategoryLectureCreate, SubCategoryLectureResponse,
    SubCategoryNoteCreate, SubCategoryNoteResponse,
    SubCategoryTestCreate, SubCategoryTestResponse,
    HomeFeaturedBatchResponse
)

router = APIRouter()

@router.get("/users", response_model=List[UserAdminResponse])
def get_users(
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    users = db.query(User).all()
    # Attach is_superuser attribute for the response model
    for user in users:
        user.is_superuser = user.credential.is_superuser if user.credential else False
    return users

@router.get("/users/{user_id}", response_model=UserDetailAdminResponse)
def get_user_detail(
    user_id: int,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_user = db.query(User).filter(User.id == user_id).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    
    # Attach is_superuser
    db_user.is_superuser = db_user.credential.is_superuser if db_user.credential else False
    return db_user

@router.get("/users/{user_id}/activity", response_model=List[UserActivityResponse])
def get_user_activities(
    user_id: int,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    activities = db.query(UserActivity).filter(UserActivity.user_id == user_id).order_by(UserActivity.created_at.desc()).all()
    return activities

@router.get("/users/{user_id}/stats", response_model=UserStatsResponse)
def get_user_stats(
    user_id: int,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    total_logins = db.query(UserActivity).filter(UserActivity.user_id == user_id, UserActivity.activity_type == 'LOGIN').count()
    courses_enrolled = db.query(UserCourse).filter(UserCourse.user_id == user_id).count()
    
    perf = db.query(UserGlobalPerformance).filter(UserGlobalPerformance.user_id == user_id).first()
    tests_attempted = perf.tests_attempted if perf else db.query(TestAttempt).filter(TestAttempt.user_id == user_id).count()
    avg_test_score = (perf.total_score / perf.tests_attempted) if perf and perf.tests_attempted > 0 else 0.0
    
    last_activity = db.query(UserActivity).filter(UserActivity.user_id == user_id).order_by(UserActivity.created_at.desc()).first()
    
    # Simple most active feature detection
    most_active = db.query(UserActivity.activity_type, func.count(UserActivity.id).label('count'))\
        .filter(UserActivity.user_id == user_id)\
        .group_by(UserActivity.activity_type)\
        .order_by(func.count(UserActivity.id).desc())\
        .first()
    
    return {
        "total_logins": total_logins,
        "courses_enrolled": courses_enrolled,
        "tests_attempted": tests_attempted,
        "avg_test_score": avg_test_score,
        "last_active": last_activity.created_at if last_activity else None,
        "most_active_feature": most_active[0] if most_active else "None"
    }

@router.post("/user", response_model=UserAdminResponse)
def create_user(
    item: UserAdminCreate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    # Check if user already exists
    if db.query(User).filter(User.email == item.email).first():
        raise HTTPException(status_code=400, detail="User already exists")
    
    db_user = User(
        email=item.email,
        first_name=item.first_name,
        last_name=item.last_name,
        mobile=item.mobile
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    
    hashed_password = security.get_password_hash(item.password)
    db_credential = UserCredential(
        user_id=db_user.id,
        hashed_password=hashed_password,
        is_superuser=item.is_superuser
    )
    db.add(db_credential)
    db.commit()
    
    db_user.is_superuser = item.is_superuser
    return db_user

@router.put("/user/{user_id}", response_model=UserAdminResponse)
def update_user(
    user_id: int,
    item: UserAdminUpdate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_user = db.query(User).filter(User.id == user_id).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    
    update_data = item.dict(exclude_unset=True)
    password = update_data.pop('password', None)
    is_superuser = update_data.pop('is_superuser', None)

    for field, value in update_data.items():
        setattr(db_user, field, value)
    
    if is_superuser is not None or password is not None:
        if not db_user.credential:
            # Should not happen but handle it
            hashed_pw = security.get_password_hash(password or "default123")
            db_user.credential = UserCredential(user_id=db_user.id, hashed_password=hashed_pw, is_superuser=is_superuser or False)
        else:
            if is_superuser is not None:
                db_user.credential.is_superuser = is_superuser
            if password:
                db_user.credential.hashed_password = security.get_password_hash(password)
    
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    db_user.is_superuser = db_user.credential.is_superuser if db_user.credential else False
    return db_user

@router.delete("/user/{user_id}")
def delete_user(
    user_id: int,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_user = db.query(User).filter(User.id == user_id).first()
    if not db_user:
        raise HTTPException(status_code=404, detail="User not found")
    db.delete(db_user)
    db.commit()
    return {"message": "User deleted"}
@router.get("/stats")
def get_stats(
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    total_courses = db.query(Course).count()
    active_courses = db.query(Course).filter(Course.is_active == True).count()
    active_tests = db.query(Test).filter(Test.is_active == True).count()
    total_mcqs = db.query(Question).count()
    global_students = db.query(User).count()
    notifications_sent = db.query(Notification).count()
    
    return {
        "total_courses": total_courses,
        "active_courses": active_courses,
        "active_tests": active_tests,
        "total_mcqs": total_mcqs,
        "global_students": global_students,
        "notifications_sent": notifications_sent
    }


@router.post("/course")
def create_course(
    title: str = Form(...),
    subtitle: str = Form(None),
    description: str = Form(None),
    subject: str = Form(None),
    level: str = Form(None),
    is_paid: str = Form("false"),
    price: str = Form("0"),
    discount_percentage: str = Form("0"),
    is_new: str = Form("false"),
    start_date: str = Form(None),
    end_date: str = Form(None),
    whatsapp_url: str = Form(None),
    info_url: str = Form(None),
    is_active: str = Form("true"),
    file: UploadFile = File(None),
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    # Manual conversion to avoid 422 encoding issues with binary files
    def to_bool(val):
        return str(val).lower() in ("true", "1", "yes", "on")
    
    def to_float(val, default=0.0):
        try:
            return float(val) if val else default
        except:
            return default

    image_url = None
    if file:
        os.makedirs("uploads/courses", exist_ok=True)
        file_extension = os.path.splitext(file.filename)[1]
        file_name = f"{uuid.uuid4()}{file_extension}"
        file_path = os.path.join("uploads/courses", file_name)
        with open(file_path, "wb") as buffer:
            buffer.write(file.file.read())
        image_url = f"/uploads/courses/{file_name}"

    # Handle Date conversion
    from datetime import datetime
    def to_date(date_str):
        if not date_str: return None
        try:
            return datetime.strptime(date_str, "%Y-%m-%d").date()
        except:
            return None

    db_obj = Course(
        title=title,
        subtitle=subtitle,
        description=description,
        subject=subject,
        level=level,
        is_paid=to_bool(is_paid),
        price=to_float(price),
        discount_percentage=to_float(discount_percentage),
        is_new=to_bool(is_new),
        start_date=to_date(start_date),
        end_date=to_date(end_date),
        batch_image=image_url,
        whatsapp_url=whatsapp_url,
        info_url=info_url,
        is_active=to_bool(is_active)
    )
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.post("/course/{course_id}/image")
def upload_course_image(
    course_id: int,
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = db.query(Course).filter(Course.id == course_id).first()
    if not db_obj:
        raise HTTPException(status_code=404, detail="Course not found")
    
    os.makedirs("uploads/courses", exist_ok=True)
    file_extension = os.path.splitext(file.filename)[1]
    file_name = f"{uuid.uuid4()}{file_extension}"
    file_path = os.path.join("uploads/courses", file_name)
    
    with open(file_path, "wb") as buffer:
        buffer.write(file.file.read())
    
    image_url = f"/uploads/courses/{file_name}"
    db_obj.batch_image = image_url
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.put("/course/{course_id}")
def update_course(
    course_id: int,
    item: CourseUpdate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = db.query(Course).filter(Course.id == course_id).first()
    if not db_obj:
        raise HTTPException(status_code=404, detail="Course not found")
    
    update_data = item.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_obj, field, value)
    
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.delete("/course/{course_id}")
def delete_course(
    course_id: int,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = db.query(Course).filter(Course.id == course_id).first()
    if not db_obj:
        raise HTTPException(status_code=404, detail="Course not found")
    db.delete(db_obj)
    db.commit()
    return {"message": "Course deleted"}

@router.post("/module")
def create_module(
    item: ModuleCreate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = CourseModule(**item.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.put("/module/{module_id}")
def update_module(
    module_id: int,
    item: ModuleUpdate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = db.query(CourseModule).filter(CourseModule.id == module_id).first()
    if not db_obj:
        raise HTTPException(status_code=404, detail="Module not found")
    
    update_data = item.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_obj, field, value)
    
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.delete("/module/{module_id}")
def delete_module(
    module_id: int,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = db.query(CourseModule).filter(CourseModule.id == module_id).first()
    if not db_obj:
        raise HTTPException(status_code=404, detail="Module not found")
    db.delete(db_obj)
    db.commit()
    return {"message": "Module deleted"}

@router.post("/lesson")
def create_lesson(
    item: LessonCreate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = CourseLesson(**item.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.put("/lesson/{lesson_id}")
def update_lesson(
    lesson_id: int,
    item: LessonUpdate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = db.query(CourseLesson).filter(CourseLesson.id == lesson_id).first()
    if not db_obj:
        raise HTTPException(status_code=404, detail="Lesson not found")
    
    update_data = item.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_obj, field, value)
    
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.delete("/lesson/{lesson_id}")
def delete_lesson(
    lesson_id: int,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = db.query(CourseLesson).filter(CourseLesson.id == lesson_id).first()
    if not db_obj:
        raise HTTPException(status_code=404, detail="Lesson not found")
    db.delete(db_obj)
    db.commit()
    return {"message": "Lesson deleted"}

@router.get("/questions/qotd", response_model=List[QuestionAdminResponse])
def get_daily_mcqs(
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    questions = db.query(Question).filter(Question.is_daily_mcq == True).order_by(Question.created_at.desc()).all()
    return questions

@router.post("/question", response_model=QuestionAdminResponse)
def create_question(
    item: QuestionCreate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = Question(**item.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.put("/question/{id}", response_model=QuestionAdminResponse)
def update_question(
    id: int,
    item: QuestionUpdate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = db.query(Question).filter(Question.id == id).first()
    if not db_obj:
        raise HTTPException(status_code=404, detail="Question not found")
    
    for field, value in item.dict(exclude_unset=True).items():
        setattr(db_obj, field, value)
        
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.delete("/question/{id}")
def delete_question(
    id: int,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = db.query(Question).filter(Question.id == id).first()
    if not db_obj:
        raise HTTPException(status_code=404, detail="Question not found")
        
    db.delete(db_obj)
    db.commit()
    return {"message": "Question deleted"}

@router.put("/test/{test_id}")
def update_test(
    test_id: int,
    item: TestUpdate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = db.query(Test).filter(Test.id == test_id).first()
    if not db_obj:
        raise HTTPException(status_code=404, detail="Test not found")
    
    update_data = item.dict(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_obj, field, value)
    
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

# --- Featured Batch Management ---
@router.get("/featured-batches", response_model=List[HomeFeaturedBatchResponse])
def get_featured_batches_admin(db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    return db.query(HomeFeaturedBatch).order_by(HomeFeaturedBatch.sequence.asc()).all()

@router.post("/featured-batch", response_model=HomeFeaturedBatchResponse)
def create_featured_batch_admin(item: HomeFeaturedBatchCreate, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    db_obj = HomeFeaturedBatch(**item.dict())
    db.add(db_obj); db.commit(); db.refresh(db_obj)
    return db_obj

@router.put("/featured-batch/{id}", response_model=HomeFeaturedBatchResponse)
def update_featured_batch_admin(id: int, item: HomeFeaturedBatchUpdate, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    db_obj = db.query(HomeFeaturedBatch).filter(HomeFeaturedBatch.id == id).first()
    if not db_obj: raise HTTPException(status_code=404, detail="Featured batch not found")
    for field, value in item.dict(exclude_unset=True).items(): setattr(db_obj, field, value)
    db.commit(); db.refresh(db_obj)
    return db_obj

@router.delete("/featured-batch/{id}")
def delete_featured_batch_admin(id: int, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    db_obj = db.query(HomeFeaturedBatch).filter(HomeFeaturedBatch.id == id).first()
    if not db_obj: raise HTTPException(status_code=404, detail="Featured batch not found")
    db.delete(db_obj); db.commit()
    return {"message": "Deleted"}

@router.post("/article")
def create_article(
    item: ArticleCreate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = Article(**item.dict(), author_id=current_admin.id)
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.post("/notification")
def create_notification(
    item: NotificationCreate,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = Notification(**item.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

# Banner Management
@router.get("/banners", response_model=List[BannerResponse])
def get_banners(
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    return db.query(HomeBanner).all()

@router.post("/banner", response_model=BannerResponse)
def create_banner(
    file: UploadFile = File(...),
    navigation_target: str = Form(None),
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    # Enforce limit of 3
    count = db.query(HomeBanner).count()
    if count >= 3:
        raise HTTPException(status_code=400, detail="Maximum limit of 3 banners reached. Please delete an existing banner first.")
    
    # Save the file
    file_extension = os.path.splitext(file.filename)[1]
    file_name = f"{uuid.uuid4()}{file_extension}"
    file_path = os.path.join("uploads/banners", file_name)
    
    with open(file_path, "wb") as buffer:
        buffer.write(file.file.read())
    
    # URL for access (assuming base URL + /uploads/...)
    # In a real app, you might want to prepend the base URL here or in the frontend
    image_url = f"/uploads/banners/{file_name}"
    
    db_obj = HomeBanner(
        image_url=image_url,
        navigation_target=navigation_target,
        is_active=True
    )
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.delete("/banner/{banner_id}")
def delete_banner(
    banner_id: int,
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    db_obj = db.query(HomeBanner).filter(HomeBanner.id == banner_id).first()
    if not db_obj:
        raise HTTPException(status_code=404, detail="Banner not found")
    
    db.delete(db_obj)
    db.commit()
    return {"message": "Banner deleted successfully"}

# --- Category Management ---
@router.get("/categories", response_model=List[CategoryResponse])
def get_categories(db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    return db.query(Category).order_by(Category.sequence.asc()).all()

@router.post("/category", response_model=CategoryResponse)
def create_category(item: CategoryCreate, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    if db.query(Category).count() >= 6:
        raise HTTPException(status_code=400, detail="Maximum limit of 6 categories reached.")
    db_obj = Category(**item.dict())
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.put("/category/{category_id}", response_model=CategoryResponse)
def update_category(category_id: int, item: CategoryUpdate, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    db_obj = db.query(Category).filter(Category.id == category_id).first()
    if not db_obj: raise HTTPException(status_code=404, detail="Category not found")
    for field, value in item.dict(exclude_unset=True).items(): setattr(db_obj, field, value)
    db.commit(); db.refresh(db_obj)
    return db_obj

@router.delete("/category/{category_id}")
def delete_category(category_id: int, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    db_obj = db.query(Category).filter(Category.id == category_id).first()
    if not db_obj: raise HTTPException(status_code=404, detail="Category not found")
    db.delete(db_obj); db.commit()
    return {"message": "Deleted"}

# --- SubCategory Management ---
@router.get("/sub_categories", response_model=List[SubCategoryResponse])
def get_sub_categories(category_id: int = None, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    q = db.query(SubCategory)
    if category_id: q = q.filter(SubCategory.category_id == category_id)
    return q.order_by(SubCategory.sequence.asc()).all()

@router.post("/sub_category", response_model=SubCategoryResponse)
def create_sub_category(
    title: str = Form(...),
    category_id: int = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    if db.query(SubCategory).filter(SubCategory.category_id == category_id).count() >= 10:
        raise HTTPException(status_code=400, detail="Maximum limit of 10 subcategories per category reached.")
        
    os.makedirs("uploads/icons", exist_ok=True)
    file_extension = os.path.splitext(file.filename)[1]
    file_name = f"{uuid.uuid4()}{file_extension}"
    file_path = os.path.join("uploads/icons", file_name)
    
    with open(file_path, "wb") as buffer:
        buffer.write(file.file.read())
        
    icon_url = f"/uploads/icons/{file_name}"
    
    db_obj = SubCategory(title=title, category_id=category_id, icon=icon_url)
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.put("/sub_category/{sub_id}", response_model=SubCategoryResponse)
def update_sub_category(sub_id: int, item: SubCategoryUpdate, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    db_obj = db.query(SubCategory).filter(SubCategory.id == sub_id).first()
    if not db_obj: raise HTTPException(status_code=404, detail="Not found")
    for field, value in item.dict(exclude_unset=True).items(): setattr(db_obj, field, value)
    db.commit(); db.refresh(db_obj)
    return db_obj

@router.delete("/sub_category/{sub_id}")
def delete_sub_category(sub_id: int, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    db_obj = db.query(SubCategory).filter(SubCategory.id == sub_id).first()
    if not db_obj: raise HTTPException(status_code=404, detail="Not found")
    db.delete(db_obj); db.commit()
    return {"message": "Deleted"}

# --- Handlers for subcategory lectures, notes, tests ---
@router.post("/sub_category_lecture", response_model=SubCategoryLectureResponse)
def create_sub_category_lecture(
    title: str = Form(...),
    sub_category_id: int = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    os.makedirs("uploads/lectures", exist_ok=True)
    file_extension = os.path.splitext(file.filename)[1]
    file_name = f"{uuid.uuid4()}{file_extension}"
    file_path = os.path.join("uploads/lectures", file_name)
    
    with open(file_path, "wb") as buffer:
        buffer.write(file.file.read())
        
    video_url = f"/uploads/lectures/{file_name}"
    
    db_obj = SubCategoryLecture(title=title, sub_category_id=sub_category_id, video_url=video_url)
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.delete("/sub_category_lecture/{id}")
def delete_sub_category_lecture(id: int, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    db_obj = db.query(SubCategoryLecture).filter(SubCategoryLecture.id == id).first()
    if db_obj: db.delete(db_obj); db.commit()
    return {"message": "Deleted"}

@router.post("/sub_category_note", response_model=SubCategoryNoteResponse)
def create_sub_category_note(
    title: str = Form(...),
    sub_category_id: int = Form(...),
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_admin: User = Depends(get_current_admin_user)
):
    os.makedirs("uploads/notes", exist_ok=True)
    file_extension = os.path.splitext(file.filename)[1]
    file_name = f"{uuid.uuid4()}{file_extension}"
    file_path = os.path.join("uploads/notes", file_name)
    
    with open(file_path, "wb") as buffer:
        buffer.write(file.file.read())
        
    pdf_url = f"/uploads/notes/{file_name}"
    
    db_obj = SubCategoryNote(title=title, sub_category_id=sub_category_id, pdf_url=pdf_url)
    db.add(db_obj)
    db.commit()
    db.refresh(db_obj)
    return db_obj

@router.delete("/sub_category_note/{id}")
def delete_sub_category_note(id: int, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    db_obj = db.query(SubCategoryNote).filter(SubCategoryNote.id == id).first()
    if db_obj: db.delete(db_obj); db.commit()
    return {"message": "Deleted"}

@router.post("/sub_category_test", response_model=SubCategoryTestResponse)
def create_sub_category_test(item: SubCategoryTestCreate, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    db_obj = SubCategoryTest(**item.dict())
    db.add(db_obj); db.commit(); db.refresh(db_obj)
    return db_obj

@router.delete("/sub_category_test/{id}")
def delete_sub_category_test(id: int, db: Session = Depends(get_db), current_admin: User = Depends(get_current_admin_user)):
    db_obj = db.query(SubCategoryTest).filter(SubCategoryTest.id == id).first()
    if db_obj: db.delete(db_obj); db.commit()
    return {"message": "Deleted"}
