"""U93 gate (written by Claude, 2026-09-14). Run from the repo root: python research/U93_check.py

Pins Cursor's hook splice to things that cannot differ:
- `mirror` IS hook_rear: its stance equals Q98's hook_rear row (an independent earlier instrument), within 1 cm,
- `upper_mirror_lower_lead`'s legs ARE hook_lead's: its stance equals Q98's hook_lead row, within 1 cm,
- `upper_mirror_lower_idle`'s legs ARE idle's: its FIRST stance equals Q98's idle take row, within 1 cm,
- variants 2 and 3 keep hook_rear's arm chain below the chest: RightHand-in-Chest deviation from `mirror` <= 1 mm,
- `mirror` deviates from itself by nothing, and every number is inside physics (a fist cannot reach 2 m forward).
Never edit this file to pass: fix the tool or re-run it.
"""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
JSON_PATH = os.path.join(RESEARCH, "U93_hook_splice.json")
Q98_PATH = os.path.join(RESEARCH, "Q98_take_stance.json")
DIGEST = os.path.join(RESEARCH, "U93_HOOK_SPLICE.md")
TOOL = os.path.join(ROOT, "Godot", "tools", "measure_hook_splice.gd")
NAMES = ["mirror", "upper_mirror_lower_lead", "upper_mirror_lower_idle", "upper_mirror_hipsrot_mirror_lower_idle"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def same_stance(label, got, want, tol=0.01):
    if got.get("lead") != want.get("lead"):
        fail("%s: lead %s, expected %s" % (label, got.get("lead"), want.get("lead")))
    for k in ("split_m", "width_m"):
        if abs(float(got.get(k, 99)) - float(want.get(k, -99))) > tol:
            fail("%s: %s %.4f, expected %.4f" % (label, k, float(got.get(k, 99)), float(want.get(k, -99))))


for path in (TOOL, JSON_PATH, Q98_PATH, DIGEST):
    if not os.path.exists(path):
        fail("missing %s" % path)
if fails:
    print("U93_check: FAIL (%d failure(s))" % len(fails))
    sys.exit(1)

data = json.load(open(JSON_PATH, encoding="utf-8"))
q98 = json.load(open(Q98_PATH, encoding="utf-8"))
q98_rows = {r.get("take"): r for r in q98.get("takes", [])}
pop = data.get("population", {})
if pop.get("fighter") != "f01_m_box_welter" or pop.get("node") != "still" or int(pop.get("fps", 0)) != 30:
    fail("population must be f01_m_box_welter, still node, 30 fps: %s" % pop)

variants = {v.get("name"): v for v in data.get("variants", [])}
for n in NAMES:
    if n not in variants:
        fail("variant %s missing" % n)
if fails:
    print("U93_check: FAIL (%d failure(s))" % len(fails))
    sys.exit(1)

for side in ("first", "last"):
    if "hook_rear" in q98_rows:
        same_stance("mirror %s v Q98 hook_rear" % side, variants["mirror"][side], q98_rows["hook_rear"][side])
    else:
        fail("Q98 has no hook_rear row")
    if "hook_lead" in q98_rows:
        same_stance("upper_mirror_lower_lead %s v Q98 hook_lead" % side, variants["upper_mirror_lower_lead"][side],
                    q98_rows["hook_lead"][side])
    else:
        fail("Q98 has no hook_lead row")
## Q98's idle_reference carries only the lead (its split/width fields are zero): the idle TAKE row holds the numbers.
if "idle" in q98_rows:
    same_stance("upper_mirror_lower_idle first v Q98 idle", variants["upper_mirror_lower_idle"]["first"], q98_rows["idle"]["first"])
    same_stance("idle_first v Q98 idle", data.get("idle_first", {}), q98_rows["idle"]["first"])
else:
    fail("Q98 has no idle row")

m = variants["mirror"]
for k in ("hand_chest_dev_max_m", "hand_node_dev_max_m", "torso_yaw_dev_max_deg"):
    if abs(float(m.get(k, 1.0))) > 1e-4:
        fail("mirror deviates from itself: %s = %s" % (k, m.get(k)))
for n in ("upper_mirror_lower_lead", "upper_mirror_lower_idle"):
    if float(variants[n].get("hand_chest_dev_max_m", 1.0)) > 0.001:
        fail("%s: RightHand in the Chest frame moved %.4f m from mirror - the arm chain was not copied" % (
            n, float(variants[n]["hand_chest_dev_max_m"])))
for n, v in variants.items():
    if int(v.get("frames", 0)) < 20:
        fail("%s: only %s frames" % (n, v.get("frames")))
    if not 0.0 < float(v.get("reach_fwd_max_m", -1)) < 2.0:
        fail("%s: reach_fwd_max_m %s outside (0, 2) m" % (n, v.get("reach_fwd_max_m")))
    if not 0.0 <= float(v.get("entry_pose_deg", -1)) <= 180.0:
        fail("%s: entry_pose_deg %s outside 0..180" % (n, v.get("entry_pose_deg")))
    if float(v.get("hand_node_dev_mean_m", 0)) > float(v.get("hand_node_dev_max_m", 0)) + 1e-6:
        fail("%s: mean deviation above max" % n)
    if float(v.get("skate_mean_mps", -1)) < 0.0:
        fail("%s: skate missing" % n)

lines = open(DIGEST, encoding="utf-8").read().splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("the digest must open with ## DECISIONS")
if len(lines) > 25:
    fail("the digest is %d lines, 25 at most" % len(lines))

print("U93_check: %s (%d failure(s))" % ("PASS" if not fails else "FAIL", len(fails)))
sys.exit(0 if not fails else 1)
