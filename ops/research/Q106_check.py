"""Q106 gate (written by Claude, 2026-09-14). Run from the repo root: python research/Q106_check.py

Pins Qwen's isolated-spike census (TASK_Q106.md):
- seed 94301 equals Claude's tools/probe_spikes.gd point by point and take by take in production, contact_off and
  push_release_0.20, and in total / LeftHand / jab / cross for contact_off_warp_off (an independent instrument through the
  same production driving);
- every bout is the realism length (frames 19801 / 19801 / 19865 counted before FIGHT OVER), in every pass;
- by_point and by_take each add up to the spikes, per seed; totals are the sums over seeds;
- every top row obeys the spike rule from its own numbers (step > 8 cm and > 2.5x the larger neighbour), rows are sorted
  largest first and number at most 40;
- the digest opens with DECISIONS and is at most 20 lines.
Never edit this file to pass. If it cannot pass: no commit, send BLOCKED."""
import json
import os
import sys

ROOT = os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
R = os.path.join(ROOT, "research")
SEEDS = ["94301", "51227", "77003"]
FRAMES = {"94301": 19801, "51227": 19801, "77003": 19865}
PASSES = ["production", "contact_off", "push_release_0.20", "contact_off_warp_off"]
PROBE = {
    "production": {
        "spikes": 351,
        "by_point": {"Head": 12, "Hips": 12, "LeftFoot": 16, "LeftHand": 256, "RightFoot": 7, "RightHand": 48},
        "by_take": {"block": 2, "cross": 38, "hook_lead": 28, "hook_rear": 8, "idle": 41, "jab": 158, "react_body": 15,
                    "react_head": 39, "slip": 11, "strike_body": 11},
    },
    "contact_off": {
        "spikes": 211,
        "by_point": {"Head": 12, "Hips": 12, "LeftFoot": 16, "LeftHand": 145, "RightFoot": 7, "RightHand": 19},
        "by_take": {"block": 2, "cross": 20, "hook_lead": 1, "hook_rear": 1, "jab": 140, "react_body": 12, "react_head": 21,
                    "slip": 5, "strike_body": 9},
    },
    "push_release_0.20": {
        "spikes": 334,
        "by_point": {"Head": 12, "Hips": 12, "LeftFoot": 16, "LeftHand": 248, "RightFoot": 7, "RightHand": 39},
        "by_take": {"block": 2, "cross": 27, "hook_lead": 14, "hook_rear": 8, "idle": 78, "jab": 145, "react_body": 14,
                    "react_head": 23, "slip": 10, "strike_body": 13},
    },
}
WARP_OFF = {"spikes": 190, "LeftHand": 146, "jab": 130, "cross": 11}
OPTIONS = {"production": {}, "contact_off": {"contact_solve": False}, "push_release_0.20": {"push_release_s": 0.2},
           "contact_off_warp_off": {"contact_solve": False, "strike_warp": False}}
fails = []


def fail(msg):
    fails.append(msg)
    print("FAIL " + msg)


try:
    data = json.load(open(os.path.join(R, "Q106_spikes.json"), encoding="utf-8"))
except Exception as exc:  # noqa: BLE001
    fail("Q106_spikes.json unreadable: %s" % exc)
    print("Q106_CHECK FAIL %d" % len(fails))
    sys.exit(1)

pop = data.get("population", {})
if [str(s) for s in pop.get("seeds", [])] != SEEDS or int(pop.get("rounds", 0)) != 3:
    fail("population must be seeds %s, 3 rounds: %s" % (SEEDS, pop))
rule = data.get("rule", {})
if abs(float(rule.get("min_m", -1)) - 0.08) > 1e-9 or abs(float(rule.get("ratio", -1)) - 2.5) > 1e-9:
    fail("rule must be min_m 0.08, ratio 2.5: %s" % rule)

passes = data.get("passes", {})
if sorted(passes) != sorted(PASSES):
    fail("passes must be exactly %s, got %s" % (PASSES, sorted(passes)))


def nonzero(d):
    return {str(k): int(v) for k, v in d.items() if int(v) != 0}


for name in PASSES:
    ps = passes.get(name)
    if not isinstance(ps, dict):
        continue
    opts = ps.get("options", {})
    for key, value in OPTIONS[name].items():
        if key not in opts or (isinstance(value, bool) and bool(opts[key]) != value) or (
                not isinstance(value, bool) and abs(float(opts[key]) - float(value)) > 1e-9):
            fail("%s options must carry %s=%s: %s" % (name, key, value, opts))
    total_spikes = 0
    total_point = {}
    total_take = {}
    try:
        for s in SEEDS:
            row = ps["seeds"][s]
            if int(row["frames"]) != FRAMES[s]:
                fail("%s seed %s frames %s != %d" % (name, s, row["frames"], FRAMES[s]))
            spikes = int(row["spikes"])
            if sum(int(v) for v in row["by_point"].values()) != spikes:
                fail("%s seed %s by_point adds to %d, spikes %d" % (name, s, sum(int(v) for v in row["by_point"].values()), spikes))
            if sum(int(v) for v in row["by_take"].values()) != spikes:
                fail("%s seed %s by_take adds to %d, spikes %d" % (name, s, sum(int(v) for v in row["by_take"].values()), spikes))
            total_spikes += spikes
            for k, v in row["by_point"].items():
                total_point[k] = total_point.get(k, 0) + int(v)
            for k, v in row["by_take"].items():
                total_take[k] = total_take.get(k, 0) + int(v)
            top = row["top"]
            if len(top) > 40:
                fail("%s seed %s top has %d rows (40 at most)" % (name, s, len(top)))
            prev_step = float("inf")
            for i, t in enumerate(top):
                step, before, after = float(t["step_cm"]), float(t["before_cm"]), float(t["after_cm"])
                if not (step > 8.0 and step > 2.5 * max(before, after)):
                    fail("%s seed %s top[%d] breaks the spike rule: %.1f (before %.1f after %.1f)" % (name, s, i, step, before, after))
                    break
                if step > prev_step + 1e-6:
                    fail("%s seed %s top is not sorted largest first at row %d" % (name, s, i))
                    break
                prev_step = step
                for field in ("frame", "side", "point", "take", "pos", "prev_take", "push", "warp_changed"):
                    if field not in t:
                        fail("%s seed %s top[%d] lacks %s" % (name, s, i, field))
                        break
        totals = ps["totals"]
        if int(totals["spikes"]) != total_spikes:
            fail("%s totals.spikes %s != the seeds' sum %d" % (name, totals["spikes"], total_spikes))
        if nonzero(totals["by_point"]) != nonzero(total_point):
            fail("%s totals.by_point is not the seeds' sum" % name)
        if nonzero(totals["by_take"]) != nonzero(total_take):
            fail("%s totals.by_take is not the seeds' sum" % name)
        seed0 = ps["seeds"]["94301"]
        if name in PROBE:
            want = PROBE[name]
            if int(seed0["spikes"]) != want["spikes"]:
                fail("%s seed 94301 spikes %s != Claude's probe %d" % (name, seed0["spikes"], want["spikes"]))
            if nonzero(seed0["by_point"]) != want["by_point"]:
                fail("%s seed 94301 by_point %s != probe %s" % (name, nonzero(seed0["by_point"]), want["by_point"]))
            if nonzero(seed0["by_take"]) != want["by_take"]:
                fail("%s seed 94301 by_take %s != probe %s" % (name, nonzero(seed0["by_take"]), want["by_take"]))
        else:
            got = (int(seed0["spikes"]), int(seed0["by_point"].get("LeftHand", 0)), int(seed0["by_take"].get("jab", 0)),
                   int(seed0["by_take"].get("cross", 0)))
            want = (WARP_OFF["spikes"], WARP_OFF["LeftHand"], WARP_OFF["jab"], WARP_OFF["cross"])
            if got != want:
                fail("%s seed 94301 (spikes, LeftHand, jab, cross) %s != probe %s" % (name, got, want))
    except (KeyError, TypeError, ValueError) as exc:
        fail("%s incomplete: %r" % (name, exc))

try:
    lines = open(os.path.join(R, "Q106_SPIKES.md"), encoding="utf-8").read().splitlines()
    body = [l for l in lines if l.strip()]
    if not body or body[0].strip() != "## DECISIONS":
        fail("Q106_SPIKES.md must open with ## DECISIONS")
    if len(lines) > 20:
        fail("Q106_SPIKES.md is %d lines (20 at most)" % len(lines))
except FileNotFoundError:
    fail("Q106_SPIKES.md missing")

if fails:
    print("Q106_CHECK FAIL %d" % len(fails))
    sys.exit(1)
print("Q106_CHECK PASS " + ", ".join("%s %s" % (n, passes[n]["totals"]["spikes"]) for n in PASSES))
