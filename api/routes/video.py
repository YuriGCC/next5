import os
import shutil
import uuid
from fastapi import APIRouter, UploadFile, File, HTTPException, status
from pathlib import Path
from fastapi.responses import FileResponse

UPLOAD_DIR = Path("temp_uploads")
UPLOAD_DIR.mkdir(exist_ok=True)

router = APIRouter()

@router.post("/video/upload/", status_code=status.HTTP_201_CREATED)
async def upload_video(video: UploadFile = File(...)):
    """
    Receives a video file, saves it locally with a unique name,
    and returns metadata. This should trigger the background tasks.
    """

    # Validates the file type (MIME type)
    if not video.content_type.startswith("video/"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="Invalid file type. Please upload a video file."
        )


    # Generate a unique name to the file
    file_extension = Path(video.filename).suffix
    unique_filename = f"{uuid.uuid4()}{file_extension}"
    save_path = UPLOAD_DIR / unique_filename

    # Save the file in chunks
    try:
        # Writes in binary mode
        with open(save_path, "wb") as buffer:
            shutil.copyfileobj(video.file, buffer)

    except Exception as e:
        # In case of an error when saving, remove the partial file if it exists
        if save_path.exists():
            os.remove(save_path)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail=f"Could not save file: {e}"
        )

    #

    return {
        "message": "Video uploaded successfully.",
    }

@router.get("/videos/{video_filename}")
async def get_video(video_filename: str):
    """
    Serves a video file for streaming/download.
    """

    video_path = Path("processed_videos") / video_filename

    if not video_path.exists():
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="Video not found."
        )

    return FileResponse(path=video_path, media_type="video/mp4", filename=f"analysis_{video_filename}")
