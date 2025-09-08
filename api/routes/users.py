from fastapi import APIRouter, Depends, HTTPException, status
from db.session import Session, get_session
from api.utils.auth import hash_password, verify_password, create_access_token
from schemas.user import UserCreate, UserRead
from db.models.user import User

router = APIRouter()


@router.post('/register', response_model=UserRead, status_code=status.HTTP_21_CREATED)
def register_user(user_data: UserCreate, db: Session = Depends(get_session)):

    db_user = db.query(User).filter(User.email == user_data.email).first()

    if db_user:
        raise HTTPException(status_code=400, detail='Email already registered.')

    hashed_password = hash_password(user_data.password)

    new_user = User(
        email=user_data.email,
        full_name=user_data.full_name,
        hashed_password=hashed_password,
        role=user_data.role
    )

    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    return new_user

@router.post('/login')
def login(user_in: UserCreate, db: Session = Depends(get_session)):
    user = db.query(User).filter(User.email == user_in.email).first()

    if not user or not verify_password(user_in.password, user.hashed_password):
        raise HTTPException(status_code=401, detail='Credenciais Inválidas')

    token = create_access_token(data={'sub': user.email})

    return {'access_token': token, 'token_type': 'bearer'}