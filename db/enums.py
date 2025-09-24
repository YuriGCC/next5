from enum import Enum

class AnalysisStatusEnum(str, Enum):
    PENDING = 'PENDING'      # Video uploaded, waiting in the queue to be processed.
    PROCESSING = 'PROCESSING'   # The AI model is currently analyzing the video.
    COMPLETED = 'COMPLETED'    # Processing finished successfully.
    FAILED = 'FAILED'        # An error occurred during processing.



class ClipStatusEnum(str, Enum):
    PENDING = 'PENDING'      # Video uploaded, waiting in the queue to be cut.
    PROCESSING = 'PROCESSING'   # Video is being cut.
    COMPLETED = 'COMPLETED'    # Cut finished successfully.
    FAILED = 'FAILED'        # An error occurred during cutting.


