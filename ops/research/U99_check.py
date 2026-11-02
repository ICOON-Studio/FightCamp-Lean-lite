"""U99 gate (written by Claude, 2026-09-14). Run from the repo root: python research/U99_check.py

Pins the jerk census to things it cannot fake:
- frame counts per seed equal the realism test's (19802 / 19802 / 19866) - the same bouts, stepped the same way,
- jerk is physical: p50 of every point under 200 m/s^3 (a standing boxer), max under 100000 (no teleports),
- the calm is calm: jerk p95 on frames with NO cause flag is below the p95 on join_active frames (a stale pose read
  would spike everywhere alike),
- every cause flag named in the task is present, shares are in [0, 1], the top list has 40 rows with flags,
- the digest opens with DECISIONS.
Never edit this file to pass."""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
R = os.path.join(ROOT, "research")
FRAMES = {"94301": 19802, "51227": 19802, "77003": 19866}
FLAGS = ["take_changed", "join_active", "warp", "gap_walk", "contact_push", "lock_release"]
POINTS = ["Head", "Chest", "LeftHand", "RightHand", "LeftFoot", "RightFoot"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


for name in ("U99_jerk.json", "U99_JERK.md"):
    if not os.path.exists(os.path.join(R, name)):
        fail("missing research/" + name)
if fails:
    print("U99_CHECK FAIL %d" % len(fails))
    sys.exit(1)
d = json.load(open(os.path.join(R, "U99_jerk.json"), encoding="utf-8"))
for seed, n in FRAMES.items():
    got = (d.get("frames") or {}).get(seed)
    if got != n:
        fail("seed %s: %r frames, the realism test steps %d" % (seed, got, n))
by_point = d.get("by_point") or {}
for point in POINTS:
    row = by_point.get(point)
    if not row:
        fail("by_point has no %s" % point)
        continue
    if not (isinstance(row.get("p50"), (int, float)) and row["p50"] < 200.0):
        fail("%s jerk p50 %r m/s^3 - a boxer in guard does not jerk like that" % (point, row.get("p50")))
    if not (isinstance(row.get("max"), (int, float)) and row["max"] < 100000.0):
        fail("%s jerk max %r m/s^3 - a teleport, not a jerk" % (point, row.get("max")))
by_cause = d.get("by_cause") or {}
for flag in FLAGS + ["none"]:
    row = by_cause.get(flag)
    if row is None:
        fail("by_cause has no %s" % flag)
        continue
    share = row.get("share_of_top1pct")
    if flag != "none" and not (isinstance(share, (int, float)) and 0.0 <= share <= 1.0):
        fail("%s share_of_top1pct %r" % (flag, share))
none_p95 = (by_cause.get("none") or {}).get("jerk_p95")
join_p95 = (by_cause.get("join_active") or {}).get("jerk_p95")
if not (isinstance(none_p95, (int, float)) and isinstance(join_p95, (int, float)) and none_p95 < join_p95):
    fail("jerk p95 with no cause (%r) is not below join_active's (%r) - read the pose after _process" % (none_p95, join_p95))
top = d.get("top") or []
if len(top) != 40:
    fail("top has %d rows, needs 40" % len(top))
for row in top[:40]:
    for key in ("seed", "frame", "side", "point", "jerk", "take", "prev_take", "flags"):
        if key not in row:
            fail("top row missing %s: %r" % (key, row))
            break
lines = open(os.path.join(R, "U99_JERK.md"), encoding="utf-8").read().splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("digest must open with '## DECISIONS'")
if len(lines) > 25:
    fail("digest is %d lines, 25 at most" % len(lines))
if fails:
    print("U99_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("U99_CHECK PASS")
