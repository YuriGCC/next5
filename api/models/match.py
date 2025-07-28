from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import DateTime
from api.config import Base
from typing import List
from api.models.player import Player
from api.models.relationships import player_has_match

class Match(Base):
    __tablename__ = 'match'

    idmatch: Mapped[int] = mapped_column(primary_key=True)
    date_time_start: Mapped[DateTime] = mapped_column(nullable=False)
    date_time_end: Mapped[DateTime] = mapped_column(nullable=False)

    players: Mapped[List["Player"]] = relationship(
        "Player",
        secondary=player_has_match,
        back_populates="matches"
    )