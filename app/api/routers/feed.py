from fastapi import APIRouter, Depends, HTTPException, Body
from sqlalchemy.orm import Session
from datetime import datetime
from typing import Dict, Any, Optional
from app.api.dependencies import get_current_user, get_optional_user
from app.core.database import get_db
from app.models.user import User
from app.models.test import Question, DailyMCQVote
from app.models.other import Article
from app.schemas.test import QuestionDetailResponse
from app.schemas.notification import ArticleResponse
from sqlalchemy import func

router = APIRouter()

@router.get("/mcq-of-the-day", response_model=QuestionDetailResponse)
def get_mcq_of_the_day(
    db: Session = Depends(get_db),
    current_user: Optional[User] = Depends(get_optional_user)
):
    """
    Get the MCQ of the day with live polling statistics.
    """
    # Fetch the latest question marked as daily.
    question = db.query(Question).filter(Question.is_daily_mcq == True, Question.is_active == True).order_by(Question.updated_at.desc()).first()
    
    if not question:
        # Fallback to a random question if none is specifically marked for today
        question = db.query(Question).filter(Question.is_active == True).order_by(func.random()).first()
        
    if not question:
        raise HTTPException(status_code=404, detail="No MCQ available")

    # Calculate selection stats
    total_votes = db.query(DailyMCQVote).filter(DailyMCQVote.question_id == question.id).count()
    option_stats = {"A": 0.0, "B": 0.0, "C": 0.0, "D": 0.0}
    if total_votes > 0:
        votes_per_option = db.query(
            DailyMCQVote.selected_option, 
            func.count(DailyMCQVote.id)
        ).filter(DailyMCQVote.question_id == question.id).group_by(DailyMCQVote.selected_option).all()
        
        for option, count in votes_per_option:
            if option in option_stats:
                option_stats[option] = round((count / total_votes) * 100, 1)

    # Check if this user has already voted
    selected_option = None
    if current_user:
        user_vote = db.query(DailyMCQVote).filter(
            DailyMCQVote.user_id == current_user.id,
            DailyMCQVote.question_id == question.id
        ).first()
        selected_option = user_vote.selected_option if user_vote else None

    # Return as a dictionary to include the calculated stats and correct_option
    return {
        "id": question.id,
        "question_text": question.question_text,
        "option_a": question.option_a,
        "option_b": question.option_b,
        "option_c": question.option_c,
        "option_d": question.option_d,
        "description": question.description,
        "subject": question.subject,
        "topic": question.topic,
        "correct_option": question.correct_option,
        "selected_option": selected_option,
        "option_stats": option_stats
    }

@router.post("/mcq-of-the-day/vote")
def submit_mcq_vote(
    vote_data: Dict[str, Any] = Body(...),
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Submit or update a vote for the daily MCQ.
    """
    question_id = vote_data.get("question_id")
    selected_option = vote_data.get("selected_option")

    if not question_id or not selected_option:
        raise HTTPException(status_code=400, detail="Missing question_id or selected_option")

    # Check if a vote already exists from this user for this question
    existing_vote = db.query(DailyMCQVote).filter(
        DailyMCQVote.user_id == current_user.id,
        DailyMCQVote.question_id == question_id
    ).first()

    if existing_vote:
        existing_vote.selected_option = selected_option
    else:
        new_vote = DailyMCQVote(
            user_id=current_user.id,
            question_id=question_id,
            selected_option=selected_option
        )
        db.add(new_vote)
    
    db.commit()
    
    # Calculate updated selection stats to return immediately
    total_votes = db.query(DailyMCQVote).filter(DailyMCQVote.question_id == question_id).count()
    option_stats = {"A": 0.0, "B": 0.0, "C": 0.0, "D": 0.0}
    if total_votes > 0:
        votes_per_option = db.query(
            DailyMCQVote.selected_option, 
            func.count(DailyMCQVote.id)
        ).filter(DailyMCQVote.question_id == question_id).group_by(DailyMCQVote.selected_option).all()
        
        for option, count in votes_per_option:
            if option in option_stats:
                option_stats[option] = round((count / total_votes) * 100, 1)

    return {
        "status": "success", 
        "message": "Vote recorded",
        "selected_option": selected_option,
        "option_stats": option_stats
    }

@router.get("/clinical-case-week", response_model=ArticleResponse)
def get_clinical_case_of_the_week(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get the clinical case of the week.
    """
    article = db.query(Article).filter(
        Article.is_clinical_case == True, 
        Article.is_published == True
    ).order_by(Article.created_at.desc()).first()
    
    if not article:
        raise HTTPException(status_code=404, detail="No clinical case available")
        
    return article
