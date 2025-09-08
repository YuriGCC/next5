from pydantic import BaseModel
import datetime
from schemas.player import PlayerRead

class TeamBase(BaseModel):
    name: str

class TeamCreate(TeamBase):
    pass


class TeamRead(TeamBase):
    id: int
    created_by_user_id: int
    created_at: datetime.datetime
    players: list[PlayerRead] = []

    class Config:
        from_attributes = True