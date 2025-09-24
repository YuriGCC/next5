from fastapi import APIRouter
from api.routes import match, team, video, user

api_router = APIRouter()

api_router.include_router(match.router, tags=['Match'])
api_router.include_router(user.auth_router, tags=['User'])
api_router.include_router(user.public_router, tags=['User', 'Authentication not required'])
api_router.include_router(video.router, tags=['Video'])
api_router.include_router(team.router, prefix='/auth' ,tags=['Team'])