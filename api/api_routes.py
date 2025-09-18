from fastapi import APIRouter
from api.routes import match, player, team, user, video

api_router = APIRouter()

api_router.include_router(match.router, tags=["Match"])
api_router.include_router(user.router, tags=["User"])
api_router.include_router(video.router, tags=["Video"])