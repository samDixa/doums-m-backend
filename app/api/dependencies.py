from fastapi import Depends, HTTPException, status
from typing import Optional
from fastapi.security import OAuth2PasswordBearer
from jose import jwt, JWTError
from pydantic import ValidationError
from sqlalchemy.orm import Session

from app.core import security
from app.core.config import settings
from app.core.database import get_db
from app.models.user import User, UserActivity
from app.schemas.user import TokenPayload

# Make sure this matches the login endpoint exact path!
reusable_oauth2 = OAuth2PasswordBearer(
    tokenUrl=f"{settings.API_V1_STR}/auth/login"
)

def get_current_user( 
    db: Session = Depends(get_db), token: str = Depends(reusable_oauth2)
) -> User:
    try:
        payload = jwt.decode(
            token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM]
        )
        token_data = TokenPayload(**payload)
    except (JWTError, ValidationError):
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Could not validate credentials",
        )
    # The subject in our token is the user id
    user = db.query(User).filter(User.id == int(token_data.sub)).first()
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return user
    
def get_optional_current_user(
    db: Session = Depends(get_db), 
    token: Optional[str] = Depends(lambda: None) # Default to None
) -> Optional[User]:
    # We need to manually handle the token because OAuth2PasswordBearer throws 401 if missing
    # But wait, there's a better way: check the Authorization header
    return None

# Let's try a better approach: detect token from request Header manually
from fastapi import Request
async def get_optional_user(
    request: Request,
    db: Session = Depends(get_db)
) -> Optional[User]:
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith("Bearer "):
        return None
    
    token = auth_header.split(" ")[1]
    try:
        payload = jwt.decode(
            token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM]
        )
        token_data = TokenPayload(**payload)
        user = db.query(User).filter(User.id == int(token_data.sub)).first()
        return user
    except (JWTError, ValidationError):
        return None

def get_current_admin_user(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db)
) -> User:
    from app.models.user import UserCredential
    cred = db.query(UserCredential).filter(UserCredential.user_id == current_user.id).first()
    if not cred or not cred.is_superuser:
        raise HTTPException(status_code=403, detail="The user doesn't have enough privileges")
    return current_user

def log_activity(
    db: Session,
    user_id: int,
    activity_type: str,
    description: str = None,
    metadata_json: dict = None
):
    activity = UserActivity(
        user_id=user_id,
        activity_type=activity_type,
        description=description,
        metadata_json=metadata_json
    )
    db.add(activity)
    db.commit()
