# TASK LIVERRIBS2 - LiverRibs.gd: the liver and the ribs do different things (pure module + unit tests)

Status: OPEN (S466, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
The operator said yes to liver vs ribs (Q-S294-219). Design map v2 (ops/research/DESIGN_LIVERRIBS1_V2_REVISE_KALLI_KALLI.md,
sections 3 and 7) passed the design loop on two critics in S466 (Maria 7/6/7, John 7/6/7). This is its build task 2: the
pure rules only. Wiring (Exchanges, Knockdowns, CornerJobs, InjuryRoll) is Claude's, later, from your module.

## What to build: scripts/rules/LiverRibs.gd (extends RefCounted, static funcs, ZERO preloads)
Constants (each with a one-line ## comment quoting the map's rule number): LIVER_DRAIN 1.3, RIB_DRAIN 0.55, BASE_FOLD 0.03,
FOLD_MIN 0.01, FOLD_MAX 0.08, FOLD_CRIT_MULT 2.0, FOLD_CAP 0.16, FOLDS_MAX 2, HURT_LINE 55.0, CRIT_LINE 35.0,
RIB_GUARD_HURT -5.0, RIB_OUTPUT_HURT 0.85, CRACK_CHANCE 0.04, CRACK_OUTPUT 0.6, CRACK_GUARD -10.0, RETIRE_BASE 0.40,
RETIRE_BEHIND 0.65, BELL_CRACK 0.25, BRUISE_LINE 50.0, HEAL_DAYS {"pull": 35, "defend": 63, "fight": 84}, WORSE_DAYS 28,
WORSE_CHANCE 0.10, BRUISED_DAYS [10, 21], CRACKED_DAYS [35, 56].
Functions (side is "liver" or "ribs"; band thresholds: value <= 35 critical, <= 55 hurt, else ok):
- side_of(attacker_stance: String, hand: String) -> String: left hand -> "liver", right hand -> "ribs", any stance (rule: the
  throwing hand picks the side; stance only changes which hand is lead).
- band(value: float) -> String: "ok" | "hurt" | "critical".
- drain(side: String) -> float: the BODY_COST multiplier (LIVER_DRAIN / RIB_DRAIN).
- liver_fold_chance(strength, explosiveness, mastery, durability: float, liver_value: float, folds_so_far: int) -> float:
  0 when band ok or folds_so_far >= FOLDS_MAX; attack_power = (strength + explosiveness) / 2 * (0.5 + mastery / 200);
  p = clamp(BASE_FOLD * exp((attack_power - durability) / 12), FOLD_MIN, FOLD_MAX); x FOLD_CRIT_MULT at critical; min FOLD_CAP.
- ribs_penalty(ribs_value: float, cracked: bool) -> Dictionary {"guard": float, "output": float}: cracked -> CRACK_*,
  hurt/critical -> RIB_*_HURT, ok -> {0, 1.0}.
- crack_chance(ribs_value: float, already: bool) -> float: CRACK_CHANCE at critical, else 0; 0 when already cracked.
- corner_retires(cracked: bool, behind: bool) -> float: 0 / RETIRE_BASE / RETIRE_BEHIND.
- injury_split(ribs_value: float, cracked: bool, roll: float) -> Dictionary {"kind": "none"|"bruised"|"cracked"}:
  the liver NEVER produces an injury; cracked in the bout -> cracked; critical and roll < BELL_CRACK -> cracked;
  ribs_value < BRUISE_LINE -> bruised; else none.
- heal_days(choice: String, roll: float) -> int: HEAL_DAYS[choice] (+WORSE_DAYS when choice == "fight" and roll < WORSE_CHANCE).

## Test: tests/liver_ribs_test.gd (extends SceneTree; prints LIVER_RIBS failures=<n>; quit(1) on any failure)
Cover every function at its edges: 55.0 is hurt, 55.1 ok, 35.0 critical; fold 0 at ok, 0 at FOLDS_MAX, clamped to FOLD_MIN
for a weak puncher and FOLD_MAX x2 <= FOLD_CAP for a strong one at critical; the 60/40 traffic mean
0.6 * drain(liver) + 0.4 * drain(ribs) == 1.0 (+-0.001); side_of for orthodox AND southpaw both hands; liver never injured
whatever the roll; heal_days 84 vs 112 around WORSE_CHANCE. Two fighters in any fixture differ (never identical numbers).
A CONTROL check that a wrong module would fail: swap LIVER_DRAIN and RIB_DRAIN in a local copy of the mean and assert it is
NOT 1.0 (proves the mean check can read worse).

## Contract
OWNS: scripts/rules/LiverRibs.gd, tests/liver_ribs_test.gd
RED_TEST: tests/liver_ribs_test.gd -> LIVER_RIBS failures=0
REGRESSION: body_map_test, injury_roll_test (read-only neighbours; nothing calls LiverRibs yet)
VISUAL: no
NOT YOURS: every other file. No preloads in LiverRibs.gd. Under 500 lines each.
Runs only through `python ops/Tools/godot_slot.py run --who liverribs2 -- <godot> --headless --audio-driver Dummy --path . --script res://tests/liver_ribs_test.gd`.
PR body: `RESULT: tests/liver_ribs_test.gd -> LIVER_RIBS failures=0`.

## Prior research
ops/research/DESIGN_LIVERRIBS1_V2_REVISE_KALLI_KALLI.md (sections 3, 7), its critics DESIGN_LIVERRIBS1_V2_CRITIC_JOHN_JOHN.md
and _MARIA_MARIA.md; scripts/rules/BodyMap.gd (band words), scripts/rules/InjuryRoll.gd (rib injury today).
## What would a human do?
A cutman knows a liver shot folds you tonight and is gone tomorrow; a cracked rib costs weeks.
## Prefab check
None: our own rules from the approved map.
## The one trap
GDScript: no `:=` on Variant (Dictionary.get) - type it (ops/research/GDSCRIPT_TRAPS.md).
