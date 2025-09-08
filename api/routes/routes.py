from schemas.clip import VideoCutRequest, VideoClipRead
from db.models import match, clip
from fastapi import status, APIRouter, Depends
from db.session import Session, get_session

router = APIRouter()

@router.post(
    "/matches/{match_id}/cut",
    response_model=VideoClipRead,
    status_code=status.HTTP_202_ACCEPTED
)
async def create_video_clip(
        match_id: int,
        cut_request: VideoCutRequest,
        db: Session = Depends(get_session)
):
    """
    Accepts a request to cut a video clip from a match.
    This creates a clip record and starts a background job.
    """
    # 1. Encontra a partida original no banco
    db_match = db.query(Match).filter(Match.id == match_id).first()
    if not db_match:
        raise HTTPException(status_code=404, detail="Original match not found.")

    # (Adicione aqui a verificação de permissão do usuário)

    # 2. Cria um novo registro para o clipe no banco de dados
    new_clip = VideoClip(
        original_match_id=db_match.id,
        start_time_seconds=cut_request.start_time,
        end_time_seconds=cut_request.end_time,
        status='PENDING'  # Status inicial
    )
    db.add(new_clip)
    db.commit()
    db.refresh(new_clip)

    # 3. Dispara a tarefa em segundo plano (background task)
    # Aqui você chamaria sua função de corte com Celery ou outro executor
    # cut_video_task.delay(
    #     clip_id=new_clip.id,
    #     input_path=db_match.original_video_path,
    #     start_time=new_clip.start_time_seconds,
    #     end_time=new_clip.end_time_seconds
    # )

    logging.info(f"Clip job {new_clip.id} created for match {match_id}. Handing off to background worker.")

    # 4. Retorna imediatamente para o cliente com os detalhes do job
    return new_clip