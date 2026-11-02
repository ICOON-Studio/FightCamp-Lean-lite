# TASK COUNTERWIN1 - the counter window: a boxer is easier to hit while he punches (boxing, pure rules module)

Model: Arena (cloud). Discipline: BOXING (demo). Fast lane: ADD ONLY the two new files below, touch nothing else.

## Why
Operator board answer Q-S249-5 (S255), question "Ludo wants a counter window: a boxer is easier to hit while he punches (longer when
tired or less skilled). Build it?" -> "Build it". Design: Ludo r119 (PRODUCTION_ROADMAP_S254.md "PUNCH FEEL"): window from
hitbox_on - 0.05 s to control return; inside it the puncher's evasion = 0, hits on him +25% crit chance, +20% rocked chance;
length x (1 + (100 - technique)/200) x (1 + fatigue/100 x 0.40). Claude wires it into the fight's evasion/crit route
(`Godot/scripts/rules/FightLink.gd`, `FightDefenceModel.gd`) afterwards - you write only the module + its test.

## Files you create (only these)
1. `Godot/scripts/rules/CounterWindow.gd` - `extends RefCounted`, ALL functions `static`, NO preloads, NO autoloads, NO RNG,
   no class_name, no argument modified.
2. `Godot/tests/counter_window_test.gd` - `extends SceneTree`, `OK  <label>` / `FAIL <label>` lines, ends with
   `print("COUNTER_WINDOW failures=%d" % failures)` and `quit(0 if failures == 0 else 1)`.

## CounterWindow.gd API
- consts: `LEAD_S = 0.05`, `TECH_DIVISOR = 200.0`, `FATIGUE_WEIGHT = 0.40`, `CRIT_BONUS = 0.25`, `ROCKED_BONUS = 0.20`,
  `EVASION_INSIDE = 0.0`, `MAX_LENGTH_MULT = 1.8` (cap so a 0-technique exhausted boxer is not open for ever: 1.5 x 1.4 = 2.1 -> 1.8).
- `static func length_mult(technique: float, fatigue: float) -> float` - technique and fatigue clamped to 0..100;
  (1 + (100 - t)/TECH_DIVISOR) x (1 + f/100 x FATIGUE_WEIGHT), capped at MAX_LENGTH_MULT. technique 100 + fatigue 0 = 1.0.
- `static func window(hitbox_on_s: float, control_return_s: float, technique: float, fatigue: float) -> Dictionary` ->
  `{"open_s", "close_s", "length_s"}` on the punch's own clock: open = max(0, hitbox_on - LEAD_S); base = control_return - open
  (>= 0); length = base x length_mult; close = open + length.
- `static func is_open(t_s: float, win: Dictionary) -> bool` - open_s <= t < close_s.
- `static func apply(t_s: float, win: Dictionary, defence: Dictionary) -> Dictionary` - defence = `{"evasion", "crit_chance",
  "rocked_chance"}` (fractions 0..1) of the PUNCHER being hit; returns a NEW dict: inside the window evasion = EVASION_INSIDE,
  crit_chance + CRIT_BONUS, rocked_chance + ROCKED_BONUS, each clamped 0..1, plus `"countered": true`; outside, a copy with
  `"countered": false`.
- Every number is a `const`; the test reads the consts, never the literals.

## The test (from this contract, not from your code)
- length_mult(100, 0) == 1; (0, 0) == 1.5; (100, 100) == 1.4; (0, 100) == MAX_LENGTH_MULT; out-of-range inputs clamp;
- monotonic: lower technique or higher fatigue never shortens the window (sweep step 10);
- window(0.25, 0.37, 100, 0): open 0.20, close 0.37; hitbox_on 0.02 -> open 0.0 (never negative);
- control_return before open -> length 0 and is_open false everywhere;
- is_open flips exactly at open_s (true) and close_s (false);
- apply inside: evasion 0, crit +0.25, rocked +0.20, clamped at 1.0 for crit 0.9; apply outside: values unchanged; input dict unchanged.
- Mutants: say in the PR body which two consts you nudged and that the test went red.

## Prior research
`python Tools/prior_research.py counter window`: FIGHTLINK_DIRECTION_S248.md (a whiff opens a counter window - idea only),
J50_HOW_A_DEFENDER_DEFENDS.md, TASK_Q215_BOXING_DEFENCE_AND_COUNTERS.md (counter techniques, not exposure timing). No existing module.

## What would a human do?
Every coach says "you're open when you punch": the chin is up and the hands are away while the arm is out, and a tired or sloppy
fighter leaves it out longer. Counter-punchers live in that gap.

## Prefab check
No boxing counter-timing library exists. Pure GDScript, no assets.

## Contract
OWNS: Godot/scripts/rules/CounterWindow.gd, Godot/tests/counter_window_test.gd
RED_TEST: Godot/tests/counter_window_test.gd -> COUNTER_WINDOW failures=0
REGRESSION: counter_window_test
VISUAL: no
