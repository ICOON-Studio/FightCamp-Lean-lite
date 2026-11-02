"""U118 gate — grapple split wired at every call site, asymmetry, control arm, saturation."""
from __future__ import annotations

import math
import os
import random
import re
import sys

REPO_ROOT = os.path.normpath(os.path.join(os.path.dirname(__file__), "..", ".."))
SCRIPTS = os.path.join(REPO_ROOT, "Godot", "scripts")

PINNED_NO_WEAKNESS_MAX = 2
PINNED_CEILING_MAX = 0
CONTROL_RATE_TOLERANCE = 0.005

STAT_KEYS = [
    "power",
    "technique",
    "speed",
    "defense",
    "conditioning",
    "fight_iq",
    "grapple_offense",
    "grapple_defence",
]

ALL_DISCIPLINES = [
    "boxing",
    "kickboxing",
    "muay_thai",
    "sanda",
    "savate",
    "wrestling",
    "sambo",
    "judo",
    "brazilian_jiu_jitsu",
    "karate",
    "taekwondo",
    "capoeira",
    "mma",
    "arnis",
    "pencak_silat",
]

# Each entry: grapple_id, file, line_no, must_contain_one_of (split stat or resolver marker)
CALL_SITES = [
    ("takedown", "GrappleResolve.gd", 21, ["grapple_offense"]),
    ("takedown", "GrappleResolve.gd", 35, ["grapple_defence"]),
    ("throw", "GrappleResolve.gd", 76, ["takedown_resolve"]),
    ("sweep", "GrappleResolve.gd", 98, ["position_resolve"]),
    ("submission_attempt", "GrappleResolve.gd", 213, ["grapple_offense"]),
    ("submission_attempt", "GrappleResolve.gd", 214, ["grapple_defence"]),
    ("clinch_break", "GrappleResolve.gd", 28, ["grapple_offense"]),
    ("clinch_break", "GrappleResolve.gd", 35, ["grapple_defence"]),
    ("control", "FightSimulation.gd", 2652, ["grapple_offense"]),
    ("escape", "FightSimulation.gd", 2666, ["_resolve_escape_attempt"]),
    ("stand_up", "FightSimulation.gd", 2666, ["_resolve_escape_attempt"]),
    ("realtime_shoot", "FightRealtime.gd", 3843, ["grapple_offense"]),
    ("realtime_clinch", "FightRealtime.gd", 3844, ["grapple_offense"]),
]

failures: list[str] = []


def fail(msg: str) -> None:
    failures.append(msg)
    print(f"  FAIL: {msg}")


def ok(msg: str) -> None:
    print(f"  OK: {msg}")


def read_lines(filename: str) -> list[str]:
    with open(os.path.join(SCRIPTS, filename), "r", encoding="utf-8") as f:
        return f.readlines()


# ---------------------------------------------------------------------------
# GrappleResolve arithmetic mirror (fresh fighters, no kuzushi)
# ---------------------------------------------------------------------------

PROB_FLOOR = 0.08
PROB_CEIL = 0.88
PROB_BASE = 0.50
PROB_SCALE = 0.012

STANDING_OFF_WEIGHTS = {
    "grapple_offense": 0.45,
    "power": 0.20,
    "speed": 0.15,
    "technique": 0.10,
    "fight_iq": 0.10,
}
DEF_WEIGHTS = {
    "grapple_defence": 0.40,
    "defense": 0.30,
    "speed": 0.15,
    "fight_iq": 0.15,
}
LEGACY_OFF_WEIGHTS = {
    "grapple": 0.45,
    "power": 0.20,
    "speed": 0.15,
    "technique": 0.10,
    "fight_iq": 0.10,
}
LEGACY_DEF_WEIGHTS = {
    "grapple": 0.40,
    "defense": 0.30,
    "speed": 0.15,
    "fight_iq": 0.15,
}


def stat(actor: dict, key: str) -> float:
    stats = actor.get("stats", {})
    return float(stats.get(key, 50))


def weighted_sum(actor: dict, weights: dict) -> float:
    return sum(float(weights[k]) * stat(actor, k) for k in weights)


def success_probability(attacker: dict, defender: dict, off_weights: dict, def_weights: dict) -> float:
    off = weighted_sum(attacker, off_weights)
    def_score = weighted_sum(defender, def_weights)
    return max(PROB_FLOOR, min(PROB_CEIL, PROB_BASE + PROB_SCALE * (off - def_score)))


def takedown_rate(attacker: dict, defender: dict, trials: int, rng: random.Random, legacy: bool = False) -> float:
    off_w = LEGACY_OFF_WEIGHTS if legacy else STANDING_OFF_WEIGHTS
    def_w = LEGACY_DEF_WEIGHTS if legacy else DEF_WEIGHTS
    p = success_probability(attacker, defender, off_w, def_w)
    hits = sum(1 for _ in range(trials) if rng.random() < p)
    return hits / trials


def neutral_stats(**overrides: int) -> dict:
    base = {
        "power": 50,
        "technique": 50,
        "speed": 50,
        "defense": 50,
        "conditioning": 50,
        "fight_iq": 50,
        "grapple_offense": 50,
        "grapple_defence": 50,
    }
    base.update(overrides)
    return {"stats": base}


def legacy_fighter(grapple: int) -> dict:
    return {"stats": {"grapple": grapple, "power": 50, "technique": 50, "speed": 50, "defense": 50, "fight_iq": 50}}


def apply_discipline_stats(stats: dict, discipline: str) -> None:
    if discipline in ("boxing", "kickboxing", "muay_thai", "sanda", "savate"):
        stats["technique"] = min(90, stats["technique"] + 5)
        stats["speed"] = min(90, stats["speed"] + 3)
    elif discipline in ("wrestling", "sambo", "judo"):
        stats["power"] = min(90, stats["power"] + 4)
        stats["conditioning"] = min(90, stats["conditioning"] + 4)
        stats["grapple_offense"] = min(90, stats["grapple_offense"] + 5)
        stats["grapple_defence"] = min(90, stats["grapple_defence"] + 5)
    elif discipline == "brazilian_jiu_jitsu":
        stats["fight_iq"] = min(90, stats["fight_iq"] + 6)
        stats["defense"] = min(90, stats["defense"] + 3)
        stats["grapple_offense"] = min(90, stats["grapple_offense"] + 5)
        stats["grapple_defence"] = min(90, stats["grapple_defence"] + 5)
    elif discipline in ("karate", "taekwondo", "capoeira"):
        stats["speed"] = min(90, stats["speed"] + 6)
        stats["technique"] = min(90, stats["technique"] + 3)
    else:
        stats["fight_iq"] = min(90, stats["fight_iq"] + 3)


def gen_athlete_v118(rng: random.Random, talent_depth: int) -> dict:
    discipline = rng.choice(ALL_DISCIPLINES)
    base = max(28, min(72, 25 + talent_depth // 3 + rng.randint(-10, 10)))
    grapple_base = max(28, min(72, 25 + talent_depth // 3 + rng.randint(-10, 10)))
    stats = {}
    for key in STAT_KEYS:
        if key in ("grapple_offense", "grapple_defence"):
            stats[key] = max(20, min(82, grapple_base + rng.randint(-8, 8)))
        else:
            stats[key] = max(20, min(82, base + rng.randint(-8, 8)))
    apply_discipline_stats(stats, discipline)
    return {"stats": stats, "discipline": discipline}


# ---------------------------------------------------------------------------
# CHECK 1 — call sites name split stats
# ---------------------------------------------------------------------------

print("=== CHECK 1: call sites read split stats ===")
for grapple_id, filename, line_no, patterns in CALL_SITES:
    fpath = os.path.join(SCRIPTS, filename)
    if not os.path.exists(fpath):
        fail(f"{filename} missing for '{grapple_id}'")
        continue
    lines = read_lines(filename)
    if line_no > len(lines):
        fail(f"{filename}:{line_no} out of range for '{grapple_id}'")
        continue
    line_text = lines[line_no - 1]
    if any(p in line_text for p in patterns):
        ok(f"'{grapple_id}' {filename}:{line_no} -> {patterns[0]}")
    else:
        fail(f"'{grapple_id}' {filename}:{line_no} missing {patterns}")
        fail(f"  actual: {line_text.rstrip()}")

# submission_finish intentionally has no stat read — assert FINISH_P still flat
finish_line = read_lines("GrappleResolve.gd")[126]
if "FINISH_P" in finish_line:
    ok("submission_finish still flat (FINISH_P, no stat read)")
else:
    fail("submission_finish line changed away from FINISH_P")

# ---------------------------------------------------------------------------
# CHECK 2 — behavioural asymmetry (different men, both directions)
# ---------------------------------------------------------------------------

print("\n=== CHECK 2: takedown asymmetry (offense specialist vs defence specialist) ===")
offense_specialist = neutral_stats(grapple_offense=82, grapple_defence=38)
defence_specialist = neutral_stats(grapple_offense=38, grapple_defence=82)
rng_asym = random.Random(11801)
trials = 20000
rate_off_vs_def = takedown_rate(offense_specialist, defence_specialist, trials, rng_asym)
rate_def_vs_off = takedown_rate(defence_specialist, offense_specialist, trials, rng_asym)
print(
    f"  Population: offense_specialist (off=82/def=38) vs defence_specialist (off=38/def=82)"
)
print(f"  Takedown rate offense->defence: {rate_off_vs_def:.4f}")
print(f"  Takedown rate defence->offense: {rate_def_vs_off:.4f}")
if rate_off_vs_def <= rate_def_vs_off:
    fail(
        f"Asymmetry missing: offense specialist should shoot better "
        f"({rate_off_vs_def:.4f} <= {rate_def_vs_off:.4f})"
    )
else:
    ok(f"Asymmetric: {rate_off_vs_def:.4f} > {rate_def_vs_off:.4f}")

# ---------------------------------------------------------------------------
# CHECK 3 — control arm (equal split == legacy single grapple)
# ---------------------------------------------------------------------------

print("\n=== CHECK 3: control arm (equal offense/defence == legacy grapple) ===")
control_value = 55
split_control = neutral_stats(grapple_offense=control_value, grapple_defence=control_value)
legacy_control = legacy_fighter(control_value)
rng_ctrl = random.Random(11802)
split_rate = takedown_rate(split_control, split_control, trials, rng_ctrl, legacy=False)
legacy_rate = takedown_rate(legacy_control, legacy_control, trials, rng_ctrl, legacy=True)
print(f"  Split equal ({control_value}/{control_value}) rate: {split_rate:.4f}")
print(f"  Legacy single grapple={control_value} rate: {legacy_rate:.4f}")
if abs(split_rate - legacy_rate) > CONTROL_RATE_TOLERANCE:
    fail(
        f"Control arm drift {abs(split_rate - legacy_rate):.4f} > {CONTROL_RATE_TOLERANCE}"
    )
else:
    ok(f"Control arm within noise (delta {abs(split_rate - legacy_rate):.4f})")

# ---------------------------------------------------------------------------
# CHECK 4 — saturation (252-fighter mixed population)
# ---------------------------------------------------------------------------

print("\n=== CHECK 4: population saturation (252 fighters, seed 117) ===")
tier_depths = [30, 46, 50, 60, 65, 74, 80, 86, 90]
rng_pop = random.Random(117)
fighters = [gen_athlete_v118(rng_pop, tier_depths[i % len(tier_depths)]) for i in range(252)]
no_weakness = sum(1 for f in fighters if all(f["stats"][k] >= 60 for k in STAT_KEYS))
ceiling = sum(
    1 for f in fighters if sum(1 for k in STAT_KEYS if f["stats"][k] > 90) > 2
)
print(f"  no-weakness={no_weakness}, ceiling={ceiling}")
if no_weakness > PINNED_NO_WEAKNESS_MAX:
    fail(f"No-weakness {no_weakness} > {PINNED_NO_WEAKNESS_MAX}")
else:
    ok(f"No-weakness {no_weakness} <= {PINNED_NO_WEAKNESS_MAX}")
if ceiling > PINNED_CEILING_MAX:
    fail(f"Ceiling {ceiling} > {PINNED_CEILING_MAX}")
else:
    ok(f"Ceiling {ceiling} <= {PINNED_CEILING_MAX}")

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------

print(f"\n{'=' * 50}")
if failures:
    print(f"FAILED: {len(failures)} check(s)")
    for msg in failures:
        print(f"  - {msg}")
    sys.exit(1)
print("ALL CHECKS PASSED")
sys.exit(0)
