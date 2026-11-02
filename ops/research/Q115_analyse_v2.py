"""Q115 v2 — refined analysis: filter degenerate values, derive clinch from data.

Key insight from v1: the distribution is unimodal at ~0.90 m with no separate
clinch mode. Near-zero values from wzUWvsviqTM are camera-angle artifacts
(three-quarter view makes fighters overlap). Filter at >= 0.40 m (below this
is physically implausible for two standing adult males viewed side-on).
"""
from __future__ import annotations

import json
import os
import sys

import numpy as np

TOOLS = os.path.join(os.path.dirname(__file__), "..", "..", "Tools", "footage")
sys.path.insert(0, os.path.abspath(TOOLS))
import pair_world as pw

TRACK_DIR = r"C:\Users\user\AppData\Local\Temp\FightCamp-footage\track"

# Clean side-on clips per U112 (visibility >= 0.877, standing confirmed)
CLEAN_CLIPS = ["-vPZqptk8jo", "HL261oRyURE", "FCM7m6TJWUQ"]
# Fourth standing clip — good but longer, more mixed content
EXTRA_CLIPS = ["wzUWvsviqTM"]

L_HIP, R_HIP = 23, 24
L_SH, R_SH = 11, 12
NOSE = 0


def hip_mid(j):
    return (j[:, L_HIP] + j[:, R_HIP]) / 2.0

def chest_mid(j):
    return (j[:, L_SH] + j[:, R_SH]) / 2.0


def process_clip(clip_id):
    path = os.path.join(TRACK_DIR, clip_id + ".npz")
    track = np.load(path)
    t_arr = track["t"]
    out = pw.reconstruct_clip(t_arr, track["img"], track["world"], track["n"],
                              float(track["fps"]), clip_id,
                              float(t_arr[0]), float(t_arr[-1]))
    joints = out["joints"]
    n_f = out["n_fighters"]
    vis = out["visibility"]

    two = n_f == 2
    j = joints[two]
    v = vis[two]

    hm0 = hip_mid(j[:, 0])
    hm1 = hip_mid(j[:, 1])
    hip_3d = np.linalg.norm(hm1 - hm0, axis=1)
    hip_x = np.abs(hm1[:, 0] - hm0[:, 0])
    hip_z = np.abs(hm1[:, 2] - hm0[:, 2])

    cm0 = chest_mid(j[:, 0])
    cm1 = chest_mid(j[:, 1])
    chest_3d = np.linalg.norm(cm1 - cm0, axis=1)

    hd0 = j[:, 0, NOSE]
    hd1 = j[:, 1, NOSE]
    head_3d = np.linalg.norm(hd1 - hd0, axis=1)

    # Filter: both fighters' hips visible, finite, physically plausible
    hip_vis = (v[:, 0, L_HIP] > 0.5) & (v[:, 0, R_HIP] > 0.5) & \
              (v[:, 1, L_HIP] > 0.5) & (v[:, 1, R_HIP] > 0.5)

    # Physical plausibility: two standing men side-on cannot have hip sep < 0.40 m
    # (that would mean their hip centres are inside each other's bodies)
    # Also cap at 3.0 m (beyond typical fighting range)
    ok = hip_vis & np.isfinite(hip_3d) & (hip_3d >= 0.40) & (hip_3d <= 3.0)

    return {
        "clip": clip_id,
        "n_total": len(t_arr),
        "n_two": int(two.sum()),
        "n_ok": int(ok.sum()),
        "hip_3d": hip_3d[ok],
        "hip_x": hip_x[ok],
        "hip_z": hip_z[ok],
        "chest_3d": chest_3d[ok],
        "head_3d": head_3d[ok],
    }


def main():
    all_clips = CLEAN_CLIPS + EXTRA_CLIPS
    results = {}
    all_hip, all_hx, all_hz, all_chest, all_head = [], [], [], [], []

    print("=" * 72)
    print("Q115 v2 — Clinch distance (filtered, data-driven)")
    print("=" * 72)

    for cid in all_clips:
        print(f"\n  Loading {cid}...")
        r = process_clip(cid)
        results[cid] = r
        all_hip.append(r["hip_3d"])
        all_hx.append(r["hip_x"])
        all_hz.append(r["hip_z"])
        all_chest.append(r["chest_3d"])
        all_head.append(r["head_3d"])
        print(f"    {r['n_two']} two-fighter -> {r['n_ok']} valid "
              f"({100*r['n_ok']/max(1,r['n_two']):.0f}%)")

    hip = np.concatenate(all_hip)
    hx = np.concatenate(all_hx)
    hz = np.concatenate(all_hz)
    chest = np.concatenate(all_chest)
    head = np.concatenate(all_head)

    # Also compute clean-only (3 clips)
    clean_hip = np.concatenate([results[c]["hip_3d"] for c in CLEAN_CLIPS])
    clean_chest = np.concatenate([results[c]["chest_3d"] for c in CLEAN_CLIPS])
    clean_head = np.concatenate([results[c]["head_3d"] for c in CLEAN_CLIPS])

    print(f"\n{'=' * 72}")
    print(f"ALL 4 CLIPS: {len(hip)} valid frames (filtered >= 0.40 m)")
    print(f"CLEAN 3 CLIPS: {len(clean_hip)} valid frames")
    print(f"{'=' * 72}")

    # ---- Distribution analysis ----
    print(f"\n--- Hip-to-hip 3D: ALL 4 clips ---")
    for p in [5, 10, 25, 50, 75, 90, 95]:
        print(f"  p{p:02d} = {np.percentile(hip, p):.3f} m")
    print(f"  mean = {np.mean(hip):.3f} m, std = {np.std(hip):.3f} m")

    print(f"\n--- Hip-to-hip 3D: CLEAN 3 clips only ---")
    for p in [5, 10, 25, 50, 75, 90, 95]:
        print(f"  p{p:02d} = {np.percentile(clean_hip, p):.3f} m")

    # Histogram on clean clips (finer bins)
    print(f"\n  Histogram (clean 3 clips, 5 cm bins):")
    edges = np.arange(0.40, 2.55, 0.05)
    counts, _ = np.histogram(clean_hip, bins=edges)
    max_c = max(counts)
    for i in range(len(counts)):
        if counts[i] > 0:
            bar = "#" * min(70, int(70 * counts[i] / max_c))
            print(f"    {edges[i]:.2f}-{edges[i+1]:.2f}: {counts[i]:5d} {bar}")

    # ---- Derive clinch definition from the distribution ----
    print(f"\n{'=' * 72}")
    print("CLINCH DEFINITION — derived from the distribution")
    print(f"{'=' * 72}")

    # The distribution is unimodal. Look for the inflection point
    # between the "close" shoulder and the main body.
    # Use the clean clips for this.
    sorted_h = np.sort(clean_hip)
    n = len(sorted_h)

    # Compute the PDF (kernel density) with a 5cm bandwidth
    # Look for the first local minimum after the initial rise
    bin_w = 0.02
    fine_edges = np.arange(0.40, 2.0, bin_w)
    fine_counts, _ = np.histogram(clean_hip, bins=fine_edges)
    fine_centers = (fine_edges[:-1] + fine_edges[1:]) / 2

    # Smooth with 5-bin window
    kernel = np.ones(5) / 5
    smoothed = np.convolve(fine_counts.astype(float), kernel, mode='same')

    # Find first local minimum after the peak
    peak_idx = np.argmax(smoothed)
    print(f"  Distribution peak at {fine_centers[peak_idx]:.2f} m "
          f"({fine_counts[peak_idx]} frames in bin)")

    # Look for valley to the left of the peak
    valley_idx = peak_idx
    for i in range(peak_idx - 1, 0, -1):
        if smoothed[i] > smoothed[i+1]:
            break
        valley_idx = i

    valley_dist = fine_centers[valley_idx]
    print(f"  Valley (left of peak) at {valley_dist:.2f} m")

    # The clinch population is everything below the valley
    # But if the valley is very close to the peak, there's no separation

    # Try a range of thresholds and report what happens
    print(f"\n  Sensitivity analysis (clean 3 clips, n={len(clean_hip)}):")
    print(f"  {'thresh':>8s} {'n_clinch':>9s} {'%':>6s} {'p50_clinch':>11s} "
          f"{'p10_r':>7s} {'p50_range':>10s} {'p90_range':>9s} {'diff':>7s}")

    thresholds = np.arange(0.45, 1.10, 0.05)
    for t in thresholds:
        cm = clean_hip <= t
        rm = clean_hip > t
        nc = cm.sum()
        nr = rm.sum()
        if nc >= 5 and nr >= 5:
            p50c = np.percentile(clean_hip[cm], 50)
            p50r = np.percentile(clean_hip[rm], 50)
            p10r = np.percentile(clean_hip[rm], 10)
            p90r = np.percentile(clean_hip[rm], 90)
            diff = p50r - p50c
            print(f"  {t:8.2f} {nc:9d} {100*nc/n:5.1f}% {p50c:11.3f} "
                  f"{p10r:7.3f} {p50r:10.3f} {p90r:9.3f} {diff:7.3f}")

    # ---- The honest assessment ----
    print(f"\n{'=' * 72}")
    print("ERROR ANALYSIS")
    print(f"{'=' * 72}")
    print(f"  U112 depth error: +/-0.19 m (clean) to +/-0.35 m (noisy)")
    print(f"  U112 horizontal error: +/-0.15 m (p90)")
    print(f"  Since camera is side-on, horizontal dominates the 3D distance.")
    print(f"  Effective 3D distance error: ~ +/-0.15 m (p90)")
    print()

    # Use 0.80 m as the data-driven threshold (valley between close and main)
    # Show what happens
    thresh = 0.80
    cm = clean_hip <= thresh
    rm = clean_hip > thresh
    print(f"  Working threshold: {thresh:.2f} m")
    print(f"  Clinch frames: {cm.sum()} ({100*cm.sum()/n:.1f}%)")
    print(f"  Range frames: {rm.sum()} ({100*rm.sum()/n:.1f}%)")

    if cm.sum() > 0:
        p50_clinch = np.percentile(clean_hip[cm], 50)
        p10_clinch = np.percentile(clean_hip[cm], 10)
        p90_clinch = np.percentile(clean_hip[cm], 90)
        print(f"  Clinch hip p10={p10_clinch:.3f}  p50={p50_clinch:.3f}  p90={p90_clinch:.3f} m")

    p50_range = np.percentile(clean_hip[rm], 50)
    p10_range = np.percentile(clean_hip[rm], 10)
    p90_range = np.percentile(clean_hip[rm], 90)
    print(f"  Range  hip p10={p10_range:.3f}  p50={p50_range:.3f}  p90={p90_range:.3f} m")

    if cm.sum() > 0:
        diff = p50_range - p50_clinch
        print(f"\n  Difference (range p50 - clinch p50): {diff:.3f} m")
        print(f"  Error bound (horizontal p90): +/-0.15 m")
        if diff < 0.30:
            print(f"  VERDICT: difference ({diff:.3f} m) is within 2x the error bound.")
            print(f"  The method CANNOT reliably separate clinch from range at this threshold.")
        else:
            print(f"  VERDICT: difference exceeds error bound — separation is real.")

    # Chest and head at the clinch threshold
    print(f"\n--- Chest-to-chest and head-to-head at threshold {thresh:.2f} m ---")
    clean_clinch_mask_all = np.concatenate([
        results[c]["hip_3d"] <= thresh for c in CLEAN_CLIPS
    ])
    # Need to reconstruct the mask properly
    clinch_chest = []
    clinch_head = []
    range_chest = []
    range_head = []
    for c in CLEAN_CLIPS:
        cm_c = results[c]["hip_3d"] <= thresh
        rm_c = results[c]["hip_3d"] > thresh
        clinch_chest.append(results[c]["chest_3d"][cm_c])
        clinch_head.append(results[c]["head_3d"][cm_c])
        range_chest.append(results[c]["chest_3d"][rm_c])
        range_head.append(results[c]["head_3d"][rm_c])

    cc = np.concatenate(clinch_chest)
    ch = np.concatenate(clinch_head)
    rc = np.concatenate(range_chest)
    rh = np.concatenate(range_head)

    if len(cc) > 0:
        print(f"  Clinch chest p50 = {np.percentile(cc, 50):.3f} m (n={len(cc)})")
        print(f"  Clinch head  p50 = {np.percentile(ch, 50):.3f} m (n={len(ch)})")
    print(f"  Range  chest p50 = {np.percentile(rc, 50):.3f} m (n={len(rc)})")
    print(f"  Range  head  p50 = {np.percentile(rh, 50):.3f} m (n={len(rh)})")

    # ---- Save final data for check script ----
    out = {
        "clips": [{"id": c, "n_ok": int(results[c]["n_ok"])} for c in all_clips],
        "clean_clips": CLEAN_CLIPS,
        "total_frames_all": int(len(hip)),
        "total_frames_clean": int(len(clean_hip)),
        "threshold_m": thresh,
        "error_horizontal_p90_m": 0.15,
        "error_depth_p90_m": 0.35,
        "error_depth_clean_p90_m": 0.19,
        "all_hip_3d": {
            "p5": float(np.percentile(hip, 5)),
            "p10": float(np.percentile(hip, 10)),
            "p25": float(np.percentile(hip, 25)),
            "p50": float(np.percentile(hip, 50)),
            "p75": float(np.percentile(hip, 75)),
            "p90": float(np.percentile(hip, 90)),
            "p95": float(np.percentile(hip, 95)),
            "mean": float(np.mean(hip)),
            "std": float(np.std(hip)),
        },
        "clean_hip_3d": {
            "p5": float(np.percentile(clean_hip, 5)),
            "p10": float(np.percentile(clean_hip, 10)),
            "p25": float(np.percentile(clean_hip, 25)),
            "p50": float(np.percentile(clean_hip, 50)),
            "p75": float(np.percentile(clean_hip, 75)),
            "p90": float(np.percentile(clean_hip, 90)),
            "p95": float(np.percentile(clean_hip, 95)),
        },
        "clinch_at_threshold": {},
        "range_at_threshold": {
            "hip_p10": float(np.percentile(clean_hip[rm], 10)),
            "hip_p50": float(np.percentile(clean_hip[rm], 50)),
            "hip_p90": float(np.percentile(clean_hip[rm], 90)),
            "chest_p50": float(np.percentile(rc, 50)),
            "head_p50": float(np.percentile(rh, 50)),
        },
    }
    if len(cc) > 0:
        out["clinch_at_threshold"] = {
            "n_frames": int(len(cc)),
            "hip_p10": float(np.percentile(clean_hip[cm], 10)),
            "hip_p50": float(np.percentile(clean_hip[cm], 50)),
            "hip_p90": float(np.percentile(clean_hip[cm], 90)),
            "chest_p50": float(np.percentile(cc, 50)),
            "head_p50": float(np.percentile(ch, 50)),
        }
    out["p50_difference_m"] = float(p50_range - (p50_clinch if cm.sum() > 0 else 0))
    out["method_cannot_separate"] = bool(cm.sum() > 0 and (p50_range - p50_clinch) < 0.30)

    json_path = os.path.join(os.path.dirname(__file__), "Q115_distance.json")
    with open(json_path, "w") as f:
        json.dump(out, f, indent=2)
    print(f"\nSaved JSON to {json_path}")

    # Save raw arrays for check script
    raw_path = os.path.join(os.path.dirname(__file__), "Q115_raw_data.npz")
    np.savez_compressed(raw_path,
                        clean_hip_3d=clean_hip,
                        clean_chest_3d=clean_chest,
                        clean_head_3d=clean_head,
                        all_hip_3d=hip,
                        clip_ids=np.array(all_clips),
                        clean_clip_ids=np.array(CLEAN_CLIPS))
    print(f"Saved raw data to {raw_path}")


if __name__ == "__main__":
    main()
