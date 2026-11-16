"""3D pose of the thrower on the frames of each candidate punch, and a 3D arm descriptor.  (Claude, S495)
(The operator's idea, S495: "maybe try a 3D pose estimation network, build a descriptor from the pose parameters".)

Model: RTMW3D-x (Apache-2.0, 369 MB ONNX, huggingface.co/Soykaf/RTMW3D-x), run through rtmlib on the graphics card.
It gives each joint x, y AND depth for one person inside his own box - so the elbow angle and the reach are true
angles and lengths, not shortened by the camera angle as in the 2D picture. It does NOT place two people in one 3D
space, so glove-to-opponent distances stay 2D.

usage: python pose3d.py <video> <boxers.npz> <out_3d.npz> [--model path.onnx]
  runs the rule detector with the loose net, then the 3D model on SIX frames of each candidate (onset .. impact +0.06 s)
  for the thrower only. Saved: key (M,2) = (frame index, boxer 0/1), k3d (M,17,3), score (M,17).
descriptor3d(...) turns one candidate's six 3D poses into 66 numbers in the boxer's own body frame."""
import os
import sys
import time

import cv2
import numpy as np

sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import classify  # noqa: E402
import pose  # noqa: E402
import punches  # noqa: E402

DEFAULT_MODEL = "E:/FightCamp/fight_video_data/models/rtmw3d-x_8xb64_cocktail14-384x288-b0a0eab7_20240626.onnx"
STEPS = 6


def window_frames(m, fps, F):
    last = min(F - 1, m["impact"] + int(round(0.06 * fps)))
    return np.unique(np.round(np.linspace(m["onset"], last, STEPS)).astype(int))


def load_model(path=DEFAULT_MODEL, use_gpu=True):
    from rtmlib import RTMPose3d
    model = RTMPose3d(path, model_input_size=(288, 384), backend="onnxruntime", device="cpu")
    if use_gpu:
        model.session = pose._session(path, True)
    return model


def run(video, boxers_npz, out_npz, model_path=DEFAULT_MODEL, log=print):
    boxers = np.load(boxers_npz)
    fps, F = float(boxers["fps"]), len(boxers["frame"])
    events, info, bodies = punches.detect(boxers, classify.LOOSE, log=lambda *a: None)
    want = {}
    for ev in events:
        b = "AB".index(ev["boxer"])
        for i in window_frames(ev["m"], fps, F):
            want.setdefault(int(i), set()).add(b)
    model = load_model(model_path)
    cap = cv2.VideoCapture(video)
    frame_of = boxers["frame"]
    keys, k3d, score = [], [], []
    began, pos = time.time(), 0
    for i in sorted(want):
        target = int(frame_of[i])
        if target - pos > 60:
            cap.set(cv2.CAP_PROP_POS_FRAMES, target)
            pos = target
        while pos < target:
            cap.grab()
            pos += 1
        ok, img = cap.read()
        pos += 1
        if not ok:
            break
        h, w = img.shape[:2]
        for b in sorted(want[i]):
            k = boxers["kpt"][i, b]
            good = k[k[:, 2] > 0.3][:, :2]
            if len(good) < 6:
                continue
            x1, y1, x2, y2 = good[:, 0].min(), good[:, 1].min(), good[:, 0].max(), good[:, 1].max()
            px, py = 0.2 * (x2 - x1) + 10, 0.15 * (y2 - y1) + 10
            box = [max(0, x1 - px), max(0, y1 - py), min(w, x2 + px), min(h, y2 + py)]
            _, sc, simcc, _ = model(img, bboxes=[box])
            keys.append((i, b)), k3d.append(simcc[0][:17].astype(np.float32)), score.append(np.asarray(sc[0][:17], np.float32))
    np.savez_compressed(out_npz, key=np.array(keys, np.int32).reshape(-1, 2), k3d=np.array(k3d, np.float32).reshape(-1, 17, 3),
                        score=np.array(score, np.float32).reshape(-1, 17))
    log("pose3d: %d poses for %d candidates in %.0f s -> %s" % (len(keys), len(events), time.time() - began, out_npz))


def _unit(v):
    return v / max(float(np.linalg.norm(v)), 1e-6)


def descriptor3d(ev, fps, F, table):
    """table: {(frame index, boxer): k3d (17,3)}. -> (66,) numbers, NaN where the 3D pose is missing."""
    b = "AB".index(ev["boxer"])
    sh_i, el_i, wr_i = (5, 7, 9) if ev["hand"] == "left" else (6, 8, 10)
    osh, oel, owr = (6, 8, 10) if ev["hand"] == "left" else (5, 7, 9)
    rows = []
    for i in np.round(np.linspace(ev["m"]["onset"], min(F - 1, ev["m"]["impact"] + int(round(0.06 * fps))), STEPS)).astype(int):
        k = table.get((int(i), b))
        if k is None:
            rows.append(np.full(10, np.nan, np.float32))
            continue
        shm, hipm = (k[5] + k[6]) / 2, (k[11] + k[12]) / 2
        T = max(float(np.linalg.norm(shm - hipm)), 1e-6)
        up = _unit(shm - hipm)
        across = k[sh_i] - k[osh]                       # from the other shoulder to the punching shoulder
        across = _unit(across - up * float(across @ up))
        fwd = np.cross(up, across)
        if ev["hand"] == "left":                        # keep "forward" pointing out of the chest for both hands
            fwd = -fwd
        frame = np.stack([across, up, fwd])
        el, wr, ow = frame @ (k[el_i] - k[sh_i]) / T, frame @ (k[wr_i] - k[sh_i]) / T, frame @ (k[owr] - k[osh]) / T
        u, v = k[sh_i] - k[el_i], k[wr_i] - k[el_i]
        ang = np.degrees(np.arccos(np.clip(float(u @ v) / max(float(np.linalg.norm(u) * np.linalg.norm(v)), 1e-6), -1, 1))) / 180.0
        rows.append(np.r_[el, wr, ow, ang].astype(np.float32))
    R = np.stack(rows)
    wr = R[:, 3:6]
    with np.errstate(invalid="ignore"), __import__("warnings").catch_warnings():
        __import__("warnings").simplefilter("ignore")
        summary = np.array([np.nanmax(np.linalg.norm(wr, axis=1)), np.nanmax(wr[:, 2]) - np.nanmin(wr[:, 2]), np.nanmax(wr[:, 0]) - np.nanmin(wr[:, 0]),
                            np.nanmax(wr[:, 1]) - np.nanmin(wr[:, 1]), np.nanmax(R[:, 9]), np.nanmax(R[:, 9]) - np.nanmin(R[:, 9])], np.float32)
    return np.concatenate([R.reshape(-1), summary])


def load_table(npz_path):
    z = np.load(npz_path)
    return {(int(i), int(b)): k for (i, b), k in zip(z["key"], z["k3d"])}


if __name__ == "__main__":
    a = sys.argv
    run(a[1], a[2], a[3], a[a.index("--model") + 1] if "--model" in a else DEFAULT_MODEL)
