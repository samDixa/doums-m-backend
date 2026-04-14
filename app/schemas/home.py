from pydantic import BaseModel
from typing import List, Optional, Any
from datetime import datetime

class CategoryBase(BaseModel):
    title: str
    sequence: int = 0
    is_active: bool = True

class CategoryCreate(CategoryBase):
    pass

class CategoryUpdate(CategoryBase):
    pass

class CategoryResponse(CategoryBase):
    id: int
    created_at: datetime
    
    class Config:
        from_attributes = True

class SubCategoryBase(BaseModel):
    title: str
    icon: str
    sequence: int = 0
    is_active: bool = True

class SubCategoryCreate(SubCategoryBase):
    category_id: int

class SubCategoryUpdate(SubCategoryBase):
    pass

class SubCategoryResponse(SubCategoryBase):
    id: int
    category_id: int
    created_at: datetime
    
    class Config:
        from_attributes = True

class SubCategoryLectureBase(BaseModel):
    title: str
    video_url: str
    sequence: int = 0

class SubCategoryLectureCreate(SubCategoryLectureBase):
    sub_category_id: int

class SubCategoryLectureResponse(SubCategoryLectureBase):
    id: int
    sub_category_id: int
    created_at: datetime
    
    class Config:
        from_attributes = True

class SubCategoryNoteBase(BaseModel):
    title: str
    pdf_url: str
    sequence: int = 0

class SubCategoryNoteCreate(SubCategoryNoteBase):
    sub_category_id: int

class SubCategoryNoteResponse(SubCategoryNoteBase):
    id: int
    sub_category_id: int
    created_at: datetime
    
    class Config:
        from_attributes = True

class SubCategoryTestBase(BaseModel):
    test_id: int
    sequence: int = 0

class SubCategoryTestCreate(SubCategoryTestBase):
    sub_category_id: int

class SubCategoryTestResponse(SubCategoryTestBase):
    id: int
    sub_category_id: int
    created_at: datetime
    
    class Config:
        from_attributes = True

class SubCategoryDetailResponse(SubCategoryResponse):
    lectures: List[SubCategoryLectureResponse] = []
    notes: List[SubCategoryNoteResponse] = []
    tests: List[SubCategoryTestResponse] = []

class CategoryWithSubCategoriesResponse(CategoryResponse):
    sub_categories: List[SubCategoryResponse] = []

class HomeCategoryBase(BaseModel):
    title: str
    icon: str
    filter_categories: List[str] = []
    navigation_target: str
    navigation_args: Optional[dict] = {}
    sequence: int = 0
    is_active: bool = True

class HomeCategoryResponse(HomeCategoryBase):
    id: int

    class Config:
        from_attributes = True

class BannerBase(BaseModel):
    image_url: str
    navigation_target: Optional[str] = None
    navigation_args: Optional[dict] = {}
    sequence: int = 0
    is_active: bool = True

class BannerCreate(BannerBase):
    pass

class BannerResponse(BannerBase):
    id: int

    class Config:
        from_attributes = True

class HomeFeaturedBatchBase(BaseModel):
    course_id: int
    sequence: int = 0
    is_active: bool = True

class HomeFeaturedBatchCreate(HomeFeaturedBatchBase):
    pass

from app.schemas.course import CourseListResponse

class HomeFeaturedBatchResponse(HomeFeaturedBatchBase):
    id: int
    created_at: Optional[datetime] = None
    course: Optional[CourseListResponse] = None
    
    class Config:
        from_attributes = True
