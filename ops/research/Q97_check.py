"""Q97 gate (written by Claude before launch). Run from the repo root: python research/Q97_check.py

C113 found that at a striking take's contact time the hand is typically 0.43-0.48 m from the receiver's Head bone, so
most punches end 10-30 cm short of the face. Before choosing a fix (close the range, turn the thrower, raise the
fist, or change the contact time) Q97 splits that miss into the thrower's forward, lateral and vertical axes, and
finds the closest the hand gets during the whole take. Nothing here trusts the tool's arithmetic:
- Pythagoras: forward^2 + lateral^2 + vertical^2 must equal hand_to_target^2 on every row (1 mm);
- the closest approach is a minimum over the take's frames, which include the contact frame, so it can never exceed
  the contact distance, and its time must lie inside the take;
- the population is C113's; per-role counts must equal C113's merged production counts (same engine, same room);
- every summary is recomputed from the rows.
"""
import json
import math
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GODOT = ROOT / "Godot"
TOOL = GODOT / "tools" / "measure_contact_miss.gd"
JSON_PATH = GODOT / "research" / "Q97_contact_miss.json"
MD_PATH = GODOT / "research" / "Q97_CONTACT_MISS.md"
C113 = GODOT / "research" / "C113_contact_clearance.json"
COLUMNS = ["seed", "frame", "side", "take", "role", "contact_s", "take_length_s", "gap_m", "hand", "hand_to_target_m",
           "forward_m", "lateral_m", "vertical_m", "closest_m", "closest_offset_s", "target_bone"]
STATS = ["hand_to_target_m", "forward_m", "lateral_m", "vertical_m", "closest_m", "closest_offset_s"]

failures = []


def fail(msg):
    failures.append(msg)
    print("FAIL:", msg)


def pct(values, p):
    ordered = sorted(values)
    if not ordered:
        return 0.0
    k = (len(ordered) - 1) * p / 100.0
    lo = int(k)
    hi = min(lo + 1, len(ordered) - 1)
    return ordered[lo] + (ordered[hi] - ordered[lo]) * (k - lo)


def main():
    for p in (TOOL, JSON_PATH, MD_PATH, C113):
        if not p.is_file():
            fail("missing %s" % p.relative_to(ROOT))
    if failures:
        return finish()
    tool = TOOL.read_text(encoding="utf-8")
    for banned in ("C113_contact_clearance.json", "probe_take_skate", "BAKEOFF_"):
        if banned in tool:
            fail("the tool names %s - it must measure, not read" % banned)
    for needed in ("FightWorldLive.tscn", "_contact_s", "get_bone_pose", "Q97_contact_miss.json"):
        if needed not in tool:
            fail("the tool does not contain %r" % needed)
    c113 = json.loads(C113.read_text(encoding="utf-8"))
    c113_counts = {}
    for r in c113["contacts"]:
        if r[0] == "production":
            c113_counts[r[5]] = c113_counts.get(r[5], 0) + 1
    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    pop = data.get("population", {})
    if pop.get("seeds") != c113["population"]["seeds"] or int(pop.get("rounds", 0)) != 3:
        fail("population must be C113's: seeds %s, 3 rounds" % c113["population"]["seeds"])
    if data.get("columns") != COLUMNS:
        fail("columns must be exactly %s" % COLUMNS)
        return finish()
    rows = data.get("contacts", [])
    by_role = {}
    for r in rows:
        if len(r) != len(COLUMNS):
            fail("malformed row %s" % r)
            return finish()
        rec = dict(zip(COLUMNS, r))
        d = float(rec["hand_to_target_m"])
        comp = math.sqrt(float(rec["forward_m"]) ** 2 + float(rec["lateral_m"]) ** 2 + float(rec["vertical_m"]) ** 2)
        if abs(comp - d) > 0.001:
            fail("PYTHAGORAS: components give %.4f m, hand_to_target is %.4f m (%s)" % (comp, d, r))
        if float(rec["closest_m"]) > d + 1e-6:
            fail("closest %.4f m exceeds the contact distance %.4f m - a minimum over frames that include the contact "
                 "frame cannot (%s)" % (float(rec["closest_m"]), d, r))
        t_closest = float(rec["contact_s"]) + float(rec["closest_offset_s"])
        if not -0.034 <= t_closest <= float(rec["take_length_s"]) + 0.034:
            fail("closest approach at %.3f s lies outside the take (length %.3f s): %s"
                 % (t_closest, float(rec["take_length_s"]), r))
        if rec["hand"] not in ("LeftHand", "RightHand"):
            fail("hand must be LeftHand or RightHand: %s" % r)
        expected_bone = "Chest" if rec["role"] == "strike_body" else "Head"
        if rec["target_bone"] != expected_bone:
            fail("role %s must aim at %s" % (rec["role"], expected_bone))
        by_role.setdefault(rec["role"], []).append(rec)
    for role, n in c113_counts.items():
        if len(by_role.get(role, [])) != n:
            fail("role %s: %d contacts, C113's production had %d on the same engine and room"
                 % (role, len(by_role.get(role, [])), n))
    summary = data.get("summary", {})
    for role, recs in by_role.items():
        s = summary.get(role)
        if s is None:
            fail("summary.%s missing" % role)
            continue
        if int(s.get("n", -1)) != len(recs):
            fail("summary.%s.n != rows" % role)
        for key in STATS:
            values = [float(x[key]) for x in recs]
            p50 = s.get(key, {}).get("p50") if isinstance(s.get(key), dict) else None
            if p50 is None or abs(float(p50) - pct(values, 50)) > 0.002:
                fail("summary.%s.%s.p50 %s != %.4f from the rows" % (role, key, p50, pct(values, 50)))
    md = MD_PATH.read_text(encoding="utf-8").splitlines()
    if next((l for l in md if l.strip()), "").strip() != "## DECISIONS":
        fail("the digest does not open with ## DECISIONS")
    if len(md) > 30:
        fail("the digest is %d lines, 30 at most" % len(md))
    return finish()


def finish():
    if failures:
        print("Q97_check: %d failure(s)" % len(failures))
        sys.exit(1)
    print("Q97_check: PASS")
    sys.exit(0)


if __name__ == "__main__":
    main()
