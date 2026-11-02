"""Q88 gate (Claude's): the engine's own rhythm, recomputed from the raw action times.

Exit 0 only when the JSON is complete, the population is legal and differentiated, and every
reported statistic is reproduced from the raw `bouts[].actions` rows by THIS script's own
definition (the one TASK_Q88 states). A number the raw rows cannot reproduce is a failure.
"""
import json
import math
import os
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
JSON_PATH = os.path.join(HERE, "Q88_engine_rhythm.json")
MD_PATH = os.path.join(HERE, "Q88_ENGINE_RHYTHM.md")
MERGES = ["0.3", "0.5", "1.0"]
TOL = 0.002
fails = []


def fail(msg):
    fails.append(msg)


def mean_sd(values):
    if not values:
        return 0.0, 0.0
    m = sum(values) / len(values)
    if len(values) < 2:
        return m, 0.0
    return m, math.sqrt(sum((v - m) ** 2 for v in values) / (len(values) - 1))


def periods_of(actions, merge_s):
    """actions: [[t_s, span_s, round], ...] sorted by t_s. Returns per-round lists of (start, end)."""
    by_round = {}
    for t, span, rnd in actions:
        by_round.setdefault(int(rnd), []).append((float(t), float(span)))
    out = {}
    for rnd, rows in by_round.items():
        rows.sort()
        periods = []
        start, end, last_t = rows[0][0], rows[0][0] + rows[0][1], rows[0][0]
        for t, span in rows[1:]:
            if t - last_t <= merge_s:
                end = max(end, t + span)
            else:
                periods.append((start, end))
                start, end = t, t + span
            last_t = t
        periods.append((start, end))
        out[rnd] = periods
    return out


if not os.path.exists(JSON_PATH):
    print("Q88_check FAIL: missing", JSON_PATH)
    sys.exit(1)
if not os.path.exists(MD_PATH):
    fail("missing Q88_ENGINE_RHYTHM.md")
else:
    md = open(MD_PATH, encoding="utf-8").read()
    if not md.lstrip().startswith("## DECISIONS"):
        fail("the markdown must open with '## DECISIONS'")
    for word in ("JPES", "0.3", "population"):
        if word.lower() not in md.lower():
            fail("the markdown never mentions '%s'" % word)

data = json.load(open(JSON_PATH, encoding="utf-8"))
pop = data.get("population", {})
fighters = pop.get("fighters", [])
if pop.get("ruleset") != "boxing":
    fail("population.ruleset must be 'boxing'")
if len(fighters) != 2:
    fail("population.fighters must list the two men")
else:
    a, b = fighters
    for key in ("name", "competition_weight_kg", "stats", "sex"):
        if key not in a or key not in b:
            fail("each fighter needs '%s'" % key)
    if a.get("stats") == b.get("stats") or not a.get("stats"):
        fail("NEVER TEST IDENTICAL FIGHTERS: the two stat blocks are equal or empty")
    if abs(float(a.get("competition_weight_kg", 0)) - float(b.get("competition_weight_kg", 99))) >= 1.0:
        fail("the two men are not in one weight class (>= 1 kg apart)")
    if a.get("sex") != b.get("sex"):
        fail("females never fight males")
if len(pop.get("seeds", [])) < 30:
    fail("at least 30 seeded bouts")
for key in ("rounds", "round_seconds", "hz", "catalogue"):
    if key not in pop:
        fail("population.%s missing (name the fixture AND the data it fights under)" % key)

bouts = data.get("bouts", [])
if len(bouts) != len(pop.get("seeds", [])):
    fail("bouts[] must hold one row per seed")
all_actions = 0
recomputed = {m: {"active": [], "inactive": [], "long": [], "rounds": 0, "actions": 0, "fight_s": 0.0} for m in MERGES}
for bout in bouts:
    actions = bout.get("actions", [])
    if not actions:
        fail("seed %s has no actions" % bout.get("seed"))
        continue
    rounds_fought = int(bout.get("rounds_fought", 0))
    if rounds_fought < 1:
        fail("seed %s: rounds_fought missing" % bout.get("seed"))
    for row in actions:
        if len(row) != 3 or float(row[1]) <= 0.0 or float(row[0]) < 0.0:
            fail("seed %s: an action row is not [t_s>=0, span_s>0, round]" % bout.get("seed"))
            break
    all_actions += len(actions)
    for m in MERGES:
        per_round = periods_of(actions, float(m))
        rec = recomputed[m]
        rec["rounds"] += rounds_fought
        rec["actions"] += len(actions)
        rec["fight_s"] += float(bout.get("fight_seconds", 0.0))
        for rnd, periods in per_round.items():
            for p in periods:
                rec["active"].append(p[1] - p[0])
            for i in range(1, len(periods)):
                gap = periods[i][0] - periods[i - 1][1]
                if gap > 0.0:
                    rec["inactive"].append(gap)
                    if gap > 4.0:
                        rec["long"].append(gap)

variants = data.get("variants", {})
for m in MERGES:
    v = variants.get(m)
    if v is None:
        fail("variants['%s'] missing" % m)
        continue
    rec = recomputed[m]
    am, asd = mean_sd(rec["active"])
    im, isd = mean_sd(rec["inactive"])
    lm, _ = mean_sd(rec["long"])
    want = {
        "active_mean_s": am, "active_sd_s": asd, "active_n": len(rec["active"]),
        "inactive_mean_s": im, "inactive_sd_s": isd, "inactive_n": len(rec["inactive"]),
        "long_inactive_mean_s": lm,
        "long_inactive_per_round": len(rec["long"]) / max(1, rec["rounds"]),
        "actions_per_minute": rec["actions"] / max(1e-9, rec["fight_s"] / 60.0),
    }
    for key, value in want.items():
        got = v.get(key)
        if got is None:
            fail("variants['%s'].%s missing" % (m, key))
        elif abs(float(got) - float(value)) > max(TOL, abs(value) * TOL):
            fail("variants['%s'].%s = %s, the raw rows give %.4f" % (m, key, got, value))
    if rec["fight_s"] <= 0.0:
        fail("bouts[].fight_seconds must be the seconds actually fought (rest excluded)")

if all_actions < 1000:
    fail("fewer than 1000 actions across the population - is the log being read?")

if fails:
    print("Q88_check FAIL (%d):" % len(fails))
    for f in fails[:40]:
        print("  -", f)
    sys.exit(1)
print("Q88_check PASS: %d bouts, %d actions, merges %s" % (len(bouts), all_actions, ", ".join(MERGES)))
sys.exit(0)
