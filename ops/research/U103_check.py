"""U103 gate (written by Claude, 2026-09-14). Run from the repo root (or the worktree root):
    python research/U103_check.py <pair.json> <watch_pair.log>

Pins the pair viewer to the data it plays, never to its own report of itself:
- the pair JSON follows the contract: format/version, FightMoveScript's pair rules, both roles present, ONE shared
  `times` array (the bridge rule k/60 then length_s), take length == pair length, rows of 12 floats per bone,
- the viewer's PAIR_DEBUG skeleton-space hand and head positions at t = 0, contact_s and length_s equal the JSON's own
  rows at those times (the one-clock claim: both roles are sampled at the SAME pair time),
- the node gap it placed equals start_gap_m, and the two Hips it read back in world space sit that far apart give or
  take a body's own offset from its node,
- no SCRIPT ERROR, and it reached PAIR_DONE.
Never edit this file to pass.
"""
import json
import math
import re
import sys

fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def times_for(length):
    out = []
    k = 0
    while k / 60.0 < length - 1e-6:
        out.append(k / 60.0)
        k += 1
    out.append(length)
    return out


if len(sys.argv) != 3:
    print("usage: python research/U103_check.py <pair.json> <watch_pair.log>")
    sys.exit(2)
try:
    data = json.load(open(sys.argv[1], encoding="utf-8"))
except (OSError, ValueError) as err:
    fail("cannot read the pair: %s" % err)
    print("U103_CHECK FAIL %d" % len(fails))
    sys.exit(1)
log = open(sys.argv[2], encoding="utf-8", errors="replace").read()

if data.get("format") != "fightcamp.pose_pair" or data.get("version") != 1 or float(data.get("fps", 0)) != 60.0:
    fail("format/version/fps must be fightcamp.pose_pair / 1 / 60")
pair = data.get("pair", {})
for key in ("id", "length_s", "contact_s", "entry_s", "start_gap_m", "min_gap_m", "max_gap_m", "end_travel_m"):
    if key not in pair:
        fail("pair is missing %s" % key)
if fails:
    print("U103_CHECK FAIL %d" % len(fails))
    sys.exit(1)
length = float(pair["length_s"])
contact = float(pair["contact_s"])
if not (0.0 <= float(pair["entry_s"]) <= contact <= length):
    fail("pair times out of order: entry %s contact %s length %s" % (pair["entry_s"], contact, length))
if not (float(pair["min_gap_m"]) <= float(pair["start_gap_m"]) <= float(pair["max_gap_m"])):
    fail("start_gap_m outside its range")
roles = data.get("roles", {})
want_times = times_for(length)
rows_by_role = {}
bones_by_role = {}
for role in ("thrower", "receiver"):
    r = roles.get(role)
    if not isinstance(r, dict):
        fail("role %s missing" % role)
        continue
    bones = r.get("bones", [])
    take = r.get("take", {})
    times = take.get("times", [])
    if abs(float(take.get("length_s", -1)) - length) > 1e-6:
        fail("%s take length %s != pair length %s" % (role, take.get("length_s"), length))
    if len(times) != len(want_times) or any(abs(a - b) > 1e-5 for a, b in zip(times, want_times)):
        fail("%s times do not follow the one-clock rule (%d v %d)" % (role, len(times), len(want_times)))
    pose = take.get("pose", [])
    if len(pose) != len(times) or any(len(row) != 12 * len(bones) for row in pose):
        fail("%s pose rows do not match times x 12 floats per bone" % role)
    rows_by_role[role] = pose
    bones_by_role[role] = [b.get("name") for b in bones]
if fails:
    print("U103_CHECK FAIL %d" % len(fails))
    sys.exit(1)


def row_at(role, t):
    k = min(range(len(want_times)), key=lambda i: abs(want_times[i] - t))
    return rows_by_role[role][k]


def bone_pos(role, row, name):
    i = bones_by_role[role].index(name)
    return row[12 * i + 9], row[12 * i + 10], row[12 * i + 11]


if "SCRIPT ERROR" in log:
    fail("the viewer log has a SCRIPT ERROR")
if "PAIR_DONE" not in log:
    fail("the viewer never printed PAIR_DONE")
seen = set()
hips_world = {}
line_re =re.compile(r"PAIR_DEBUG t=(\S+) role=(\w+) hand_L=\(?(\S+?),\s*(\S+?),\s*(\S+?)\)? head=\(?(\S+?),\s*(\S+?),\s*(\S+?)\)? hips_world=\(?(\S+?),\s*(\S+?),\s*(\S+?)\)?\s*$")
for line in log.splitlines():
    m = line_re.search(line.strip())
    if not m:
        continue
    t = float(m.group(1))
    role = m.group(2)
    vals = [float(m.group(i)) for i in range(3, 12)]
    if role not in rows_by_role:
        fail("PAIR_DEBUG names an unknown role %s" % role)
        continue
    which = min((0.0, contact, length), key=lambda x: abs(x - t))
    if abs(which - t) > 1.0 / 60.0 + 1e-4:
        continue
    seen.add((role, round(which, 4)))
    row = row_at(role, t)
    for label, got, name in (("hand_L", vals[0:3], "LeftHand"), ("head", vals[3:6], "Head")):
        want = bone_pos(role, row, name)
        err = math.sqrt(sum((got[i] - want[i]) ** 2 for i in range(3)))
        if err > 1e-3:
            fail("PAIR_DEBUG t=%.3f %s %s = %s, the pair JSON row says %s (off by %.4f)" % (t, role, label, got, want, err))
    if abs(which) < 1e-9:
        hips_world[role] = vals[6:9]
for role in ("thrower", "receiver"):
    for t in (0.0, contact, length):
        if (role, round(t, 4)) not in seen:
            fail("no PAIR_DEBUG line for %s at t=%.3f" % (role, t))
m = re.search(r"PAIR_DEBUG gap_nodes=(-?[0-9.]+)", log)
if not m:
    fail("no PAIR_DEBUG gap_nodes line")
else:
    gap_nodes = float(m.group(1))
    if abs(gap_nodes - float(pair["start_gap_m"])) > 0.01:
        fail("nodes placed %.4f m apart, the pair says %.4f" % (gap_nodes, float(pair["start_gap_m"])))
    if len(hips_world) == 2:
        a = hips_world["thrower"]
        b = hips_world["receiver"]
        flat = math.sqrt((a[0] - b[0]) ** 2 + (a[2] - b[2]) ** 2)
        if abs(flat - gap_nodes) > 0.5:
            fail("the two Hips are %.3f m apart on the floor at t=0 against a %.3f m node gap - a body is not where its node is" % (flat, gap_nodes))

# SEND-BACK 1 (Claude, 2026-09-14): the first recording stood both men on the floor UNDER the ring - the canvas cut them at
# the waist - while every check above passed. PHYSICS: a standing man's lowest toe is on the canvas.
grounds = re.findall(r"PAIR_DEBUG ground t=(\S+) role=(\w+) deck_y=(-?[0-9.]+) toe_min_y=(-?[0-9.]+)", log)
seen_ground = set()
for t_txt, role, deck_txt, toe_txt in grounds:
    above = float(toe_txt) - float(deck_txt)
    seen_ground.add((role, round(float(t_txt), 2)))
    if above < -0.03 or above > 0.10:
        fail("%s at t=%s: lowest toe %.3f m against the canvas at %.3f - %s" % (
            role, t_txt, float(toe_txt), float(deck_txt), "through the canvas" if above < 0 else "floating above it"))
for role in ("thrower", "receiver"):
    if (role, 0.0) not in seen_ground:
        fail("no 'PAIR_DEBUG ground t=0.000 role=%s deck_y=.. toe_min_y=..' line" % role)

if fails:
    print("U103_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("U103_CHECK PASS frames=%d gap=%.3f" % (len(want_times), float(pair["start_gap_m"])))
