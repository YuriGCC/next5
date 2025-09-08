from pydantic import BaseModel, model_validator
import datetime
from db.enums import ClipStatusEnum


class VideoCutRequest(BaseModel):
    start_time: float
    end_time: float

    @model_validator(mode='after')
    def end_time_must_be_after_start_time(self) -> 'VideoCutRequest':
        if self.start_time is not None and self.end_time is not None:
            if self.start_time >= self.end_time:
                raise ValueError('End time must be after start time.')

        return self


class VideoClipRead(BaseModel):
    id: int
    original_match_id: int
    status: ClipStatusEnum = ClipStatusEnum.PENDING
    start_time_seconds: float
    end_time_seconds: float
    created_at: datetime.datetime

    class Config:
        from_attributes = True