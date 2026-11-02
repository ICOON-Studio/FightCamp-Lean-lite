"""Q100 gate (written by Claude, 2026-09-14). Run from the repo root: python research/Q100_check.py

Pins Qwen's Fighting Motions rig census:
- the map covers OUR 22 bones exactly once each (read from FightClipRetarget.gd's UE4_TO_OURS - never typed), and
  every non-empty mapped name is a bone in every one of the three files, with no bone used twice,
- the hierarchy agrees with the map: where our parent is mapped, the mapped bone's ancestor chain contains it,
- OUR f01 rest matches R108's independent measurement: shoulder abduction 92.1 deg (+-1.5), both sides,
- every angle is inside 0..180 and every hips height is positive and under 1.5 m,
- the rest file named is one of the three (or "") and, if named, its shoulder abduction is within 15 deg of ours.
Never edit this file to pass: fix the tool or re-run it.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
RESEARCH = os.path.join(ROOT, "research")
JSON_PATH = os.path.join(RESEARCH, "Q100_fm1_rig.json")
DIGEST = os.path.join(RESEARCH, "Q100_FM1_RIG.md")
TOOL = os.path.join(ROOT, "Godot", "tools", "measure_fm1_rig.gd")
RETARGET = os.path.join(ROOT, "Godot", "scripts", "FightClipRetarget.gd")
FILES = ["BlueGuy.fbx", "idle_A.fbx", "idle_Tiramis.fbx"]
ANGLE_KEYS = ["shoulder_abduction_deg_l", "shoulder_abduction_deg_r", "elbow_flex_deg_l", "elbow_flex_deg_r",
              "knee_flex_deg_l", "knee_flex_deg_r"]
## OUR parent of each driven bone, as the retarget's own map implies it (Hips is the root of the 22).
OUR_PARENT = {
    "Spine": "Hips", "Chest": "Spine", "UpperChest": "Chest", "Neck": "UpperChest", "Head": "Neck",
    "LeftShoulder": "UpperChest", "LeftUpperArm": "LeftShoulder", "LeftLowerArm": "LeftUpperArm", "LeftHand": "LeftLowerArm",
    "RightShoulder": "UpperChest", "RightUpperArm": "RightShoulder", "RightLowerArm": "RightUpperArm", "RightHand": "RightLowerArm",
    "LeftUpperLeg": "Hips", "LeftLowerLeg": "LeftUpperLeg", "LeftFoot": "LeftLowerLeg", "LeftToes": "LeftFoot",
    "RightUpperLeg": "Hips", "RightLowerLeg": "RightUpperLeg", "RightFoot": "RightLowerLeg", "RightToes": "RightFoot",
}
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


for path in (TOOL, JSON_PATH, DIGEST):
    if not os.path.exists(path):
        fail("missing %s" % path)
if fails:
    print("Q100_check: FAIL (%d failure(s))" % len(fails))
    sys.exit(1)

src = open(RETARGET, encoding="utf-8").read()
block = re.search(r"const UE4_TO_OURS := \{(.*?)\}", src, re.S)
ours = re.findall(r'"[^"]+":\s*"([^"]+)"', block.group(1)) if block else []
if len(ours) != 22:
    fail("could not read 22 bones from UE4_TO_OURS (got %d)" % len(ours))

data = json.load(open(JSON_PATH, encoding="utf-8"))
rows = data.get("map", [])
mapped = {}
for r in rows:
    o = r.get("ours")
    if o in mapped:
        fail("our bone %s mapped twice" % o)
    mapped[o] = r.get("fm1", "")
    if r.get("method") not in ("name", "hierarchy"):
        fail("%s: method must be name or hierarchy" % o)
if sorted(mapped.keys()) != sorted(ours):
    fail("the map's bones differ from UE4_TO_OURS's 22: missing %s, extra %s" % (
        sorted(set(ours) - set(mapped)), sorted(set(mapped) - set(ours))))
used = [v for v in mapped.values() if v]
if len(used) != len(set(used)):
    fail("a Fighting Motions bone is used for two of ours")
if len(used) < 18:
    fail("only %d of 22 mapped - the rig should cover a humanoid" % len(used))

files = data.get("files", {})
for fname in FILES:
    f = files.get(fname)
    if not f:
        fail("no entry for %s" % fname)
        continue
    bones = {b.get("name"): b for b in f.get("bones", [])}
    if len(bones) < 15:
        fail("%s: only %d bones" % (fname, len(bones)))
    for o, fm in mapped.items():
        if fm and fm not in bones:
            fail("%s: mapped bone %s (for %s) is not in the file" % (fname, fm, o))
    for o, fm in mapped.items():
        parent_ours = OUR_PARENT.get(o)
        if not fm or not parent_ours or not mapped.get(parent_ours):
            continue
        want = mapped[parent_ours]
        walk, guard, found = bones.get(fm, {}).get("parent", ""), 0, False
        while walk and guard < 64:
            if walk == want:
                found = True
                break
            walk = bones.get(walk, {}).get("parent", "")
            guard += 1
        if not found:
            fail("%s: %s (our %s) does not descend from %s (our %s)" % (fname, fm, o, want, parent_ours))
    ra = f.get("rest_angles", {})
    for k in ANGLE_KEYS:
        if not 0.0 <= float(ra.get(k, -1)) <= 180.0:
            fail("%s: %s = %s outside 0..180" % (fname, k, ra.get(k)))
    if not 0.0 < float(ra.get("hips_height_m", -1)) < 1.5:
        fail("%s: hips_height_m %s outside (0, 1.5)" % (fname, ra.get("hips_height_m")))

o = data.get("ours", {}).get("rest_angles", {})
for side in ("l", "r"):
    v = float(o.get("shoulder_abduction_deg_" + side, -1))
    if abs(v - 92.1) > 1.5:
        fail("ours shoulder_abduction_deg_%s = %.2f, R108 measured 92.1" % (side, v))
if not 0.0 < float(o.get("hips_height_m", -1)) < 1.5:
    fail("ours hips_height_m %s outside (0, 1.5)" % o.get("hips_height_m"))

rest = data.get("rest_file", None)
if rest not in FILES + [""]:
    fail("rest_file must be one of %s or empty, got %s" % (FILES, rest))
elif rest:
    ra = files.get(rest, {}).get("rest_angles", {})
    for side in ("l", "r"):
        if abs(float(ra.get("shoulder_abduction_deg_" + side, 0)) - float(o.get("shoulder_abduction_deg_" + side, 0))) > 15.0:
            fail("rest_file %s is not a T-pose like ours on the %s shoulder" % (rest, side))

lines = open(DIGEST, encoding="utf-8").read().splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("the digest must open with ## DECISIONS")
if len(lines) > 25:
    fail("the digest is %d lines, 25 at most" % len(lines))

print("Q100_check: %s (%d failure(s))" % ("PASS" if not fails else "FAIL", len(fails)))
sys.exit(0 if not fails else 1)
