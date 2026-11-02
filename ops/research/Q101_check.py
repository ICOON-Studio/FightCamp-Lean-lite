"""Q101 gate (written by Claude, 2026-09-14). Run from the repo root: python research/Q101_check.py

Pins Qwen's Fighting Motions census to things that cannot differ:
- the rows are EXACTLY the pack's .fbx files on disk (listed here from the folder, never from the JSON),
- the map is Q100's non-empty entries (read from Q100's JSON, never typed),
- the `hook_rear` and `idle` reference rows reproduce Cursor's U93 run of the same measure (an independent earlier
  instrument): skate, planted frames, first stance and the right hand's forward reach,
- every number is inside physics (feet near the canvas, a head and a fist at human heights, angles in degrees).
Never edit this file to pass: fix the tool or re-run it.
"""
import json
import math
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GODOT = os.path.join(ROOT, "Godot")
RESEARCH = os.path.join(GODOT, "research")
JSON_PATH = os.path.join(RESEARCH, "Q101_fm1_takes.json")
U93_PATH = os.path.join(RESEARCH, "U93_hook_splice.json")
Q100_PATH = os.path.join(RESEARCH, "Q100_fm1_rig.json")
DIGEST = os.path.join(RESEARCH, "Q101_FM1_TAKES.md")
TOOL = os.path.join(GODOT, "tools", "measure_fm1_takes.gd")
PACK = os.path.join(GODOT, "assets", "anim", "audition", "magicpot_fm1")
REFERENCES = {"idle": "", "jab": "LeftHand", "cross": "RightHand", "hook_lead": "LeftHand", "hook_rear": "RightHand"}
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def is_num(value):
    return isinstance(value, (int, float)) and not (isinstance(value, float) and math.isnan(value))


def num(row, key):
    value = row.get(key)
    if not is_num(value):
        fail("%s: %s missing or not a number (%r)" % (row.get("name"), key, value))
        return float("nan")
    return float(value)


for path in (TOOL, JSON_PATH, U93_PATH, Q100_PATH, DIGEST, PACK):
    if not os.path.exists(path):
        fail("missing %s" % path)
if fails:
    sys.exit(1)

data = json.load(open(JSON_PATH, encoding="utf-8"))
u93 = json.load(open(U93_PATH, encoding="utf-8"))
u93_mirror = {row["name"]: row for row in u93["variants"]}["mirror"]
q100 = json.load(open(Q100_PATH, encoding="utf-8"))
map_size = len([entry for entry in q100["map"] if str(entry.get("fm1", "")).strip()])

expected = sorted(name for name in os.listdir(PACK)
                  if name.lower().endswith(".fbx") and name != "BlueGuy.fbx"
                  and os.path.isfile(os.path.join(PACK, name)))
nomove = os.path.join(PACK, "nomove")
if os.path.isdir(nomove):
    expected += sorted("nomove/" + name for name in os.listdir(nomove) if name.lower().endswith(".fbx"))

pop = data.get("population", {})
for key, want in (("fighter", "f01_m_box_welter"), ("binding", "boxing"), ("node", "still"), ("fps", 30),
                  ("pack", "magicpot_fighting_motions_vol1"), ("reference_pose", "BlueGuy.fbx"),
                  ("map_source", "Q100_fm1_rig.json"), ("map_size", map_size)):
    if pop.get(key) != want:
        fail("population.%s is %r, expected %r" % (key, pop.get(key), want))

rows = data.get("rows", [])
names = [row.get("name") for row in rows]
if sorted(names) != sorted(expected):
    fail("rows must be exactly the pack's %d .fbx files; missing %s, extra %s"
         % (len(expected), sorted(set(expected) - set(names)), sorted(set(names) - set(expected))))
refs = {row.get("name"): row for row in data.get("references", [])}
for name in REFERENCES:
    if name not in refs:
        fail("reference row %s missing" % name)
if fails:
    sys.exit(1)


def check_stance(label, stance):
    if not isinstance(stance, dict) or stance.get("lead") not in ("LeftToes", "RightToes"):
        fail("%s: stance missing or lead not LeftToes/RightToes (%r)" % (label, stance))
        return
    for key in ("split_m", "width_m"):
        if not is_num(stance.get(key)) or not 0.0 <= float(stance[key]) <= 1.5:
            fail("%s: %s %r outside 0..1.5 m" % (label, key, stance.get(key)))


def check_row(row, want_hand):
    name = row.get("name")
    for key in ("first", "last"):
        check_stance("%s.%s" % (name, key), row.get(key))
    if not 0.0 <= num(row, "entry_pose_deg") <= 180.0:
        fail("%s: entry_pose_deg outside 0..180" % name)
    if not isinstance(row.get("planted_frames"), int) or row["planted_frames"] < 0:
        fail("%s: planted_frames %r not a count" % (name, row.get("planted_frames")))
    elif row["planted_frames"] > 0 and (num(row, "skate_mean_mps") < 0.0 or num(row, "skate_p95_mps") < 0.0):
        fail("%s: negative skate over %d planted frames" % (name, row["planted_frames"]))
    if num(row, "lowest_toe_m") < -0.20:
        fail("%s: lowest toe %.3f m - more than 20 cm through the canvas is an instrument error" % (name, num(row, "lowest_toe_m")))
    if not 0.0 <= num(row, "head_height_f0_m") <= 2.2:
        fail("%s: head height %.3f m outside 0..2.2" % (name, num(row, "head_height_f0_m")))
    hands = row.get("hands_f0")
    if not isinstance(hands, dict) or not all(is_num(hands.get(k)) and -0.2 <= float(hands[k]) <= 2.4 for k in ("left_y", "right_y")):
        fail("%s: hands_f0 missing or outside -0.2..2.4 m (%r)" % (name, hands))
    if row.get("hand") != want_hand:
        fail("%s: hand %r, expected %r" % (name, row.get("hand"), want_hand))
    strike = row.get("strike")
    if want_hand == "":
        if strike is not None:
            fail("%s: strike must be null when no hand is named" % name)
        return
    if not isinstance(strike, dict) or not all(is_num(strike.get(k)) for k in ("x", "y", "z", "frame")):
        fail("%s: strike missing a number (%r)" % (name, strike))
        return
    if not 0.0 <= float(strike["y"]) <= 2.2 or abs(float(strike["x"])) > 2.0 or abs(float(strike["z"])) > 2.0:
        fail("%s: strike (%.3f, %.3f, %.3f) outside physics" % (name, float(strike["x"]), float(strike["y"]), float(strike["z"])))


errors = 0
for row in rows:
    name = str(row.get("name"))
    base = name.split("/")[-1].lower()
    want_hand = "LeftHand" if "_left" in base else ("RightHand" if "_right" in base else "")
    if str(row.get("error", "")) != "":
        errors += 1
        continue
    if "error" not in row:
        fail("%s: error field missing (use \"\" on success)" % name)
    if not isinstance(row.get("bones"), int) or not 1 <= row["bones"] <= 22:
        fail("%s: bones %r outside 1..22" % (name, row.get("bones")))
    if num(row, "length_s") <= 0.0 or not isinstance(row.get("frames"), int) or row["frames"] < 2:
        fail("%s: length_s/frames not sane" % name)
    check_row(row, want_hand)
if errors > 16:
    fail("%d of %d rows errored - the task says send Q101 BLOCKED instead of committing" % (errors, len(rows)))

for name, want_hand in REFERENCES.items():
    check_row(refs[name], want_hand)

# SEND-BACK 1 (2026-09-14): the first delivery put every Fighting Motions body 0.9 m in the air (lowest toe 0.906 m,
# head 1.54 m against production idle's 0.61 m) and the digest read hand and strike HEIGHTS off it. The SAME body, f01,
# must stand on the same canvas: every clip that is not a knockdown or a get-up keeps a toe within -5..+8 cm of it and
# starts with its head within 20 cm of production idle's.
idle_head = float(refs["idle"].get("head_height_f0_m", float("nan")))
for row in rows:
    name = str(row.get("name"))
    base = name.split("/")[-1].lower()
    if str(row.get("error", "")) != "" or base.startswith("knockdown") or base.startswith("getup"):
        continue
    low = row.get("lowest_toe_m")
    if not is_num(low) or not -0.05 <= float(low) <= 0.08:
        fail("%s: lowest toe %r m - the body is not standing on the canvas (production rows: -0.01..0.00)" % (name, low))
    head = row.get("head_height_f0_m")
    if not is_num(head) or abs(float(head) - idle_head) > 0.20:
        fail("%s: head at frame 0 %r m against production idle's %.3f m - the Hips are placed wrong" % (name, head, idle_head))

# The independent instrument: U93 measured hook_rear (the mirror) and idle the same way.
rear = refs["hook_rear"]
if abs(num(rear, "skate_mean_mps") - float(u93_mirror["skate_mean_mps"])) > 0.003:
    fail("hook_rear skate %.4f does not reproduce U93's %.4f" % (num(rear, "skate_mean_mps"), float(u93_mirror["skate_mean_mps"])))
if not isinstance(rear.get("planted_frames"), int) or abs(rear["planted_frames"] - int(u93_mirror["planted_frames"])) > 1:
    fail("hook_rear planted_frames %r does not reproduce U93's %d" % (rear.get("planted_frames"), int(u93_mirror["planted_frames"])))
if isinstance(rear.get("strike"), dict) and is_num(rear["strike"].get("z")):
    if abs(float(rear["strike"]["z"]) - float(u93_mirror["reach_fwd_max_m"])) > 0.003:
        fail("hook_rear strike.z %.4f does not reproduce U93's reach %.4f" % (float(rear["strike"]["z"]), float(u93_mirror["reach_fwd_max_m"])))
for label, got, want in (("hook_rear first", rear.get("first"), u93_mirror["first"]),
                         ("idle first", refs["idle"].get("first"), u93["idle_first"]),
                         ("idle_first", data.get("idle_first"), u93["idle_first"])):
    if not isinstance(got, dict) or got.get("lead") != want["lead"]:
        fail("%s: lead %r does not reproduce U93's %s" % (label, (got or {}).get("lead"), want["lead"]))
        continue
    for key in ("split_m", "width_m"):
        if abs(float(got.get(key, 99)) - float(want[key])) > 0.005:
            fail("%s: %s %.4f does not reproduce U93's %.4f" % (label, key, float(got.get(key, 99)), float(want[key])))

lines = open(DIGEST, encoding="utf-8").read().splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("digest must open with '## DECISIONS'")
if len(lines) > 35:
    fail("digest is %d lines, 35 at most" % len(lines))
text = "\n".join(lines)
for token in ("idle_A", "idle_Tiramis", "bp_hook_right_A", "hp_straight_right_A"):
    if token not in text:
        fail("digest never names %s" % token)

if fails:
    print("Q101_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("Q101_CHECK PASS rows=%d errors=%d references=%d" % (len(rows), errors, len(refs)))
