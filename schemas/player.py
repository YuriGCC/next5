from pydantic import BaseModel
import datetime

class PlayerBase(BaseModel):
    full_name: str
    jersey_number: int
    position: str | None = None

class PlayerUpdate(PlayerBase):
    pass

class PlayerCreate(PlayerBase):
    pass

class PlayerRead(PlayerBase):
    id: int
    team_id: int
    created_at: datetime.datetime

    class Config:
        from_attributes = True