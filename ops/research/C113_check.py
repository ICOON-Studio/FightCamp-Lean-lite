"""C113 gate (written by Claude before launch). Run from the repo root: python research/C113_check.py

C113 measures WHERE A PUNCH ENDS relative to the man it is thrown at, in the live room: at each striking take's
contact time, the distance from the striking hand to the receiver's target bone. S4a carried the strikers' hip sway
on 2026-09-14 (087a3c9) and hand reach from the body grew (jab 0.82 -> 1.03 m, hooks 0.65 -> 0.99 m on a still
body), so range must now follow the take. Nothing here trusts the tool's summaries:
- every summary is recomputed from the contact rows;
- the engine decides which strikes happen, and the hip carry is presentation only, so both variants must present
  the SAME strikes: per-role counts equal between `production` and `receivers`;
- physics: a hand is never a negative distance from anything, a pair's gap is never below 0.3 m, and a hand cannot
  be farther from the target than the gap plus 2 m of arm and lean;
- the striking roles are read from FightStagePlayer.STRIKER_SWAY_ROLES here, not typed.
"""
import json
import re
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]
GODOT = ROOT / "Godot"
TOOL = GODOT / "tools" / "measure_contact_clearance.gd"
JSON_PATH = GODOT / "research" / "C113_contact_clearance.json"
MD_PATH = GODOT / "research" / "C113_CONTACT_CLEARANCE.md"
PLAYER = GODOT / "scripts" / "FightStagePlayer.gd"
COLUMNS = ["variant", "seed", "frame", "side", "take", "role", "contact_s", "gap_m", "hand_to_target_m", "target_bone"]
SEEDS = [94301, 51227, 77003]

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


def near(a, b, tol=0.002):
    return abs(float(a) - float(b)) <= tol


def striker_roles():
    text = PLAYER.read_text(encoding="utf-8")
    m = re.search(r"const\s+STRIKER_SWAY_ROLES\s*:=\s*\[([^\]]*)\]", text, re.S)
    if not m:
        fail("FightStagePlayer.gd no longer declares STRIKER_SWAY_ROLES")
        return []
    return re.findall(r'"([^"]+)"', m.group(1))


def main():
    for p in (TOOL, JSON_PATH, MD_PATH, PLAYER):
        if not p.is_file():
            fail("missing %s" % p.relative_to(ROOT))
    if failures:
        return finish()
    tool = TOOL.read_text(encoding="utf-8")
    for needed in ("FightWorldLive.tscn", "_contact_s", "STRIKER_SWAY_ROLES", "RECEIVER_SWAY_ROLES",
                   "C113_contact_clearance.json", "get_bone_pose"):
        if needed not in tool:
            fail("the tool does not contain %r" % needed)
    for banned in ("probe_take_skate", "BAKEOFF_", "C112_live_frames"):
        if banned in tool:
            fail("the tool names %s - it must measure, not read" % banned)
    roles = striker_roles()
    data = json.loads(JSON_PATH.read_text(encoding="utf-8"))
    pop = data.get("population", {})
    if sorted(int(s) for s in pop.get("seeds", [])) != sorted(SEEDS):
        fail("population.seeds must be the realism test's %s" % SEEDS)
    if int(pop.get("rounds", 0)) != 3:
        fail("population.rounds must be 3 (the realism test's)")
    if sorted(pop.get("striker_roles", [])) != sorted(roles):
        fail("population.striker_roles %s != FightStagePlayer.STRIKER_SWAY_ROLES %s" % (pop.get("striker_roles"), roles))
    fighters = pop.get("fighters", [])
    if len(fighters) != 2 or fighters[0] == fighters[1]:
        fail("population.fighters must name two different men: %s" % fighters)
    if data.get("columns") != COLUMNS:
        fail("columns must be exactly %s" % COLUMNS)
        return finish()
    rows = data.get("contacts", [])
    if len(rows) < 50:
        fail("only %d contact rows" % len(rows))
        return finish()
    by = {}
    for r in rows:
        if len(r) != len(COLUMNS):
            fail("malformed row %s" % r)
            return finish()
        variant, seed, frame, side, take, role, contact_s, gap, dist, bone = r
        if variant not in ("production", "receivers"):
            fail("unknown variant %r" % variant)
        if role not in roles:
            fail("row role %r is not a striking role" % role)
        if str(take).split("#")[0] != role:
            fail("row take %r does not belong to role %r" % (take, role))
        if int(seed) not in SEEDS or side not in ("a", "b"):
            fail("row seed/side out of population: %s" % r)
        if not 0.3 <= float(gap) <= 3.0:
            fail("PHYSICS: gap %.3f m at a contact (%s)" % (float(gap), r))
        if not 0.0 <= float(dist) <= float(gap) + 2.0:
            fail("PHYSICS: hand %.3f m from the target with a gap of %.3f m (%s)" % (float(dist), float(gap), r))
        if role == "strike_leg":
            fail("strike_leg has no head or chest target - the tool must skip it and count it in summary.skipped")
        expected_bone = "Chest" if role == "strike_body" else "Head"
        if bone != expected_bone:
            fail("role %s must aim at %s, row says %s" % (role, expected_bone, bone))
        by.setdefault(variant, {}).setdefault(role, []).append(float(dist))
    for role in set(list(by.get("production", {}).keys()) + list(by.get("receivers", {}).keys())):
        n_p = len(by.get("production", {}).get(role, []))
        n_r = len(by.get("receivers", {}).get(role, []))
        if n_p != n_r:
            fail("role %s: production presents %d contacts, receivers %d - the engine decides strikes, so they must match"
                 % (role, n_p, n_r))
    summary = data.get("summary", {})
    for variant, per_role in by.items():
        for role, values in per_role.items():
            s = summary.get(variant, {}).get(role)
            if s is None:
                fail("summary.%s.%s missing" % (variant, role))
                continue
            if int(s.get("n", -1)) != len(values):
                fail("summary.%s.%s.n != its rows" % (variant, role))
            for key, p in (("p10", 10), ("p50", 50), ("p90", 90)):
                if not near(s.get(key, -99), pct(values, p)):
                    fail("summary.%s.%s.%s %s != %.4f from the rows" % (variant, role, key, s.get(key), pct(values, p)))
            if not near(s.get("mean", -99), sum(values) / len(values)):
                fail("summary.%s.%s.mean != the rows' mean" % (variant, role))
    md = MD_PATH.read_text(encoding="utf-8").splitlines()
    if next((l for l in md if l.strip()), "").strip() != "## DECISIONS":
        fail("the digest does not open with ## DECISIONS")
    if len(md) > 30:
        fail("the digest is %d lines, 30 at most" % len(md))
    return finish()


def finish():
    if failures:
        print("C113_check: %d failure(s)" % len(failures))
        sys.exit(1)
    print("C113_check: PASS")
    sys.exit(0)


if __name__ == "__main__":
    main()
