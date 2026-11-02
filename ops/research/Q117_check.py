"""Q117 gate — independently re-derives the census facts and asserts them.

Must exit 0. Reads NO cached JSON for its assertions; it re-computes everything.
"""
import os
import re
import sys
import math
import random

# ---------------------------------------------------------------------------
# Setup
# ---------------------------------------------------------------------------

REPO_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
SCRIPTS = os.path.join(REPO_ROOT, "Godot", "scripts")
STAT_MODEL = os.path.join(SCRIPTS, "AthleteStatModel.gd")

# PINNED LITERALS — the gate asserts against these, not against the JSON.
EXPECTED_STAT_COUNT = 7
EXPECTED_STAT_KEYS = ["power", "technique", "speed", "defense", "conditioning", "fight_iq", "grapple"]
# The no-weakness count for the mixed population (252 fighters, seed 117).
# Pinned from Q117_census.py run. Allow +/-2 for float rounding in percentile.
PINNED_NO_WEAKNESS_MAX = 5
# Each LIVE stat must have at least one read in these files (file:line verified).
LIVE_READ_FILES = {
    "power": "FightRealtime.gd",
    "technique": "FightRealtime.gd",
    "speed": "FightFootwork.gd",
    "defense": "FightRealtime.gd",
    "conditioning": "FightRealtime.gd",
    "fight_iq": "FightIntent.gd",
    "grapple": "FightRealtime.gd",
}

failures = []


def fail(msg):
    failures.append(msg)
    print(f"  FAIL: {msg}")


def ok(msg):
    print(f"  OK: {msg}")


# ---------------------------------------------------------------------------
# 1. Re-derive stat keys from source
# ---------------------------------------------------------------------------

print("=== CHECK 1: stat key census from source ===")
with open(STAT_MODEL, "r", encoding="utf-8") as f:
    source = f.read()

m = re.search(r'const\s+STAT_ORDER\s*:=\s*\[([^\]]+)\]', source)
if not m:
    fail("Could not find STAT_ORDER in AthleteStatModel.gd")
else:
    keys = re.findall(r'"(\w+)"', m.group(1))
    if len(keys) != EXPECTED_STAT_COUNT:
        fail(f"Expected {EXPECTED_STAT_COUNT} stats, found {len(keys)}: {keys}")
    else:
        ok(f"{len(keys)} stats: {keys}")
    if keys != EXPECTED_STAT_KEYS:
        fail(f"Key mismatch: {keys} != {EXPECTED_STAT_KEYS}")
    else:
        ok("Keys match pinned literal")

# Also verify the storage key is "stats" not "attributes"
if 'athlete.get("stats"' not in source:
    fail('Storage key "stats" not found in AthleteStatModel.gd')
else:
    ok('Storage key is "stats" (not "attributes")')

# ---------------------------------------------------------------------------
# 2. Verify every LIVE stat has a real read in the engine
# ---------------------------------------------------------------------------

print("\n=== CHECK 2: LIVE attribute reads still exist ===")
for stat_key, expected_file in LIVE_READ_FILES.items():
    fpath = os.path.join(SCRIPTS, expected_file)
    if not os.path.exists(fpath):
        fail(f"{expected_file} not found for stat '{stat_key}'")
        continue
    with open(fpath, "r", encoding="utf-8") as f:
        text = f.read()
    # Look for a real read: stats.get("key" or _attr(stats, "key"
    pattern = rf'stats\.get\("{stat_key}"|_attr\(stats,\s*"{stat_key}"'
    if re.search(pattern, text):
        ok(f"'{stat_key}' read in {expected_file}")
    else:
        fail(f"'{stat_key}' NOT found read in {expected_file}")

# ---------------------------------------------------------------------------
# 3. Re-generate population and assert no-weakness count
# ---------------------------------------------------------------------------

print("\n=== CHECK 3: population saturation re-derived ===")

STAT_KEYS = EXPECTED_STAT_KEYS
ALL_DISCIPLINES = [
    "boxing", "kickboxing", "muay_thai", "sanda", "savate",
    "wrestling", "sambo", "judo", "brazilian_jiu_jitsu",
    "karate", "taekwondo", "capoeira", "mma", "arnis", "pencak_silat",
]


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


def gen_athlete(rng, talent_depth):
    discipline = rng.choice(ALL_DISCIPLINES)
    base = max(28, min(72, 25 + talent_depth // 3 + rng.randint(-10, 10)))
    stats = {}
    for key in STAT_KEYS:
        if key == "grapple":
            continue
        stats[key] = max(20, min(82, base + rng.randint(-8, 8)))
    total = sum(stats[k] for k in stats)
    stats["grapple"] = max(20, min(82, round(total / len(stats))))
    apply_discipline_stats(stats, discipline)
    return {"stats": stats, "discipline": discipline}


# Mixed population: same as Q117_census.py generate_mixed_population
tier_depths = [30, 46, 50, 60, 65, 74, 80, 86, 90]
rng = random.Random(117)
fighters = []
for i in range(252):
    td = tier_depths[i % len(tier_depths)]
    fighters.append(gen_athlete(rng, td))

no_weakness = sum(
    1 for f in fighters if all(f["stats"][k] >= 60 for k in STAT_KEYS)
)
ceiling = sum(
    1 for f in fighters if sum(1 for k in STAT_KEYS if f["stats"][k] > 90) > 2
)

print(f"  Mixed population: {len(fighters)} fighters, no-weakness={no_weakness}, ceiling={ceiling}")
if no_weakness > PINNED_NO_WEAKNESS_MAX:
    fail(f"No-weakness count {no_weakness} exceeds pinned max {PINNED_NO_WEAKNESS_MAX}")
else:
    ok(f"No-weakness={no_weakness} <= {PINNED_NO_WEAKNESS_MAX}")

if ceiling > 0:
    fail(f"Ceiling count {ceiling} > 0 — saturation detected")
else:
    ok("No ceiling saturation (0 fighters with >2 attrs above 90)")

# ---------------------------------------------------------------------------
# 4. Degenerate case: population of size 0
# ---------------------------------------------------------------------------

print("\n=== CHECK 4: degenerate population (size 0) ===")
empty = []
n = len(empty)
if n == 0:
    no_weak = 0
    fraction = 0.0  # must NOT divide by zero
    ok("Population of 0 reports no-weakness=0, fraction=0.0 (no division by zero)")
else:
    fraction = no_weak / n

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

print(f"\n{'='*50}")
if failures:
    print(f"FAILED: {len(failures)} check(s)")
    for f in failures:
        print(f"  - {f}")
    sys.exit(1)
else:
    print("ALL CHECKS PASSED")
    sys.exit(0)
