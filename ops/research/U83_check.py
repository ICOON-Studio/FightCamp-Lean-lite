#!/usr/bin/env python
"""U83's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/U83_check.py

Holds the INSTRUMENT to physics and to the real world, never to the answer Q83 gave:
  - the idle's lowest toe stands on the floor: -0.05 .. +0.10 m;
  - a standing pelvis (T-pose hierarchy, idle) is 0.80 .. 1.05 m up (adult human pelvis height);
  - a walking pelvis bobs 0.01 .. 0.12 m (real walking vertical CoM excursion is ~4-6 cm, M18);
  - no pelvis is ever under the floor (>= -0.05 m) or above a jump (<= 1.30 m);
  - the population is exactly Q83's rows, and each row's `q83` block is Q83's own numbers.
"""
import json
import math
import os
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
R = lambda p: os.path.join(ROOT, p)  # noqa: E731
JSON_PATH = R("research/U83_pelvis_by_tree.json")
MD_PATH = R("research/U83_PELVIS_BY_TREE.md")
TOOL = R("Godot/tools/measure_pelvis_by_tree.gd")
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def key(r):
    return (str(r.get("path")), round(float(r.get("start_s", -1)), 3), round(float(r.get("end_s", -1)), 3))


def main():
    q83 = json.load(open(R("research/Q83_dropped_position_tracks.json"), encoding="utf-8"))
    q83_rows = {key(r): r for r in q83.get("rows", [])}
    check(len(q83_rows) == 28, f"Q83 baseline is not 28 rows ({len(q83_rows)}) - the gate itself is broken")

    check(os.path.isfile(TOOL), "Godot/tools/measure_pelvis_by_tree.gd does not exist")
    if not check(os.path.isfile(JSON_PATH), "U83_pelvis_by_tree.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return

    toe = data.get("floor", {}).get("idle_lowest_toe_y_m")
    check(finite(toe) and -0.05 <= toe <= 0.10, f"the idle's lowest toe is at {toe} m - the instrument's floor is wrong")
    tp = data.get("tpose", {}).get("pelvis_y_m")
    check(finite(tp) and 0.80 <= tp <= 1.05, f"T-pose pelvis at {tp} m is not a standing human pelvis")
    idle = data.get("idle", {})
    check(all(finite(idle.get(k)) and 0.80 <= idle.get(k) <= 1.05 for k in ("pelvis_y_min_m", "pelvis_y_max_m")),
          f"idle pelvis {idle} is not a standing human pelvis")

    ts = data.get("track_space", {})
    samples = ts.get("samples", [])
    check(len(samples) == 5 and all(all(isinstance(s.get(k), list) and len(s.get(k)) == 3 and all(finite(v) for v in s.get(k))
                                        for k in ("raw_track", "local", "global")) for s in samples),
          "track_space must hold 5 samples, each with raw_track, local and global as 3 numbers")
    if len(samples) == 5:
        def near(a, b):
            return math.dist(a, b) <= 0.001
        eq_local = all(near(s["raw_track"], s["local"]) for s in samples)
        eq_global = all(near(s["raw_track"], s["global"]) for s in samples)
        derived = "local" if eq_local else ("global" if eq_global else "neither")
        check(ts.get("raw_track_equals") == derived,
              f"track_space says the raw track equals '{ts.get('raw_track_equals')}', its own samples say '{derived}'")

    rows = data.get("rows", [])
    got = {key(r): r for r in rows}
    check(len(rows) == 28 and set(got) == set(q83_rows), f"rows are not Q83's 28 windows (got {len(rows)}, {len(set(got) & set(q83_rows))} matching)")
    for k, r in got.items():
        name = os.path.basename(k[0])
        vals = [r.get(f) for f in ("pelvis_y_min_m", "pelvis_y_max_m", "pelvis_y_final_m", "pelvis_xz_net_m",
                                   "pelvis_xz_path_m", "root_xz_net_m", "lowest_toe_y_min_m")]
        if not check(all(finite(v) for v in vals) and int(r.get("frames", 0)) >= 2, f"{name} {k[1]}-{k[2]}: a field is missing"):
            continue
        lo, hi = r["pelvis_y_min_m"], r["pelvis_y_max_m"]
        check(-0.05 <= lo <= hi <= 1.30, f"{name} {k[1]}-{k[2]}: pelvis {lo:.3f}..{hi:.3f} m leaves the physical range")
        check(r["pelvis_xz_net_m"] <= r["pelvis_xz_path_m"] + 1e-6, f"{name}: net travel exceeds path length")
        ref = q83_rows.get(k, {})
        q = r.get("q83", {})
        for f in ("pelvis_y_min_m", "pelvis_y_max_m", "pelvis_xz_net_m"):
            check(finite(q.get(f)) and abs(q.get(f) - float(ref.get(f, 1e9))) <= 1e-6,
                  f"{name}: q83.{f} is not Q83's own number")
        if name == "H2H_WalkForward.FBX":
            bob = hi - lo
            check(0.01 <= bob <= 0.12, f"WalkForward pelvis bob {bob:.3f} m is not a walking bob (real: ~0.04-0.06 m)")

    cav = data.get("caveats", {})
    check(all(isinstance(cav.get(c), str) and len(cav.get(c).strip()) > 10 for c in ("1", "2", "3")), "caveats 1-3 need verdicts")

    if check(os.path.isfile(MD_PATH), "U83_PELVIS_BY_TREE.md does not exist"):
        text = open(MD_PATH, encoding="utf-8").read()
        check(any("DECISIONS" in h for h in text.lstrip().splitlines()[:6]), "the markdown does not open with DECISIONS")


if __name__ == "__main__":
    main()
    if failures:
        for f in failures:
            print("FAIL", f)
        print(f"U83_CHECK FAIL ({len(failures)})")
        sys.exit(1)
    print("U83_CHECK PASS")
