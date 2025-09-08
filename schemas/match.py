from pydantic import BaseModel
import datetime
from typing import Any
from db.enums import AnalysisStatusEnum
from schemas.team import TeamRead

class MatchStatisticsBase(BaseModel):
    total_shots: int = 0
    shots_on_target: int = 0
    goals: int = 0
    successful_dribbles: int = 0
    total_passes: int = 0
    completed_passes: int = 0
    assists: int = 0
    interceptions: int = 0
    total_distance_meters: float | None = None
    max_speed_kmh: float | None = None
    extra_stats: dict[str, Any] | None = None # O campo JSONB vira um dicionário

class MatchStatisticsRead(MatchStatisticsBase):
    id: int
    player_id: int

    class Config:
        from_attributes = True


class MatchBase(BaseModel):
    title: str
    match_date: datetime.date | None = None

class MatchRead(MatchBase):
    id: int
    uploaded_by_user_id: int
    status: AnalysisStatusEnum
    upload_timestamp: datetime.datetime
    home_team: TeamRead | None = None
    away_team: TeamRead | None = None
    statistics: list[MatchStatisticsRead] = []

    class Config:
        from_attributes = True