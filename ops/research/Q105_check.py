"""Q105 gate (written by Claude, 2026-09-14). Run from the repo root: python research/Q105_check.py

Pins Qwen's hand-jump classification (TASK_Q105.md):
- seed 94301's counts equal Claude's tools/probe_hand_pop.gd on 4016a9e: production 2344 steps / 524 jumps, contact_off
  1936 / 508 (an independent instrument through the same production driving);
- every bout is the realism test's length (frames 19802 / 19802 / 19866), in both passes;
- causes and takes each add up to the jumps, in both passes; the production rows are exactly the production jumps;
- rows are physical: 0.30 < step_m < 3.0, and the moving hand's world step, its step relative to the hips and the hips'
  step obey the triangle inequality both ways;
- every row's cause is the one the task's ordered rules give from that row's own fields and native_p99_m;
- native_p99_m values are in (0, 0.6] m;
- the digest opens with DECISIONS and is at most 20 lines.
Never edit this file to pass. If it cannot pass: no commit, send BLOCKED."""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
R = os.path.join(ROOT, "research")
SEEDS = ["94301", "51227", "77003"]
FRAMES = {"94301": 19802, "51227": 19802, "77003": 19866}
PROBE = {"production": (2344, 524), "contact_off": (1936, 508)}
CAUSES = ["seek_start", "join", "warp", "body_move", "push", "clip_native", "unexplained"]
FIELDS = ["seed", "frame", "side", "step_m", "take", "take_pos", "prev_take", "take_started", "frames_into_take",
          "started_from", "start_pos", "seeked", "body_step_m", "hand_rel_step_m", "warp_changed", "push", "cause"]
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


try:
    data = json.load(open(os.path.join(R, "Q105_hand_steps.json"), encoding="utf-8"))
except Exception as exc:  # noqa: BLE001
    fail("Q105_hand_steps.json unreadable: %s" % exc)
    print("Q105_CHECK FAIL %d" % len(fails))
    sys.exit(1)

pop = data.get("population", {})
if [str(s) for s in pop.get("seeds", [])] != SEEDS or int(pop.get("rounds", 0)) != 3:
    fail("population must be seeds %s, 3 rounds: %s" % (SEEDS, pop))
if sorted(pop.get("passes", [])) != ["contact_off", "production"]:
    fail("population.passes must be production and contact_off: %s" % pop.get("passes"))
if "f01_m_box_welter" not in str(pop.get("fighters", "")) or "f09_m_bare_welter" not in str(pop.get("fighters", "")):
    fail("population must name both fighters: %s" % pop.get("fighters"))

passes = data.get("passes", {})
for name, (steps_94301, jumps_94301) in PROBE.items():
    ps = passes.get(name)
    if not isinstance(ps, dict):
        fail("passes.%s missing" % name)
        continue
    try:
        for s in SEEDS:
            if int(ps["frames"][s]) != FRAMES[s]:
                fail("%s frames[%s] %s != %d (the realism bouts)" % (name, s, ps["frames"][s], FRAMES[s]))
            if not (0 <= int(ps["jumps"][s]) <= int(ps["steps"][s])):
                fail("%s seed %s: jumps %s must be within steps %s" % (name, s, ps["jumps"][s], ps["steps"][s]))
        if int(ps["steps"]["94301"]) != steps_94301 or int(ps["jumps"]["94301"]) != jumps_94301:
            fail("%s seed 94301 steps/jumps %s/%s != Claude's probe %d/%d" % (
                name, ps["steps"]["94301"], ps["jumps"]["94301"], steps_94301, jumps_94301))
        total = sum(int(ps["jumps"][s]) for s in SEEDS)
        by_cause = ps["jumps_by_cause"]
        for k in by_cause:
            if k not in CAUSES:
                fail("%s jumps_by_cause has an unknown cause %s" % (name, k))
        if sum(int(v) for v in by_cause.values()) != total:
            fail("%s causes add to %d, jumps are %d" % (name, sum(int(v) for v in by_cause.values()), total))
        if sum(int(v) for v in ps["jumps_by_take"].values()) != total:
            fail("%s takes add to %d, jumps are %d" % (name, sum(int(v) for v in ps["jumps_by_take"].values()), total))
    except (KeyError, TypeError, ValueError) as exc:
        fail("passes.%s incomplete: %r" % (name, exc))

native = data.get("native_p99_m", {})
for take, value in native.items():
    if not (0.0 < float(value) <= 0.6):
        fail("native_p99_m[%s] = %s is outside (0, 0.6] m" % (take, value))
if not native:
    fail("native_p99_m is empty")


def expected_cause(r):
    if bool(r["seeked"]) and int(r["frames_into_take"]) <= 2:
        return "seek_start"
    if int(r["frames_into_take"]) / 30.0 <= 0.27 + 1e-9 and str(r["started_from"]) != "":
        return "join"
    if bool(r["warp_changed"]) and float(r["body_step_m"]) > 0.05:
        return "warp"
    if float(r["body_step_m"]) >= 0.5 * float(r["step_m"]):
        return "body_move"
    nat = native.get(str(r["take"]))
    if bool(r["push"]) and (nat is None or float(r["hand_rel_step_m"]) > 1.2 * float(nat)):
        return "push"
    if nat is not None and float(r["hand_rel_step_m"]) <= 1.2 * float(nat):
        return "clip_native"
    return "unexplained"


rows = data.get("rows", [])
prod = passes.get("production", {})
try:
    prod_total = sum(int(prod["jumps"][s]) for s in SEEDS)
    if len(rows) != prod_total:
        fail("rows %d != production jumps %d" % (len(rows), prod_total))
except (KeyError, TypeError, ValueError):
    pass
counted = {}
bad_fields = bad_phys = bad_cause = 0
for i, r in enumerate(rows):
    missing = [f for f in FIELDS if f not in r]
    if missing:
        bad_fields += 1
        if bad_fields <= 3:
            fail("row %d lacks %s" % (i, missing))
        continue
    step, rel, body = float(r["step_m"]), float(r["hand_rel_step_m"]), float(r["body_step_m"])
    if not (0.30 < step < 3.0) or step > rel + body + 0.001 or rel > step + body + 0.001:
        bad_phys += 1
        if bad_phys <= 3:
            fail("row %d not physical: step %.3f rel %.3f body %.3f" % (i, step, rel, body))
    want = expected_cause(r)
    if str(r["cause"]) != want:
        bad_cause += 1
        if bad_cause <= 5:
            fail("row %d (seed %s f%s %s %s) cause %s, the rules give %s" % (
                i, r["seed"], r["frame"], r["side"], r["take"], r["cause"], want))
    counted[str(r["cause"])] = counted.get(str(r["cause"]), 0) + 1
if bad_fields or bad_phys or bad_cause:
    print("INFO rows with missing fields %d, unphysical %d, wrong cause %d" % (bad_fields, bad_phys, bad_cause))
try:
    declared = {k: int(v) for k, v in prod["jumps_by_cause"].items() if int(v) > 0}
    if counted and declared != counted:
        fail("production jumps_by_cause %s != the rows' causes %s" % (declared, counted))
except (KeyError, TypeError, ValueError):
    pass

try:
    lines = open(os.path.join(R, "Q105_HAND_STEPS.md"), encoding="utf-8").read().splitlines()
    body_lines = [l for l in lines if l.strip()]
    if not body_lines or body_lines[0].strip() != "## DECISIONS":
        fail("Q105_HAND_STEPS.md must open with ## DECISIONS")
    if len(lines) > 20:
        fail("Q105_HAND_STEPS.md is %d lines (20 at most)" % len(lines))
except FileNotFoundError:
    fail("Q105_HAND_STEPS.md missing")

if fails:
    print("Q105_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("Q105_CHECK PASS rows=%d production=%s contact_off=%s" % (
    len(rows), prod.get("jumps_by_cause"), passes.get("contact_off", {}).get("jumps_by_cause")))
