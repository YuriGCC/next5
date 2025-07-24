from ultralytics import YOLO
import cv2

model = YOLO('yolo11n.pt')
capture = cv2.VideoCapture("input_360p.mp4")

if not capture.isOpened():
    print("Error: Could not open video file.")

frame_width = int(capture.get(cv2.CAP_PROP_FRAME_WIDTH))
frame_height = int(capture.get(cv2.CAP_PROP_FRAME_HEIGHT))
frame_count = int(capture.get(cv2.CAP_PROP_FRAME_COUNT))
fps = capture.get(cv2.CAP_PROP_FPS)

fourcc = int(capture.get(cv2.CAP_PROP_FOURCC))
output_file = cv2.VideoWriter('output_video_360p.mp4',
                              fourcc, fps, (frame_width, frame_height))
ball_file = cv2.VideoWriter('ball_output_frames', fourcc, fps, (frame_width, frame_height))
while True:
    rep, frame = capture.read()
    result = model(frame)
    annoted_frame = result[0].plot()
    if not rep:
        break

   # for box in result.boxes:
        # if box.cls == BALL_ID:
            # ball_file.write(annoted_frame)

    # cv2_imshow(frame)
    output_file.write(annoted_frame)



capture.release()
output_file.release()
cv2.destroyAllWindows()