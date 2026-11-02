# TASK GUARDCLOCK1 - the guard keeps the actor's rhythm: which guard take, where in it, when to cross-fade (pure)

Model: Arena (cloud, FightCamp-lite). Discipline: BOXING (demo).

## Why (Claude S274, operator "fix !!!" on "the movement in the fight is not natural like in actionforge")
The fight's guard is a 2.0 s loop of the Rokoko FightingIdle take restarted after every punch (~31 clip switches per man
per 20 s). The fix (Ziva TASK_ROKOKOMOVES1 Part A): 2-4 LONG guard takes (8-12 s, not looped - the actor moves 38 deg in
0.5 s, no long window loops cleanly) that cross-fade into each other, and a guard that RESUMES where it would be had it
kept playing under the punch. This module is that clock - pure, so the player only asks it.

## What to write
`Godot/scripts/rules/GuardClock.gd` - `extends RefCounted`, PURE (static funcs, zero preloads, no file read, no RNG, no
argument modified). Header style of `Godot/scripts/rules/StepPicker.gd`.

State is a Dictionary the caller keeps: `{"take": int, "pos_s": float}` (which guard take, position in it).
Takes: `lengths: Array` of float seconds (each >= 2.0), `fade_s: float` (default 0.3).

1. `advance(state, lengths, dt, fade_s := 0.3) -> Dictionary` - the guard plays on for dt (whether or not it is on screen):
   pos += dt; when pos passes `length - fade_s` of the current take, the next take (take + 1) % n starts at 0 and the
   returned state carries `"fade_from": {"take": old, "pos_s": old_pos}` while the fade lasts (fade progress
   `"fade_t"` 0..1); after the fade only the new take remains. dt can be larger than a take (several wraps).
2. `resume(state, lengths, away_s, fade_s := 0.3) -> Dictionary` - where the guard comes back after a punch that lasted
   away_s: exactly advance(state, lengths, away_s) but without a fade pair in the result (a punch hides the change).
3. `at(state) -> Dictionary` - {"take": int, "pos_s": float, "fade_from"?: {...}, "fade_t"?: float} for the player.
4. `start(lengths, body_seed: int) -> Dictionary` - two fighters must not guard in lockstep: the start take and position
   come from body_seed deterministically (e.g. take = body_seed % n, pos = fposmod(body_seed * 0.618, 1) * (length - fade)).

## The test
`Godot/tests/guard_clock_test.gd` - `extends SceneTree`, preload the module only, `_check` + `print("GUARD_CLOCK failures=%d")`,
`quit(1 if failures > 0 else 0)`. Cases:
- lengths [10, 12, 9]: advance 3 s from {0, 0} -> {0, 3}; advance to 9.8 -> fade_from take 0, take 1 at 0.1 s, fade_t ~0.33;
  after 0.3 s more -> no fade_from;
- the last take wraps to take 0;
- advance(dt = 40 s) == forty advance(1 s) calls (same take, pos within 1e-6) - no drift;
- resume after 0.8 s away lands 0.8 s later, never a fade pair, and NEVER at pos 0 unless the arithmetic says so (the old
  restart bug: re-entry always at the take's first frame);
- start(lengths, 1) != start(lengths, 2), both deterministic, both inside the takes;
- a single take ([10]) fades into itself (take 0 at 0) - allowed;
- inputs unchanged (compare to duplicate(true)); empty lengths -> {} from every function.
RED on master (module missing), green with yours. PR body: one MUTANT proof (resume returns pos 0 -> which check goes red).

## Parse gate and tests
`python Godot/tools/check_scripts.py scripts/rules/GuardClock.gd tests/guard_clock_test.gd`;
`$GODOT --headless --path Godot --script tests/guard_clock_test.gd`. Pure - no LFS.
PR body: `RESULT: tests/guard_clock_test.gd -> GUARD_CLOCK failures=0`.

## Owned files
Godot/scripts/rules/GuardClock.gd (new), Godot/tests/guard_clock_test.gd (new). Nothing else.

## Prior research
TASK_ROKOKOMOVES1.md (Part A), FOOTWORK_CONTRACT_S274.md, J19_THE_JOINS.md (joins), K34_NBA2K_TRANSITIONS.md (blend lengths).

## What would a human do?
A fight-game animator keeps several long idle takes and cycles them with short cross-fades, and after an action returns to
the idle where the character would have been - never to its first frame.

## Prefab check
n/a - ~70 lines of clock arithmetic.

## The one trap
Never return position 0 on re-entry as a shortcut - that IS the restart we are removing.

## Contract
OWNS: Godot/scripts/rules/GuardClock.gd, Godot/tests/guard_clock_test.gd
RED_TEST: Godot/tests/guard_clock_test.gd -> GUARD_CLOCK failures=0
REGRESSION: guard_clock_test
VISUAL: no
