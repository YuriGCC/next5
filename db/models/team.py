from sqlalchemy import Column, String, Integer, DateTime, ForeignKey
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from db.session import Base

# Teams managed by users
class Team(Base):
    __tablename__ = 'teams'

    id = Column(Integer, primary_key=True)
    name = Column(String(255), nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    # Foreign key to the user who created/manages the team.
    # If a user is deleted, their teams are also deleted.
    created_by_user_id = Column(Integer, ForeignKey('users.id'), nullable=False)
    created_by = relationship('User', back_populates='teams')

    players = relationship('Player', back_populates='team', cascade='all, delete-orphan')
    home_matches = relationship("Match", foreign_keys="Match.home_team_id", back_populates="home_team")
    away_matches = relationship("Match", foreign_keys="Match.away_team_id", back_populates="away_team")




