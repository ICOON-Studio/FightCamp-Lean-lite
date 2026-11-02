# TASK BURSTS1 - QWEN - punches come in bursts of 2-5, then a quiet spell (Lean, real-fight gap 6)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_BURSTS1 (branch qwen/bursts1). Commit there; do not push.

## Why
Real amateur bouts throw punches in bursts: 2-5 punches is the most common sequence, then a quiet spell of several
seconds at range (`research/S310_REAL_FIGHT_GAPS.md` in the old repo, row "Punches per exchange" and fix 6).
Ours throws an even tempo of single shots: median 1 punch a burst, 54 % single shots, a burst every 1.7 s, 71 bursts a
round. The round's punch TOTAL already matches real (~20 a minute), so only the GROUPING changes, not the count.
You write ONE pure module that re-times the beats of one 30 s exchange into real bursts. Claude wires it into the game.

## The beats you get (read `scripts/rules/RoundScript.gd` and `scripts/fight3d/ExchangeBeats.gd` build)
One exchange = an Array of beats sorted by "t" (seconds 0..30): `{"t": float, "who": "a"|"b", "move": String,
"result": "lands"|"blocked"|"misses"|"none", "caption": String, ...}` and optional keys you must carry unchanged:
"big", "combo" (bool), "combo_id" (String), "habit" (String), "def", "knockback". Punch moves = `RoundScript.PUNCHES`
(jab, cross, lead_hook, body_hook, rear_uppercut); everything else (step_in, step_out, slip, tired, count, say) is not
a punch. Build test exchanges with `RoundScript.build(rl, "Out-boxer", "Pressure fighter", 30.0, seed)` where
rl = {"n": 1..3, "won": bool, "mine": 3.0 | 10.0 | 20.0, "theirs": 0.0, "corner": "", "lines": [], "names": ["Lucy", "Maria"]}
and take `["beats"]`.

## Owned files (create both; touch nothing else)
- `scripts/rules/BurstShape.gd` (new, under 200 lines, `extends RefCounted`, static functions only, ZERO preloads -
  copy the five punch ids into a const)
- `tests/burst_shape_test.gd` (new, `extends SceneTree`, same shape as `tests/round_style_test.gd`; it MAY preload
  RoundScript to build exchanges; prints `BURST_SHAPE failures=<n>`; quit(1 if failures else 0))

## The module
```
## Real numbers: 2-5 punch sequences most common (Tokyo 2020 sequences, S310 [S5]); a new attack after a pause > 1 s
## (BoxMind); inactive spells 2.3 +- 1.8 s, about 7.6 a round longer than 4 s at 5.6 +- 1.7 s (time-motion, J28).
const SIZE_W := [0.15, 0.30, 0.25, 0.18, 0.12]   # burst of 1, 2, 3, 4, 5 punches
const IN_GAP_S := Vector2(0.28, 0.45)           # punch to punch inside a burst
const QUIET_S := Vector2(1.6, 6.5)              # between bursts (draw from a skewed spread: most 2-3 s, some 4-6 s)
const START_S := 0.8                             # nothing before this
const END_S := 27.0                              # the last beat at or before this (the verdict caption comes at 27.6)
## Re-times one exchange's beats (in place, kept sorted) and returns the bursts as [[beat indices], ...].
static func apply(beats: Array, rng: RandomNumberGenerator) -> Array
```
Rules:
1. Never add, delete or reorder beats; never change any key except "t". The punch ORDER (and who throws each) is
   the same before and after.
2. Group consecutive punches into bursts by SIZE_W. Punches that belong together stay in ONE burst and keep their
   own spacing (their original t differences, clamped to IN_GAP_S): a run of beats with the same non-empty "combo_id",
   or with "combo" true next to each other, and a beat with a "habit" key together with the punch right before it.
   A burst may hold punches from both boxers (an exchange of blows); a burst can be longer than 5 only when one combo
   alone is longer.
3. A non-punch beat keeps its place in the order: it rides with the punch AFTER it (same offset before that punch as
   it had, clamped to 0.2..1.2 s), or, after the last punch, 0.6 s after the previous beat. A "count" beat stays last.
4. Quiet spells between bursts fill the time so the whole exchange spans START_S..END_S: draw each quiet spell from
   QUIET_S, then scale ALL quiet spells by one factor so the last beat lands at END_S (factor clamped 0.6..1.6; if it
   still does not fit, compress the quiet spells but never below 1.1 s, and never compress inside a burst).
5. Determinism: same seed, same input, same output.

## Tests (all must pass; 300 seeds per case; rounds n = 1, 2, 3; margins close/clear/dominant)
1. Every beat is still there (same count), same order of punches (who, move, result), every key but "t" unchanged.
2. Sorted by "t"; first beat >= START_S - 0.001; last beat <= END_S + 0.001.
3. Burst sizes over all exchanges (a burst = punches less than 1.0 s apart): median 2 or 3; singles under 30 %;
   bursts of 2-5 at least 60 %. (Measure on the OUTPUT times, not on what apply returns.)
4. Bursts per exchange: mean 2.5..6 (ours today ~12; real ~4).
5. Quiet spells (gaps >= 1.0 s between punches): mean 2.0..4.5 s; at least one >= 4 s in 40 % of exchanges or more.
6. Combos: every run of beats with the same combo_id has all its punch-to-punch gaps <= IN_GAP_S.y + 0.001 after apply.
7. Habit beats: a beat with "habit" is <= IN_GAP_S.y + 0.001 after the punch before it (when it is a punch).
8. Same seed -> same output.
Write test 1 first and see it fail (the module missing), then build the module.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/burst_shape_test.gd
```
NEVER the console build. Output must show `BURST_SHAPE failures=0` and no `SCRIPT ERROR`. A script error in
`_initialize` HANGS the run (quit is never reached): if there is no output in 60 s, kill it and fix the error.
Parse gate first: `... --headless --path . --check-only --script res://scripts/rules/BurstShape.gd`.
Also run `tests/round_script_test.gd` the same way (must stay green; you do not touch RoundScript).

## Contract
OWNS: scripts/rules/BurstShape.gd, tests/burst_shape_test.gd   (Lean repo)
RED_TEST: tests/burst_shape_test.gd -> BURST_SHAPE failures=0
REGRESSION: round_script_test
VISUAL: no (Claude wires it into ExchangeBeats and films a round)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: write `var m: String = str(b["move"])`. Build the new
times in a separate Array and write them back at the end (do not re-time while you walk the beats). A multi-line
lambda inside a call hangs the parser in this repo - use a named static func.

## Prior research
`python Tools/prior_research.py punch sequence burst combination exchange` (old repo): J28_HOW_FIGHT_MOVES_FLOW.md
(inactive 2.3 +- 1.8 s; long inactives > 4 s avg 5.6 +- 1.7 s, ~7.6 a round; a new attack after > 1 s pause),
G49_THE_EXCHANGE.md (combinations ~half of offensive actions; burst ownership), U18 (Davis 2015 ~20 punches a minute),
Q40_THE_EXCHANGE_WE_HAVE.md (run-length measurement), S310_REAL_FIGHT_GAPS.md fix 6.

## What would a human do?
An amateur boxer works behind the jab: feints and steps at range for a few seconds, lunges in, throws two to four
punches (her drilled combination), the other answers or covers, and one steps out. Then they reset at range. A
choreographer timing a fight scene counts it the same way: beat-beat-beat ... pause ... beat-beat.

## Prefab check
Nothing to buy: a pure re-timing of our own beat format. No library times boxing beats.

## VISUAL GATE
Not this task (pure rules). Claude films a round after wiring it (tools/range_probe.gd) before it ships.

## When done
Commit both files on qwen/bursts1, message ending `RESULT: tests/burst_shape_test.gd -> BURST_SHAPE failures=0`,
and paste the last 20 lines of both test runs in your final answer.
