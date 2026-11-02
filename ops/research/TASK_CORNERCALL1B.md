# TASK CORNERCALL1B (S227) - MEASURE what each corner call does to the next round, with REAL seeded fights (Arena)

Seat: Arena (cloud). Own branch `arena/<chat-id>-fightcamp` + PR into master; never merge, never master. Everything sent is PUBLIC.
CI has NO LFS: use only the pure fight sim (`Godot/scripts/FightRealtime.gd` static functions) - no .glb, no 3D, no FightStagePlayer.
FightRealtime.gd is ~6,500 lines: read only the windows named below (`sed -n a,bp`). Never delete or loosen a test.

## Why (approved)
Operator Q-S221-5 "Approve, build it" (LUDO_ROUND63_VERDICT_S224.md F): "Every effect on the NEXT round is MEASURED with seeded bouts
(called vs not), like CAMPPAY1 - Ludo's '+40% counter' style numbers are not used." Two earlier rounds on another seat were rejected:
the numbers were typed into a JSON by hand and the "measurement" drew random numbers ("simulated control noise"). This task is the
measurement AS CODE.

## The engine API you use (all static on FightRealtime; read these windows)
- `begin(fighter_a, fighter_b, options)` ~1264 - options `{"seed": int, "rounds": 3, "ruleset": ..., "player_corner": "a"}`.
- `advance_tick(state)` ~2514, `round_number(state)` ~2498, `run_to_completion(state)` ~2714.
- `pending_pit_stop(state, side)` and `apply_player_corner(state, side, picks, pace, rolls=[])` ~3063: with player_corner "a" the
  engine stops at each break with a pending pit stop for side a; you choose the picks.
- The working example of exactly this loop: `Godot/tests/corner_pit_stop_test.gd` lines ~170-220 (begin -> advance to the break ->
  pending_pit_stop -> apply_player_corner). Copy its fighter construction (`pair` / ruleset) - two DIFFERENT fighters, same weight
  class, legal for the ruleset (house rule: never identical fighters; print both names + weight class in the output).
- The call ids and their targets: `Godot/scripts/CornerPitStop.gd` (cards / apply) and `Godot/assets/data/ludo_corner.json` lanes.

## Build: `Godot/tests/corner_call_effect_test.gd` (new) + optional `Godot/tools/corner_call_measure.gd` it calls
For each call id C the corner offers (cutman cut work, swelling/ice, vaseline, water/stool recovery, nose-blow, each chief read):
1. For seed s in 40 seeds: `begin` with player_corner "a", advance ticks until `pending_pit_stop(state, "a")` is non-empty at the
   END OF ROUND 1. Duplicate the state (`state.duplicate(true)`; re-create any RandomNumberGenerator in it with the same seed+state -
   check how `_stream` / `_rng_corner` are stored and copy them so both arms draw identically).
2. Arm CALLED: `apply_player_corner(copy1, "a", [C], "normal")`. Arm NOT: `apply_player_corner(copy2, "a", [], "normal")`.
3. Advance both arms to the end of round 2. Read from state["log"] / fighter dicts: side a landed %, damage taken, stamina at the bell,
   cut opened/reopened, heart rate (bpm) curve over the first 30 s of the corner/round, round won (the round's judges if available,
   else the round's landed-damage margin - say which).
4. Delta = CALLED - NOT per seed; mean, sample SD, 95% CI (1.96*SD/sqrt(n)), n. Print one line per call:
   `CORNER_CALL <id> metric=<m> mean=<x> ci=[lo,hi] n=40 fighters=<a> vs <b> (<weight class>)`.
5. CONTROL: both arms apply [] - every delta must be exactly 0.0 (identical states, identical draws). If it is not 0, the fork is wrong
   - fix the fork, do not widen a band. MUTANT: a call id whose effect you zero out (a test-only hook, or a call that does nothing)
   must measure 0 and FAIL "effect present" - prove the instrument can read worse.
6. Write `Godot/assets/data/corner_call_effects.json` FROM the run (the tool writes it; the test asserts the JSON equals what it just
   measured, rounded to 2 decimals). No hand-typed number anywhere.

## Acceptance (in the test, printed)
(a) each call whose code claims an effect shows it on its target metric with a CI excluding 0 - or the PR says it measured 0 and WHY
(is the effect applied to the fighter the sim reads in round 2?) and fixes that cause; (b) vaseline lowers next-round cut chance and
does NOT change damage taken; (c) the stool recovery drops bpm ~0.5 bpm/s front-loaded and capped; (d) control = exactly 0;
(e) mutant fails. Final line `CORNER_CALL_EFFECT PASS checks=N` or FAIL, quit(0|1). Paste the CI log lines in the PR body.

## The one trap
Forking before the break, or letting the two arms draw different random numbers, measures noise. Fork AT the break from one state,
change ONLY the call, and prove it with the exact-zero control.
