from db.session import Base
from sqlalchemy import Column, Integer, ForeignKey, String, Enum as SQLEnum, REAL, DateTime
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from db.enums import ClipStatusEnum

# Table to store information about video clips
class VideoClip(Base):
    __tablename__ = "video_clips"

    id = Column(Integer, primary_key=True)

    # Link to the original match
    original_match_id = Column(Integer, ForeignKey("matches.id", ondelete="CASCADE"), nullable=False)
    clip_path = Column(String)

    status = Column(SQLEnum(ClipStatusEnum), default=ClipStatusEnum.PENDING, nullable=False)
    start_time_seconds = Column(REAL, nullable=False)

    end_time_seconds = Column(REAL, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())

    original_match = relationship("Match", back_populates="clips")