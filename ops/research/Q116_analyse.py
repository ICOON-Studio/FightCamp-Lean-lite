"""Q116 — Clinch motion: how much does a clinch move, and how fast?

Same method and clips as Q115.  Segments consecutive clinch / range runs,
then measures per-run excursion of hip separation, vertical bob, lateral
sway, and dominant period.  Control arm (range > threshold) computed
identically for comparison.
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
CLEAN_CLIPS = ["-vPZqptk8jo", "HL261oRyURE", "FCM7m6TJWUQ"]

L_HIP, R_HIP = 23, 24
MIN_RUN_FRAMES = 3


def hip_mid(j):
    return (j[:, L_HIP] + j[:, R_HIP]) / 2.0


def find_runs(mask):
    """Maximal consecutive True runs -> list of (start, end) inclusive."""
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


def zero_crossing_period(signal, fps):
    """Dominant period from zero-crossings of mean-removed signal."""
    s = signal - np.mean(signal)
    crossings = np.where(np.diff(np.signbit(s)))[0]
    if len(crossings) < 2:
        return None, len(crossings)
    intervals = np.diff(crossings) / fps
    half = float(np.median(intervals))
    if half < 1e-6:
        return None, len(crossings)
    return 2.0 * half, len(crossings)


def fft_period(signal, fps):
    """Dominant period from FFT peak of mean-removed signal."""
    s = signal - np.mean(signal)
    n = len(s)
    if n < 8:
        return None
    S = np.abs(np.fft.rfft(s))
    freqs = np.fft.rfftfreq(n, d=1.0 / fps)
    if len(S) < 2:
        return None
    S = S[1:]
    freqs = freqs[1:]
    if len(S) == 0 or float(np.max(S)) < 1e-8:
        return None
    peak_f = float(freqs[np.argmax(S)])
    if peak_f < 1e-6:
        return None
    return 1.0 / peak_f


def lateral_positions(hm0_arr, hm1_arr, fidx):
    """Perpendicular (in xz) displacement of fighter fidx from the line
    joining the two hip midpoints.  Uses the MEAN facing direction across
    all frames (stable) rather than per-frame (noisy when dx >> dz)."""
    mean_hm0 = hm0_arr.mean(axis=0)
    mean_hm1 = hm1_arr.mean(axis=0)
    line_xz = (mean_hm1 - mean_hm0)[[0, 2]]
    line_len = np.linalg.norm(line_xz)
    if line_len < 1e-8:
        return np.zeros(len(hm0_arr))
    perp = np.array([-line_xz[1], line_xz[0]]) / line_len
    fighter_xz = (hm0_arr if fidx == 0 else hm1_arr)[:, [0, 2]]
    return np.dot(fighter_xz, perp)


def analyse_band(hip_sep, hm0, hm1, fps, mask, label):
    """Compute all motion metrics for one band (clinch or range)."""
    runs_all = find_runs(mask)
    n_runs_total = len(runs_all)
    lengths = [e - s + 1 for s, e in runs_all]

    kept = [(s, e) for s, e in runs_all if (e - s + 1) >= MIN_RUN_FRAMES]
    discarded = n_runs_total - len(kept)

    per_run = []
    for s, e in kept:
        n_f = e - s + 1
        sep = hip_sep[s:e + 1]
        h0 = hm0[s:e + 1]
        h1 = hm1[s:e + 1]

        hip_exc = float(np.max(sep) - np.min(sep))
        vert0 = float(np.ptp(h0[:, 1]))
        vert1 = float(np.ptp(h1[:, 1]))
        lat0 = float(np.ptp(lateral_positions(h0, h1, 0)))
        lat1 = float(np.ptp(lateral_positions(h0, h1, 1)))

        period, n_cross = zero_crossing_period(sep, fps)
        fft_p = fft_period(sep, fps)

        per_run.append({
            "start": int(s), "end": int(e), "n_frames": n_f,
            "duration_s": round(n_f / fps, 3),
            "hip_excursion_m": round(hip_exc, 4),
            "vert_exc_f0_m": round(vert0, 4),
            "vert_exc_f1_m": round(vert1, 4),
            "lat_exc_f0_m": round(lat0, 4),
            "lat_exc_f1_m": round(lat1, 4),
            "period_zc_s": round(period, 3) if period is not None else None,
            "period_fft_s": round(fft_p, 3) if fft_p is not None else None,
            "n_zero_crossings": n_cross,
        })

    pooled = {"n_runs": len(kept)}
    if kept:
        exc = np.array([r["hip_excursion_m"] for r in per_run])
        v0 = np.array([r["vert_exc_f0_m"] for r in per_run])
        v1 = np.array([r["vert_exc_f1_m"] for r in per_run])
        l0 = np.array([r["lat_exc_f0_m"] for r in per_run])
        l1 = np.array([r["lat_exc_f1_m"] for r in per_run])
        dur = np.array([r["duration_s"] for r in per_run])
        pooled["hip_excursion"] = {
            "p50": round(float(np.percentile(exc, 50)), 4),
            "p10": round(float(np.percentile(exc, 10)), 4),
            "p90": round(float(np.percentile(exc, 90)), 4),
            "mean": round(float(np.mean(exc)), 4),
        }
        pooled["vert_exc_f0"] = {
            "p50": round(float(np.percentile(v0, 50)), 4),
            "p90": round(float(np.percentile(v0, 90)), 4),
        }
        pooled["vert_exc_f1"] = {
            "p50": round(float(np.percentile(v1, 50)), 4),
            "p90": round(float(np.percentile(v1, 90)), 4),
        }
        pooled["lat_exc_f0"] = {
            "p50": round(float(np.percentile(l0, 50)), 4),
            "p90": round(float(np.percentile(l0, 90)), 4),
        }
        pooled["lat_exc_f1"] = {
            "p50": round(float(np.percentile(l1, 50)), 4),
            "p90": round(float(np.percentile(l1, 90)), 4),
        }
        pooled["run_duration_s"] = {
            "p50": round(float(np.percentile(dur, 50)), 3),
            "p10": round(float(np.percentile(dur, 10)), 3),
            "p90": round(float(np.percentile(dur, 90)), 3),
            "mean": round(float(np.mean(dur)), 3),
        }
        periods_zc = [r["period_zc_s"] for r in per_run if r["period_zc_s"] is not None]
        periods_fft = [r["period_fft_s"] for r in per_run if r["period_fft_s"] is not None]
        pooled["period"] = {
            "n_resolvable_zc": len(periods_zc),
            "n_resolvable_fft": len(periods_fft),
            "median_zc_s": round(float(np.median(periods_zc)), 3) if periods_zc else None,
            "median_fft_s": round(float(np.median(periods_fft)), 3) if periods_fft else None,
        }
    else:
        pooled["hip_excursion"] = {}
        pooled["vert_exc_f0"] = {}
        pooled["vert_exc_f1"] = {}
        pooled["lat_exc_f0"] = {}
        pooled["lat_exc_f1"] = {}
        pooled["run_duration_s"] = {}
        pooled["period"] = {}

    return {
        "label": label,
        "n_runs_total": n_runs_total,
        "n_runs_kept": len(kept),
        "n_runs_discarded": discarded,
        "min_run_frames": MIN_RUN_FRAMES,
        "run_lengths": lengths,
        "pooled": pooled,
        "per_run": per_run,
    }


def main():
    all_hip_sep = []
    all_hm0 = []
    all_hm1 = []
    all_fps = []
    all_valid = []

    for cid in CLEAN_CLIPS:
        path = os.path.join(TRACK_DIR, cid + ".npz")
        track = np.load(path)
        t_arr = track["t"]
        out = pw.reconstruct_clip(
            t_arr, track["img"], track["world"], track["n"],
            float(track["fps"]), cid, float(t_arr[0]), float(t_arr[-1]),
        )
        joints = out["joints"]
        n_f = out["n_fighters"]
        vis = out["visibility"]
        fps = float(track["fps"])

        two = n_f == 2
        j = joints[two]
        v = vis[two]

        hm0 = hip_mid(j[:, 0])
        hm1 = hip_mid(j[:, 1])
        hip_sep = np.linalg.norm(hm1 - hm0, axis=1)

        hip_vis = ((v[:, 0, L_HIP] > 0.5) & (v[:, 0, R_HIP] > 0.5)
                   & (v[:, 1, L_HIP] > 0.5) & (v[:, 1, R_HIP] > 0.5))
        ok = hip_vis & np.isfinite(hip_sep) & (hip_sep >= 0.40) & (hip_sep <= 3.0)

        all_hip_sep.append(hip_sep[ok])
        all_hm0.append(hm0[ok])
        all_hm1.append(hm1[ok])
        all_fps.append(fps)
        all_valid.append(int(ok.sum()))
        print(f"  {cid}: {int(two.sum())} two-fighter, {int(ok.sum())} valid, "
              f"hip_sep p50={float(np.nanmedian(hip_sep[ok])):.3f} m")

    hip_sep = np.concatenate(all_hip_sep)
    hm0 = np.concatenate(all_hm0)
    hm1 = np.concatenate(all_hm1)
    fps = all_fps[0]
    total_frames = len(hip_sep)

    print(f"\nTotal valid frames: {total_frames}")
    print(f"FPS: {fps}")

    out = {
        "q116": "clinch_motion",
        "date": "2026-09-21",
        "method": "pair_world.py PAIR_WORLD_v1 on track/*.npz, run segmentation",
        "clean_clips": CLEAN_CLIPS,
        "clip_frame_counts": {c: n for c, n in zip(CLEAN_CLIPS, all_valid)},
        "total_frames": total_frames,
        "fps": fps,
        "min_run_frames": MIN_RUN_FRAMES,
        "clinch_definition": "3D hip-to-hip <= threshold, consecutive frames segmented into runs",
    }

    for thresh, label in [(0.80, "clinch"), (0.90, "clinch_wide")]:
        c_mask = hip_sep <= thresh
        r_mask = hip_sep > thresh
        print(f"\n{'=' * 64}")
        print(f"Threshold {thresh:.2f} m: {int(c_mask.sum())} clinch, {int(r_mask.sum())} range")
        print(f"{'=' * 64}")

        c_res = analyse_band(hip_sep, hm0, hm1, fps, c_mask, f"{label}_thresh_{thresh}")
        r_res = analyse_band(hip_sep, hm0, hm1, fps, r_mask, f"range_thresh_{thresh}")

        print(f"\n  CLINCH (<= {thresh:.2f} m):")
        print(f"    Runs total: {c_res['n_runs_total']}, "
              f"kept (>={MIN_RUN_FRAMES}f): {c_res['n_runs_kept']}, "
              f"discarded: {c_res['n_runs_discarded']}")
        if c_res["run_lengths"]:
            print(f"    Run lengths: {c_res['run_lengths']}")
        if c_res["pooled"].get("hip_excursion"):
            he = c_res["pooled"]["hip_excursion"]
            print(f"    Hip excursion: p50={he['p50']:.4f} m, "
                  f"p10={he['p10']:.4f}, p90={he['p90']:.4f}")
            ve0 = c_res["pooled"]["vert_exc_f0"]
            ve1 = c_res["pooled"]["vert_exc_f1"]
            print(f"    Vertical bob F0: p50={ve0.get('p50', 0):.4f}, "
                  f"p90={ve0.get('p90', 0):.4f}")
            print(f"    Vertical bob F1: p50={ve1.get('p50', 0):.4f}, "
                  f"p90={ve1.get('p90', 0):.4f}")
            le0 = c_res["pooled"]["lat_exc_f0"]
            le1 = c_res["pooled"]["lat_exc_f1"]
            print(f"    Lateral sway F0: p50={le0.get('p50', 0):.4f}, "
                  f"p90={le0.get('p90', 0):.4f}")
            print(f"    Lateral sway F1: p50={le1.get('p50', 0):.4f}, "
                  f"p90={le1.get('p90', 0):.4f}")
            rd = c_res["pooled"]["run_duration_s"]
            print(f"    Run duration: p50={rd.get('p50', 0):.3f} s, "
                  f"mean={rd.get('mean', 0):.3f} s")
            per = c_res["pooled"]["period"]
            print(f"    Period: n_resolvable_zc={per.get('n_resolvable_zc', 0)}, "
                  f"n_resolvable_fft={per.get('n_resolvable_fft', 0)}")
            if per.get("median_zc_s") is not None:
                print(f"    Median period (ZC): {per['median_zc_s']:.3f} s")
            if per.get("median_fft_s") is not None:
                print(f"    Median period (FFT): {per['median_fft_s']:.3f} s")

        print(f"\n  RANGE (> {thresh:.2f} m):")
        print(f"    Runs total: {r_res['n_runs_total']}, "
              f"kept (>={MIN_RUN_FRAMES}f): {r_res['n_runs_kept']}, "
              f"discarded: {r_res['n_runs_discarded']}")
        if r_res["pooled"].get("hip_excursion"):
            he = r_res["pooled"]["hip_excursion"]
            print(f"    Hip excursion: p50={he['p50']:.4f} m, "
                  f"p10={he['p10']:.4f}, p90={he['p90']:.4f}")
            ve0 = r_res["pooled"]["vert_exc_f0"]
            ve1 = r_res["pooled"]["vert_exc_f1"]
            print(f"    Vertical bob F0: p50={ve0.get('p50', 0):.4f}, "
                  f"p90={ve0.get('p90', 0):.4f}")
            print(f"    Vertical bob F1: p50={ve1.get('p50', 0):.4f}, "
                  f"p90={ve1.get('p90', 0):.4f}")
            le0 = r_res["pooled"]["lat_exc_f0"]
            le1 = r_res["pooled"]["lat_exc_f1"]
            print(f"    Lateral sway F0: p50={le0.get('p50', 0):.4f}, "
                  f"p90={le0.get('p90', 0):.4f}")
            print(f"    Lateral sway F1: p50={le1.get('p50', 0):.4f}, "
                  f"p90={le1.get('p90', 0):.4f}")
            rd = r_res["pooled"]["run_duration_s"]
            print(f"    Run duration: p50={rd.get('p50', 0):.3f} s, "
                  f"mean={rd.get('mean', 0):.3f} s")

        out[f"clinch_{thresh}"] = c_res
        out[f"range_{thresh}"] = r_res

    # Degenerate case: threshold = 0.0 m
    deg_mask = hip_sep <= 0.0
    deg_runs = find_runs(deg_mask)
    out["degenerate_0m"] = {
        "n_runs": len(deg_runs),
        "n_frames": int(deg_mask.sum()),
        "note": "no runs" if len(deg_runs) == 0 else "unexpected: runs found at 0.0 m",
    }
    print(f"\nDegenerate (<= 0.0 m): {len(deg_runs)} runs, "
          f"{int(deg_mask.sum())} frames")

    json_path = os.path.join(os.path.dirname(__file__), "Q116_motion.json")
    with open(json_path, "w") as f:
        json.dump(out, f, indent=2)
    print(f"\nSaved JSON to {json_path}")


if __name__ == "__main__":
    main()
