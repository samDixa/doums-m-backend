from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
from app.core.database import get_db
from app.models.home import HomeCategory, HomeBanner, Category, SubCategory, HomeFeaturedBatch
from app.schemas.home import (
    HomeCategoryResponse, BannerResponse,
    CategoryResponse, SubCategoryResponse, SubCategoryDetailResponse,
    HomeFeaturedBatchResponse
)
from app.schemas.course import CourseListResponse

router = APIRouter()

# ... (previous endpoints)

@router.get("/featured-batches", response_model=List[HomeFeaturedBatchResponse])
def get_featured_batches(db: Session = Depends(get_db)):
    """
    Get all active featured batches (courses) for the home screen carousel.
    """
    featured = db.query(HomeFeaturedBatch)\
        .filter(HomeFeaturedBatch.is_active == True)\
        .order_by(HomeFeaturedBatch.sequence.asc()).all()
    
    return featured

@router.get("/categories", response_model=List[HomeCategoryResponse])
def get_home_categories(
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 100
):
    """
    Get all active home categories for the 'Domus Homoeopathica' section.
    """
    categories = db.query(HomeCategory)\
        .filter(HomeCategory.is_active == True)\
        .order_by(HomeCategory.sequence.asc())\
        .offset(skip).limit(limit).all()
    return categories
@router.get("/banners", response_model=List[BannerResponse])
def get_banners(
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 3
):
    """
    Get all active home banners for the carousel.
    """
    banners = db.query(HomeBanner)\
        .filter(HomeBanner.is_active == True)\
        .order_by(HomeBanner.sequence.asc())\
        .offset(skip).limit(limit).all()
    return banners

@router.get("/app_categories", response_model=List[CategoryResponse])
def get_app_categories(db: Session = Depends(get_db)):
    """
    Get all top-level level 1 categories (max 5 expected).
    """
    return db.query(Category).filter(Category.is_active == True).order_by(Category.sequence.asc()).all()

@router.get("/app_categories/{category_id}/sub_categories", response_model=List[SubCategoryResponse])
def get_app_sub_categories(category_id: int, db: Session = Depends(get_db)):
    """
    Get all subcategories (icons) under a specific top-level category.
    """
    return db.query(SubCategory).filter(
        SubCategory.category_id == category_id,
        SubCategory.is_active == True
    ).order_by(SubCategory.sequence.asc()).all()

@router.get("/app_sub_category/{sub_category_id}", response_model=SubCategoryDetailResponse)
def get_app_sub_category_detail(sub_category_id: int, db: Session = Depends(get_db)):
    """
    Get detail of a subcategory including its lectures, notes, and tests.
    """
    subcategory = db.query(SubCategory).filter(
        SubCategory.id == sub_category_id,
        SubCategory.is_active == True
    ).first()
    
    if not subcategory:
        raise HTTPException(status_code=404, detail="Subcategory not found")
        
    return subcategory
