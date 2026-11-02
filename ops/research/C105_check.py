"""C105 gate (Claude's): the one-frame toe dip - room evidence, a reproduction, and variants that decide.

Exit 0 only when: the tool source exists and never names a reference result file; the JSON carries at
least 5 room dip frames with per-bone rows at f-1, f, f+1; the reproduction's baseline reports its own
lowest toe; every variant reports its lowest toe; and the markdown's DECISIONS names either a variant whose
lowest toe stays above the canvas bound, or says NOT REPRODUCED.
"""
import json
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(HERE)
JSON_PATH = os.path.join(HERE, "C105_toe_dip.json")
MD_PATH = os.path.join(HERE, "C105_TOE_DIP.md")
TOOL = os.path.join(ROOT, "tools", "measure_toe_dip.gd")
BOUND = -0.0263
LEG_BONES = ["Hips", "LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "LeftToes",
             "RightUpperLeg", "RightLowerLeg", "RightFoot", "RightToes"]
VARIANTS = ["baseline", "previous_still_playing", "blend_0", "blend_0_20", "deterministic_true", "deterministic_false"]
fails = []

if not os.path.exists(TOOL):
    fails.append("missing Godot/tools/measure_toe_dip.gd")
else:
    src = open(TOOL, encoding="utf-8").read()
    for forbidden in ("get_file_as_string", "FileAccess.READ", "fightcamp_test_logs", "JSON.parse"):
        if forbidden in src:
            fails.append("the tool reads a file (%s) - it must measure, never read a result" % forbidden)
if not os.path.exists(JSON_PATH):
    print("C105_check FAIL: missing", JSON_PATH)
    sys.exit(1)
data = json.load(open(JSON_PATH, encoding="utf-8"))

room = data.get("room", {})
if room.get("seed") is None or room.get("frames", 0) < 1000:
    fails.append("room.seed / room.frames missing (drive the whole bout)")
dips = room.get("dips", [])
if len(dips) < 5:
    fails.append("fewer than 5 room dip frames (got %d)" % len(dips))
for d in dips[:20]:
    for key in ("frame", "side", "take", "previous_take", "previous_finished", "toe_below_rest_m", "bones"):
        if key not in d:
            fails.append("a dip row lacks '%s'" % key)
            break
    else:
        if float(d["toe_below_rest_m"]) >= BOUND:
            fails.append("frame %s is listed as a dip but its toe is not under the bound" % d["frame"])
        for bone in LEG_BONES:
            row = d["bones"].get(bone)
            if row is None or not all(k in row for k in ("f_minus_1_deg", "f_deg", "f_plus_1_deg")):
                fails.append("frame %s: bone %s needs f_minus_1_deg / f_deg / f_plus_1_deg (angle from rest)" % (d["frame"], bone))
                break

repro = data.get("reproduction", {})
for key in ("fighter", "clip_from", "clip_to", "fps"):
    if key not in repro:
        fails.append("reproduction.%s missing" % key)
got = repro.get("variants", {})
for v in VARIANTS:
    row = got.get(v)
    if row is None or "lowest_toe_below_rest_m" not in row or "frames" not in row:
        fails.append("reproduction.variants['%s'] needs lowest_toe_below_rest_m and frames" % v)

if not os.path.exists(MD_PATH):
    fails.append("missing C105_TOE_DIP.md")
else:
    md = open(MD_PATH, encoding="utf-8").read()
    if not md.lstrip().startswith("## DECISIONS"):
        fails.append("the markdown must open with '## DECISIONS'")
    head = md.split("\n## ", 2)[0] if md.count("\n## ") else md
    baseline = got.get("baseline", {})
    reproduced = float(baseline.get("lowest_toe_below_rest_m", 0.0)) < BOUND
    if not reproduced and "NOT REPRODUCED" not in head:
        fails.append("the baseline does not dip, so DECISIONS must say NOT REPRODUCED")
    if reproduced:
        clean = [v for v in VARIANTS[1:] if float(got.get(v, {}).get("lowest_toe_below_rest_m", -1.0)) >= BOUND]
        if clean and not any(v in head for v in clean):
            fails.append("DECISIONS must name the variant(s) that keep the toe above the bound: %s" % clean)
        if not clean and "NO VARIANT" not in head:
            fails.append("no variant removes the dip, so DECISIONS must say NO VARIANT")

if fails:
    print("C105_check FAIL (%d):" % len(fails))
    for f in fails[:40]:
        print("  -", f)
    sys.exit(1)
print("C105_check PASS: %d room dips, %d variants" % (len(dips), len(got)))
sys.exit(0)
