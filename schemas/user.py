from pydantic import BaseModel, EmailStr
import datetime
from schemas.team import TeamRead


class UserBase(BaseModel):
    email: EmailStr
    full_name: str | None = None

class UserLogin(BaseModel):
    email: str
    password: str

class UserCreate(UserBase):
    password: str
    role: str | None = 'jogador'

class UserRead(UserBase):
    id: int
    role: str
    created_at: datetime.datetime
    teams: list[TeamRead] = []

    class Config:
        from_attributes = True
