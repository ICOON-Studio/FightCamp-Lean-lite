"""U97 gate (written by Claude, 2026-09-14). Run from the repo root: python research/U97_check.py

R7 (bodies never pass through each other) and R8 (the fist reaches its target) join the realism test, measured
through ONE capsule module that the U95/U96 instrument now also uses. Pins, none of them to Cursor's own prose:
- DERIVE, NEVER COPY: Godot/scripts/FightBodyCapsules.gd exists; the tool and the realism test both preload it; the
  tool no longer declares its own CAPSULE_DEFS / SPHERE_DEFS / _pair_depth.
- THE REFACTOR CHANGED NOTHING: the refactored tool's realism rows at both band sets reproduce U96's committed rows
  (ints exact, floats within 1e-9).
- THE OLD RULES DID NOT MOVE: every line of the R1-R6 RULE blocks is identical before and after; TOTAL grows by 2.
- R7 IS THE SAME INSTRUMENT: its per-seed overlap frames reproduce U96's room rows exactly, and at real spacing its
  violations are fewer than at room spacing; R7 FAILS at room spacing (88% overlap cannot pass a physics rule).
- R8 COUNTS THE SAME CONTACTS AS Q97: per role, total within 2% of Q97's n and the contact-frame forward / lateral /
  vertical p50 within 0.03 m of U96's room contact summary; R8 FAILS at room spacing (Q97: straights 0.3-0.4 m low).
- Every new RULE block prints study / real / bound / label / measured, and names its studies.
Never edit this file to pass: fix the module, the test, the tool or the outputs.
"""
import json
import os
import re
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
GODOT = os.path.join(ROOT, "Godot")
RESEARCH = os.path.join(GODOT, "research")
MODULE = os.path.join(GODOT, "scripts", "FightBodyCapsules.gd")
TOOL = os.path.join(GODOT, "tools", "measure_body_overlap.gd")
TEST = os.path.join(GODOT, "tests", "fight_stage_realism_test.gd")
U96 = os.path.join(RESEARCH, "U96_real_spacing.json")
Q97 = os.path.join(RESEARCH, "Q97_contact_miss.json")
OUT = {
    "room_json": os.path.join(RESEARCH, "U97_overlap_room.json"),
    "real_json": os.path.join(RESEARCH, "U97_overlap_real.json"),
    "before": os.path.join(RESEARCH, "U97_realism_before.txt"),
    "after": os.path.join(RESEARCH, "U97_realism_after.txt"),
    "real": os.path.join(RESEARCH, "U97_realism_real.txt"),
    "digest": os.path.join(RESEARCH, "U97_R7_R8.md"),
}
SEEDS = [94301, 51227, 77003]
ROLES = ["jab", "cross", "hook_lead", "hook_rear", "strike_body"]
OLD_RULES = ["R1", "R2", "R2b", "R3", "R3b", "R4", "R5", "R5b", "R6"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def read(path):
    return open(path, encoding="utf-8", errors="replace").read()


for path in [MODULE, TOOL, TEST, U96, Q97] + list(OUT.values()):
    if not os.path.exists(path):
        fail("missing %s" % path)
if fails:
    print("U97_CHECK FAIL %d" % len(fails))
    sys.exit(1)

# -- derive, never copy
module_src, tool_src, test_src = read(MODULE), read(TOOL), read(TEST)
for name, src in (("tool", tool_src), ("realism test", test_src)):
    if 'preload("res://scripts/FightBodyCapsules.gd")' not in src:
        fail("%s does not preload res://scripts/FightBodyCapsules.gd" % name)
for token in ("const CAPSULE_DEFS", "const SPHERE_DEFS", "func _pair_depth"):
    if token in tool_src:
        fail("the tool still declares %r - the capsule model must live only in FightBodyCapsules.gd" % token)
    if token.split()[-1] not in module_src:
        fail("FightBodyCapsules.gd has no %s" % token.split()[-1])

# -- the refactor changed nothing
u96 = json.load(open(U96, encoding="utf-8"))


def same_row(label, got, want):
    for key in ("seed", "frames", "overlap_frames"):
        if got.get(key) != want.get(key):
            fail("%s: %s %r, U96 %r" % (label, key, got.get(key), want.get(key)))
    for key in ("overlap_share", "depth_p50_m", "depth_p95_m", "depth_max_m"):
        g, w = got.get(key), want.get(key)
        if not isinstance(g, (int, float)) or abs(float(g) - float(w)) > 1e-9:
            fail("%s: %s %r, U96 %r" % (label, key, g, w))
    for cls, row in (want.get("by_class") or {}).items():
        g = ((got.get("by_class") or {}).get(cls) or {}).get("frames")
        if g != row.get("frames"):
            fail("%s: by_class %s frames %r, U96 %r" % (label, cls, g, row.get("frames")))


for band in ("room", "real"):
    data = json.load(open(OUT[band + "_json"], encoding="utf-8"))
    rows = data.get("bouts") or data.get("realism") or data.get("rows") or []
    if isinstance(rows, dict):
        rows = rows.get("realism", [])
    by_seed = {r.get("seed"): r for r in rows if isinstance(r, dict)}
    for want in u96["overlap"][band]:
        got = by_seed.get(want["seed"])
        if got is None:
            fail("U97_overlap_%s.json has no realism row for seed %s" % (band, want["seed"]))
            continue
        same_row("tool %s seed %s" % (band, want["seed"]), got, want)


# -- the realism test outputs
def rule_blocks(text):
    blocks, current = {}, None
    for line in text.splitlines():
        m = re.match(r"^RULE (\S+) ", line)
        if m:
            current = m.group(1)
            blocks[current] = [line]
            continue
        if current and re.match(r"^    (study|real|bound|label|measured):", line):
            blocks[current].append(line)
        else:
            current = None
    return blocks


def total(text):
    m = re.search(r"^TOTAL=(\d+) fails=(\d+)", text, re.M)
    return (int(m.group(1)), int(m.group(2))) if m else (None, None)


before, after, real = read(OUT["before"]), read(OUT["after"]), read(OUT["real"])
bb, ba, br = rule_blocks(before), rule_blocks(after), rule_blocks(real)
for rid in OLD_RULES:
    if rid not in bb:
        fail("before-run has no RULE %s block - run the unmodified test on master first" % rid)
    elif ba.get(rid) != bb[rid]:
        fail("RULE %s changed between before and after: %r -> %r" % (rid, bb[rid], ba.get(rid)))
tb, ta = total(before), total(after)
if tb[0] is None or ta[0] is None or ta[0] != tb[0] + 2:
    fail("TOTAL checks before %r after %r - R7 and R8 add exactly two gated checks" % (tb, ta))

for rid, name in (("R7", "bodies_never_pass_through"), ("R8", "the_fist_reaches_its_target")):
    for label, blocks in (("after", ba), ("real", br)):
        block = blocks.get(rid)
        if not block:
            fail("%s run has no RULE %s block" % (label, rid))
            continue
        if not re.match(r"^RULE %s %s \| GATED S4a \| (PASS|FAIL)$" % (rid, name), block[0]):
            fail("%s %s header %r - expected 'RULE %s %s | GATED S4a | PASS|FAIL'" % (label, rid, block[0], rid, name))
        fields = [l.split(":", 1)[0].strip() for l in block[1:]]
        if fields != ["study", "real", "bound", "label", "measured"]:
            fail("%s %s prints %r, needs study/real/bound/label/measured in that order" % (label, rid, fields))
    head = (ba.get(rid) or [""])[0]
    if not head.endswith("| FAIL"):
        fail("%s passes at room spacing (%r) - a physics rule cannot pass where Q97/U95 measured the failure" % (rid, head))
study7 = " ".join(ba.get("R7", []))
for word in ("PHYSICS", "Atha", "U95"):
    if word not in study7:
        fail("R7's block never names %s" % word)
study8 = " ".join(ba.get("R8", []))
for word in ("PHYSICS", "Q97", "K52"):
    if word not in study8:
        fail("R8's block never names %s" % word)


def seed_lines(text):
    out = {}
    for m in re.finditer(r"^\s*R7-SEED (\d+) frames=(\d+) overlap_frames=(\d+) violating_frames=(\d+) allowed_contact_frames=(\d+)", text, re.M):
        out[int(m.group(1))] = tuple(int(g) for g in m.groups()[1:])
    return out


room_seeds, real_seeds = seed_lines(after), seed_lines(real)
for want in u96["overlap"]["room"]:
    got = room_seeds.get(want["seed"])
    if not got:
        fail("after-run has no R7-SEED line for seed %s" % want["seed"])
        continue
    if got[0] != want["frames"] or got[1] != want["overlap_frames"]:
        fail("R7-SEED %s frames/overlap_frames %r/%r - U96 room %r/%r (the same module on the same frames)" % (
            want["seed"], got[0], got[1], want["frames"], want["overlap_frames"]))
    if got[2] + got[3] != got[1]:
        fail("R7-SEED %s violating %d + allowed %d != overlap frames %d (every overlap frame is one or the other)" % (
            want["seed"], got[2], got[3], got[1]))
viol_room = sum(v[2] for v in room_seeds.values())
viol_real = sum(v[2] for v in real_seeds.values())
if len(real_seeds) != 3:
    fail("real-spacing run has %d R7-SEED lines, needs 3" % len(real_seeds))
elif not viol_real < viol_room:
    fail("R7 violating frames at real spacing %d are not fewer than at room spacing %d" % (viol_real, viol_room))

q97 = json.load(open(Q97, encoding="utf-8"))["summary"]
room_contact = u96["contact"]["room"]


def role_lines(text):
    out = {}
    pat = (r"^\s*R8-ROLE (\S+) total=(\d+) landed=(\d+) reach=(\d+) gap_p50=(-?[\d.]+) "
           r"fwd_p50=(-?[\d.]+) lat_p50=(-?[\d.]+) vert_p50=(-?[\d.]+)")
    for m in re.finditer(pat, text, re.M):
        out[m.group(1)] = [int(m.group(2)), int(m.group(3)), int(m.group(4))] + [float(g) for g in m.groups()[4:]]
    return out


roles = role_lines(after)
for role in ROLES:
    got = roles.get(role)
    if not got:
        fail("after-run has no R8-ROLE line for %s" % role)
        continue
    n = int(q97[role]["n"])
    if abs(got[0] - n) > max(1, round(0.02 * n)):
        fail("R8-ROLE %s total=%d, Q97 counted %d contacts (2%% allowed)" % (role, got[0], n))
    if not (0 <= got[2] <= got[1] <= got[0]):
        fail("R8-ROLE %s reach %d <= landed %d <= total %d does not hold" % (role, got[2], got[1], got[0]))
    if role != "strike_body" and got[1] == 0:
        fail("R8-ROLE %s landed=0 - the receiver's reaction is not being read" % role)
    if not -0.5 <= got[3] <= 2.0:
        fail("R8-ROLE %s gap_p50 %.3f m is not a distance between two bodies a metre apart" % (role, got[3]))
    if role in room_contact:
        for key, idx in (("forward_m", 4), ("lateral_m", 5), ("vertical_m", 6)):
            want = float(room_contact[role][key]["p50"])
            if abs(got[idx] - want) > 0.03:
                fail("R8-ROLE %s %s p50 %.3f, Q97/U96 room %.3f (the same contact frame and hand)" % (role, key, got[idx], want))

lines = read(OUT["digest"]).splitlines()
if not lines or not lines[0].startswith("## DECISIONS"):
    fail("U97_R7_R8.md must open with '## DECISIONS'")
if len(lines) > 30:
    fail("U97_R7_R8.md is %d lines, 30 at most" % len(lines))

if fails:
    print("U97_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("U97_CHECK PASS violating room=%d real=%d" % (viol_room, viol_real))
