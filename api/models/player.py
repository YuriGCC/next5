from sqlalchemy.orm import Mapped, mapped_column, relationship
from sqlalchemy import String, JSON
from api.config import Base
from typing import List
from api.models.match import Match
from api.models.relationships import player_has_match

class Player(Base):
    __tablename__ = 'player'

    idplayer: Mapped[int] = mapped_column(primary_key=True)
    player_name: Mapped[str] = mapped_column(String(255), nullable=False)
    team_name: Mapped[str] = mapped_column(String(255), nullable=True)
    statistics: Mapped[dict] = mapped_column(JSON)

    matches: Mapped[List["Match"]] = relationship(
        "Match",
        secondary=player_has_match,
        back_populates="players"
    )
