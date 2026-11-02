#!/usr/bin/env python
"""C100's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/C100_check.py

It DERIVES what the delivery must cover from the repo - the RamsterZ windows bound in
FightClipBinding.gd, the twelve fighter bodies on disk, R108's joint list - and checks the
JSON against that and against R108's recorded numbers. It never reads its expectations
out of the delivery it is judging.
"""
import glob
import json
import math
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
JSON_PATH = os.path.join(ROOT, "research/C100_retarget_by_frame.json")
MD_PATH = os.path.join(ROOT, "research/C100_RETARGET_BY_FRAME.md")
TOOL_PATH = os.path.join(ROOT, "Godot/tools/measure_retarget_frames.gd")
BINDING = os.path.join(ROOT, "Godot/scripts/FightClipBinding.gd")
R108 = os.path.join(ROOT, "Godot/tools/measure_r108_retarget.gd")
FIGHTERS = os.path.join(ROOT, "Godot/assets/models/fighters/f??_*_rigged.glb")

R108_MEAN, R108_MAX, TOL = 7.21, 19.64, 0.05
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def derived_windows():
    text = open(BINDING, encoding="utf-8").read()
    start = text.find("const BINDINGS")
    end = text.find("const PAIRED_REFERENCE")
    block = text[start:end if end > start else len(text)]
    hits = list(re.finditer(r'"path":\s*"(res://assets/anim/audition/ramsterz_h2h/[^"]+)"', block))
    windows = set()
    for i, m in enumerate(hits):
        stop = hits[i + 1].start() if i + 1 < len(hits) else len(block)
        chunk = block[m.end():stop]
        s = re.search(r'"start_s":\s*([0-9.]+)', chunk)
        e = re.search(r'"end_s":\s*([0-9.]+)', chunk)
        windows.add((m.group(1), round(float(s.group(1)), 3) if s else None, round(float(e.group(1)), 3) if e else None))
    return windows


def derived_joints():
    text = open(R108, encoding="utf-8").read()
    m = re.search(r"const JOINTS := \{(.*?)\n\}", text, re.S)
    return set(re.findall(r'"([a-z_]+)":\s*\[', m.group(1))) if m else set()


def derived_fighters():
    return {os.path.basename(p)[: -len("_rigged.glb")] for p in glob.glob(FIGHTERS)}


def main():
    windows, joints, fighters = derived_windows(), derived_joints(), derived_fighters()
    check(len(windows) >= 10, f"derived only {len(windows)} RamsterZ windows from FightClipBinding.gd - the gate itself is broken")
    check(len(joints) >= 6, f"derived only {len(joints)} joints from measure_r108_retarget.gd - the gate itself is broken")
    check(len(fighters) == 12, f"derived {len(fighters)} fighter bodies, expected 12 - the gate itself is broken")

    check(os.path.isfile(TOOL_PATH), "the tool Godot/tools/measure_retarget_frames.gd does not exist")
    if not check(os.path.isfile(JSON_PATH), "C100_retarget_by_frame.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return

    trip = data.get("tripwire", {})
    check(trip.get("clip") == "H2H_HitReaction01.FBX" and str(trip.get("fighter", "")).startswith("f01"),
          "tripwire must be H2H_HitReaction01.FBX on f01")
    check(trip.get("samples") == 9, "tripwire must use R108's nine samples")
    check(finite(trip.get("fixed_mean_deg")) and abs(trip["fixed_mean_deg"] - R108_MEAN) <= TOL,
          f"tripwire fixed_mean_deg {trip.get('fixed_mean_deg')} does not reproduce R108's {R108_MEAN} (+-{TOL})")
    check(finite(trip.get("fixed_max_deg")) and abs(trip["fixed_max_deg"] - R108_MAX) <= TOL,
          f"tripwire fixed_max_deg {trip.get('fixed_max_deg')} does not reproduce R108's {R108_MAX} (+-{TOL})")

    pop = data.get("population", {})
    check(set(pop.get("fighters", [])) == fighters, "population.fighters is not exactly the twelve bodies on disk")
    got_paths = {w.get("path") for w in pop.get("windows", [])}
    check(got_paths == {w[0] for w in windows},
          f"population.windows paths differ from FightClipBinding.gd: missing {sorted({w[0] for w in windows} - got_paths)[:4]}, extra {sorted(got_paths - {w[0] for w in windows})[:4]}")

    rows = data.get("rows", [])
    index = {}
    for r in rows:
        key = (r.get("path"), round(float(r.get("start_s", -1)), 3), round(float(r.get("end_s", -1)), 3), r.get("fighter"))
        check(key not in index, f"duplicate row {key}")
        index[key] = r
    for path, s, e in sorted(windows, key=lambda w: (w[0], w[1] or 0.0)):
        for f in sorted(fighters):
            hits = [r for (p, rs, re_, rf), r in index.items() if p == path and rf == f and
                    (s is None or abs(rs - s) <= 0.005) and (e is None or abs(re_ - e) <= 0.005)]
            check(len(hits) == 1, f"expected exactly one row for {os.path.basename(path)} [{s},{e}] on {f}, found {len(hits)}")

    maxes = []
    for r in rows:
        name = f"{os.path.basename(str(r.get('path')))} on {r.get('fighter')}"
        nums = ["angle_mean_deg", "angle_p95_deg", "angle_max_deg", "worst_t", "reach_arm_max_diff",
                "reach_leg_max_diff", "floor_min_m", "floor_max_m", "floor_min_height_frac"]
        if not check(all(finite(r.get(k)) for k in nums), f"{name}: a non-finite or missing number"):
            continue
        check(int(r.get("frames", 0)) >= 2, f"{name}: fewer than two frames")
        check(r["angle_mean_deg"] <= r["angle_p95_deg"] + 1e-6 <= r["angle_max_deg"] + 2e-6,
              f"{name}: mean <= p95 <= max does not hold")
        check(r.get("worst_joint") in joints, f"{name}: worst_joint {r.get('worst_joint')!r} is not one of R108's joints")
        span = float(r["end_s"]) - float(r["start_s"])
        check(-1e-6 <= r["worst_t"] <= span + 0.05, f"{name}: worst_t {r['worst_t']} is outside its window (0..{span:.3f})")
        check(0.0 <= r["reach_arm_max_diff"] < 1.0 and 0.0 <= r["reach_leg_max_diff"] < 1.0,
              f"{name}: a reach difference outside [0, 1)")
        check(r["floor_min_m"] <= r["floor_max_m"] + 1e-9, f"{name}: floor_min_m > floor_max_m")
        maxes.append(r["angle_max_deg"])

    check(len(maxes) > 0 and max(maxes) > 0.0, "no row has a non-zero angle error - an instrument reading rest poses")
    check(len(set(round(m, 3) for m in maxes)) > 1, "every row has the same angle_max - the instrument is not reading the clips")

    jt = data.get("joints", {})
    check(joints <= set(jt.keys()), f"joints table lacks {sorted(joints - set(jt.keys()))}")
    joint_max = 0.0
    for j in joints & set(jt.keys()):
        v = jt[j]
        if check(all(finite(v.get(k)) for k in ("mean_deg", "p95_deg", "max_deg")), f"joint {j}: non-finite numbers"):
            check(v["mean_deg"] <= v["p95_deg"] + 1e-6 <= v["max_deg"] + 2e-6, f"joint {j}: mean <= p95 <= max does not hold")
            joint_max = max(joint_max, v["max_deg"])
    if maxes:
        check(abs(max(maxes) - joint_max) <= 0.01, f"the worst row ({max(maxes):.2f}) and the worst joint ({joint_max:.2f}) disagree")

    if check(os.path.isfile(MD_PATH), "C100_RETARGET_BY_FRAME.md does not exist"):
        md = open(MD_PATH, encoding="utf-8").read()
        head = "\n".join(md.splitlines()[:40])
        check(re.search(r"^#+\s*DECISIONS", head, re.M | re.I) is not None, "the markdown does not open with a DECISIONS section")
        if maxes:
            worst = max(rows, key=lambda r: r.get("angle_max_deg", -1))
            check(os.path.basename(worst["path"]) in md and str(worst["fighter"]) in md,
                  "the markdown does not name the worst row (its clip file and fighter)")
        check("f06" in md and "f08" in md, "the markdown does not flag f06 and f08 (the 1.00 m meshes)")


main()
if failures:
    print(f"C100_CHECK FAIL ({len(failures)})")
    for f in failures[:40]:
        print("  - " + f)
    sys.exit(1)
print("C100_CHECK PASS")
