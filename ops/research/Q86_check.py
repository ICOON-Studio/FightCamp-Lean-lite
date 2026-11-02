#!/usr/bin/env python
"""Q86's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q86_check.py

Re-derives from the delivery's own data, never from an expected verdict:
  - oscillations_per_min recomputed from pelvis_y_series (upward zero crossings of the height minus
    its mean, per minute of clip) within 10% or 2/min;
  - loops == (loop_seam_deg <= 3.0);
  - `standing` agrees with the numbers (pelvis 0.55-1.20 m, bounce <= 0.20 m, lowest foot <= 0.15 m up);
    a clip that is NOT standing stays in `clips` - `unmapped` is only for bones that cannot be found;
  - a pelvis that never moves must show which translation tracks were read; toes point along the facing;
  - every one of the eleven files is either measured or listed unmapped with a reason;
  - Davis's reference is carried exactly as K29 reports it.
"""
import json
import math
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
JSON_PATH = os.path.join(ROOT, "research/Q86_stance_takes.json")
MD_PATH = os.path.join(ROOT, "research/Q86_STANCE_TAKES.md")
TOOL = os.path.join(ROOT, "Godot/tools/measure_stance_takes.gd")
FILES = (
    "ramsterz_h2h/H2H_Idle.FBX", "ramsterz_h2h/H2H_BlockIdle.FBX", "ramsterz_h2h/H2H_JumpIdle.FBX",
    "ramsterz_h2h/H2H_LegBlockIdle.FBX", "ramsterz_h2h/Standing_Idle.FBX", "magicpot_fm1/idle_A.fbx",
    "magicpot_fm1/idle_Tiramis.fbx",
    "motifect/unpacked/Motifect_martial_arts_v1_0/FBX/muay_thai_guard_stance.fbx",
    "motifect/unpacked/Motifect_martial_arts_v1_0/FBX/wrestling_guard_position.fbx",
    "motifect/unpacked/Motifect_martial_arts_v1_0/FBX/staff_spin_guard.fbx",
    "motifect/unpacked/Motifect_martial_arts_v1_0/FBX/sword_draw_stance.fbx",
)
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def crossings_per_min(series, length_s):
    mean = sum(series) / len(series)
    d = [v - mean for v in series]
    ups = sum(1 for a, b in zip(d, d[1:]) if a < 0.0 <= b)
    return ups / (length_s / 60.0) if length_s > 0 else float("nan")


def norm(path):
    return path.replace("\\", "/").split("audition/")[-1]


def main():
    check(os.path.isfile(TOOL), "Godot/tools/measure_stance_takes.gd does not exist")
    if not check(os.path.isfile(JSON_PATH), "Q86_stance_takes.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return

    ref = data.get("davis_reference", {})
    check(list(ref.get("men_per_min", [])) == [47, 56] and ref.get("women_per_min") == 63,
          "davis_reference must carry K29's numbers exactly: men 47-56/min, women 63/min")

    clips = {norm(str(c.get("file", ""))): c for c in data.get("clips", [])}
    unmapped = {norm(str(u.get("file", ""))): u for u in data.get("unmapped", [])}
    for f in FILES:
        if f in unmapped:
            # SEND-BACK 1: 'unmapped' means the bones could not be FOUND. A clip that was measured and
            # fell outside a bound is a finding - it stays in `clips` with its numbers and a verdict.
            missing = unmapped[f].get("bones_missing", [])
            check(isinstance(missing, list) and len(missing) > 0,
                  f"{f}: unmapped must name the bones it could not find (bones_missing) - a measured clip stays in clips")
        else:
            check(f in clips, f"{f} is neither measured nor listed unmapped")

    for f, c in clips.items():
        for k in ("length_s", "pelvis_y_mean_m", "pelvis_y_amp_m", "oscillations_per_min", "loop_seam_deg",
                  "hands_below_head_m", "hands_forward_m", "stance_stagger_m", "stance_width_m"):
            check(finite(c.get(k)), f"{f}: {k} missing")
        if not all(finite(c.get(k)) for k in ("length_s", "pelvis_y_mean_m", "pelvis_y_amp_m", "oscillations_per_min", "loop_seam_deg")):
            continue
        check(isinstance(c.get("pack_status"), str) and isinstance(c.get("pack_licence"), str), f"{f}: pack status/licence missing")
        standing = c.get("standing")
        if check(isinstance(standing, bool), f"{f}: standing must be true or false, from the numbers"):
            is_standing = 0.55 <= c["pelvis_y_mean_m"] <= 1.20 and c["pelvis_y_amp_m"] <= 0.20                 and finite(c.get("lowest_foot_y_max_m")) and c["lowest_foot_y_max_m"] <= 0.15
            check(standing == is_standing, f"{f}: standing={standing} disagrees with its own pelvis height, bounce and lowest foot")
        # A performer is never motionless: exactly zero pelvis travel over a clip whose bones rotate means
        # the pelvis translation was not read (it lives on an ancestor or another track) - SEND-BACK 1.
        if c["pelvis_y_amp_m"] < 0.001:
            tracks = c.get("translation_tracks_on_chain", None)
            check(isinstance(tracks, list), f"{f}: pelvis never moves - list translation_tracks_on_chain (every position track on the pelvis and its ancestors) to show it was read")
        # Toes point roughly forward in any stance: the facing used for hands_forward must agree with the feet.
        check(finite(c.get("toes_along_facing")) and c["toes_along_facing"] > 0.0,
              f"{f}: toes_along_facing {c.get('toes_along_facing')} - the facing is flipped or missing, so hands_forward means nothing")
        for k in ("stance_stagger_m", "stance_width_m"):
            if finite(c.get(k)):
                check(0.0 <= c[k] <= 1.0, f"{f}: {k} {c[k]:.2f} m - feet cannot be that far apart standing")
        check(bool(c.get("loops")) == (c["loop_seam_deg"] <= 3.0), f"{f}: loops flag disagrees with seam {c['loop_seam_deg']:.2f} deg")
        series = c.get("pelvis_y_series", [])
        if check(isinstance(series, list) and len(series) >= max(2, int(c["length_s"] * 30.0) - 2) and all(finite(v) for v in series),
                 f"{f}: pelvis_y_series missing or shorter than the clip at 30 fps"):
            rate = crossings_per_min(series, c["length_s"])
            check(abs(rate - c["oscillations_per_min"]) <= max(2.0, 0.10 * rate),
                  f"{f}: oscillations_per_min {c['oscillations_per_min']:.1f} but its own series gives {rate:.1f}")
            check(abs((max(series) - min(series)) - c["pelvis_y_amp_m"]) <= 0.005,
                  f"{f}: pelvis_y_amp_m {c['pelvis_y_amp_m']:.3f} is not its own series' max - min")

    if check(os.path.isfile(MD_PATH), "Q86_STANCE_TAKES.md does not exist"):
        text = open(MD_PATH, encoding="utf-8").read()
        check(any("DECISIONS" in h for h in text.lstrip().splitlines()[:6]), "the markdown does not open with DECISIONS")
        check("Davis" in text, "the markdown does not set the bounce beside Davis's rate")


if __name__ == "__main__":
    main()
    if failures:
        for f in failures:
            print("FAIL", f)
        print(f"Q86_CHECK FAIL ({len(failures)})")
        sys.exit(1)
    print("Q86_CHECK PASS")
