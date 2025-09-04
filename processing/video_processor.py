import cv2
from ultralytics import YOLO
import logging

# Basic logging setup to track progress and potential errors
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')


class VideoProcessor:
    """
    A class to encapsulate video processing logic.

    This class handles opening, reading, processing frame-by-frame,
    and saving a new video with annotations from the AI model.
    """

    def __init__(self, model: YOLO):
        """
        Initializes the video processor.

        Args:
            model (YOLO): The pre-loaded YOLOv8 model instance.
        """
        self.model = model
        self.cap = None
        self.video_info = {}
        self.writer = None

    def _load_video_info(self):
        """Private method to load information from the input video."""
        if not self.cap.isOpened():
            raise IOError(f"Could not open the video file.")

        self.video_info['width'] = int(self.cap.get(cv2.CAP_PROP_FRAME_WIDTH))
        self.video_info['height'] = int(self.cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
        self.video_info['fps'] = self.cap.get(cv2.CAP_PROP_FPS)
        self.video_info['frame_count'] = int(self.cap.get(cv2.CAP_PROP_FRAME_COUNT))
        logging.info(
            f"Video loaded successfully: {self.video_info['width']}x{self.video_info['height']} @ {self.video_info['fps']:.2f} FPS")

    def _setup_writer(self, output_path: str):
        """Sets up the VideoWriter object to save the output video."""
        fourcc = cv2.VideoWriter_fourcc(*'mp4v')  # Codec for .mp4
        self.writer = cv2.VideoWriter(
            output_path,
            fourcc,
            self.video_info['fps'],
            (self.video_info['width'], self.video_info['height'])
        )
        logging.info(f"Output file configured at: {output_path}")

    def process_video(self, input_path: str, output_path: str):
        """
        Processes the input video and saves the result.

        Args:
            input_path (str): Path to the input video file.
            output_path (str): Path to save the processed video file.
        """
        self.cap = cv2.VideoCapture(input_path)
        try:
            self._load_video_info()
            self._setup_writer(output_path)

            frame_num = 0
            while self.cap.isOpened():
                ret, frame = self.cap.read()
                if not ret:
                    break  # End of video

                # Perform detection on the frame
                results = self.model(frame)

                # Get the frame with annotations (bounding boxes)
                annotated_frame = results[0].plot()

                # Write the processed frame to the output file
                self.writer.write(annotated_frame)

                frame_num += 1
                if frame_num % 100 == 0:  # Log every 100 frames
                    progress = (frame_num / self.video_info['frame_count']) * 100
                    logging.info(f"Progress: {progress:.2f}% ({frame_num}/{self.video_info['frame_count']} frames)")

            logging.info("Video processing completed successfully.")

        except Exception as e:
            logging.error(f"An error occurred during processing: {e}")
        finally:
            self._cleanup()

    def _cleanup(self):
        """Releases video resources."""
        if self.cap:
            self.cap.release()
        if self.writer:
            self.writer.release()
        cv2.destroyAllWindows()
        logging.info("Video resources released.")