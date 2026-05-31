from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional

from app.api.dependencies import get_current_user
from app.core.database import get_db
from app.models.user import User
from app.models.test import Test, Question, TestQuestion, TestGroup, TestAttempt, UserAnswer, UserGlobalPerformance
from app.schemas.test import (
    TestListResponse, TestDetailResponse, QuestionDetailResponse, 
    TestSubmitRequest, TestAttemptResponse, TestGroupBase, TestGroupDetailResponse
)

router = APIRouter()

@router.get("/", response_model=List[TestListResponse])
def list_tests(
    db: Session = Depends(get_db),
    skip: int = 0,
    limit: int = 100,
    current_user: User = Depends(get_current_user)
):
    """
    List active tests.
    """
    tests = db.query(Test).filter(Test.is_active == True).offset(skip).limit(limit).all()
    return tests

@router.get("/groups", response_model=List[TestGroupBase])
def list_test_groups(
    parent_id: Optional[int] = None,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    List test groups, optionally filtered by parent_id.
    """
    query = db.query(TestGroup).filter(TestGroup.is_active == True)
    if parent_id:
        query = query.filter(TestGroup.parent_id == parent_id)
    else:
        query = query.filter(TestGroup.parent_id == None)
    return query.order_by(TestGroup.sequence).all()

@router.get("/groups/{group_id}", response_model=TestGroupDetailResponse)
def get_test_group(
    group_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get test group details including nested children and tests.
    """
    group = db.query(TestGroup).filter(TestGroup.id == group_id, TestGroup.is_active == True).first()
    if not group:
        raise HTTPException(status_code=404, detail="Test group not found")
    return group

@router.get("/{test_id}", response_model=TestDetailResponse)
def get_test(
    test_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get test details.
    """
    test = db.query(Test).filter(Test.id == test_id, Test.is_active == True).first()
    if not test:
        raise HTTPException(status_code=404, detail="Test not found")
    return test

@router.get("/{test_id}/questions", response_model=List[QuestionDetailResponse])
def get_test_questions(
    test_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get test questions.
    """
    test_questions = db.query(TestQuestion).filter(TestQuestion.test_id == test_id).order_by(TestQuestion.sequence).all()
    questions = [tq.question for tq in test_questions]
    return questions

@router.post("/{test_id}/start", response_model=TestAttemptResponse)
def start_test(
    test_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Start a new test attempt.
    """
    test = db.query(Test).filter(Test.id == test_id).first()
    if not test:
        raise HTTPException(status_code=404, detail="Test not found")
        
    attempts_count = db.query(TestAttempt).filter(
        TestAttempt.user_id == current_user.id,
        TestAttempt.test_id == test_id
    ).count()
    
    if not test.reattempt_allowed and attempts_count > 0:
        raise HTTPException(status_code=400, detail="Reattempt not allowed for this test")
        
    attempt = TestAttempt(
        user_id=current_user.id,
        test_id=test_id,
        attempt_number=attempts_count + 1,
        score=0,
        accuracy=0.0
    )
    db.add(attempt)
    db.commit()
    db.refresh(attempt)
    return attempt

@router.post("/{test_id}/submit", response_model=TestAttemptResponse)
def submit_test(
    test_id: int,
    attempt_id: int, # passed as query param for simplicity, or we can look up last attempt
    submit_in: TestSubmitRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Submit test answers and calculate score.
    """
    attempt = db.query(TestAttempt).filter(TestAttempt.id == attempt_id, TestAttempt.user_id == current_user.id).first()
    if not attempt or attempt.test_id != test_id:
        raise HTTPException(status_code=404, detail="Valid test attempt not found")
        
    if attempt.submitted_at:
        raise HTTPException(status_code=400, detail="Test already submitted")
        
    test = attempt.test
    score = 0
    correct_count = 0
    total_answered = len(submit_in.answers)
    
    positive_marks = test.positive_marks or 1
    negative_marks = test.negative_marks or 0

    from datetime import datetime
    
    for answer_in in submit_in.answers:
        question = db.query(Question).filter(Question.id == answer_in.question_id).first()
        is_correct = False
        if question and question.correct_option == answer_in.selected_option:
            is_correct = True
            correct_count += 1
            score += positive_marks
        else:
            score -= negative_marks
            
        user_answer = UserAnswer(
            test_attempt_id=attempt.id,
            question_id=answer_in.question_id,
            selected_option=answer_in.selected_option,
            is_correct=is_correct,
            time_spent=answer_in.time_spent
        )
        db.add(user_answer)
        
    attempt.submitted_at = datetime.utcnow()
    attempt.time_taken_seconds = submit_in.time_taken_seconds
    attempt.score = score
    attempt.accuracy = (correct_count / total_answered * 100) if total_answered > 0 else 0.0
    db.add(attempt)
    
    # Update global performance
    perf = db.query(UserGlobalPerformance).filter(UserGlobalPerformance.user_id == current_user.id).first()
    if not perf:
        perf = UserGlobalPerformance(user_id=current_user.id)
        db.add(perf)
        db.commit() # ensure it exists
    
    perf.tests_attempted += 1
    if attempt.submitted_at:
        perf.tests_completed += 1
    perf.total_score += score
    perf.total_questions += total_answered
    # avg_accuracy calculation logic here would be a running average, simplifying for now
    perf.global_score += score 
    db.add(perf)

    db.commit()
    db.refresh(attempt)
    return attempt

@router.get("/{test_id}/analysis/{attempt_id}")
def get_attempt_analysis(
    test_id: int,
    attempt_id: int,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user)
):
    """
    Get detailed analysis for a specific test attempt.
    """
    attempt = db.query(TestAttempt).filter(TestAttempt.id == attempt_id, TestAttempt.user_id == current_user.id).first()
    if not attempt or attempt.test_id != test_id:
        raise HTTPException(status_code=404, detail="Valid test attempt not found")
        
    answers = db.query(UserAnswer).filter(UserAnswer.test_attempt_id == attempt_id).all()
    # In real app, build a detailed payload
    return {
        "score": attempt.score,
        "accuracy": attempt.accuracy,
        "answers": answers,
        "time_taken": attempt.time_taken_seconds
    }

