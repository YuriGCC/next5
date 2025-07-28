from sqlalchemy import Table, Column, ForeignKey, Integer
from api.config import Base

player_has_match = Table(
    'player_has_match',
    Base.metadata,
    Column('idplayer', ForeignKey('player.idplayer'), primary_key=True),
    Column('idmatch', ForeignKey('match.idmatch'), primary_key=True)
)