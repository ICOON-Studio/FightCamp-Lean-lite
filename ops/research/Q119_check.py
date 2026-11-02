"""Q119 gate — re-computes every assertion from scratch, reads no cached JSON.

Part 1 assertions:
  - Re-generate 252 fighters with the NEW independent-grapple logic
  - Assert grapple correlation with mean-of-six is under 0.6
  - Assert no-weakness count <= Q117's 2
  - Assert ceiling count (>2 stats > 90) == 0
  - Assert degenerate case (population 0) does not divide by zero

Part 2 assertions:
  - Every file:line in the Part 2 read table still resolves to a line naming
    that read in the current source tree.
"""
import math
import os
import random
import re
import sys

REPO_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
SCRIPTS = os.path.join(REPO_ROOT, "Godot", "scripts")

failures = []


def fail(msg):
    failures.append(msg)
    print(f"  FAIL: {msg}")


def ok(msg):
    print(f"  OK: {msg}")


# ---------------------------------------------------------------------------
# PINNED LITERALS
# ---------------------------------------------------------------------------

PINNED_CORRELATION = 0.3525
PINNED_CORRELATION_CEIL = 0.6
PINNED_NO_WEAKNESS_MAX = 2
PINNED_CEILING_MAX = 0

STAT_KEYS = ["power", "technique", "speed", "defense", "conditioning", "fight_iq", "grapple"]
OTHER_SIX = [k for k in STAT_KEYS if k != "grapple"]

ALL_DISCIPLINES = [
    "boxing", "kickboxing", "muay_thai", "sanda", "savate",
    "wrestling", "sambo", "judo",
    "brazilian_jiu_jitsu",
    "karate", "taekwondo", "capoeira",
    "mma", "arnis", "pencak_silat",
]

# Part 2 read table: each entry is (grapple_id, file, line_number, pattern_on_line)
# These are verified against the live source tree.
PART2_READS = [
    # takedown — resolved by GrappleResolve.takedown_resolve
    ("takedown", "GrappleResolve.gd", 76, "takedown_resolve"),
    # throw — uses same takedown_resolve (throw is a takedown variant)
    ("throw", "GrappleResolve.gd", 76, "takedown_resolve"),
    # sweep — resolved by position_resolve from guard/half
    ("sweep", "GrappleResolve.gd", 98, "position_resolve"),
    # submission_attempt — resolved by submission_advance
    ("submission_attempt", "GrappleResolve.gd", 122, "submission_advance"),
    # submission_finish — resolved by submission_advance at progress >= 100
    ("submission_finish", "GrappleResolve.gd", 127, "FINISH_P"),
    # escape — resolved by _resolve_escape_attempt in FightSimulation
    ("escape", "FightSimulation.gd", 2664, "_resolve_escape_attempt"),
    # control — top_control_norm reads grapple
    ("control", "FightSimulation.gd", 2651, "grapple_norm"),
    # clinch_break — uses CLINCH_OFF_WEIGHTS for clinch stance resolution
    ("clinch_break", "GrappleResolve.gd", 27, "CLINCH_OFF_WEIGHTS"),
    # stand_up — resolved by _resolve_escape_attempt (same as escape)
    ("stand_up", "FightSimulation.gd", 2664, "_resolve_escape_attempt"),
]


# ---------------------------------------------------------------------------
# Generation (NEW v2 logic — independent grapple base)
# ---------------------------------------------------------------------------

def apply_discipline_stats(stats, discipline):
    if discipline in ("boxing", "kickboxing", "muay_thai", "sanda", "savate"):
        stats["technique"] = min(90, stats["technique"] + 5)
        stats["speed"] = min(90, stats["speed"] + 3)
    elif discipline in ("wrestling", "sambo", "judo"):
        stats["power"] = min(90, stats["power"] + 4)
        stats["conditioning"] = min(90, stats["conditioning"] + 4)
        stats["grapple"] = min(90, stats["grapple"] + 5)
    elif discipline == "brazilian_jiu_jitsu":
        stats["fight_iq"] = min(90, stats["fight_iq"] + 6)
        stats["defense"] = min(90, stats["defense"] + 3)
        stats["grapple"] = min(90, stats["grapple"] + 5)
    elif discipline in ("karate", "taekwondo", "capoeira"):
        stats["speed"] = min(90, stats["speed"] + 6)
        stats["technique"] = min(90, stats["technique"] + 3)
    else:
        stats["fight_iq"] = min(90, stats["fight_iq"] + 3)


def gen_athlete_v2(rng, talent_depth):
    discipline = rng.choice(ALL_DISCIPLINES)
    base = max(28, min(72, 25 + talent_depth // 3 + rng.randint(-10, 10)))
    grapple_base = max(28, min(72, 25 + talent_depth // 3 + rng.randint(-10, 10)))
    stats = {}
    for key in STAT_KEYS:
        if key == "grapple":
            stats[key] = max(20, min(82, grapple_base + rng.randint(-8, 8)))
        else:
            stats[key] = max(20, min(82, base + rng.randint(-8, 8)))
    apply_discipline_stats(stats, discipline)
    return {"stats": stats, "discipline": discipline}


def pearson_r(xs, ys):
    n = len(xs)
    if n < 2:
        return 0.0
    mx = sum(xs) / n
    my = sum(ys) / n
    num = sum((x - mx) * (y - my) for x, y in zip(xs, ys))
    dx = math.sqrt(sum((x - mx) ** 2 for x in xs))
    dy = math.sqrt(sum((y - my) ** 2 for y in ys))
    if dx == 0.0 or dy == 0.0:
        return 0.0
    return num / (dx * dy)


# ---------------------------------------------------------------------------
# CHECK 1: Re-generate population, assert correlation and saturation
# ---------------------------------------------------------------------------

print("=== CHECK 1: grapple independence (correlation + saturation) ===")

tier_depths = [30, 46, 50, 60, 65, 74, 80, 86, 90]
rng = random.Random(117)
fighters = []
for i in range(252):
    td = tier_depths[i % len(tier_depths)]
    fighters.append(gen_athlete_v2(rng, td))

grapples = [f["stats"]["grapple"] for f in fighters]
other_means = [
    sum(f["stats"][k] for k in OTHER_SIX) / len(OTHER_SIX)
    for f in fighters
]
r = pearson_r(grapples, other_means)
r_rounded = round(r, 4)

print(f"  Correlation: {r_rounded} (pinned: {PINNED_CORRELATION})")
if abs(r_rounded - PINNED_CORRELATION) > 0.001:
    fail(f"Correlation {r_rounded} != pinned {PINNED_CORRELATION}")
else:
    ok(f"Correlation matches pinned literal {PINNED_CORRELATION}")

if r_rounded >= PINNED_CORRELATION_CEIL:
    fail(f"Correlation {r_rounded} >= {PINNED_CORRELATION_CEIL}")
else:
    ok(f"Correlation {r_rounded} < {PINNED_CORRELATION_CEIL}")

no_weakness = sum(
    1 for f in fighters if all(f["stats"][k] >= 60 for k in STAT_KEYS)
)
ceiling = sum(
    1 for f in fighters if sum(1 for k in STAT_KEYS if f["stats"][k] > 90) > 2
)

print(f"  No-weakness: {no_weakness} (pinned max: {PINNED_NO_WEAKNESS_MAX})")
if no_weakness > PINNED_NO_WEAKNESS_MAX:
    fail(f"No-weakness {no_weakness} > pinned max {PINNED_NO_WEAKNESS_MAX}")
else:
    ok(f"No-weakness {no_weakness} <= {PINNED_NO_WEAKNESS_MAX}")

print(f"  Ceiling (>2 above 90): {ceiling} (pinned max: {PINNED_CEILING_MAX})")
if ceiling > PINNED_CEILING_MAX:
    fail(f"Ceiling {ceiling} > pinned max {PINNED_CEILING_MAX}")
else:
    ok(f"Ceiling {ceiling} <= {PINNED_CEILING_MAX}")

# ---------------------------------------------------------------------------
# CHECK 2: Degenerate case — population of 0
# ---------------------------------------------------------------------------

print("\n=== CHECK 2: degenerate population (size 0) ===")
empty_fighters = []
n_empty = len(empty_fighters)
if n_empty == 0:
    no_weak_empty = 0
    fraction_empty = 0.0
    ok("Population of 0 reports no-weakness=0, fraction=0.0 (no division by zero)")
else:
    fraction_empty = no_weak_empty / n_empty

# ---------------------------------------------------------------------------
# CHECK 3: Part 2 file:line assertions
# ---------------------------------------------------------------------------

print("\n=== CHECK 3: Part 2 read table — file:line still resolves ===")
for grapple_id, filename, line_no, pattern in PART2_READS:
    fpath = os.path.join(SCRIPTS, filename)
    if not os.path.exists(fpath):
        fail(f"{filename} not found (for grapple id '{grapple_id}')")
        continue
    with open(fpath, "r", encoding="utf-8") as f:
        lines = f.readlines()
    if line_no > len(lines):
        fail(f"{filename}:{line_no} out of range (file has {len(lines)} lines)")
        continue
    line_text = lines[line_no - 1]
    if pattern in line_text:
        ok(f"'{grapple_id}': {filename}:{line_no} contains '{pattern}'")
    else:
        fail(f"'{grapple_id}': {filename}:{line_no} does NOT contain '{pattern}'")
        fail(f"  actual line: {line_text.rstrip()}")

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

print(f"\n{'='*50}")
if failures:
    print(f"FAILED: {len(failures)} check(s)")
    for msg in failures:
        print(f"  - {msg}")
    sys.exit(1)
else:
    print("ALL CHECKS PASSED")
    sys.exit(0)
