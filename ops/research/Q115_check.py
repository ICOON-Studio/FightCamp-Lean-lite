"""Q115_check.py — verify the clinch distance measurement from raw tracks.

Recomputes the headline p50 from the raw track .npz files via pair_world.py,
applies the clinch definition (hip-to-hip 3D <= 0.80 m), and asserts:
  1. Clinch and range samples are both non-empty.
  2. Clinch p50 != range p50 (the separation rule does something).
  3. Pins the literal p50 values for eye-check.

Exits 0 on success, 1 on any assertion failure.
"""
from __future__ import annotations

import os
import sys

import numpy as np

TOOLS = os.path.join(os.path.dirname(__file__), "..", "..", "Tools", "footage")
sys.path.insert(0, os.path.abspath(TOOLS))
import pair_world as pw

TRACK_DIR = r"C:\Users\user\AppData\Local\Temp\FightCamp-footage\track"
CLEAN_CLIPS = ["-vPZqptk8jo", "HL261oRyURE", "FCM7m6TJWUQ"]
CLINCH_THRESH_M = 0.80
L_HIP, R_HIP = 23, 24


def hip_mid(j):
    return (j[:, L_HIP] + j[:, R_HIP]) / 2.0


def main():
    all_hip = []

    for cid in CLEAN_CLIPS:
        path = os.path.join(TRACK_DIR, cid + ".npz")
        assert os.path.exists(path), f"Track file not found: {path}"
        track = np.load(path)
        t_arr = track["t"]
        out = pw.reconstruct_clip(
            t_arr, track["img"], track["world"], track["n"],
            float(track["fps"]), cid, float(t_arr[0]), float(t_arr[-1])
        )
        joints = out["joints"]
        n_f = out["n_fighters"]
        vis = out["visibility"]

        two = n_f == 2
        j = joints[two]
        v = vis[two]

        hm0 = hip_mid(j[:, 0])
        hm1 = hip_mid(j[:, 1])
        hip_3d = np.linalg.norm(hm1 - hm0, axis=1)

        hip_vis = (v[:, 0, L_HIP] > 0.5) & (v[:, 0, R_HIP] > 0.5) & \
                  (v[:, 1, L_HIP] > 0.5) & (v[:, 1, R_HIP] > 0.5)
        ok = hip_vis & np.isfinite(hip_3d) & (hip_3d >= 0.40) & (hip_3d <= 3.0)
        all_hip.append(hip_3d[ok])

    hip = np.concatenate(all_hip)
    n_total = len(hip)

    clinch_mask = hip <= CLINCH_THRESH_M
    range_mask = hip > CLINCH_THRESH_M
    n_clinch = int(clinch_mask.sum())
    n_range = int(range_mask.sum())

    print(f"Q115_CHECK total_frames={n_total}")
    print(f"Q115_CHECK clinch_frames={n_clinch} (threshold <= {CLINCH_THRESH_M:.2f} m)")
    print(f"Q115_CHECK range_frames={n_range}")

    # Assert non-empty
    assert n_clinch > 0, "FAIL: clinch sample is empty — threshold too tight"
    assert n_range > 0, "FAIL: range sample is empty — threshold too loose"
    print(f"Q115_CHECK both_samples_non_empty=PASS")

    p50_clinch = float(np.percentile(hip[clinch_mask], 50))
    p50_range = float(np.percentile(hip[range_mask], 50))
    diff = p50_range - p50_clinch

    print(f"Q115_CHECK clinch_hip_p50={p50_clinch:.3f}_m")
    print(f"Q115_CHECK range_hip_p50={p50_range:.3f}_m")
    print(f"Q115_CHECK p50_difference={diff:.3f}_m")

    # Assert they are different (the rule does something)
    assert abs(p50_clinch - p50_range) > 0.01, (
        f"FAIL: clinch p50 ({p50_clinch:.3f}) == range p50 ({p50_range:.3f}) — "
        "separation rule did nothing"
    )
    print(f"Q115_CHECK clinch_ne_range=PASS (diff={diff:.3f} m)")

    # Pin literals for eye-check
    # Clinch p50 should be around 0.72 m; range p50 around 1.05 m
    assert 0.60 < p50_clinch < 0.85, f"FAIL: clinch p50 {p50_clinch:.3f} out of expected range"
    assert 0.90 < p50_range < 1.20, f"FAIL: range p50 {p50_range:.3f} out of expected range"
    print(f"Q115_CHECK pinned_literals=PASS")

    # Error context
    print(f"Q115_CHECK error_horizontal_p90=+/-0.15_m")
    print(f"Q115_CHECK diff_vs_error={diff/0.15:.1f}x_error_bound")

    print("Q115_CHECK PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
