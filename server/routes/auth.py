from fastapi import Depends, FastAPI, HTTPException, Header
import uuid
import bcrypt
from fastapi import APIRouter
from middleware.auth_middleware import auth_middleware
from models.user import User
from pydantic_schemas.user_create import UserCreate
from database import get_db
from sqlalchemy.orm import Session, joinedload
import jwt
from pydantic_schemas.user_login import UserLogin
router = APIRouter()


@router.post("/signup", status_code=201)
def signup_user(user: UserCreate, db: Session = Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()
    if user_db:
        raise HTTPException(status_code=400, detail="User already exists")

    
    # Hash the password
    hashed_password = bcrypt.hashpw(user.password.encode(), bcrypt.gensalt())
    user_db = User(
        id=str(uuid.uuid4()),
        name=user.name,
        email=user.email,
        password=hashed_password
    )

    db.add(user_db)
    db.commit()
    db.refresh(user_db)

    return user_db


@router.post("/login")
def login_user(user: UserLogin, db: Session = Depends(get_db)):
    user_db = db.query(User).filter(User.email == user.email).first()

    if not user_db:
        raise HTTPException(status_code=400, detail="Invalid credentials: user not found")

    # Check the password
    if not bcrypt.checkpw(user.password.encode(), user_db.password):
        raise HTTPException(status_code=400, detail="Invalid password")

    token = jwt.encode({'id': user_db.id}, 'password_key')
    print(token)
    return {'token': token , 'user':user_db}


@router.get("/")
def current_user_data(db: Session = Depends(get_db), user_dict = Depends(auth_middleware)):
    user_db = db.query(User).filter(User.id == user_dict['uid']).options(
        joinedload(User.favourites)
    ).first()
    if not user_db:
        raise HTTPException(status_code=401, detail="User not found")
    return user_db