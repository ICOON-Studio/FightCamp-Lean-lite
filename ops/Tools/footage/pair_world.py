"""Reconstruct two fighters in one shared world space (metres) from a track_pairs .npz.

usage:
  python pair_world.py <track.npz> <out.npz> [start_s] [end_s]

INPUT (track_pairs.py):
  t (F,) seconds; img (F,2,33,5) x,y pixels, z, visibility, presence;
  world (F,2,33,3) metres, hip-centred per person; n (F,) poses found; fps; size (w,h).

OUTPUT FORMAT — PAIR_WORLD v1 (contract for retarget; do not change without bumping version)
=========================================================================================
File: one .npz per exported clip window.

Arrays:
  t            (F,)              float32   seconds from the source video's timeline
  joints       (F, 2, 33, 3)     float32   metres, shared right-handed world frame
  visibility   (F, 2, 33)        float32   MediaPipe visibility 0..1
  presence     (F, 2, 33)        float32   MediaPipe presence 0..1
  n_fighters   (F,)              int8      0, 1, or 2 reconstructed fighters this frame
  hip_sep_m    (F,)              float32   horizontal hip separation after reconstruction (NaN if <2)
  fps          scalar            float64
  source       scalar            str       video id (basename of input without .npz)
  start_s      scalar            float64   window start (seconds)
  end_s        scalar            float64   window end (seconds)
  format       scalar            str       "PAIR_WORLD_v1"
  method       scalar            str       short method tag

Joint order (33, MediaPipe Pose Landmarker):
  0 nose, 1 left_eye_inner, 2 left_eye, 3 left_eye_outer,
  4 right_eye_inner, 5 right_eye, 6 right_eye_outer,
  7 left_ear, 8 right_ear, 9 mouth_left, 10 mouth_right,
  11 left_shoulder, 12 right_shoulder, 13 left_elbow, 14 right_elbow,
  15 left_wrist, 16 right_wrist, 17 left_pinky, 18 right_pinky,
  19 left_index, 20 right_index, 21 left_thumb, 22 right_thumb,
  23 left_hip, 24 right_hip, 25 left_knee, 26 right_knee,
  27 left_ankle, 28 right_ankle, 29 left_heel, 30 right_heel,
  31 left_foot_index, 32 right_foot_index

Coordinate system (after reconstruction):
  x — ring horizontal, positive to the image right (fighter 1 is at larger x than fighter 0)
  y — up, metres; shared floor plane at y = 0 (lowest reliable ankle height each frame)
  z — toward the camera; positive is closer to the camera

Fighter order:
  index 0 — left-most man in the image (pair_events.py "A", attacker convention)
  index 1 — right-most man ("B", defender)

Frames with n_fighters < 2: joints row is NaN; retarget should hold or interpolate.

METHOD (summary; see research/U112_VIDEO_MOTION.md for error bounds)
===========================================================================
MediaPipe `world` is hip-centred per person, so each pose is correct in shape but not
relative placement. Identity across frames follows pair_events.py (hip-midpoint matching,
left-most = fighter 0). Per frame with two tracked men:

1. Fighter 0 stays at the origin; his joints are `world[0]` unchanged.
2. Horizontal offset to fighter 1's hips: delta_x_px * mean(torso_world / torso_px) over both men.
   Torso = shoulder-mid to hip-mid. This is a monocular depth estimate from each man's own
   real size in metres vs pixels — no invented focal length.
3. Depth offset (z): delta of image-landmark z at the hips, times mean hip width in metres
   from `world` (MediaPipe image z is in hip-width units).
4. Shared floor: subtract the lower ankle-mid y among visible ankles so the floor is y = 0.

Assumes a side-on broadcast camera with slow pan. Horizontal separation error ~ +/-0.15 m (p90);
depth (z) ~ +/-0.35 m (p90). Not reliable for ground grappling (see digest standing vs ground).
"""
from __future__ import annotations

import os
import sys

import numpy as np

# MediaPipe Pose indices
NOSE = 0
L_SH, R_SH = 11, 12
L_HIP, R_HIP = 23, 24
L_ANK, R_ANK = 27, 28
NEEDED = [NOSE, L_SH, R_SH, L_HIP, R_HIP, L_ANK, R_ANK]

JOINT_NAMES = [
    "nose", "left_eye_inner", "left_eye", "left_eye_outer",
    "right_eye_inner", "right_eye", "right_eye_outer",
    "left_ear", "right_ear", "mouth_left", "mouth_right",
    "left_shoulder", "right_shoulder", "left_elbow", "right_elbow",
    "left_wrist", "right_wrist", "left_pinky", "right_pinky",
    "left_index", "right_index", "left_thumb", "right_thumb",
    "left_hip", "right_hip", "left_knee", "right_knee",
    "left_ankle", "right_ankle", "left_heel", "right_heel",
    "left_foot_index", "right_foot_index",
]


def hipmid(pose: np.ndarray) -> np.ndarray:
    return (pose[L_HIP, :2] + pose[R_HIP, :2]) / 2.0


def shmid(pose: np.ndarray) -> np.ndarray:
    return (pose[L_SH, :2] + pose[R_SH, :2]) / 2.0


def torso_px(pose: np.ndarray) -> float:
    return float(np.linalg.norm(shmid(pose) - hipmid(pose)))


def torso_world(world_pose: np.ndarray) -> float:
    sh = (world_pose[L_SH] + world_pose[R_SH]) / 2.0
    hp = (world_pose[L_HIP] + world_pose[R_HIP]) / 2.0
    return float(np.linalg.norm(sh - hp))


def hip_width_world(world_pose: np.ndarray) -> float:
    return float(np.linalg.norm(world_pose[L_HIP] - world_pose[R_HIP]))


def usable(pose: np.ndarray) -> bool:
    return bool(np.all(pose[NEEDED, 3] > 0.5))


def assign_identity(img: np.ndarray, n_arr: np.ndarray) -> tuple[np.ndarray, np.ndarray, np.ndarray]:
    """Return (fighter0_img, fighter1_img, ok) per frame — mirrors pair_events.py."""
    f = img.shape[0]
    a = np.full((f, 33, 5), np.nan, dtype=np.float32)
    b = np.full((f, 33, 5), np.nan, dtype=np.float32)
    ok = np.zeros(f, dtype=bool)
    prev = None
    for i in range(f):
        slot_poses = [(p, img[i, p]) for p in range(int(n_arr[i]))]
        usable_sp = [(s, pose) for s, pose in slot_poses if usable(pose)]
        if len(usable_sp) != 2:
            prev = None
            continue
        (s0, p0), (s1, p1) = usable_sp
        if prev is None:
            if hipmid(p0)[0] > hipmid(p1)[0]:
                p0, p1 = p1, p0
        else:
            keep = np.linalg.norm(hipmid(p0) - prev[0]) + np.linalg.norm(hipmid(p1) - prev[1])
            swap = np.linalg.norm(hipmid(p1) - prev[0]) + np.linalg.norm(hipmid(p0) - prev[1])
            if swap < keep:
                p0, p1 = p1, p0
            t_mean = max(1.0, (torso_px(p0) + torso_px(p1)) / 2.0)
            jump0 = np.linalg.norm(hipmid(p0) - prev[0]) / t_mean
            jump1 = np.linalg.norm(hipmid(p1) - prev[1]) / t_mean
            if jump0 > 1.0 or jump1 > 1.0 or (jump0 > 0.6 and jump1 > 0.6):
                prev = None
                continue
        a[i], b[i] = p0, p1
        ok[i] = True
        prev = (hipmid(p0), hipmid(p1))
    return a, b, ok


def match_world_slots(
    world: np.ndarray,
    img: np.ndarray,
    n_arr: np.ndarray,
    fighter0_img: np.ndarray,
    ok: np.ndarray,
) -> tuple[np.ndarray, np.ndarray]:
    f = world.shape[0]
    w0 = np.full((f, 33, 3), np.nan, dtype=np.float32)
    w1 = np.full((f, 33, 3), np.nan, dtype=np.float32)
    for i in range(f):
        if not ok[i]:
            continue
        slots = [p for p in range(int(n_arr[i])) if usable(img[i, p])]
        if len(slots) != 2:
            continue
        dist0 = {p: float(np.linalg.norm(hipmid(img[i, p]) - hipmid(fighter0_img[i]))) for p in slots}
        i0 = min(slots, key=lambda p: dist0[p])
        i1 = slots[1] if slots[0] == i0 else slots[0]
        w0[i] = world[i, i0]
        w1[i] = world[i, i1]
    return w0, w1


def reconstruct_frame(
    w0: np.ndarray,
    w1: np.ndarray,
    p0: np.ndarray,
    p1: np.ndarray,
) -> tuple[np.ndarray, float]:
    """Place fighter 0 at origin, fighter 1 offset; return (joints[2,33,3], hip_sep_m)."""
    joints = np.full((2, 33, 3), np.nan, dtype=np.float32)
    joints[0] = w0

    tw0 = torso_world(w0)
    tw1 = torso_world(w1)
    tp0 = max(torso_px(p0), 1.0)
    tp1 = max(torso_px(p1), 1.0)
    scale0 = tw0 / tp0
    scale1 = tw1 / tp1
    scale = (scale0 + scale1) / 2.0

    hip0_i = hipmid(p0)
    hip1_i = hipmid(p1)
    d_img = hip1_i - hip0_i
    hip_z0 = (p0[L_HIP, 2] + p0[R_HIP, 2]) / 2.0
    hip_z1 = (p1[L_HIP, 2] + p1[R_HIP, 2]) / 2.0
    hw = (hip_width_world(w0) + hip_width_world(w1)) / 2.0

    offset = np.array([d_img[0] * scale, 0.0, (hip_z1 - hip_z0) * hw], dtype=np.float32)
    joints[1] = w1 + offset

    # Shared floor: y = 0 at lowest visible ankle mid
    floor_y = np.inf
    for person, pose_w, pose_i in ((0, joints[0], p0), (1, joints[1], p1)):
        for ank in (L_ANK, R_ANK):
            if pose_i[ank, 3] > 0.5:
                floor_y = min(floor_y, float(pose_w[ank, 1]))
    if np.isfinite(floor_y):
        joints[:, :, 1] -= floor_y

    hip_sep = float(np.linalg.norm(joints[1, L_HIP] - joints[0, L_HIP]))
    return joints, hip_sep


def reconstruct_clip(
    t_arr: np.ndarray,
    img: np.ndarray,
    world: np.ndarray,
    n_arr: np.ndarray,
    fps: float,
    source: str,
    start_s: float,
    end_s: float,
) -> dict:
    f0_img, f1_img, ok = assign_identity(img, n_arr)
    w0, w1 = match_world_slots(world, img, n_arr, f0_img, ok)

    f = len(t_arr)
    joints = np.full((f, 2, 33, 3), np.nan, dtype=np.float32)
    visibility = np.full((f, 2, 33), np.nan, dtype=np.float32)
    presence = np.full((f, 2, 33), np.nan, dtype=np.float32)
    n_fighters = np.zeros(f, dtype=np.int8)
    hip_sep = np.full(f, np.nan, dtype=np.float32)

    for i in range(f):
        if not ok[i]:
            continue
        j, sep = reconstruct_frame(w0[i], w1[i], f0_img[i], f1_img[i])
        joints[i] = j
        visibility[i, 0] = f0_img[i, :, 3]
        visibility[i, 1] = f1_img[i, :, 3]
        presence[i, 0] = f0_img[i, :, 4]
        presence[i, 1] = f1_img[i, :, 4]
        n_fighters[i] = 2
        hip_sep[i] = sep

    return {
        "t": t_arr.astype(np.float32),
        "joints": joints,
        "visibility": visibility,
        "presence": presence,
        "n_fighters": n_fighters,
        "hip_sep_m": hip_sep,
        "fps": np.float64(fps),
        "source": np.array(source),
        "start_s": np.float64(start_s),
        "end_s": np.float64(end_s),
        "format": np.array("PAIR_WORLD_v1"),
        "method": np.array("img_scale_v1"),
        "joint_names": np.array(JOINT_NAMES),
    }


def window_indices(t_arr: np.ndarray, start_s: float, end_s: float) -> slice:
    lo = int(np.searchsorted(t_arr, start_s, side="left"))
    hi = int(np.searchsorted(t_arr, end_s, side="right"))
    return slice(lo, hi)


def main() -> None:
    if len(sys.argv) < 3:
        print(__doc__)
        sys.exit(2)
    in_path, out_path = sys.argv[1], sys.argv[2]
    start_s = float(sys.argv[3]) if len(sys.argv) > 3 else 0.0
    end_s = float(sys.argv[4]) if len(sys.argv) > 4 else 1e9

    track = np.load(in_path)
    t_arr = track["t"]
    sl = window_indices(t_arr, start_s, end_s)
    t_win = t_arr[sl]
    if len(t_win) == 0:
        print("empty window %.3f-%.3f s" % (start_s, end_s))
        sys.exit(1)

    source = os.path.splitext(os.path.basename(in_path))[0]
    out = reconstruct_clip(
        t_win,
        track["img"][sl],
        track["world"][sl],
        track["n"][sl],
        float(track["fps"]),
        source,
        float(t_win[0]),
        float(t_win[-1]),
    )
    os.makedirs(os.path.dirname(os.path.abspath(out_path)) or ".", exist_ok=True)
    np.savez_compressed(out_path, **out)
    two = int((out["n_fighters"] == 2).sum())
    sep = out["hip_sep_m"][out["n_fighters"] == 2]
    print(
        "%s -> %s: %d frames (%.1f s), two fighters on %d (%.0f%%), hip_sep p50=%.2f m"
        % (
            source,
            out_path,
            len(t_win),
            len(t_win) / float(track["fps"]),
            two,
            100.0 * two / max(1, len(t_win)),
            float(np.nanmedian(sep)) if len(sep) else 0.0,
        )
    )


if __name__ == "__main__":
    main()
