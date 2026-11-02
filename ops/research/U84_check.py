#!/usr/bin/env python
"""U84's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U84_check.py

Bounds come from the world and from the clip itself, not from an expected answer: a walk plants
every step once, a walking speed is 0.2-2.0 m/s, a root-motion walk's planted
foot barely skates (< 0.15 m/s), an in-place clip must agree with its root-motion twin within 15%,
a step is the twin's travel shared over its planted spans, and a clip's direction is the one its
NAME says. SEND-BACK 1 removed a "boxing step is 0.2-0.8 m" bound: K29 found step length NOT FOUND
in any bout study, so it was an invented number - the step is now reported, never bounded.
"""
import json
import math
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
R = lambda p: os.path.join(ROOT, p)  # noqa: E731
JSON_PATH = R("research/U84_stride_speed.json")
MD_PATH = R("research/U84_STRIDE_SPEED.md")
TOOL = R("Godot/tools/measure_stride_speed.gd")
FOLDER = R("Godot/assets/anim/audition/ramsterz_h2h")
# Forward is 0; a Left/Right pair must sit at +-90 with opposite signs, diagonals at +-45 / +-135.
DIRECTION = {"Forward": 0.0, "Back": 180.0, "Left": 90.0, "Right": -90.0, "ForwardLeft": 45.0,
             "ForwardRight": -45.0, "BackLeft": 135.0, "BackRight": -135.0}
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def main():
    on_disk = sorted(f for f in os.listdir(FOLDER) if f.startswith("H2H_Walk") and f.endswith(".FBX"))
    twins = {f for f in os.listdir(FOLDER) if f.startswith("H2H_Walk") and f.endswith("_RootMotion.fbx")}
    check(len(on_disk) >= 2, "the gate found no H2H_Walk*.FBX on disk - the gate itself is broken")

    check(os.path.isfile(TOOL), "Godot/tools/measure_stride_speed.gd does not exist")
    if not check(os.path.isfile(JSON_PATH), "U84_stride_speed.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return

    clips = {c.get("file"): c for c in data.get("clips", [])}
    check(sorted(clips) == on_disk, f"clips {sorted(clips)} are not every in-place walk on disk {on_disk}")
    for name, c in clips.items():
        spans = c.get("planted_spans")
        # Every planted interval of either foot in the whole clip - a 1 s clip may hold four.
        check(isinstance(spans, int) and 1 <= spans <= 8, f"{name}: {spans} planted spans in the clip is not a walk")
        check(finite(c.get("cadence_steps_per_s")) and finite(c.get("length_s")) and c.get("length_s", 0) > 0
              and abs(c["cadence_steps_per_s"] - spans / c["length_s"]) <= 0.05,
              f"{name}: cadence_steps_per_s must be planted spans / clip length")
        for f in ("length_s", "sweep_speed_mps", "native_speed_mps", "step_length_m", "root_direction_deg"):
            check(finite(c.get(f)), f"{name}: {f} missing")
        if not all(finite(c.get(f)) for f in ("native_speed_mps", "step_length_m")):
            continue
        check(0.2 <= c["native_speed_mps"] <= 2.0, f"{name}: native speed {c['native_speed_mps']:.3f} m/s is not a walk")
        want_dir = DIRECTION.get(name.replace("H2H_Walk", "").replace(".FBX", ""))
        got_dir = c.get("root_direction_deg")
        if want_dir is not None and check(finite(got_dir), f"{name}: root_direction_deg missing"):
            err = abs((got_dir - want_dir + 180.0) % 360.0 - 180.0)
            mirrored = abs((got_dir + want_dir + 180.0) % 360.0 - 180.0)
            check(min(err, mirrored) <= 25.0,
                  f"{name}: travels at {got_dir:.1f} deg but its name says {want_dir:.0f} (or its mirror) - the direction is not measured")
        twin = name.replace(".FBX", "_RootMotion.fbx")
        if twin in twins:
            check(c.get("twin") == twin, f"{name}: its twin {twin} exists on disk but was not measured")
            ts, sk = c.get("twin_native_speed_mps"), c.get("twin_planted_skate_mps")
            if check(finite(ts) and finite(sk), f"{name}: twin speed or skate missing"):
                check(sk < 0.15, f"{twin}: planted foot skates {sk:.3f} m/s - the planted definition is wrong")
                tt = c.get("twin_root_travel_m")
                if check(finite(tt) and isinstance(spans, int) and spans > 0, f"{name}: twin travel missing"):
                    check(abs(c["step_length_m"] * spans - tt) <= 0.15 * tt,
                          f"{name}: step {c['step_length_m']:.3f} m x {spans} spans is not the twin's travel {tt:.3f} m")
                check(ts > 0 and abs(c["native_speed_mps"] - ts) / ts <= 0.15,
                      f"{name}: in-place sweep {c['native_speed_mps']:.3f} vs twin travel {ts:.3f} m/s disagree by more than 15%")

    bound = data.get("bound", {})
    for role, file in (("loc_advance", "H2H_WalkForward.FBX"), ("loc_retreat", "H2H_WalkBack.FBX")):
        got = bound.get(role, {}).get("native_speed_mps")
        want = clips.get(file, {}).get("native_speed_mps")
        check(finite(got) and finite(want) and abs(got - want) < 1e-6, f"bound {role} must equal {file}'s native speed")

    if check(os.path.isfile(MD_PATH), "U84_STRIDE_SPEED.md does not exist"):
        text = open(MD_PATH, encoding="utf-8").read()
        check(any("DECISIONS" in h for h in text.lstrip().splitlines()[:6]), "the markdown does not open with DECISIONS")
        check("0.6" in text and "0.3" in text, "the markdown does not give the playback rate at 0.6 and 0.3 m/s")


if __name__ == "__main__":
    main()
    if failures:
        for f in failures:
            print("FAIL", f)
        print(f"U84_CHECK FAIL ({len(failures)})")
        sys.exit(1)
    print("U84_CHECK PASS")
