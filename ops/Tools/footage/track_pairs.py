"""Track every frame of a video with MediaPipe Pose (up to 2 people) -> <out>.npz   (Claude, S4a move script, 2026-09-14)
usage: python track_pairs.py <video> <out.npz> [start_s] [end_s]
Saved arrays (F frames, P=2 poses, 33 landmarks):
  t (F,) seconds; img (F,P,33,5) x, y (pixels), z, visibility, presence; world (F,P,33,3) metres, hip-centred;
  n (F,) poses found; fps; size (w, h).
Poses are stored in the detector's order; identity across frames is assigned later (pair_events.py), never here."""
import os
import sys
import time

import cv2
import numpy as np
import mediapipe as mp
from mediapipe.tasks.python import BaseOptions, vision

video, out = sys.argv[1], sys.argv[2]
start_s = float(sys.argv[3]) if len(sys.argv) > 3 else 0.0
end_s = float(sys.argv[4]) if len(sys.argv) > 4 else 1e9
MODEL = os.path.join(os.path.dirname(os.path.abspath(__file__)), "models", "pose_landmarker_full.task")
if not os.path.exists(MODEL):  # the pose model is never committed; it lives beside the downloaded footage and is deleted with it
    MODEL = "C:/Users/user/AppData/Local/Temp/FightCamp-footage/models/pose_landmarker_full.task"

cap = cv2.VideoCapture(video)
fps = cap.get(cv2.CAP_PROP_FPS) or 30.0
w = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
h = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
total = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
first = int(round(start_s * fps))
last = min(total - 1, int(round(end_s * fps)))
cap.set(cv2.CAP_PROP_POS_FRAMES, first)
options = vision.PoseLandmarkerOptions(
    base_options=BaseOptions(model_asset_path=MODEL),
    running_mode=vision.RunningMode.VIDEO, num_poses=2,
    min_pose_detection_confidence=0.4, min_pose_presence_confidence=0.4, min_tracking_confidence=0.4)
landmarker = vision.PoseLandmarker.create_from_options(options)
count = last - first + 1
T = np.zeros(count, dtype=np.float32)
IMG = np.zeros((count, 2, 33, 5), dtype=np.float32)
WORLD = np.zeros((count, 2, 33, 3), dtype=np.float32)
N = np.zeros(count, dtype=np.int8)
began = time.time()
for i in range(count):
    ok, frame = cap.read()
    if not ok:
        count = i
        break
    frame_no = first + i
    T[i] = frame_no / fps
    rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    result = landmarker.detect_for_video(mp.Image(image_format=mp.ImageFormat.SRGB, data=rgb), int(round(frame_no * 1000.0 / fps)))
    found = result.pose_landmarks or []
    N[i] = min(2, len(found))
    for p, lms in enumerate(found[:2]):
        IMG[i, p] = np.array([[lm.x * w, lm.y * h, lm.z, lm.visibility or 0.0, lm.presence or 0.0] for lm in lms], dtype=np.float32)
        WORLD[i, p] = np.array([[lm.x, lm.y, lm.z] for lm in result.pose_world_landmarks[p]], dtype=np.float32)
np.savez_compressed(out, t=T[:count], img=IMG[:count], world=WORLD[:count], n=N[:count], fps=fps, size=(w, h))
print("%s: %d frames in %.0fs (%.1f fps), two people on %.0f%%, one on %.0f%%" % (
    os.path.basename(video), count, time.time() - began, count / max(1e-6, time.time() - began),
    100.0 * (N[:count] == 2).mean(), 100.0 * (N[:count] == 1).mean()))
