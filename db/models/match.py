from sqlalchemy import (
    Column, Integer, String, DateTime, Enum as SQLEnum,
    ForeignKey, REAL, Date, UniqueConstraint
)
from sqlalchemy.orm import relationship
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.sql import func

from db.session import Base
from db.enums import AnalysisStatusEnum

# The central table for matches, which are uploaded by users for analysis.
class Match(Base):
    __tablename__ = "matches"

    id = Column(Integer, primary_key=True)
    title = Column(String(255), nullable=False)
    match_date = Column(Date)
    uploaded_by_user_id = Column(Integer, ForeignKey("users.id"), nullable=False)

    # Optional foreign keys to link the match to pre-registered teams
    home_team_id = Column(Integer, ForeignKey("teams.id"))
    away_team_id = Column(Integer, ForeignKey("teams.id"))

    original_video_path = Column(String, nullable=False)
    processed_video_path = Column(String)

    # The current status of the AI analysis job for this match
    status = Column(SQLEnum(AnalysisStatusEnum), default=AnalysisStatusEnum.PENDING, nullable=False)
    upload_timestamp = Column(DateTime(timezone=True), server_default=func.now())
    processing_completed_timestamp = Column(DateTime(timezone=True))

    uploaded_by = relationship("User", back_populates="matches")
    home_team = relationship("Team", foreign_keys=[home_team_id], back_populates="home_matches")
    away_team = relationship("Team", foreign_keys=[away_team_id], back_populates="away_matches")
    statistics = relationship("MatchStatistics", back_populates="match", cascade="all, delete-orphan")
    clips = relationship("VideoClip", back_populates="original_match", cascade="all, delete-orphan")

# Statistics related to the match
class MatchStatistics(Base):
    __tablename__ = "match_statistics"
    __table_args__ = (UniqueConstraint('match_id', 'player_id', name='_match_player_uc'),)

    id = Column(Integer, primary_key=True)
    match_id = Column(Integer, ForeignKey("matches.id"), nullable=False)
    player_id = Column(Integer, ForeignKey("players.id"), nullable=False)

    # == Relational Columns for Core, Frequently Queried Metrics ==

    # Offensive Stats
    total_shots = Column(Integer, default=0)
    shots_on_target = Column(Integer, default=0)
    goals = Column(Integer, default=0)
    successful_dribbles = Column(Integer, default=0)

    # Passing Stats
    total_passes = Column(Integer, default=0)
    completed_passes = Column(Integer, default=0)
    assists = Column(Integer, default=0)

    # Defensive Stats
    interceptions = Column(Integer, default=0)

    # Physical Stats
    total_distance_meters = Column(REAL)
    max_speed_kmh = Column(REAL)

    # == Non-Relational Column for Flexible Data ==
    extra_stats = Column(JSONB)

    match = relationship("Match", back_populates="statistics")
    player = relationship("Player", back_populates="statistics")
