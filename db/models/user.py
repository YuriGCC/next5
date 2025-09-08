from sqlalchemy import Column, String, Integer, DateTime
from sqlalchemy.sql import func
from sqlalchemy.orm import relationship
from db.session import Base

# Table for user authentication and information.
class User(Base):
    __tablename__ = 'users'

    id = Column(Integer, primary_key=True)
    email = Column(String(255), unique=True, nullable=False, index=True)
    hashed_password = Column(String(255), nullable=False)
    full_name = Column(String(255))
    role = Column(String(255), default='player')

    created_at = Column(
        DateTime(timezone=True),
        server_default=func.now()
    )

    teams = relationship('Team', back_populates='created_by', cascade='all, delete-orphan')
    matches = relationship('Match', back_populates='uploaded_by')