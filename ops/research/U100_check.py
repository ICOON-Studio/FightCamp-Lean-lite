"""U100 gate (written by Claude, 2026-09-14). Run from the repo root: python research/U100_check.py

Pins Cursor's contact-push easing sweep (TASK_U100.md):
- the room reads the two knobs from configure's options with 0.0 defaults; the census tool and the realism test pass them;
- U99's committed census record (the tool's default output path) is untouched, and no source names the reference file;
- the six variants carry exactly the task's knob values;
- V0 reproduces Claude's independent run on 3fedec4 - census frame counts and hand p95/p99 within 1% of
  research/S4A_SMOOTH/jerk_3fedec4.json; R7 violating frames 1700 / 1704 / 1357; R4 1008 of 1070; R8 122 of 551; the
  same RULE verdicts;
- every census row is physical (0 < p50 <= p95 <= p99 <= max), and each of V1-V5 moves a hand p95 by more than 0.5% from
  V0 (an eased push that is not carried across frames changes nothing);
- `recommended` is the variant the task's rule picks, recomputed here;
- the digest opens with DECISIONS, is at most 20 lines and names the recommended variant.
Never edit this file to pass. If it cannot pass: no commit, send BLOCKED."""
import json
import os
import re
import subprocess
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
G = os.path.join(ROOT, "Godot")
R = os.path.join(G, "research")
SEEDS = ["94301", "51227", "77003"]
POINTS = ["Head", "Chest", "Hip", "LeftHand", "RightHand", "LeftFoot", "RightFoot"]
KNOBS = {"V0": (0.0, 0.0), "V1": (0.0, 0.05), "V2": (0.0, 0.10), "V3": (0.0, 0.20), "V4": (0.03, 0.10), "V5": (0.06, 0.10)}
V0_R7 = {"94301": 1700, "51227": 1704, "77003": 1357}
V0_VERDICTS = {"R1": "FAIL", "R2": "FAIL", "R2b": "PASS", "R3": "FAIL", "R3b": "PASS", "R4": "PASS", "R5": "FAIL",
               "R5b": "FAIL", "R7": "FAIL", "R8": "FAIL"}
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


def read(rel):
    with open(os.path.join(ROOT, rel), encoding="utf-8", errors="replace") as f:
        return f.read()


# ---- wiring -------------------------------------------------------------------------------------------------------
room = read("Godot/scripts/FightWorldLiveScreen.gd")
for decl in ("var _push_attack_s: float = 0.0", "var _push_release_s: float = 0.0"):
    if decl not in room:
        fail("FightWorldLiveScreen.gd lacks `%s` (both knobs default 0.0)" % decl)
for key in ("push_attack_s", "push_release_s"):
    if not re.search(r'options\.get\(\s*"%s"' % key, room):
        fail("FightWorldLiveScreen.configure does not read options[\"%s\"]" % key)
if not re.search(r"func _solve_contacts\(\s*\w+", room):
    fail("_solve_contacts takes no delta argument")
jerk_src = read("Godot/tools/measure_jerk.gd")
test_src = read("Godot/tests/fight_stage_realism_test.gd")
for name, src in (("measure_jerk.gd", jerk_src), ("fight_stage_realism_test.gd", test_src)):
    for arg in ("push_attack=", "push_release="):
        if arg not in src:
            fail("%s does not accept `-- %s`" % (name, arg))
    for key in ("push_attack_s", "push_release_s"):
        if key not in src:
            fail("%s never passes the `%s` option" % (name, key))
    if "jerk_3fedec4" in src:
        fail("%s names the reference census - a tool that can read its reference will copy it" % name)
if "out=" not in jerk_src:
    fail("measure_jerk.gd does not accept `out=`")
diff = subprocess.run(["git", "diff", "--quiet", "HEAD", "--", "research/U99_jerk.json"], cwd=ROOT)
if diff.returncode != 0:
    fail("research/U99_jerk.json changed - every sweep run must pass out=")

# ---- the record ---------------------------------------------------------------------------------------------------
try:
    data = json.load(open(os.path.join(R, "U100_push_ease.json"), encoding="utf-8"))
except Exception as exc:  # noqa: BLE001
    fail("U100_push_ease.json unreadable: %s" % exc)
    print("U100_CHECK FAIL %d" % len(fails))
    sys.exit(1)
ref = json.load(open(os.path.join(R, "S4A_SMOOTH", "jerk_3fedec4.json"), encoding="utf-8"))

pop = data.get("population", {})
if [str(s) for s in pop.get("seeds", [])] != SEEDS or int(pop.get("rounds", 0)) != 3:
    fail("population must be seeds %s, 3 rounds: %s" % (SEEDS, pop))
if "f01_m_box_welter" not in str(pop.get("fighters", "")) or "f09_m_bare_welter" not in str(pop.get("fighters", "")):
    fail("population must name both fighters: %s" % pop.get("fighters"))

variants = {str(v.get("name")): v for v in data.get("variants", [])}
if sorted(variants) != sorted(KNOBS):
    fail("variants must be exactly %s, got %s" % (sorted(KNOBS), sorted(variants)))


def hands_p95(v):
    bp = v["census"]["by_point"]
    return float(bp["LeftHand"]["p95"]) + float(bp["RightHand"]["p95"])


def r7_total(v):
    return sum(int(v["realism"]["R7_violating_frames"][s]) for s in SEEDS)


ok_rows = True
for name, (attack, release) in KNOBS.items():
    v = variants.get(name)
    if v is None:
        ok_rows = False
        continue
    if abs(float(v.get("push_attack_s", -1)) - attack) > 1e-9 or abs(float(v.get("push_release_s", -1)) - release) > 1e-9:
        fail("%s knobs must be attack %.2f release %.2f: %s / %s" % (name, attack, release, v.get("push_attack_s"), v.get("push_release_s")))
    try:
        census = v["census"]
        for s in SEEDS:
            if int(census["frames"][s]) != int(ref["frames"][s]):
                fail("%s census frames[%s] %s != %s (the realism bouts)" % (name, s, census["frames"][s], ref["frames"][s]))
        for p in POINTS:
            row = census["by_point"][p]
            q = [float(row[k]) for k in ("p50", "p95", "p99", "max")]
            if not (0.0 < q[0] <= q[1] <= q[2] <= q[3]):
                fail("%s %s is not physical (0 < p50 <= p95 <= p99 <= max): %s" % (name, p, q))
        share = float(census["contact_push_share_of_top1pct"])
        if not (0.0 <= share <= 1.0):
            fail("%s contact_push_share_of_top1pct %s is not a share in [0, 1]" % (name, share))
        real = v["realism"]
        for key in ("R8_reached", "R8_landed", "R4_pass", "R4_exits"):
            int(real[key])
        float(real["R3_mean_mps"])
        for rule in V0_VERDICTS:
            if str(real["verdicts"].get(rule, "")) not in ("PASS", "FAIL"):
                fail("%s verdicts lack %s" % (name, rule))
        r7_total(v)
    except (KeyError, TypeError, ValueError) as exc:
        ok_rows = False
        fail("%s row incomplete: %r" % (name, exc))

if ok_rows and "V0" in variants:
    v0 = variants["V0"]
    for p in ("LeftHand", "RightHand"):
        for k in ("p95", "p99"):
            mine, theirs = float(v0["census"]["by_point"][p][k]), float(ref["by_point"][p][k])
            if abs(mine - theirs) > 0.01 * theirs:
                fail("V0 census %s %s %.1f is not Claude's 3fedec4 run %.1f (1%%) - V0 is not today's room" % (p, k, mine, theirs))
    real0 = v0["realism"]
    for s in SEEDS:
        if int(real0["R7_violating_frames"][s]) != V0_R7[s]:
            fail("V0 R7 violating frames[%s] %s != %d (Claude's subset run on 3fedec4)" % (s, real0["R7_violating_frames"][s], V0_R7[s]))
    if (int(real0["R4_pass"]), int(real0["R4_exits"])) != (1008, 1070):
        fail("V0 R4 %s of %s != 1008 of 1070" % (real0["R4_pass"], real0["R4_exits"]))
    if (int(real0["R8_reached"]), int(real0["R8_landed"])) != (122, 551):
        fail("V0 R8 %s of %s != 122 of 551" % (real0["R8_reached"], real0["R8_landed"]))
    for rule, verdict in V0_VERDICTS.items():
        if str(real0["verdicts"].get(rule)) != verdict:
            fail("V0 %s verdict %s != %s" % (rule, real0["verdicts"].get(rule), verdict))
    base = hands_p95(v0)
    for name in ("V1", "V2", "V3", "V4", "V5"):
        v = variants[name]
        moved = max(abs(float(v["census"]["by_point"][p]["p95"]) - float(v0["census"]["by_point"][p]["p95"]))
                    / float(v0["census"]["by_point"][p]["p95"]) for p in ("LeftHand", "RightHand"))
        if moved <= 0.005:
            fail("%s moves no hand p95 by more than 0.5%% from V0 - the eased push is not carried across frames" % name)
    # the task's rule, recomputed
    r7_cap = 1.10 * r7_total(v0)
    r3_cap = float(v0["realism"]["R3_mean_mps"]) + 0.005
    eligible = [n for n, v in variants.items()
                if r7_total(v) <= r7_cap and str(v["realism"]["verdicts"].get("R4")) == "PASS"
                and float(v["realism"]["R3_mean_mps"]) <= r3_cap + 1e-9]
    want = min(eligible, key=lambda n: (hands_p95(variants[n]), n)) if eligible else None
    if str(data.get("recommended")) != str(want):
        fail("recommended %s, the task's rule picks %s (eligible %s)" % (data.get("recommended"), want, eligible))
    print("INFO hands p95 sum: " + ", ".join("%s %.0f" % (n, hands_p95(variants[n])) for n in sorted(variants)))
    print("INFO R7 totals: " + ", ".join("%s %d" % (n, r7_total(variants[n])) for n in sorted(variants)))

# ---- the digest ---------------------------------------------------------------------------------------------------
try:
    lines = read("research/U100_PUSH_EASE.md").splitlines()
    body = [l for l in lines if l.strip()]
    if not body or body[0].strip() != "## DECISIONS":
        fail("U100_PUSH_EASE.md must open with ## DECISIONS")
    if len(lines) > 20:
        fail("U100_PUSH_EASE.md is %d lines (20 at most)" % len(lines))
    if data.get("recommended") and str(data["recommended"]) not in "\n".join(lines):
        fail("the digest never names the recommended variant %s" % data["recommended"])
except FileNotFoundError:
    fail("U100_PUSH_EASE.md missing")

if fails:
    print("U100_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("U100_CHECK PASS variants=%d recommended=%s" % (len(variants), data.get("recommended")))
