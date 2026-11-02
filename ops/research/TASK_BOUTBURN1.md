# TASK BOUTBURN1 - QWEN - each body part's burn round by round, from the settled bout (Lean, update 29 body report)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_GYMBILLS1 (branch qwen/boutburn1). Commit there; do not push.

## Why
The post-fight body report (BodyReport.report, on main) needs, per round, how burnt each of her six parts was at the bell.
The 3D fight computes that from its beats (scripts/fight3d/BodyBurn.gd -> BodyLoad.add_exchange), but most bouts are not
watched: the words-mode bout only keeps each exchange's settled record. This module rebuilds the same numbers from those
records through the SAME BodyLoad rules, so watched and unwatched bouts read alike. Claude wires it into the result page.

## Owned files (create both; touch nothing else)
- `scripts/rules/BoutBurn.gd` (new, under 150 lines, `extends RefCounted`, static functions only; preloads ONLY
  `res://scripts/rules/BodyLoad.gd` and `res://scripts/rules/BodyRates.gd` - read both, change neither)
- `tests/bout_burn_test.gd` (new, `extends SceneTree`, same shape as `tests/body_report_test.gd`; prints
  `BOUT_BURN failures=<n>`; quit(1 if failures else 0))

## The input (what the game keeps after a bout)
`rounds`: Array, one Dictionary per round in order, each with `"exchanges"`: Array of exchange records
`{"sit": String, "pace": "push"|"steady"|"save", "landed": [her_landed: int, opp_landed: int]}` (other keys may exist -
ignore them). `stats`: her stats Dictionary (keys power, hand_speed, technique, defence, conditioning, ring_iq, chin, 0-100).
`style`: her style String ("" allowed). Pass both straight to `BodyRates.of(stats, style)`.

## The module
```
const LAND_RATE := 0.33        # amateur punches landed / thrown (CompuBox-style connect rate) - thrown = ceil(landed / LAND_RATE)
const MIX := [["jab", 0.50], ["cross", 0.25], ["lead_hook", 0.13], ["body_hook", 0.06], ["rear_uppercut", 0.06]]
const EX_SECONDS := 30.0       # one exchange = 30 s of the 3:00 round

## The beats one exchange stands for, for BodyLoad: her thrown punches spread evenly over the exchange,
## moves dealt in MIX proportion by largest remainder (ties: MIX order), each {"who": "a", "move": m, "t": t_s}, t from 0 at
## even spacing (EX_SECONDS / (thrown + 1) apart, first at one spacing). landed 0 -> thrown 0 -> [].
static func beats_of(exchange: Dictionary) -> Array

## Per round, her six parts' burn (BodyLoad.burn(load, "a", part), 0-100) at that round's bell, BEFORE the minute's rest:
## [{"lead_shoulder": v, "rear_shoulder": v, "lead_arm": v, "rear_arm": v, "core": v, "legs": v}, ...] (rounds.size() entries).
## One BodyLoad.fresh() for the bout; per exchange BodyLoad.add_exchange(load, beats_of(x), {"sit": x.sit,
## "pace": {"a": x.pace}, "tank": {"a": 100.0}, "rates": {"a": BodyRates.of(stats, style)}}); after each round's snapshot,
## BodyLoad.rest(load, {"a": 0.8 + 0.4 * conditioning / 100}, {}, {}) before the next round.
static func per_round(rounds: Array, stats: Dictionary, style: String) -> Array
```
Read BodyLoad.add_exchange / rest / burn first and match their real signatures; if one differs from the above, follow the
real one and say so in your final answer.

## Tests (all must pass)
1. Write this first and see it fail (module missing): per_round([], {}, "") == [].
2. beats_of({"landed": [0, 3]}) == []; beats_of({"landed": [10, 0]}) has 31 beats (ceil(10 / 0.33) = 31), every "who" == "a",
   t strictly increasing, all t < 30.
3. Move mix of 31 thrown: jab 16, cross 8, lead_hook 4, body_hook 2, rear_uppercut 1 (largest remainder; check it sums to 31).
4. One round of six exchanges at landed [8, 4], steady: 1 entry, 6 parts, every value 0-100, lead_shoulder > 0, legs > 0.
5. Busier is hotter: the same round with landed [16, 4] gives a higher lead_shoulder and rear_arm than with [4, 4].
6. Pace: "push" on every exchange gives higher lead_shoulder than "save" (same landed).
7. Rounds add up: three identical rounds -> 3 entries; legs in round 3 >= legs in round 1 (rest recovers only part).
8. Conditioning: conditioning 90 gives a round-2 legs value <= conditioning 30's (better rest).
9. Same input -> same output; rounds/stats not mutated.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/bout_burn_test.gd
```
Use exactly that exe (never the console variant). Output must show `BOUT_BURN failures=0` and no `SCRIPT ERROR`. No output in
60 s = a script error. Regression (must stay green): `tests/body_load_test.gd` and `tests/body_report_test.gd`.
Read `E:\FightCamp\Game\research\GDSCRIPT_TRAPS.md` first (Variant `:=`, `%%`, integer division).

## Prior research
Lean `scripts/rules/BodyLoad.gd` (the part-burn rules the 3D view uses), `scripts/fight3d/BodyBurn.gd` (how the view feeds it -
read only), `scripts/rules/BodyReport.gd` (what consumes the result). Game `research/MAKE_IT_A_GAME_PLAN_S323.md`
decision 5 "THE FIGHT TEACHES THE GYM".

## What would a human do?
A coach reviewing the fight tape counts what she threw each round and watches when her shoulders and legs went; the
connect rate (about a third of punches land at amateur level) turns landed counts back into work done.

## Prefab check
Nothing to buy: glue over our own BodyLoad rules.

## Contract
OWNS: scripts/rules/BoutBurn.gd, tests/bout_burn_test.gd (Lean repo)
RED_TEST: tests/bout_burn_test.gd (fails before the module exists - test 1)
REGRESSION: tests/body_load_test.gd, tests/body_report_test.gd
VISUAL: none (pure rules)

## When done
Commit both files on qwen/boutburn1, message ending `RESULT: tests/bout_burn_test.gd -> BOUT_BURN failures=0`, and paste the
last 25 lines of the test run in your final answer. Leave this brief uncommitted.
