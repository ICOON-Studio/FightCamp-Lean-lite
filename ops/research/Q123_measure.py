"""Q123 — measure clinch arm geometry from the paired corpus.

Produces Q123_clinch_arms.json with the exact key contract from TASK_Q123.md.
Three clean side-on clips, clinch defined as hip-midpoint 3D separation in
[0.40, 0.80] m (Q115's published rule). Y runs DOWN in pair_world's frame
(nose y = -1.272, ankle y = +0.042 on -vPZqptk8jo frame 0); the docstring at
pair_world.py:41 says "y — up" which is wrong. Positive wrist_y - neck_y
means the hand is BELOW the neck.
"""
from __future__ import annotations

import json
import os
import sys

import numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
TOOLS = os.path.abspath(os.path.join(HERE, "..", "..", "Tools", "footage"))
sys.path.insert(0, TOOLS)
import pair_world as pw  # noqa: E402

TRACK_DIR = r"C:\Users\user\AppData\Local\Temp\FightCamp-footage\track"

CLIPS = ["-vPZqptk8jo", "HL261oRyURE", "FCM7m6TJWUQ"]
CLINCH_MAX_M = 0.80
IMPLAUSIBLE_MIN_M = 0.40

NOSE = 0
L_SH, R_SH = 11, 12
L_WR, R_WR = 15, 16
L_HIP, R_HIP = 23, 24
L_ANK, R_ANK = 27, 28


def mid(j, a, b):
    return (j[:, a] + j[:, b]) / 2.0


def neck(j):
    return mid(j, L_SH, R_SH)


def pct(v, q):
    return float(np.percentile(np.asarray(v, dtype=float), q))


def main() -> None:
    rows: dict[str, list] = {
        "hand_to_opp_neck_m": [],
        "nearest_hand_to_opp_neck_m": [],
        "hand_minus_neck_height_m": [],
        "hip_sep_m": [],
        "stature_m": [],
        "hand_to_opp_hand_m": [],
    }
    per_clip: dict[str, int] = {}

    for clip in CLIPS:
        path = os.path.join(TRACK_DIR, clip + ".npz")
        tr = np.load(path)
        t_arr = tr["t"]
        out = pw.reconstruct_clip(
            t_arr, tr["img"], tr["world"], tr["n"],
            float(tr["fps"]), clip,
            float(t_arr[0]), float(t_arr[-1]),
        )
        j_all = out["joints"]
        two = out["n_fighters"] == 2
        j = j_all[two]
        if j.shape[0] == 0:
            per_clip[clip] = 0
            continue

        hm0 = mid(j[:, 0], L_HIP, R_HIP)
        hm1 = mid(j[:, 1], L_HIP, R_HIP)
        hip_sep = np.linalg.norm(hm1 - hm0, axis=1)
        keep = (hip_sep >= IMPLAUSIBLE_MIN_M) & (hip_sep <= CLINCH_MAX_M)
        per_clip[clip] = int(keep.sum())
        if keep.sum() == 0:
            continue

        jc = j[keep]
        rows["hip_sep_m"].extend(hip_sep[keep].tolist())

        n0 = neck(jc[:, 0])
        n1 = neck(jc[:, 1])

        for me, opp_neck in ((0, n1), (1, n0)):
            for wr in (L_WR, R_WR):
                d = np.linalg.norm(jc[:, me, wr] - opp_neck, axis=1)
                rows["hand_to_opp_neck_m"].extend(d.tolist())
                rows["hand_minus_neck_height_m"].extend(
                    (jc[:, me, wr, 1] - opp_neck[:, 1]).tolist()
                )
            best = np.minimum(
                np.linalg.norm(jc[:, me, L_WR] - opp_neck, axis=1),
                np.linalg.norm(jc[:, me, R_WR] - opp_neck, axis=1),
            )
            rows["nearest_hand_to_opp_neck_m"].extend(best.tolist())

            other = 1 - me
            for wr in (L_WR, R_WR):
                for owr in (L_WR, R_WR):
                    rows["hand_to_opp_hand_m"].extend(
                        np.linalg.norm(jc[:, me, wr] - jc[:, other, owr],
                                       axis=1).tolist()
                    )

            ank = np.maximum(jc[:, me, L_ANK, 1], jc[:, me, R_ANK, 1])
            rows["stature_m"].extend((ank - jc[:, me, NOSE, 1]).tolist())

    n_clinch = len(rows["hip_sep_m"])
    print(f"Q123 clinch frames: {n_clinch} " +
          " ".join(f"{c}={per_clip.get(c, 0)}" for c in CLIPS))

    out: dict = {"clinch_frames": n_clinch}
    for key in rows:
        for q in (10, 50, 90):
            out[f"{key}_p{q}"] = round(pct(rows[key], q), 4)

    json_path = os.path.join(HERE, "Q123_clinch_arms.json")
    with open(json_path, "w") as f:
        json.dump(out, f, indent=2)
    print(f"Saved {json_path}")

    for key in ("hand_to_opp_neck_m", "nearest_hand_to_opp_neck_m",
                "hand_minus_neck_height_m", "hip_sep_m", "stature_m",
                "hand_to_opp_hand_m"):
        print(f"  {key}: p10={out[f'{key}_p10']:.3f}  "
              f"p50={out[f'{key}_p50']:.3f}  p90={out[f'{key}_p90']:.3f} m")


if __name__ == "__main__":
    main()
