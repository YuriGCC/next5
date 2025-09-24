from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List
from db.session import get_session
from db.models.team import Team
from db.models.player import Player
from schemas.player import  PlayerCreate, PlayerRead, PlayerUpdate
from api.utils.auth import get_team_for_current_user

router = APIRouter()

@router.post("/teams/{team_id}/players/", response_model=PlayerRead, status_code=status.HTTP_201_CREATED)
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


@router.get("/teams/{team_id}/players/", response_model=List[PlayerRead])
def list_players_in_team(
        team_id: int,
        team: Team = Depends(get_team_for_current_user)
):

    return team.players


@router.put("/teams/{team_id}/players/{player_id}", response_model=PlayerRead)
def update_player(
        player_id: int,
        player_data: PlayerUpdate,
        db: Session = Depends(get_session),
        team: Team = Depends(get_team_for_current_user)
):

    player_to_update = db.query(Player).filter(Player.id == player_id, Player.team_id == team.id).first()

    if not player_to_update:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Player not found for this team")

    for key, value in player_data.model_dump().items():
        setattr(player_to_update, key, value)

    db.commit()
    db.refresh(player_to_update)
    return player_to_update


# DELETE
@router.delete("/teams/{team_id}/players/{player_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_player(
        player_id: int,
        db: Session = Depends(get_session),
        team: Team = Depends(get_team_for_current_user)  # Valida o time
):
    """
    Deleta um jogador específico de um time.
    """
    player_to_delete = db.query(Player).filter(Player.id == player_id, Player.team_id == team.id).first()

    if not player_to_delete:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Jogador não encontrado neste time")

    db.delete(player_to_delete)
    db.commit()
    return None