#!/usr/bin/env python
"""Q83's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/Q83_check.py

DERIVES the population (the RamsterZ windows bound in FightClipBinding.gd) and the tripwire
(C94's own table rows for the two walk clips) from the repo, then checks the delivery's
arithmetic and that the instrument sees a knockdown go down.
"""
import json
import math
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
JSON_PATH = os.path.join(ROOT, "research/Q83_dropped_position_tracks.json")
MD_PATH = os.path.join(ROOT, "research/Q83_DROPPED_POSITION_TRACKS.md")
TOOL = os.path.join(ROOT, "Godot/tools/measure_dropped_position_tracks.gd")
BINDING = os.path.join(ROOT, "Godot/scripts/FightClipBinding.gd")
C94 = os.path.join(ROOT, "research/C94_LOCOMOTION_CONTENT.md")
TRIP_TOL = 0.0005
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def derived_windows():
    text = open(BINDING, encoding="utf-8").read()
    block = text[text.find("const BINDINGS"):text.find("const PAIRED_REFERENCE")]
    hits = list(re.finditer(r'"path":\s*"(res://assets/anim/audition/ramsterz_h2h/[^"]+)"', block))
    out = set()
    for i, m in enumerate(hits):
        chunk = block[m.end():hits[i + 1].start() if i + 1 < len(hits) else len(block)]
        s = re.search(r'"start_s":\s*([0-9.]+)', chunk)
        e = re.search(r'"end_s":\s*([0-9.]+)', chunk)
        out.add((m.group(1), round(float(s.group(1)), 3) if s else None, round(float(e.group(1)), 3) if e else None))
    return out


def c94_row(clip):
    for line in open(C94, encoding="utf-8"):
        cells = [c.strip() for c in line.strip().strip("|").split("|")]
        if cells and cells[0] == clip and len(cells) >= 9:
            return {"travel_m": float(cells[6]), "bob_m": float(cells[8])}
    return None


def main():
    windows = derived_windows()
    check(len(windows) >= 10, f"derived only {len(windows)} windows - the gate itself is broken")
    trip_expect = {c: c94_row(c) for c in ("H2H_WalkForward.FBX", "H2H_WalkBack.FBX")}
    check(all(trip_expect.values()), f"could not read C94's walk rows - the gate itself is broken: {trip_expect}")

    check(os.path.isfile(TOOL), "Godot/tools/measure_dropped_position_tracks.gd does not exist")
    if not check(os.path.isfile(JSON_PATH), "Q83_dropped_position_tracks.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return

    # REDO 2026-09-13: the first delivery matched C94 to the micrometre and put 7 of 28 pelvises
    # through the floor - it measured a horizontal axis, and C94 may have too. The tripwire is now
    # PHYSICAL; C94 is reported beside it, not required.
    pt = data.get("physical_tripwire", {})
    tp, it = pt.get("tpose_pelvis_y_m"), pt.get("idle_t0_pelvis_y_m")
    check(finite(tp) and 0.80 <= tp <= 1.10, f"physical_tripwire.tpose_pelvis_y_m {tp} is not a standing pelvis height (0.80-1.10 m)")
    check(finite(tp) and finite(it) and abs(tp - it) <= 0.05, f"the T-pose pelvis ({tp}) and the Idle's pelvis at t=0 ({it}) disagree by more than 5 cm - they are not in one frame")
    comp = data.get("c94_comparison", {})
    for clip, want in trip_expect.items():
        row = comp.get(clip, {})
        check(all(finite(row.get(k)) for k in ("bob_m", "travel_m", "c94_bob_m", "c94_travel_m")) and isinstance(row.get("agrees"), bool),
              f"c94_comparison lacks {clip} (bob_m, travel_m, c94_bob_m, c94_travel_m, agrees)")
        if want and finite(row.get("c94_bob_m")):
            check(abs(row["c94_bob_m"] - want["bob_m"]) <= TRIP_TOL, f"c94_comparison {clip}: c94_bob_m does not quote C94's table ({want['bob_m']})")

    rest = data.get("pelvis_rest_y_m")
    check(finite(rest) and finite(tp) and abs(rest - tp) <= 1e-4, f"pelvis_rest_y_m {rest} is not the T-pose pelvis height {tp}")

    rows = data.get("rows", [])
    seen = {}
    for r in rows:
        key = (r.get("path"), round(float(r.get("start_s", -1)), 3), round(float(r.get("end_s", -1)), 3))
        check(key not in seen, f"duplicate row {key}")
        seen[key] = r
    for path, s, e in sorted(windows, key=lambda w: (w[0], w[1] or 0.0)):
        hits = [r for (p, rs, re_), r in seen.items() if p == path and (s is None or abs(rs - s) <= 0.005) and (e is None or abs(re_ - e) <= 0.005)]
        check(len(hits) == 1, f"expected one row for {os.path.basename(path)} [{s},{e}], found {len(hits)}")
    check(len(rows) == len(windows), f"{len(rows)} rows for {len(windows)} bound windows")

    nums = ["pelvis_y_min_m", "pelvis_y_max_m", "pelvis_y_range_m", "pelvis_drop_below_rest_m",
            "pelvis_drop_frac", "pelvis_xz_path_m", "pelvis_xz_net_m", "root_path_m"]
    by_file = {}
    for r in rows:
        name = os.path.basename(str(r.get("path")))
        if not check(all(finite(r.get(k)) for k in nums), f"{name}: a non-finite or missing number"):
            continue
        check(int(r.get("frames", 0)) >= 2, f"{name}: fewer than two frames")
        check(r["pelvis_y_min_m"] <= r["pelvis_y_max_m"], f"{name}: min > max")
        check(r["pelvis_y_min_m"] >= -0.05, f"{name}: pelvis at {r['pelvis_y_min_m']:+.3f} m is through the floor - height is being read on the wrong axis")
        if finite(rest):
            check(r["pelvis_y_max_m"] <= rest + 0.30, f"{name}: pelvis at {r['pelvis_y_max_m']:+.3f} m is 30 cm above standing - the wrong axis or frame")
        check(abs(r["pelvis_y_range_m"] - (r["pelvis_y_max_m"] - r["pelvis_y_min_m"])) <= 1e-4, f"{name}: range != max - min")
        if finite(rest):
            check(abs(r["pelvis_drop_below_rest_m"] - (r["pelvis_y_min_m"] - rest)) <= 1e-4, f"{name}: drop != min - rest")
            check(abs(r["pelvis_drop_frac"] - r["pelvis_drop_below_rest_m"] / rest) <= 1e-3, f"{name}: drop_frac != drop / rest")
        check(r["pelvis_xz_net_m"] <= r["pelvis_xz_path_m"] + 1e-4, f"{name}: net displacement exceeds path length")
        by_file.setdefault(name, []).append(r)

    kd = [r for n, rs in by_file.items() if n.startswith("H2H_KnockDown") for r in rs]
    idle = by_file.get("H2H_Idle.FBX", [])
    if check(kd and idle, "no knockdown or idle row to sanity-check the instrument against"):
        check(min(r["pelvis_drop_below_rest_m"] for r in kd) < idle[0]["pelvis_drop_below_rest_m"] - 0.15,
              "no knockdown's hips drop 15 cm further than the idle's - the instrument is not reading the fall")
        check(min(r["pelvis_y_min_m"] for r in kd) <= 0.45, "no knockdown's pelvis gets within 45 cm of the floor - a man on the canvas has his hips low")

    if check(os.path.isfile(MD_PATH), "Q83_DROPPED_POSITION_TRACKS.md does not exist"):
        md = open(MD_PATH, encoding="utf-8").read()
        head = "\n".join(md.splitlines()[:40])
        check(re.search(r"^#+\s*DECISIONS", head, re.M | re.I) is not None, "the markdown does not open with DECISIONS")
        if rows and all(finite(r.get("pelvis_drop_below_rest_m")) for r in rows):
            deepest = min(rows, key=lambda r: r["pelvis_drop_below_rest_m"])
            check(os.path.basename(deepest["path"]) in head, "DECISIONS does not name the window whose hips drop furthest")


main()
if failures:
    print(f"Q83_CHECK FAIL ({len(failures)})")
    for f in failures[:40]:
        print("  - " + f)
    sys.exit(1)
print("Q83_CHECK PASS")
