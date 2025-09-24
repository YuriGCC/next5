from db.session import Base
from sqlalchemy.orm import relationship
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey
from  sqlalchemy.sql import func

# Players belong to a team
class Player(Base):
    __tablename__ = 'players'

    id = Column(Integer, primary_key=True)
    full_name = Column(String(255), nullable=False)
    jersey_number = Column(Integer)
    position = Column(String(50))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    team_id = Column(Integer, ForeignKey('teams.id'), nullable=False)
    team = relationship('Team', back_populates='players')
    statistics = relationship("MatchStatistics", back_populates="player", cascade="all, delete-orphan")

