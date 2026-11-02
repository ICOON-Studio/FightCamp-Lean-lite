"""Q115 — measure clinch vs range hip separation from broadcast footage.

Uses pair_world.py to place both fighters in one shared metric space, then
analyses the distribution of inter-fighter distances to derive a clinch
definition from the data (not a picked threshold).

Usage:
    python research/Q115_analyse.py
"""
from __future__ import annotations

import json
import os
import sys

import numpy as np

# Add pair_world to path
TOOLS = os.path.join(os.path.dirname(__file__), "..", "..", "Tools", "footage")
sys.path.insert(0, os.path.abspath(TOOLS))
import pair_world as pw

# Track files live in the shared footage store
TRACK_DIR = r"C:\Users\user\AppData\Local\Temp\FightCamp-footage\track"

# Clean standing clips per U112 inventory (visibility >= 0.877)
CLEAN_CLIPS = [
    "-vPZqptk8jo",   # vis 0.898, 118.7 s
    "HL261oRyURE",   # vis 0.882, 105.8 s
    "FCM7m6TJWUQ",   # vis 0.877,  50.5 s
]
# Fourth standing clip (good but longer)
EXTRA_CLIPS = [
    "wzUWvsviqTM",   # vis 0.807, 470.2 s
]

# Joint indices
L_HIP, R_HIP = 23, 24
L_SH, R_SH = 11, 12
NOSE = 0
L_ANK, R_ANK = 27, 28


def hip_mid(joints_f: np.ndarray) -> np.ndarray:
    """(F,3) hip midpoint per fighter."""
    return (joints_f[:, L_HIP] + joints_f[:, R_HIP]) / 2.0


def chest_mid(joints_f: np.ndarray) -> np.ndarray:
    return (joints_f[:, L_SH] + joints_f[:, R_SH]) / 2.0


def head_pos(joints_f: np.ndarray) -> np.ndarray:
    return joints_f[:, NOSE]


def process_clip(clip_id: str) -> dict:
    """Load track, reconstruct pair world, return per-frame distances."""
    path = os.path.join(TRACK_DIR, clip_id + ".npz")
    if not os.path.exists(path):
        print(f"  SKIP {clip_id}: not found at {path}")
        return {}

    track = np.load(path)
    t_arr = track["t"]
    img = track["img"]
    world = track["world"]
    n_arr = track["n"]
    fps = float(track["fps"])

    out = pw.reconstruct_clip(t_arr, img, world, n_arr, fps, clip_id,
                              float(t_arr[0]), float(t_arr[-1]))

    joints = out["joints"]       # (F, 2, 33, 3)
    n_f = out["n_fighters"]      # (F,)
    vis = out["visibility"]      # (F, 2, 33)

    two = n_f == 2
    j = joints[two]              # (N, 2, 33, 3)
    v = vis[two]                 # (N, 2, 33)

    # Hip separation (3D)
    hm0 = hip_mid(j[:, 0])      # (N, 3)
    hm1 = hip_mid(j[:, 1])
    hip_sep_3d = np.linalg.norm(hm1 - hm0, axis=1)

    # Horizontal only (x)
    hip_sep_x = np.abs(hm1[:, 0] - hm0[:, 0])

    # Depth only (z)
    hip_sep_z = np.abs(hm1[:, 2] - hm0[:, 2])

    # Chest-to-chest (3D)
    cm0 = chest_mid(j[:, 0])
    cm1 = chest_mid(j[:, 1])
    chest_sep = np.linalg.norm(cm1 - cm0, axis=1)

    # Head-to-head (3D)
    hd0 = head_pos(j[:, 0])
    hd1 = head_pos(j[:, 1])
    head_sep = np.linalg.norm(hd1 - hd0, axis=1)

    # Filter: both fighters must have hips visible
    hip_vis = (v[:, 0, L_HIP] > 0.5) & (v[:, 0, R_HIP] > 0.5) & \
              (v[:, 1, L_HIP] > 0.5) & (v[:, 1, R_HIP] > 0.5)

    # Filter: finite values
    ok = hip_vis & np.isfinite(hip_sep_3d) & (hip_sep_3d > 0.05) & (hip_sep_3d < 5.0)

    print(f"  {clip_id}: {two.sum()} two-fighter frames, {ok.sum()} pass filters "
          f"({100*ok.sum()/max(1,two.sum()):.0f}%)")

    return {
        "clip": clip_id,
        "n_two": int(two.sum()),
        "n_ok": int(ok.sum()),
        "hip_sep_3d": hip_sep_3d[ok],
        "hip_sep_x": hip_sep_x[ok],
        "hip_sep_z": hip_sep_z[ok],
        "chest_sep": chest_sep[ok],
        "head_sep": head_sep[ok],
    }


def percentile(arr, pcts):
    if len(arr) == 0:
        return {p: float("nan") for p in pcts}
    return {p: float(np.percentile(arr, p)) for p in pcts}


def histogram_bins(arr, bin_w=0.05, max_val=3.0):
    """Return (edges, counts) for bins of width bin_w up to max_val."""
    edges = np.arange(0, max_val + bin_w, bin_w)
    counts, _ = np.histogram(arr, bins=edges)
    return edges, counts


def find_modes(edges, counts, min_prominence=0.05):
    """Find local maxima in the histogram that are prominent enough."""
    # Smooth with a 3-bin moving average
    smoothed = np.convolve(counts.astype(float), np.ones(3)/3, mode='same')
    modes = []
    for i in range(1, len(smoothed) - 1):
        if smoothed[i] > smoothed[i-1] and smoothed[i] > smoothed[i+1]:
            # Prominence: how much it stands above its neighbours
            prominence = (smoothed[i] - min(smoothed[i-1], smoothed[i+1])) / max(1, smoothed[i])
            if prominence > min_prominence:
                center = (edges[i] + edges[i+1]) / 2.0
                modes.append((center, int(counts[i]), float(prominence)))
    modes.sort(key=lambda x: -x[1])  # sort by count
    return modes


def main():
    all_clips = CLEAN_CLIPS + EXTRA_CLIPS
    results = {}

    print("=" * 70)
    print("Q115 — Clinch distance measurement")
    print("=" * 70)

    # Process clips one at a time
    all_hip_3d = []
    all_hip_x = []
    all_hip_z = []
    all_chest = []
    all_head = []
    clip_stats = []

    for clip_id in all_clips:
        print(f"\nProcessing {clip_id}...")
        r = process_clip(clip_id)
        if not r:
            continue
        results[clip_id] = r
        all_hip_3d.append(r["hip_sep_3d"])
        all_hip_x.append(r["hip_sep_x"])
        all_hip_z.append(r["hip_sep_z"])
        all_chest.append(r["chest_sep"])
        all_head.append(r["head_sep"])
        clip_stats.append({
            "clip": clip_id,
            "n_two": r["n_two"],
            "n_ok": r["n_ok"],
        })

    # Concatenate
    hip_3d = np.concatenate(all_hip_3d)
    hip_x = np.concatenate(all_hip_x)
    hip_z = np.concatenate(all_hip_z)
    chest = np.concatenate(all_chest)
    head = np.concatenate(all_head)

    print(f"\n{'=' * 70}")
    print(f"TOTAL: {len(hip_3d)} valid frames across {len(results)} clips")
    print(f"{'=' * 70}")

    # Full distribution analysis
    print(f"\n--- Hip-to-hip 3D distance distribution ---")
    edges, counts = histogram_bins(hip_3d, bin_w=0.05, max_val=3.0)
    print(f"  p10={np.percentile(hip_3d, 10):.3f} m")
    print(f"  p25={np.percentile(hip_3d, 25):.3f} m")
    print(f"  p50={np.percentile(hip_3d, 50):.3f} m")
    print(f"  p75={np.percentile(hip_3d, 75):.3f} m")
    print(f"  p90={np.percentile(hip_3d, 90):.3f} m")
    print(f"  mean={np.mean(hip_3d):.3f} m, std={np.std(hip_3d):.3f} m")
    print(f"  min={np.min(hip_3d):.3f} m, max={np.max(hip_3d):.3f} m")

    # Histogram
    print(f"\n  Histogram (5 cm bins, 0-3.0 m):")
    for i in range(len(counts)):
        if counts[i] > 0:
            bar = "#" * min(80, int(80 * counts[i] / max(counts)))
            print(f"    {edges[i]:.2f}-{edges[i+1]:.2f}: {counts[i]:5d} {bar}")

    # Find modes
    modes = find_modes(edges, counts)
    print(f"\n  Modes found: {len(modes)}")
    for center, count, prom in modes[:5]:
        print(f"    center={center:.2f} m, count={count}, prominence={prom:.2f}")

    # Horizontal separation
    print(f"\n--- Hip-to-hip horizontal (x) distance ---")
    print(f"  p10={np.percentile(hip_x, 10):.3f} m")
    print(f"  p50={np.percentile(hip_x, 50):.3f} m")
    print(f"  p90={np.percentile(hip_x, 90):.3f} m")

    # Depth separation
    print(f"\n--- Hip-to-hip depth (z) distance ---")
    print(f"  p10={np.percentile(hip_z, 10):.3f} m")
    print(f"  p50={np.percentile(hip_z, 50):.3f} m")
    print(f"  p90={np.percentile(hip_z, 90):.3f} m")

    # Chest and head
    print(f"\n--- Chest-to-chest 3D distance ---")
    print(f"  p10={np.percentile(chest, 10):.3f} m")
    print(f"  p50={np.percentile(chest, 50):.3f} m")
    print(f"  p90={np.percentile(chest, 90):.3f} m")

    print(f"\n--- Head-to-head 3D distance ---")
    print(f"  p10={np.percentile(head, 10):.3f} m")
    print(f"  p50={np.percentile(head, 50):.3f} m")
    print(f"  p90={np.percentile(head, 90):.3f} m")

    # Now try to separate clinch from range using the distribution
    # The clinch should be a mode at short distance
    print(f"\n{'=' * 70}")
    print("CLINCH vs RANGE SEPARATION")
    print(f"{'=' * 70}")

    # Look at the CDF to find natural breakpoints
    sorted_d = np.sort(hip_3d)
    cdf = np.arange(1, len(sorted_d)+1) / len(sorted_d)

    # Find where the first big jump ends (clinch population)
    # Look at the derivative of the CDF (PDF)
    # The clinch mode should be the first peak
    if modes:
        # Use the first mode (shortest distance peak) as clinch center
        clinch_center = modes[0][0]
        print(f"\n  First mode (clinch candidate): {clinch_center:.2f} m")

        # Try different thresholds and see what happens
        thresholds = [0.30, 0.35, 0.40, 0.45, 0.50, 0.55, 0.60, 0.65, 0.70, 0.75, 0.80]
        print(f"\n  Sensitivity analysis — varying clinch threshold:")
        print(f"  {'thresh':>8s} {'n_clinch':>10s} {'n_range':>10s} {'p50_clinch':>12s} {'p50_range':>12s} {'diff':>8s}")

        for thresh in thresholds:
            clinch_mask = hip_3d <= thresh
            range_mask = hip_3d > thresh
            n_c = clinch_mask.sum()
            n_r = range_mask.sum()
            if n_c > 10 and n_r > 10:
                p50_c = np.percentile(hip_3d[clinch_mask], 50)
                p50_r = np.percentile(hip_3d[range_mask], 50)
                diff = p50_r - p50_c
                print(f"  {thresh:8.2f} {n_c:10d} {n_r:10d} {p50_c:12.3f} {p50_r:12.3f} {diff:8.3f}")

    # Per-clip breakdown
    print(f"\n{'=' * 70}")
    print("PER-CLIP BREAKDOWN")
    print(f"{'=' * 70}")
    for clip_id, r in results.items():
        h = r["hip_sep_3d"]
        print(f"\n  {clip_id} (n={len(h)}):")
        print(f"    p10={np.percentile(h, 10):.3f}  p50={np.percentile(h, 50):.3f}  p90={np.percentile(h, 90):.3f}")
        # Show first 20 values sorted
        sh = np.sort(h)
        print(f"    lowest 10: {', '.join(f'{v:.3f}' for v in sh[:10])}")

    # Save raw data for the check script
    out_path = os.path.join(os.path.dirname(__file__), "Q115_raw_data.npz")
    np.savez_compressed(out_path,
                        hip_3d=hip_3d, hip_x=hip_x, hip_z=hip_z,
                        chest=chest, head=head,
                        clip_ids=np.array(all_clips[:len(clip_stats)]))
    print(f"\nSaved raw data to {out_path}")

    # Save JSON summary
    json_out = {
        "clips_used": [c["clip"] for c in clip_stats],
        "clip_frame_counts": clip_stats,
        "total_frames": int(len(hip_3d)),
        "hip_3d": {
            "p10": float(np.percentile(hip_3d, 10)),
            "p25": float(np.percentile(hip_3d, 25)),
            "p50": float(np.percentile(hip_3d, 50)),
            "p75": float(np.percentile(hip_3d, 75)),
            "p90": float(np.percentile(hip_3d, 90)),
            "mean": float(np.mean(hip_3d)),
            "std": float(np.std(hip_3d)),
            "min": float(np.min(hip_3d)),
            "max": float(np.max(hip_3d)),
        },
        "hip_x": {
            "p10": float(np.percentile(hip_x, 10)),
            "p50": float(np.percentile(hip_x, 50)),
            "p90": float(np.percentile(hip_x, 90)),
        },
        "hip_z": {
            "p10": float(np.percentile(hip_z, 10)),
            "p50": float(np.percentile(hip_z, 50)),
            "p90": float(np.percentile(hip_z, 90)),
        },
        "chest_3d": {
            "p10": float(np.percentile(chest, 10)),
            "p50": float(np.percentile(chest, 50)),
            "p90": float(np.percentile(chest, 90)),
        },
        "head_3d": {
            "p10": float(np.percentile(head, 10)),
            "p50": float(np.percentile(head, 50)),
            "p90": float(np.percentile(head, 90)),
        },
        "modes": [{"center_m": m[0], "count": m[1], "prominence": m[2]} for m in modes[:5]],
    }
    json_path = os.path.join(os.path.dirname(__file__), "Q115_distance.json")
    with open(json_path, "w") as f:
        json.dump(json_out, f, indent=2)
    print(f"Saved JSON to {json_path}")


if __name__ == "__main__":
    main()
