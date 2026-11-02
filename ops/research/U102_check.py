"""U102 gate (written by Claude, 2026-09-14). Run from the repo root (or the worktree root):
    python research/U102_check.py <export.json> <export_tool.log> <unit_test.log>

Pins Cursor's pose bridge to things its own code cannot agree with by construction:
- PHYSICS: a bone does not change length. In every exported frame of every take, the distance from a bone to its parent
  equals the same distance in the rest block (the export writes skeleton-space GLOBAL transforms, so a wrong
  composition order, a missing parent or a local-for-global slip breaks this at once),
- PHYSICS: every basis is a rotation times a positive scale (determinant > 0, columns orthogonal),
- PRODUCTION: the tool's own VERIFY lines compare the bridge's sampler with FightStagePlayer._sample_global - the
  sampler the room's contact frames, warp and probes already use - and must be within 0.01 deg / 0.01 mm,
- ROUND TRIP: the tool's ROUNDTRIP lines (JSON -> Animation -> sampled again) must be within 0.01 deg / 0.01 mm,
- the unit test printed its own PASS line with zero failures and no SCRIPT ERROR,
- the jab's lead (left) hand actually travels: > 0.25 skeleton units forward of where the take starts it.
Never edit this file to pass.
"""
import json
import math
import re
import sys

TAKES_REQUIRED = ["jab", "cross", "hook_rear", "react_head", "idle"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def xf(row, i):
    return row[12 * i:12 * i + 12]


def origin(block):
    return block[9], block[10], block[11]


def dist(a, b):
    return math.sqrt(sum((a[k] - b[k]) ** 2 for k in range(3)))


def det_and_ortho(block):
    x = block[0:3]
    y = block[3:6]
    z = block[6:9]
    det = (x[0] * (y[1] * z[2] - y[2] * z[1]) - y[0] * (x[1] * z[2] - x[2] * z[1]) + z[0] * (x[1] * y[2] - x[2] * y[1]))
    lens = [math.sqrt(sum(c * c for c in v)) for v in (x, y, z)]
    worst = 0.0
    for a, b in ((x, y), (y, z), (x, z)):
        la = math.sqrt(sum(c * c for c in a)) or 1.0
        lb = math.sqrt(sum(c * c for c in b)) or 1.0
        worst = max(worst, abs(sum(a[k] * b[k] for k in range(3))) / (la * lb))
    return det, worst, lens


if len(sys.argv) != 4:
    print("usage: python research/U102_check.py <export.json> <export_tool.log> <unit_test.log>")
    sys.exit(2)
json_path, tool_log_path, test_log_path = sys.argv[1:4]

try:
    data = json.load(open(json_path, encoding="utf-8"))
except (OSError, ValueError) as err:
    fail("cannot read %s: %s" % (json_path, err))
    print("U102_CHECK FAIL %d" % len(fails))
    sys.exit(1)

if data.get("format") != "fightcamp.pose_bridge" or data.get("version") != 1:
    fail("format/version must be fightcamp.pose_bridge / 1, got %r / %r" % (data.get("format"), data.get("version")))
if float(data.get("fps", 0)) != 60.0:
    fail("fps must be 60, got %r" % data.get("fps"))
bones = data.get("bones", [])
names = [str(b.get("name")) for b in bones]
if len(bones) < 20:
    fail("only %d bones exported" % len(bones))
if len(set(names)) != len(names):
    fail("bone names are not unique")
index = {n: i for i, n in enumerate(names)}
for i, b in enumerate(bones):
    p = b.get("parent")
    if not isinstance(p, int) or p < -1 or p >= len(bones) or p == i:
        fail("bone %s has a bad parent %r" % (names[i], p))
    if len(b.get("rest", [])) != 12:
        fail("bone %s rest is not 12 floats" % names[i])
if fails:
    print("U102_CHECK FAIL %d" % len(fails))
    sys.exit(1)

rest_len = {}
for i, b in enumerate(bones):
    if b["parent"] >= 0:
        rest_len[i] = dist(origin(b["rest"]), origin(bones[b["parent"]]["rest"]))

takes = data.get("takes", {})
for name in TAKES_REQUIRED:
    if name not in takes:
        fail("take %s missing from the export" % name)
for take_name, take in sorted(takes.items()):
    times = take.get("times", [])
    pose = take.get("pose", [])
    length = float(take.get("length_s", -1))
    if len(times) < 2 or len(pose) != len(times):
        fail("%s: %d times but %d pose rows" % (take_name, len(times), len(pose)))
        continue
    if abs(times[0]) > 1e-9 or abs(times[-1] - length) > 1e-6:
        fail("%s: times must run from 0 to length_s (%.4f), got %.6f .. %.6f" % (take_name, length, times[0], times[-1]))
    if any(times[k + 1] - times[k] <= 0 or times[k + 1] - times[k] > 1.0 / 60.0 + 1e-6 for k in range(len(times) - 1)):
        fail("%s: times are not strictly increasing at <= 1/60 s steps" % take_name)
    worst_len = 0.0
    worst_where = ""
    worst_det = 1.0
    worst_ortho = 0.0
    for f, row in enumerate(pose):
        if len(row) != 12 * len(bones):
            fail("%s frame %d: row has %d floats, wants %d" % (take_name, f, len(row), 12 * len(bones)))
            break
        for i, b in enumerate(bones):
            block = xf(row, i)
            det, ortho, _ = det_and_ortho(block)
            worst_det = min(worst_det, det)
            worst_ortho = max(worst_ortho, ortho)
            if i in rest_len:
                d = abs(dist(origin(block), origin(xf(row, b["parent"]))) - rest_len[i])
                if d > worst_len:
                    worst_len = d
                    worst_where = "%s frame %d" % (names[i], f)
    if worst_len > 1e-4:
        fail("%s: a bone changed length by %.6f (worst %s) - the export is not skeleton-space globals" % (take_name, worst_len, worst_where))
    if worst_det <= 0.0:
        fail("%s: a basis has determinant %.6f (<= 0)" % (take_name, worst_det))
    if worst_ortho > 1e-3:
        fail("%s: a basis is not orthogonal (worst |cos| %.5f)" % (take_name, worst_ortho))
    print("TAKE %s frames=%d length=%.4f worst_bone_length_change=%.2e" % (take_name, len(times), length, worst_len))

if "jab" in takes and "LeftHand" in index:
    rows = takes["jab"]["pose"]
    h = index["LeftHand"]
    start = origin(xf(rows[0], h))
    travel = max(dist(origin(xf(r, h)), start) for r in rows)
    if travel <= 0.25:
        fail("jab: the lead (left) hand travels only %.3f skeleton units - not a punch" % travel)
    print("JAB LeftHand travel %.3f" % travel)

tool_log = open(tool_log_path, encoding="utf-8", errors="replace").read()
if "SCRIPT ERROR" in tool_log:
    fail("the export tool log has a SCRIPT ERROR")
for kind in ("VERIFY", "ROUNDTRIP"):
    seen = set()
    for m in re.finditer(r"EXPORT %s (\S+) max_rot_deg ([0-9.eE+-]+) max_pos_mm ([0-9.eE+-]+)" % kind, tool_log):
        seen.add(m.group(1))
        if float(m.group(2)) > 0.01 or float(m.group(3)) > 0.01:
            fail("EXPORT %s %s: %s deg / %s mm, over 0.01" % (kind, m.group(1), m.group(2), m.group(3)))
    for name in TAKES_REQUIRED:
        if name not in seen:
            fail("the export tool printed no EXPORT %s line for %s" % (kind, name))
if not re.search(r"EXPORT DONE takes=\d+", tool_log):
    fail("the export tool never printed EXPORT DONE")

test_log = open(test_log_path, encoding="utf-8", errors="replace").read()
if "SCRIPT ERROR" in test_log:
    fail("the unit test log has a SCRIPT ERROR")
m = re.search(r"FIGHT_POSE_BRIDGE_TEST checks=(\d+) failures=(\d+)", test_log)
if not m:
    fail("the unit test never printed FIGHT_POSE_BRIDGE_TEST checks=N failures=M")
elif int(m.group(2)) != 0 or int(m.group(1)) < 12:
    fail("unit test: checks=%s failures=%s (needs >= 12 checks, 0 failures)" % (m.group(1), m.group(2)))

if fails:
    print("U102_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("U102_CHECK PASS takes=%d bones=%d" % (len(takes), len(bones)))
