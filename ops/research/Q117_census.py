"""Q117 — Attribute census: re-derive the stat list from source and generate
a population of fighters using the same logic as WorldPopulation._generate_athlete.

Outputs Q117_population.json with per-attribute percentiles and saturation metrics.
"""
import hashlib
import json
import math
import os
import random
import re
import sys

# ---------------------------------------------------------------------------
# 1. CENSUS — extract stat keys from AthleteStatModel.gd source
# ---------------------------------------------------------------------------

REPO_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
STAT_MODEL_PATH = os.path.join(REPO_ROOT, "Godot", "scripts", "AthleteStatModel.gd")
WORLD_POP_PATH = os.path.join(REPO_ROOT, "Godot", "scripts", "WorldPopulation.gd")


def extract_stat_keys_from_source():
    """Parse STAT_ORDER from AthleteStatModel.gd — the canonical list."""
    with open(STAT_MODEL_PATH, "r", encoding="utf-8") as f:
        text = f.read()
    m = re.search(r'const\s+STAT_ORDER\s*:=\s*\[([^\]]+)\]', text)
    if not m:
        raise RuntimeError("Could not find STAT_ORDER in AthleteStatModel.gd")
    keys = re.findall(r'"(\w+)"', m.group(1))
    return keys


def extract_stat_definitions():
    """Parse the STATS dict metadata from AthleteStatModel.gd."""
    with open(STAT_MODEL_PATH, "r", encoding="utf-8") as f:
        text = f.read()
    defs = {}
    for key in extract_stat_keys_from_source():
        pattern = rf'"{key}"\s*:\s*\{{([^}}]+)\}}'
        m = re.search(pattern, text)
        if m:
            block = m.group(1)
            cat_m = re.search(r'"category"\s*:\s*"(\w+)"', block)
            direct_m = re.search(r'"direct"\s*:\s*(true|false)', block)
            defs[key] = {
                "category": cat_m.group(1) if cat_m else "UNKNOWN",
                "direct": direct_m.group(1) == "true" if direct_m else False,
            }
        else:
            defs[key] = {"category": "UNKNOWN", "direct": False}
    return defs


# ---------------------------------------------------------------------------
# 2. POPULATION GENERATION — replicate WorldPopulation._generate_athlete
# ---------------------------------------------------------------------------

STAT_KEYS = ["power", "technique", "speed", "defense", "conditioning", "fight_iq", "grapple"]

# Disciplines and their weights (from a typical culture dict).
# We use a flat distribution across all disciplines to get broad coverage.
ALL_DISCIPLINES = [
    "boxing", "kickboxing", "muay_thai", "sanda", "savate",
    "wrestling", "sambo", "judo",
    "brazilian_jiu_jitsu",
    "karate", "taekwondo", "capoeira",
    "mma", "arnis", "pencak_silat",
]

# Discipline stat bumps — exact copy from _apply_discipline_stats
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
        # mma, arnis, pencak_silat, anything else
        stats["fight_iq"] = min(90, stats["fight_iq"] + 3)


def generate_athlete(rng, talent_depth=50, discipline=None):
    """Replicate WorldPopulation._generate_athlete exactly."""
    if discipline is None:
        discipline = rng.choice(ALL_DISCIPLINES)
    base = max(28, min(72, 25 + talent_depth // 3 + rng.randint(-10, 10)))
    stats = {}
    for key in STAT_KEYS:
        if key == "grapple":
            continue
        stats[key] = max(20, min(82, base + rng.randint(-8, 8)))
    stat_total = sum(stats[k] for k in stats)
    stats["grapple"] = max(20, min(82, round(stat_total / len(stats))))
    apply_discipline_stats(stats, discipline)
    return {
        "stats": stats,
        "discipline": discipline,
        "age": rng.randint(18, 31),
        "potential": max(55, min(96, base + rng.randint(14, 30))),
    }


def generate_population(n=250, seed=117, talent_depth=50):
    """Generate n fighters with a spread of disciplines and a FIXED talent_depth."""
    rng = random.Random(seed)
    fighters = []
    for _ in range(n):
        fighters.append(generate_athlete(rng, talent_depth))
    return fighters


def generate_mixed_population(n=250, seed=117):
    """Generate n fighters across the FULL talent_depth range the game uses.
    talent_depth = clampi(tier_score + gym_count, 30, 90).
    Tier scores: S=86, A=74, B=60, C=46. With gym_count 1-5 the real range is 30-90.
    We cycle through tiers to get a realistic spread."""
    rng = random.Random(seed)
    tier_depths = [30, 46, 50, 60, 65, 74, 80, 86, 90]
    fighters = []
    for i in range(n):
        td = tier_depths[i % len(tier_depths)]
        fighters.append(generate_athlete(rng, td))
    return fighters


# ---------------------------------------------------------------------------
# 3. MEASUREMENT
# ---------------------------------------------------------------------------

def percentile(values, p):
    """Return the p-th percentile (0-100) of a sorted list."""
    if not values:
        return 0
    s = sorted(values)
    k = (len(s) - 1) * p / 100.0
    f = int(math.floor(k))
    c = min(f + 1, len(s) - 1)
    d = k - f
    return s[f] + d * (s[c] - s[f])


def measure_population(fighters):
    """Compute per-attribute stats and saturation metrics."""
    if not fighters:
        return {
            "count": 0,
            "note": "no fighters",
            "attributes": {},
            "no_weakness_count": 0,
            "ceiling_count": 0,
        }
    n = len(fighters)
    attr_stats = {}
    for key in STAT_KEYS:
        vals = [f["stats"][key] for f in fighters]
        attr_stats[key] = {
            "min": min(vals),
            "max": max(vals),
            "p10": round(percentile(vals, 10), 1),
            "p50": round(percentile(vals, 50), 1),
            "p90": round(percentile(vals, 90), 1),
            "mean": round(sum(vals) / len(vals), 1),
        }
    # Saturation: how many fighters have NO attribute below 60?
    no_weakness = sum(
        1 for f in fighters
        if all(f["stats"][k] >= 60 for k in STAT_KEYS)
    )
    # Ceiling: how many have more than two attributes above 90?
    ceiling = sum(
        1 for f in fighters
        if sum(1 for k in STAT_KEYS if f["stats"][k] > 90) > 2
    )
    # Discipline breakdown
    disc_counts = {}
    for f in fighters:
        d = f["discipline"]
        disc_counts[d] = disc_counts.get(d, 0) + 1

    return {
        "count": n,
        "seed": 117,
        "talent_depth": 50,
        "generation": "WorldPopulation._generate_athlete replica",
        "attributes": attr_stats,
        "no_weakness_count": no_weakness,
        "no_weakness_fraction": round(no_weakness / n, 4),
        "ceiling_count": ceiling,
        "ceiling_fraction": round(ceiling / n, 4),
        "discipline_spread": disc_counts,
    }


# ---------------------------------------------------------------------------
# 4. MAIN
# ---------------------------------------------------------------------------

def main():
    keys = extract_stat_keys_from_source()
    print(f"Census: {len(keys)} stats from AthleteStatModel.gd: {keys}")
    assert keys == STAT_KEYS, f"Key mismatch: {keys} != {STAT_KEYS}"

    defs = extract_stat_definitions()
    for k in keys:
        print(f"  {k}: category={defs[k]['category']}, direct={defs[k]['direct']}")

    # Generate at multiple talent depths to show the full picture
    tiers = {
        "C-tier (talent=30)": 30,
        "B-tier (talent=60)": 60,
        "A-tier (talent=74)": 74,
        "S-tier (talent=90)": 90,
    }
    tier_results = {}
    for label, td in tiers.items():
        fighters = generate_population(250, seed=117, talent_depth=td)
        tier_results[label] = measure_population(fighters)
        tier_results[label]["talent_depth"] = td

    # Mixed population: the headline measurement
    mixed = generate_mixed_population(252, seed=117)
    result = measure_population(mixed)
    result["stat_keys"] = keys
    result["stat_definitions"] = defs
    result["by_tier"] = tier_results

    out_path = os.path.join(os.path.dirname(__file__), "Q117_population.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(result, f, indent=2)

    print(f"\n=== MIXED POPULATION (all tiers): {result['count']} fighters ===")
    print(f"No-weakness (all >= 60): {result['no_weakness_count']} ({result['no_weakness_fraction']*100:.1f}%)")
    print(f"Ceiling (>2 attrs > 90): {result['ceiling_count']} ({result['ceiling_fraction']*100:.1f}%)")
    for key in STAT_KEYS:
        s = result["attributes"][key]
        print(f"  {key:14s}: min={s['min']:3d}  p10={s['p10']:6.1f}  p50={s['p50']:6.1f}  p90={s['p90']:6.1f}  max={s['max']:3d}")

    print(f"\n=== BY TIER ===")
    for label, tr in tier_results.items():
        print(f"\n{label}: {tr['count']} fighters, no-weakness={tr['no_weakness_count']}, ceiling={tr['ceiling_count']}")
        for key in STAT_KEYS:
            s = tr["attributes"][key]
            print(f"  {key:14s}: min={s['min']:3d}  p50={s['p50']:6.1f}  p90={s['p90']:6.1f}  max={s['max']:3d}")

    print(f"\nWrote {out_path}")


if __name__ == "__main__":
    main()
