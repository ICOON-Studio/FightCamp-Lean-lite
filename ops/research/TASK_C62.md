# TASK C62 — CODEX — CAN A REAL-TIME FIGHT STILL REPLAY?

**Model:** Opus-class / your strongest · high effort. This is the finding that
decides whether the whole direction is buildable.

**Research only. You write no `.gd` and you change no behaviour.**

## The decision behind this

Operator ruling 2026-09-09: **the fight becomes real time** — damage, movement
and everything else resolved continuously, not in one lump per exchange. This
overturns C17 Q1 ("the atomic exchange stands") and Q3 ("no saved position"),
both of which were answered only hours earlier. C17 **Q2 survives**: one clock,
and it is the simulation's.

## What is true today (verify, do not trust this summary)

- `FightSimulation.advance_exchange()` resolves ONE deterministic
  14-fight-second outcome. `AVG_SECONDS_PER_EXCHANGE` is 14, so a 3x5 bout is
  roughly 64 exchanges.
- `_build_fighter_state` (`:859`) stores **no** coordinates, distance, facing,
  velocity or collision. Range is a five-value BAND enum, not a number.
- `run_to_completion()` is the render-free path the whole suite depends on.
- Seeded replay is a hard, tested contract: `{"burst": false}` must reproduce a
  fight byte-identically, winner and method included
  (`fight_simulation_test.gd::_test_burst_never_moves_the_fight`), and
  `judge_panel_test.gd` pins ten scorecards.

## The three questions, in priority order

1. **Does seeded replay survive a fixed step?** A real-time core accumulates
   float state over tens of thousands of ticks instead of ~64. Say plainly
   whether byte-exact replay is still achievable, what it costs (fixed
   timestep + accumulator? quantised or integer math? a replay log of inputs
   rather than state?), and where it breaks. **If the answer is no, say so —
   that is the finding that sends this back to the operator rather than
   forward.**
2. **Does the suite still run?** Cost out `run_to_completion()` at candidate
   tick rates (say 10 / 20 / 60 Hz) against today's ~64 exchanges. 192 tests
   run today; many simulate whole fights. Give measured or clearly-reasoned
   numbers, not adjectives. Name the tick rate you would pick and why.
3. **What is the migration?** 192 tests and a save format assume atomic
   completion. Is there a path where the real-time core produces the SAME
   event log shape (so `BroadcastRead`, `PostFightRead`, `JudgePanel` and the
   burst contract keep working) and the atomic API becomes a wrapper? Name the
   test files that must change either way.

## Owned files

- `research/C62_REAL_TIME_DETERMINISM.md` — new, the report.
- `research/C62_DIGEST.md` — new, short.

**Do NOT touch** `Godot/scripts/FightSimulation.gd` or any test. Cursor owns
U20, Qwen owns Q13, Grok owns G28 — none of them touch what you touch.

## Anchors, so you never open the big file whole

`Godot/scripts/FightSimulation.gd` is **2,977 lines — never read it whole.**
`:379` `begin_fight`, `:859` `_build_fighter_state`, `:3160` `_write_burst`,
and grep `run_to_completion` for the render-free path.

## The trap

Do not design the real-time core. Three people will build it and they need to
know what is POSSIBLE, not your preferred shape. A recommendation is welcome in
one section at the end; the body of the report is evidence and cost.

## Gate

Ceiling, not a floor: this is research, so there is no suite gate. If you run
anything, `python Godot/tools/run_tests.py` must still read `fails=0`.
