from fastapi import APIRouter, Depends, HTTPException, Response, status
from schemas.team import TeamRead, TeamCreate, TeamEdit
from api.utils.auth import get_current_user, get_session, Session, get_team_for_current_user
from schemas.player import  PlayerCreate, PlayerRead, PlayerUpdate
from db.models.player import Player
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

@router.delete('/team/{team_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_team(team_id: int, db:Session = Depends(get_session), current_user = Depends(get_current_user)):
    team = db.query(Team).filter(team_id == Team.id).first()

    if not team:
        raise HTTPException(status_code=404, detail='Team not found')

    if team.created_by_user_id != current_user.id:
        raise HTTPException(status_code=403, detail='Not authorized to access this team')

    db.delete(team)
    db.commit()

    return Response(status_code=204)

@router.post("/team/{team_id}/players/",
    response_model=PlayerRead,
    status_code=status.HTTP_201_CREATED)
def create_player_for_team(
        team_id: int,
        player_data: PlayerCreate,
        db: Session = Depends(get_session),
        team: Team = Depends(get_team_for_current_user)
):
    new_player = Player(**player_data.model_dump(), team_id=team.id)
    db.add(new_player)
    db.commit()
    db.refresh(new_player)
    return new_player

@router.get("/team/{team_id}/players/", response_model=List[PlayerRead])
def list_players_in_team(team_id: int, team: Team = Depends(get_team_for_current_user)):
    return team.players

@router.put("/team/{team_id}/players/{player_id}", response_model=PlayerRead)
def update_player(
        player_id: int,
        player_data: PlayerUpdate,
        db: Session = Depends(get_session),
        team: Team = Depends(get_team_for_current_user)
):

    player_to_update = (db.query(Player).
                        filter(Player.id == player_id,
                               Player.team_id == team.id).first())

    if not player_to_update:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Player not found for this team"
        )

    for key, value in player_data.model_dump().items():
        setattr(player_to_update, key, value)

    db.commit()
    db.refresh(player_to_update)
    return player_to_update

@router.delete(
    "/team/{team_id}/players/{player_id}",
    status_code=status.HTTP_204_NO_CONTENT
)
def delete_player(
        player_id: int,
        db: Session = Depends(get_session),
        team: Team = Depends(get_team_for_current_user)
):
    player_to_delete = (db.query(Player).
                        filter(Player.id == player_id,
                               Player.team_id == team.id).first())

    if not player_to_delete:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Jogador não encontrado neste time"
        )

    db.delete(player_to_delete)
    db.commit()
    return None