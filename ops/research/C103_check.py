#!/usr/bin/env python
"""C103's acceptance gate (Claude's). Run from the repo root; commit only on exit 0.

    python research/C103_check.py

Population from C100's committed rows (336 window x body pairs); every relation present OFF and ON
with sane statistics; and PHYSICAL rest checks that catch a facing read in bone axes instead of
joint positions: in every rest pose (the source T-pose and each fighter's rest) the chest faces the
pelvis's way within 15 deg, the head faces the chest's way within 1 deg (it is calibrated there),
and each foot points within 45 deg of the pelvis.
"""
import json
import math
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
JSON_PATH = os.path.join(ROOT, "research/C103_facing.json")
MD_PATH = os.path.join(ROOT, "research/C103_FACING.md")
TOOL = os.path.join(ROOT, "Godot/tools/measure_retarget_facing.gd")
C100_JSON = os.path.join(ROOT, "research/C100_retarget_by_frame.json")
RELATIONS = ("chest_pelvis", "left_foot_pelvis", "right_foot_pelvis", "head_chest")
failures = []


def check(ok, message):
    if not ok:
        failures.append(message)
    return ok


def finite(x):
    return isinstance(x, (int, float)) and not isinstance(x, bool) and math.isfinite(x)


def key(r):
    return (r.get("path"), round(float(r.get("start_s", -1)), 3), round(float(r.get("end_s", -1)), 3), r.get("fighter"))


def stats_ok(v):
    return (isinstance(v, dict) and all(finite(v.get(k)) for k in ("mean_deg", "p95_deg", "max_deg"))
            and 0.0 <= v["mean_deg"] <= v["p95_deg"] + 1e-6 <= v["max_deg"] + 2e-6 <= 180.0 + 1e-6)


def main():
    c100 = json.load(open(C100_JSON, encoding="utf-8"))
    base = {key(r) for r in c100.get("rows", [])}
    fighters = set(c100.get("population", {}).get("fighters", []))
    check(len(base) == 336 and len(fighters) == 12, "C100 baseline is not 336 rows / 12 fighters - the gate itself is broken")

    check(os.path.isfile(TOOL), "Godot/tools/measure_retarget_facing.gd does not exist")
    if not check(os.path.isfile(JSON_PATH), "C103_facing.json does not exist"):
        return
    try:
        data = json.load(open(JSON_PATH, encoding="utf-8"))
    except Exception as exc:  # noqa: BLE001
        check(False, f"the JSON does not parse: {exc}")
        return

    trip = data.get("tripwire", {})
    check(finite(trip.get("fixed_mean_deg")) and abs(trip["fixed_mean_deg"] - 7.21) <= 0.05, "tripwire mean does not reproduce R108's 7.21")
    check(finite(trip.get("fixed_max_deg")) and abs(trip["fixed_max_deg"] - 19.64) <= 0.05, "tripwire max does not reproduce R108's 19.64")

    rest = data.get("rest_relations", {})
    for body in ["source"] + sorted(fighters):
        rr = rest.get(body)
        if not check(isinstance(rr, dict) and all(finite(rr.get(k)) for k in RELATIONS), f"rest_relations lacks finite values for {body}"):
            continue
        check(abs(rr["chest_pelvis"]) <= 15.0, f"{body} at rest: chest faces {rr['chest_pelvis']:+.1f} deg from the pelvis - facing read in bone axes, not joint positions?")
        check(abs(rr["head_chest"]) <= 1.0, f"{body} at rest: head_chest is {rr['head_chest']:+.1f} deg but the head is calibrated to the chest at rest")
        for foot in ("left_foot_pelvis", "right_foot_pelvis"):
            check(abs(rr[foot]) <= 45.0, f"{body} at rest: {foot} is {rr[foot]:+.1f} deg - a rest foot points roughly forward")

    rows = {key(r): r for r in data.get("rows", [])}
    check(set(rows) == base, f"rows cover {len(rows)} pairs; C100 has {len(base)} - not the same population")
    bad = 0
    first = ""
    for k, r in rows.items():
        ok = int(r.get("frames", 0)) >= 2 and all(stats_ok(r.get(side, {}).get(rel)) for side in ("off", "on") for rel in RELATIONS)
        if not ok:
            bad += 1
            first = first or f"{os.path.basename(str(k[0]))} on {k[3]}"
    check(bad == 0, f"{bad} rows lack a relation OFF or ON, or break 0 <= mean <= p95 <= max <= 180 (first: {first})")

    rel = data.get("relations", {})
    for name in RELATIONS:
        v = rel.get(name, {})
        fields = ("off_mean_deg", "off_p95_deg", "off_max_deg", "on_mean_deg", "on_p95_deg", "on_max_deg")
        check(all(finite(v.get(f)) for f in fields), f"relations.{name} is incomplete")

    if check(os.path.isfile(MD_PATH), "C103_FACING.md does not exist"):
        md = open(MD_PATH, encoding="utf-8").read()
        head = "\n".join(md.splitlines()[:50])
        check(re.search(r"^#+\s*DECISIONS", head, re.M | re.I) is not None, "the markdown does not open with DECISIONS")
        for name in RELATIONS:
            check(name in head, f"DECISIONS does not report {name}")


main()
if failures:
    print(f"C103_CHECK FAIL ({len(failures)})")
    for f in failures[:40]:
        print("  - " + f)
    sys.exit(1)
print("C103_CHECK PASS")
