"""Q119 — Derive the stat floor from the engine.

Part 1: grapple now gets its own independent roll (no longer the mean of the
other six). This script re-generates the 252-fighter population and measures:
  - Pearson correlation between grapple and the mean of the other six
  - No-weakness count (all stats >= 60)
  - Ceiling count (>2 stats above 90)

Outputs Q119_correlation.json.
"""
import json
import math
import os
import random
import sys

STAT_KEYS = ["power", "technique", "speed", "defense", "conditioning", "fight_iq", "grapple"]
OTHER_SIX = [k for k in STAT_KEYS if k != "grapple"]

ALL_DISCIPLINES = [
    "boxing", "kickboxing", "muay_thai", "sanda", "savate",
    "wrestling", "sambo", "judo",
    "brazilian_jiu_jitsu",
    "karate", "taekwondo", "capoeira",
    "mma", "arnis", "pencak_silat",
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


def gen_athlete_v2(rng, talent_depth):
    """NEW generation: grapple gets its own independent base + roll."""
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


def generate_mixed_population(n=252, seed=117):
    tier_depths = [30, 46, 50, 60, 65, 74, 80, 86, 90]
    rng = random.Random(seed)
    fighters = []
    for i in range(n):
        td = tier_depths[i % len(tier_depths)]
        fighters.append(gen_athlete_v2(rng, td))
    return fighters


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


def measure_population(fighters):
    if not fighters:
        return {
            "count": 0,
            "note": "no fighters",
            "grapple_correlation": None,
            "no_weakness_count": 0,
            "ceiling_count": 0,
        }
    n = len(fighters)
    grapples = [f["stats"]["grapple"] for f in fighters]
    other_means = [
        sum(f["stats"][k] for k in OTHER_SIX) / len(OTHER_SIX)
        for f in fighters
    ]
    r = pearson_r(grapples, other_means)
    no_weakness = sum(
        1 for f in fighters if all(f["stats"][k] >= 60 for k in STAT_KEYS)
    )
    ceiling = sum(
        1 for f in fighters if sum(1 for k in STAT_KEYS if f["stats"][k] > 90) > 2
    )
    return {
        "count": n,
        "seed": 117,
        "generation": "WorldPopulation._generate_athlete v2 (independent grapple)",
        "grapple_correlation": round(r, 4),
        "no_weakness_count": no_weakness,
        "no_weakness_fraction": round(no_weakness / n, 4),
        "ceiling_count": ceiling,
        "ceiling_fraction": round(ceiling / n, 4),
    }


def main():
    fighters = generate_mixed_population(252, seed=117)
    result = measure_population(fighters)

    out_path = os.path.join(os.path.dirname(__file__), "Q119_correlation.json")
    with open(out_path, "w", encoding="utf-8") as f:
        json.dump(result, f, indent=2)

    print(f"Population: {result['count']} fighters")
    print(f"Grapple correlation with mean-of-six: {result['grapple_correlation']}")
    print(f"No-weakness (all >= 60): {result['no_weakness_count']} ({result['no_weakness_fraction']*100:.1f}%)")
    print(f"Ceiling (>2 stats > 90): {result['ceiling_count']} ({result['ceiling_fraction']*100:.1f}%)")
    print(f"Wrote {out_path}")


if __name__ == "__main__":
    main()
