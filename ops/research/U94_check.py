"""U94 gate (written by Claude, 2026-09-14). Run from the repo root: python research/U94_check.py

Pins Cursor's skeleton-space hook splice to things that cannot differ:
- `mirror` and `upper_mirror_lower_idle` reproduce U93's JSON (an earlier, independent run of the same instrument),
- variant 3's Chest faces exactly where the mirror's does (the Spine solve is in skeleton space, not local),
- variants 4 and 5 start facing idle's Chest and differ from the mirror's by exactly their yaw offset,
- variants 3-5 keep the mirror's arm chain above the Chest (RightHand-in-Chest deviation <= 1 mm),
- variants 3-5 start in idle's stance (their legs ARE idle's),
- every number is inside physics (a fist in the node frame, a twist in degrees).
Never edit this file to pass: fix the tool or re-run it.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
JSON_PATH = os.path.join(RESEARCH, "U94_hook_global.json")
U93_PATH = os.path.join(RESEARCH, "U93_hook_splice.json")
DIGEST = os.path.join(RESEARCH, "U94_HOOK_GLOBAL.md")
TOOL = os.path.join(ROOT, "Godot", "tools", "measure_hook_global.gd")
NAMES = ["mirror", "upper_mirror_lower_idle", "global_chest_lower_idle",
         "global_chest_yawmatch_lower_idle", "global_chest_yawmatch_split_lower_idle"]
GLOBAL = NAMES[2:]
REFERENCES = ["hook_lead", "idle"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def num(row, key):
    value = row.get(key)
    if not isinstance(value, (int, float)):
        fail("%s: %s missing or not a number (%r)" % (row.get("name"), key, value))
        return float("nan")
    return float(value)


def same_stance(label, got, want, tol):
    if not isinstance(got, dict):
        fail("%s: stance missing" % label)
        return
    if got.get("lead") != want.get("lead"):
        fail("%s: lead %s, expected %s" % (label, got.get("lead"), want.get("lead")))
    for k in ("split_m", "width_m"):
        if abs(float(got.get(k, 99)) - float(want.get(k, -99))) > tol:
            fail("%s: %s %.4f, expected %.4f" % (label, k, float(got.get(k, 99)), float(want.get(k, -99))))


for path in (TOOL, JSON_PATH, U93_PATH, DIGEST):
    if not os.path.exists(path):
        fail("missing %s" % path)
if fails:
    sys.exit(1)

data = json.load(open(JSON_PATH, encoding="utf-8"))
u93 = json.load(open(U93_PATH, encoding="utf-8"))
u93_rows = {row["name"]: row for row in u93["variants"]}

pop = data.get("population", {})
for key, want in (("fighter", "f01_m_box_welter"), ("binding", "boxing"), ("node", "still"), ("fps", 30)):
    if pop.get(key) != want:
        fail("population.%s is %r, expected %r" % (key, pop.get(key), want))
if not str(pop.get("source", "")).strip():
    fail("population.source must name what hook_rear is")

rows = {row.get("name"): row for row in data.get("variants", [])}
if [row.get("name") for row in data.get("variants", [])] != NAMES:
    fail("variants must be exactly %s in order, got %s" % (NAMES, [row.get("name") for row in data.get("variants", [])]))
refs = {row.get("name"): row for row in data.get("references", [])}
for name in REFERENCES:
    if name not in refs:
        fail("reference row %s missing" % name)
if fails:
    sys.exit(1)

same_stance("idle_first v U93", data.get("idle_first"), u93["idle_first"], 0.005)

# 1-2: the instrument reproduces U93.
for name in ("mirror", "upper_mirror_lower_idle"):
    got, want = rows[name], u93_rows[name]
    for key, tol in (("entry_pose_deg", 0.05), ("hand_node_dev_max_m", 0.002), ("reach_fwd_max_m", 0.002),
                     ("torso_yaw_dev_max_deg", 0.1), ("skate_mean_mps", 0.002)):
        if abs(num(got, key) - float(want[key])) > tol:
            fail("%s: %s %.4f does not reproduce U93's %.4f (tol %s)" % (name, key, num(got, key), float(want[key]), tol))
    same_stance(name + " first v U93", got.get("first"), want["first"], 0.005)

# 3: the Chest faces exactly where the mirror's does, on every frame.
if num(rows["global_chest_lower_idle"], "torso_yaw_dev_max_deg") > 0.5:
    fail("global_chest_lower_idle: torso_yaw_dev_max_deg %.3f > 0.5 - the Spine solve is not in skeleton space"
         % num(rows["global_chest_lower_idle"], "torso_yaw_dev_max_deg"))

# 4-5: start on idle's facing; differ from the mirror by exactly the offset.
for name in ("global_chest_yawmatch_lower_idle", "global_chest_yawmatch_split_lower_idle"):
    row = rows[name]
    if num(row, "chest_yaw_vs_idle_f0_deg") > 0.5:
        fail("%s: chest_yaw_vs_idle_f0_deg %.3f > 0.5 - Y does not put the torso on idle's facing"
             % (name, num(row, "chest_yaw_vs_idle_f0_deg")))
    offset = abs(num(row, "yaw_offset_deg"))
    if abs(num(row, "torso_yaw_dev_max_deg") - offset) > 1.0:
        fail("%s: torso_yaw_dev_max_deg %.3f should equal |yaw_offset_deg| %.3f within 1 deg"
             % (name, num(row, "torso_yaw_dev_max_deg"), offset))
if abs(abs(num(rows["global_chest_yawmatch_lower_idle"], "yaw_offset_deg"))
       - abs(num(rows["global_chest_yawmatch_split_lower_idle"], "yaw_offset_deg"))) > 0.01:
    fail("variants 4 and 5 must use the same Y")

# 3-5: arm chain above the Chest unchanged; idle's stance at entry; a value in every new metric.
for name in GLOBAL:
    row = rows[name]
    if num(row, "hand_chest_dev_max_m") > 0.001:
        fail("%s: hand_chest_dev_max_m %.4f > 1 mm - the arm chain above the Chest changed" % (name, num(row, "hand_chest_dev_max_m")))
    same_stance(name + " first v idle", row.get("first"), u93["idle_first"], 0.01)

# physics, every row
for row in list(rows.values()) + list(refs.values()):
    name = row.get("name")
    strike = row.get("strike")
    if not isinstance(strike, dict):
        fail("%s: strike missing" % name)
        continue
    for key in ("x", "y", "z", "frame"):
        if not isinstance(strike.get(key), (int, float)):
            fail("%s: strike.%s missing" % (name, key))
    if isinstance(strike.get("y"), (int, float)) and not 0.5 <= float(strike["y"]) <= 2.2:
        fail("%s: strike height %.3f m outside 0.5..2.2 - wrong frame for the node" % (name, float(strike["y"])))
    if isinstance(strike.get("x"), (int, float)) and abs(float(strike["x"])) > 1.2:
        fail("%s: strike side %.3f m beyond 1.2" % (name, float(strike["x"])))
    if isinstance(strike.get("z"), (int, float)) and float(strike["z"]) > 1.6:
        fail("%s: strike reach %.3f m beyond 1.6" % (name, float(strike["z"])))
    for key in ("twist_max_deg", "spine_from_rest_max_deg", "chest_from_rest_max_deg"):
        value = num(row, key)
        if not 0.0 <= value <= 180.0:
            fail("%s: %s %.3f outside 0..180" % (name, key, value))
    if num(row, "skate_mean_mps") < 0.0:
        fail("%s: negative skate" % name)

lines = open(DIGEST, encoding="utf-8").read().splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("digest must open with '## DECISIONS'")
if len(lines) > 30:
    fail("digest is %d lines, 30 at most" % len(lines))
text = "\n".join(lines)
for name in GLOBAL + ["hook_lead"]:
    if name not in text:
        fail("digest never names %s" % name)

if fails:
    print("U94_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("U94_CHECK PASS variants=%d references=%d" % (len(rows), len(refs)))
