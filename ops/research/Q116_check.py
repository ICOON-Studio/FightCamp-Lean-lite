"""Q116_check.py — independent gate for clinch motion metrics.

Recomputes from raw track/*.npz via pair_world.py.  Does NOT read
Q116_motion.json.  Asserts:
  1. Clinch run count matches the digest (3 kept runs at 0.80 m).
  2. Pooled hip-separation excursion p50 pinned to 3 decimal places.
  3. Control arm (range) exists and differs from clinch.
  4. Degenerate case: threshold 0.0 m -> 0 runs, "no runs" reported.
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
L_HIP, R_HIP = 23, 24
CLINCH_THRESH = 0.80
MIN_RUN = 3
PINNED_HIP_EXC_P50 = 0.046


def hip_mid(j):
    return (j[:, L_HIP] + j[:, R_HIP]) / 2.0


def find_runs(mask):
    runs = []
    start = None
    for i in range(len(mask)):
        if mask[i]:
            if start is None:
                start = i
        else:
            if start is not None:
                runs.append((start, i - 1))
                start = None
    if start is not None:
        runs.append((start, len(mask) - 1))
    return runs


def perp_direction(hm0_mean, hm1_mean):
    d = (hm1_mean - hm0_mean)[[0, 2]]
    length = np.linalg.norm(d)
    if length < 1e-8:
        return np.array([1.0, 0.0])
    return np.array([-d[1], d[0]]) / length


def load_and_classify(thresh):
    all_hip, all_hm0, all_hm1 = [], [], []
    for cid in CLEAN_CLIPS:
        path = os.path.join(TRACK_DIR, cid + ".npz")
        assert os.path.exists(path), f"Track not found: {path}"
        track = np.load(path)
        t_arr = track["t"]
        out = pw.reconstruct_clip(
            t_arr, track["img"], track["world"], track["n"],
            float(track["fps"]), cid, float(t_arr[0]), float(t_arr[-1]),
        )
        joints = out["joints"]
        n_f = out["n_fighters"]
        vis = out["visibility"]
        two = n_f == 2
        j = joints[two]
        v = vis[two]
        hm0 = hip_mid(j[:, 0])
        hm1 = hip_mid(j[:, 1])
        hip_sep = np.linalg.norm(hm1 - hm0, axis=1)
        hip_vis = ((v[:, 0, L_HIP] > 0.5) & (v[:, 0, R_HIP] > 0.5)
                   & (v[:, 1, L_HIP] > 0.5) & (v[:, 1, R_HIP] > 0.5))
        ok = hip_vis & np.isfinite(hip_sep) & (hip_sep >= 0.40) & (hip_sep <= 3.0)
        all_hip.append(hip_sep[ok])
        all_hm0.append(hm0[ok])
        all_hm1.append(hm1[ok])

    hip = np.concatenate(all_hip)
    hm0 = np.concatenate(all_hm0)
    hm1 = np.concatenate(all_hm1)
    fps = 50.0

    c_mask = hip <= thresh
    r_mask = hip > thresh
    return hip, hm0, hm1, fps, c_mask, r_mask


def compute_hip_excursion(hip, mask, min_run):
    runs = find_runs(mask)
    kept = [(s, e) for s, e in runs if (e - s + 1) >= min_run]
    excursions = []
    for s, e in kept:
        h = hip[s:e + 1]
        excursions.append(float(np.max(h) - np.min(h)))
    n_kept = len(kept)
    n_total = len(runs)
    if not excursions:
        return 0.0, n_total, n_kept, []
    p50 = float(np.percentile(excursions, 50))
    return p50, n_total, n_kept, excursions


def main():
    print("Q116_CHECK — independent recomputation from raw tracks")

    # --- Primary assertion: 0.80 m threshold ---
    hip, hm0, hm1, fps, c_mask, r_mask = load_and_classify(CLINCH_THRESH)
    n_total = len(hip)
    n_clinch_frames = int(c_mask.sum())
    print(f"  total_frames={n_total}")
    print(f"  clinch_frames={n_clinch_frames} (threshold <= {CLINCH_THRESH:.2f} m)")

    # 1. Re-segment and assert run count
    _, c_total_runs, c_kept, c_excursions = compute_hip_excursion(hip, c_mask, MIN_RUN)
    print(f"  clinch_runs_total={c_total_runs}, kept(>={MIN_RUN})={c_kept}")
    assert c_kept == 3, f"FAIL: expected 3 clinch runs kept, got {c_kept}"
    print(f"  CHECK run_count=PASS (3)")

    # 2. Pinned hip-separation excursion p50
    p50_clinch, _, _, _ = compute_hip_excursion(hip, c_mask, MIN_RUN)
    print(f"  clinch_hip_exc_p50={p50_clinch:.3f}_m (pinned={PINNED_HIP_EXC_P50:.3f})")
    assert abs(p50_clinch - PINNED_HIP_EXC_P50) < 0.005, (
        f"FAIL: hip excursion p50 {p50_clinch:.3f} != pinned {PINNED_HIP_EXC_P50:.3f}"
    )
    print(f"  CHECK pinned_p50=PASS")

    # 3. Control arm: range must exist and differ
    p50_range, r_total_runs, r_kept, r_excursions = compute_hip_excursion(hip, r_mask, MIN_RUN)
    print(f"  range_runs_kept={r_kept}, range_hip_exc_p50={p50_range:.3f}_m")
    assert r_kept > 0, "FAIL: range has no runs"
    assert abs(p50_clinch - p50_range) > 0.01, (
        f"FAIL: clinch ({p50_clinch:.3f}) == range ({p50_range:.3f}) — control arm useless"
    )
    print(f"  CHECK control_arm=PASS (diff={p50_range - p50_clinch:.3f} m)")

    # 4. Degenerate case: threshold 0.0 m
    _, _, _, _, d_mask, _ = load_and_classify(0.0)
    d_runs = find_runs(d_mask)
    n_deg = int(d_mask.sum())
    print(f"  degenerate_0m: runs={len(d_runs)}, frames={n_deg}")
    assert len(d_runs) == 0, f"FAIL: expected 0 runs at 0.0 m, got {len(d_runs)}"
    assert n_deg == 0, f"FAIL: expected 0 frames at 0.0 m, got {n_deg}"
    print(f"  CHECK degenerate='no runs'=PASS")

    print("Q116_CHECK ALL PASS")
    return 0


if __name__ == "__main__":
    sys.exit(main())
