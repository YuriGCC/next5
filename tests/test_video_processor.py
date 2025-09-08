import pytest
from unittest.mock import MagicMock, patch
import numpy as np
import cv2
import os

from processing.video_processor import VideoProcessor

""" Setup methods """

@pytest.fixture
def mock_yolo_model():
    """
    Creates a mock YOLO model.
    This avoids loading the real, heavy model during tests.

    """
    model = MagicMock()
    # We simulate the model's output. The plot() method should return a fake image (numpy array).
    mock_result = MagicMock()
    mock_result.plot.return_value = np.zeros((100, 100, 3), dtype=np.uint8) # A black frame
    model.return_value = [mock_result] # model(frame) will return this
    return model

@pytest.fixture
def video_processor(mock_yolo_model):
    """
    Creates an instance of VideoProcessor with the mock model.
    This instance will be used in the test functions.
    """
    return VideoProcessor(model=mock_yolo_model)

def create_dummy_video(path, width=128, height=72, duration_sec=1, fps=30):
    """Helper function to create a real, small video file for testing I/O."""
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    writer = cv2.VideoWriter(path, fourcc, fps, (width, height))
    for _ in range(duration_sec * fps):
        frame = np.random.randint(0, 255, (height, width, 3), dtype=np.uint8)
        writer.write(frame)
    writer.release()


""" Test methods """

def test_cut_video_successful(video_processor, tmp_path):
    """
    Tests if the cut_video method correctly creates a shorter video file.
    'tmp_path' is a pytest fixture that provides a temporary directory.
    """
    # 1. Arrange: Set up the test conditions
    input_dir = tmp_path / "input"
    output_dir = tmp_path / "output"
    input_dir.mkdir()
    output_dir.mkdir()

    input_video_path = str(input_dir / "test.mp4")
    output_video_path = str(output_dir / "cut.mp4")

    # Create a dummy 2-second video at 10 FPS (20 frames total)
    create_dummy_video(input_video_path, duration_sec=2, fps=10)

    # 2. Act: Call the method we are testing
    video_processor.cut_video(input_video_path, output_video_path, start_time=0.5, end_time=1.5)

    # 3. Assert: Check if the result is correct
    assert os.path.exists(output_video_path) # Did it create the file?

    # Verify the output video's properties
    cap = cv2.VideoCapture(output_video_path)
    assert cap.isOpened()
    frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    # Expected frames: (1.5s - 0.5s) * 10 FPS = 10 frames
    assert frame_count == 10
    cap.release()

def test_process_video_calls_model_and_writes_frames(video_processor, mocker, tmp_path):
    """
    Tests if process_video correctly uses the model and writes frames.
    Here, we mock cv2 functions to avoid real file I/O.
    """

    # 1. Arrange
    input_path = "fake_input.mp4"
    output_path = str(tmp_path / "fake_output.mp4")

    # Mock the cv2 VideoCapture and VideoWriter
    # We make VideoCapture produce 3 fake frames
    mock_frame = np.zeros((100, 100, 3), dtype=np.uint8)
    mocker.patch('cv2.VideoCapture').return_value.read.side_effect = [(True, mock_frame), (True, mock_frame), (True, mock_frame), (False, None)]
    mocker.patch('cv2.VideoCapture').return_value.isOpened.return_value = True
    mock_writer = mocker.patch('cv2.VideoWriter')

    # 2. Act
    video_processor.process_video(input_path, output_path)

    # 3. Assert
    # Was the model called once for each of the 3 frames?
    assert video_processor.model.call_count == 3
    # Was the writer's write method called for each frame?
    assert mock_writer().write.call_count == 3