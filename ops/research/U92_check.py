"""U92 gate (written by Claude, 2026-09-14). Run from the repo root: python research/U92_check.py

Checks Cursor's plant census for internal consistency and against physics it cannot copy:
- counts: planted <= frames, both <= each side, IoU recomputed from the counts,
- the mirror: a mirrored take reads the OTHER source foot, an unmirrored one the same foot,
- the guard hold: every idle take has both feet planted on >= 90% of frames in source AND ours_c114 (Q86: the two
  free guard holds loop cleanly with no bounce - a scale or floor error makes this fail),
- floors: no source toe more than 5 cm under its floor, no retargeted toe more than Q87's 2.63 cm + 1 cm under,
- the summary pools the rows it claims to pool.
Never edit this file to pass: fix the tool or re-run it.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
JSON_PATH = os.path.join(RESEARCH, "U92_plant_census.json")
DIGEST = os.path.join(RESEARCH, "U92_PLANT_CENSUS.md")
TOOL = os.path.join(ROOT, "Godot", "tools", "measure_plant_census.gd")
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def iou(a, b, both):
    return 1.0 if a + b == 0 else both / float(a + b - both)


if not os.path.exists(TOOL):
    fail("missing tool %s" % TOOL)
if not os.path.exists(JSON_PATH):
    fail("missing %s" % JSON_PATH)
    print("U92_check: FAIL (%d failure(s))" % len(fails))
    sys.exit(1)

with open(JSON_PATH, encoding="utf-8") as fh:
    data = json.load(fh)

pop = data.get("population", {})
if pop.get("fighter") != "f01_m_box_welter" or pop.get("binding") != "boxing" or pop.get("node") != "still":
    fail("population must name f01_m_box_welter / boxing / still, got %s" % pop)
if int(pop.get("fps", 0)) != 30:
    fail("fps must be 30")
det = pop.get("detectors", {})
want = {"source": [0.15, 0.06], "ours_c114": [0.15, 0.06], "ours_ue": [0.60, 0.10]}
for k, v in want.items():
    got = det.get(k)
    if not got or abs(float(got[0]) - v[0]) > 1e-6 or abs(float(got[1]) - v[1]) > 1e-6:
        fail("detector %s must be %s, got %s" % (k, v, got))
for k in ("carry_scale", "world_scale"):
    if not float(pop.get(k, 0.0)) > 0.0:
        fail("population %s must be positive" % k)

rows = data.get("rows", [])
if len(rows) < 10:
    fail("only %d rows - every retargeted take the player holds, two feet each" % len(rows))
keys = {}
pool = {"non_walk": dict(frames=0, source_planted=0, c114_both=0, ours_c114=0, ue_both=0, ours_ue=0),
        "walk": dict(frames=0, source_planted=0, c114_both=0, ours_c114=0, ue_both=0, ours_ue=0)}
idle_rows = []
for r in rows:
    name = "%s/%s" % (r.get("take"), r.get("foot"))
    if name in keys:
        fail("duplicate row %s" % name)
    keys[name] = True
    fr = int(r.get("frames", 0))
    sp, c, u = int(r["source_planted"]), int(r["ours_c114_planted"]), int(r["ours_ue_planted"])
    cb, ub = int(r["c114_both"]), int(r["ue_both"])
    if fr < 2:
        fail("%s: frames %d" % (name, fr))
    for label, v in (("source_planted", sp), ("ours_c114_planted", c), ("ours_ue_planted", u)):
        if v < 0 or v > fr:
            fail("%s: %s %d outside 0..%d" % (name, label, v, fr))
    if cb > min(sp, c) or ub > min(sp, u):
        fail("%s: a 'both' count exceeds one of its sides" % name)
    if abs(iou(sp, c, cb) - float(r["c114_iou"])) > 0.001:
        fail("%s: c114_iou %.4f, recomputed %.4f" % (name, float(r["c114_iou"]), iou(sp, c, cb)))
    if abs(iou(sp, u, ub) - float(r["ue_iou"])) > 0.001:
        fail("%s: ue_iou %.4f, recomputed %.4f" % (name, float(r["ue_iou"]), iou(sp, u, ub)))
    if u < c:
        fail("%s: the looser UE detector planted fewer frames (%d) than C114's (%d) - thresholds swapped?" % (name, u, c))
    foot, src = r.get("foot"), r.get("source_bone")
    if foot not in ("LeftToes", "RightToes") or src not in ("LeftToes", "RightToes"):
        fail("%s: foot/source_bone must be LeftToes/RightToes" % name)
    elif bool(r.get("mirrored")) != (foot != src):
        fail("%s: mirrored=%s but foot %s reads source %s" % (name, r.get("mirrored"), foot, src))
    if float(r.get("source_min_height_m", 0.0)) < -0.05:
        fail("%s: source toe %.3f m under its floor - scale or floor wrong" % (name, float(r["source_min_height_m"])))
    if float(r.get("ours_min_height_m", 0.0)) < -(0.0263 + 0.01):
        fail("%s: retargeted toe %.3f m under the canvas - Q87 bounds the clips at 0.0263 m" % (name, float(r["ours_min_height_m"])))
    for k in ("ours_speed_in_source_plants_p50", "ours_speed_in_source_plants_p95", "source_speed_in_source_plants_p95"):
        if float(r.get(k, -1.0)) < 0.0:
            fail("%s: %s negative or missing" % (name, k))
    if float(r["ours_speed_in_source_plants_p50"]) > float(r["ours_speed_in_source_plants_p95"]) + 1e-6:
        fail("%s: p50 above p95" % name)
    if sp > 0 and float(r["source_speed_in_source_plants_p95"]) > 0.15 * 1.5 + 1e-3:
        fail("%s: source speed p95 %.3f inside source plants exceeds the detector's own exit speed 0.225" % (
            name, float(r["source_speed_in_source_plants_p95"])))
    bucket = "walk" if bool(r.get("walk")) else "non_walk"
    if bool(r.get("walk")) != str(r.get("role", "")).startswith("loc_"):
        fail("%s: walk flag disagrees with role %s" % (name, r.get("role")))
    p = pool[bucket]
    p["frames"] += fr
    p["source_planted"] += sp
    p["c114_both"] += cb
    p["ours_c114"] += c
    p["ue_both"] += ub
    p["ours_ue"] += u
    if r.get("role") == "idle":
        idle_rows.append(r)

if len(idle_rows) < 2:
    fail("no idle rows (both feet of every idle take)")
for r in idle_rows:
    fr = int(r["frames"])
    for label in ("source_planted", "ours_c114_planted"):
        if int(r[label]) < 0.9 * fr:
            fail("idle %s/%s: %s %d of %d frames (< 90%%) - a guard hold stands on both feet" % (
                r["take"], r["foot"], label, int(r[label]), fr))

summary = data.get("summary", {})
for bucket, p in pool.items():
    s = summary.get(bucket)
    if s is None:
        fail("summary lacks %s" % bucket)
        continue
    for k in ("frames", "source_planted", "c114_both", "ue_both"):
        if int(s.get(k, -1)) != p[k]:
            fail("summary %s.%s = %s, rows pool to %d" % (bucket, k, s.get(k), p[k]))
    if abs(float(s.get("c114_iou", -1)) - iou(p["source_planted"], p["ours_c114"], p["c114_both"])) > 0.001:
        fail("summary %s.c114_iou does not match the pooled counts" % bucket)
    if abs(float(s.get("ue_iou", -1)) - iou(p["source_planted"], p["ours_ue"], p["ue_both"])) > 0.001:
        fail("summary %s.ue_iou does not match the pooled counts" % bucket)
nw = pool["non_walk"]
if nw["frames"] > 0 and nw["source_planted"] < 0.5 * nw["frames"]:
    fail("source plants only %d of %d non-walk foot-frames - standing fighters keep their feet down most of the time" % (
        nw["source_planted"], nw["frames"]))

if not os.path.exists(DIGEST):
    fail("missing digest")
else:
    with open(DIGEST, encoding="utf-8") as fh:
        lines = fh.read().splitlines()
    if not lines or not lines[0].startswith("## DECISIONS"):
        fail("the digest must open with ## DECISIONS")
    if len(lines) > 25:
        fail("the digest is %d lines, 25 at most" % len(lines))

print("U92_check: %s (%d failure(s))" % ("PASS" if not fails else "FAIL", len(fails)))
sys.exit(0 if not fails else 1)
