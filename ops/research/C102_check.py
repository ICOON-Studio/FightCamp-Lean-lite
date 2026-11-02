#!/usr/bin/env python
"""C102's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/C102_check.py

The OFF half must reproduce C100's committed rows (the same pipeline, measured again); the ON
half must cover the same 336 rows with sane statistics. It never requires ON to be better -
whether the silhouette fix helps is the finding.
"""
import json
import math
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
JSON_PATH = os.path.join(ROOT, "research/C102_silhouette_fix.json")
MD_PATH = os.path.join(ROOT, "research/C102_SILHOUETTE_FIX.md")
TOOL = os.path.join(ROOT, "Godot/tools/measure_silhouette_fix.gd")
C100_JSON = os.path.join(ROOT, "research/C100_retarget_by_frame.json")
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def key(r):
    return (r.get("path"), round(float(r.get("start_s", -1)), 3), round(float(r.get("end_s", -1)), 3), r.get("fighter"))


def main():
    c100 = json.load(open(C100_JSON, encoding="utf-8"))
    base = {key(r): r for r in c100.get("rows", [])}
    joints = set(c100.get("joints", {}).keys())
    check(len(base) == 336 and len(joints) >= 6, f"C100 baseline has {len(base)} rows / {len(joints)} joints - the gate itself is broken")

    check(os.path.isfile(TOOL), "Godot/tools/measure_silhouette_fix.gd does not exist")
    if not check(os.path.isfile(JSON_PATH), "C102_silhouette_fix.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return

    trip = data.get("tripwire", {})
    check(finite(trip.get("fixed_mean_deg")) and abs(trip["fixed_mean_deg"] - 7.21) <= 0.05, "tripwire mean does not reproduce R108's 7.21")
    check(finite(trip.get("fixed_max_deg")) and abs(trip["fixed_max_deg"] - 19.64) <= 0.05, "tripwire max does not reproduce R108's 19.64")

    rows = {key(r): r for r in data.get("rows", [])}
    check(set(rows) == set(base), f"rows cover {len(rows)} (window, fighter) pairs; C100 has {len(base)} - not the same population")
    off_bad, on_bad, worse = 0, 0, 0
    first_off = ""
    for k, b in base.items():
        r = rows.get(k)
        if r is None:
            continue
        if not (finite(r.get("off_angle_mean_deg")) and finite(r.get("off_angle_max_deg"))
                and abs(r["off_angle_mean_deg"] - b["angle_mean_deg"]) <= 0.01
                and abs(r["off_angle_max_deg"] - b["angle_max_deg"]) <= 0.01):
            off_bad += 1
            first_off = first_off or f"{os.path.basename(str(k[0]))} on {k[3]}"
        nums = ("on_angle_mean_deg", "on_angle_p95_deg", "on_angle_max_deg")
        if not all(finite(r.get(n)) for n in nums) or not (r["on_angle_mean_deg"] <= r["on_angle_p95_deg"] + 1e-6 <= r["on_angle_max_deg"] + 2e-6) or r.get("on_worst_joint") not in joints:
            on_bad += 1
        elif r["on_angle_max_deg"] > b["angle_max_deg"] + 0.01:
            worse += 1
    check(off_bad == 0, f"{off_bad} OFF rows do not reproduce C100 within 0.01 deg (first: {first_off}) - the OFF pipeline is not C100's")
    check(on_bad == 0, f"{on_bad} ON rows have non-finite numbers, mean<=p95<=max broken, or an unknown worst joint")

    on_means = [r["on_angle_mean_deg"] for r in rows.values() if finite(r.get("on_angle_mean_deg"))]
    check(on_means and max(on_means) > 0.0, "every ON mean is zero - the fix was measured against itself (the trap in the task file)")

    jt = data.get("joints", {})
    check(joints <= set(jt), f"joints table lacks {sorted(joints - set(jt))}")
    for j in joints & set(jt):
        v = jt[j]
        fields = ("off_mean_deg", "off_p95_deg", "off_max_deg", "on_mean_deg", "on_p95_deg", "on_max_deg")
        if check(all(finite(v.get(f)) for f in fields), f"joint {j}: non-finite numbers"):
            c = c100["joints"][j]
            check(abs(v["off_mean_deg"] - c["mean_deg"]) <= 0.01 and abs(v["off_max_deg"] - c["max_deg"]) <= 0.01,
                  f"joint {j}: OFF pooled numbers do not reproduce C100 ({v['off_mean_deg']:.2f}/{v['off_max_deg']:.2f} vs {c['mean_deg']:.2f}/{c['max_deg']:.2f})")

    if check(os.path.isfile(MD_PATH), "C102_SILHOUETTE_FIX.md does not exist"):
        md = open(MD_PATH, encoding="utf-8").read()
        head = "\n".join(md.splitlines()[:50])
        check(re.search(r"^#+\s*DECISIONS", head, re.M | re.I) is not None, "the markdown does not open with DECISIONS")
        check(str(worse) in head, f"DECISIONS does not state how many rows got worse ({worse} by this gate's count)")


main()
if failures:
    print(f"C102_CHECK FAIL ({len(failures)})")
    for f in failures[:40]:
        print("  - " + f)
    sys.exit(1)
print("C102_CHECK PASS")
