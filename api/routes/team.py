from fastapi import APIRouter, Depends, HTTPException, Response
from schemas.team import TeamRead, TeamCreate, TeamEdit
from api.utils.auth import get_current_user, get_session, Session
from db.models import Team
from typing import List

router = APIRouter()

@router.get('/teams/', response_model=List[TeamRead])
def get_teams(current_user = Depends(get_current_user), db: Session = Depends(get_session)):
    teams = db.query(Team).filter(Team.created_by_user_id == current_user.id).all()
    return teams

@router.get('/team/{team_id}', response_model=TeamRead)
def get_team(team_id:int, db: Session = Depends(get_session), current_user = Depends(get_current_user)):

    team = db.query(Team).filter(Team.id == team_id).first()
    if not team:
        raise  HTTPException(status_code=404, detail='Team not found')

    if team.created_by_user_id != current_user.id:
        raise HTTPException(status_code=403, detail='Not authorized to access this team')

    return team

@router.post('/team/', response_model=TeamRead, status_code=201)
def create_team(team: TeamCreate, db: Session = Depends(get_session), current_user = Depends(get_current_user)):

    new_team = Team(
        name=team.name,
        created_by_user_id=current_user.id,
        created_at=team.created_at
    )

    db.add(new_team)
    db.commit()
    db.refresh(new_team)

    return new_team

@router.put('/team/{team_id}', response_model=TeamRead)
def edit_team(team_id: int,
              team_data: TeamEdit,
              db: Session = Depends(get_session),
              current_user = Depends(get_current_user)
              ):
    team = db.query(Team).filter(team_id == Team.id).first()

    if not team:
        raise  HTTPException(status_code=404, detail='Team not found')

    if team.created_by_user_id != current_user.id:
        raise HTTPException(status_code=403, detail='Not authorized to access this team')

    team.name = team_data.name
    db.commit()
    db.refresh(team)

    return team

@router.delete('/teams/{team_id}', status_code=204)
def delete_team(team_id: int, db:Session = Depends(get_session), current_user = Depends(get_current_user)):
    """
    Deletes a specific team.
    Ensures the team exists and belongs to the authenticated user.
    """

    team = db.query(Team).filter(team_id == Team.id).first()

    if not team:
        raise HTTPException(status_code=404, detail='Team not found')

    if team.created_by_user_id != current_user.id:
        raise HTTPException(status_code=403, detail='Not authorized to access this team')

    db.delete(team)
    db.commit()

    return Response(status_code=204)

