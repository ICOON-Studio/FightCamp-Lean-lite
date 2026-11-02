# TASK INSIDEBEATS1 - QWEN - when the boxers fight inside, and what they throw there (Lean, inside range)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_INSIDEBEATS1 (branch qwen/insidebeats1). Commit there; do not push.

## Why
Real women's amateur finals spend 17-31 % of a round at inside range (pelvis to pelvis under 0.65 m: hooks, uppercuts,
heads close) - our own footage study, `research/S310_REAL_FIGHT_GAPS.md` in the old repo. Our 3D fight is inside
only 5 % of a round (the clinches). John (J_INSIDE1_JOHN.md) found no published time share; the footage stays the anchor,
and his reading of the papers: boxers go inside on purpose behind an attack, throw hooks and uppercuts there, leave by a
step out or a clinch, and pressure fighters work inside far more than out-boxers.
You write ONE pure module that decides WHICH bursts of punches are fought inside, how long each inside spell lasts, and
turns some straight punches in a spell into hooks/uppercuts. Claude wires it into the 3D view - not your job.

## The beats you get (read `scripts/fight3d/ExchangeBeats.gd` build/_show_game/_body and `scripts/rules/RoundScript.gd`,
`scripts/rules/BurstShape.gd`, `scripts/rules/ClinchBeats.gd` - same beat format and the same style of module)
One exchange = an Array of beats, each `{"t": float seconds 0..30 (sorted ascending), "who": "a"|"b", "move": String,
"result": "lands"|"blocked"|"misses"|"none", "caption": String, ...}`; some carry "combo": true, "combo_id", "big": true.
Punch moves: jab, cross, lead_hook, body_hook, rear_uppercut. Build test exchanges the way
`tests/clinch_beats_test.gd` and `tests/burst_shape_test.gd` do (RoundScript.build + BurstShape.apply).

## Owned files (create both; touch nothing else)
- `scripts/rules/InsideBeats.gd` (new, under 200 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/inside_beats_test.gd` (new, `extends SceneTree`, same shape as `tests/clinch_beats_test.gd`; it MAY preload
  RoundScript and BurstShape to build exchanges; prints `INSIDE_BEATS failures=<n>`; quit(1 if failures else 0))

## The module
```
## A burst = punch beats each less than BURST_GAP_S after the one before (RangeBreath.BURST_GAP_S).
const BURST_GAP_S := 1.4
## Share of an exchange's time fought inside, before the situation multiplier (real 17-31 % of a round including
## clinches ~4 %; this is the rest).
const SHARE := 0.15
const SIT_MULT := {"press": 1.6, "range": 0.35, "counter": 0.7, "loadup": 0.8, "tiring": 1.2, "she_tired": 1.2,
	"hurt": 1.2, "she_hurt": 1.2}
const LEAD_S := 0.38                 # the step in starts this long before the burst's first punch
const LINGER_S := Vector2(0.8, 1.6)  # they stay inside this long after its last punch
const SPELL_S := Vector2(1.5, 6.0)   # a spell's length, min / max
## Inside, a straight is thrown as a hook or uppercut this often (real inside work is hooks and uppercuts; across the
## whole bout straights stay about half of all punches - Davis 2015: 53 % straights, 40 % hooks, 7 % uppercuts).
const TURN := 0.65
## Marks inside spells in one exchange (in place, kept sorted) and returns the inserted beats.
## ctx = {"sit": the exchange's situation (Exchanges.MODES keys, as in ClinchBeats)}
static func apply(beats: Array, ctx: Dictionary, rng: RandomNumberGenerator) -> Array
```
An inside beat: `{"t": first punch t - LEAD_S, "who": the boxer who steps in, "move": "inside", "result": "none",
"caption": "", "end_t": spell end}`.
Rules:
1. Which bursts: walk the bursts in random order and pick bursts until the picked spells' total length reaches
   SHARE x SIT_MULT[sit] (1.0 when the sit is not listed) x 30 s; a burst whose spell would push the total past 1.5x
   that target is skipped. Combinations may be fought inside; only the turning rule (4) leaves them alone.
2. Spell window: start = first punch t - LEAD_S, end = last punch t + rng LINGER_S, length clamped to SPELL_S (cut the
   linger, never move a punch). The window must lie in 0.5..29.0 s and must not overlap another spell or contain a
   "clinch" beat or a clinch's break_t (ClinchBeats may already have run - handle both orders); else skip that burst.
3. Who steps in: in "press" the presser ("b"); otherwise the boxer who throws the burst's first punch.
4. Turning: inside a spell, each jab -> lead_hook and each cross -> rear_uppercut (half the time) or lead_hook (the
   other half), with probability TURN - only for beats with no "combo", no "combo_id", no "big". Never touch
   body_hook beats (the fight display counts them), never change "who", "t" or "result" of any beat.

## Tests (all must pass; 300 seeds per case; rounds n = 1, 2, 3)
1. Every punch beat keeps its who, t and result; the number of body_hook beats per boxer is unchanged; combo/big beats
   keep their move. (Write this first and see it fail: module missing.)
2. Beats stay sorted; every inside spell lies in 0.5..29.0, is 1.5..6.0 s long, overlaps no other spell and holds no
   clinch beat or break_t (run ClinchBeats.apply AFTER InsideBeats in half the seeds, BEFORE in the other half).
3. Inside time share over a round of 6 exchanges with the realistic situation mix (press 0.35, range 0.25, counter 0.15,
   loadup 0.1, tiring 0.1, hurt 0.05): mean in 0.10..0.22 of the round.
4. "press" exchanges spend at least 3x the inside time of "range" exchanges.
5. Inside spells, hooks + uppercuts are at least 55 % of the punches; over the whole round straights (jab + cross)
   stay at least 35 % of all punches.
6. In "press" exchanges "b" is the one who steps in for every spell.
7. Same seed, same input -> same output.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/inside_beats_test.gd
```
NEVER the `_console.exe`. Output must show `INSIDE_BEATS failures=0` and no `SCRIPT ERROR`. A script error in
`_initialize` HANGS the run: if there is no output in 60 s, kill it and fix the error. Parse gate first:
`... --headless --path . --check-only --script res://scripts/rules/InsideBeats.gd`. Also run `tests/clinch_beats_test.gd`
and `tests/burst_shape_test.gd` the same way (must stay green). Do NOT tune SHARE / SIT_MULT / TURN to pass a bound:
if a bound fails with these numbers, say so in your final answer with the measured value.

## Contract
OWNS: scripts/rules/InsideBeats.gd, tests/inside_beats_test.gd   (Lean repo)
RED_TEST: tests/inside_beats_test.gd -> INSIDE_BEATS failures=0
REGRESSION: clinch_beats_test, burst_shape_test
VISUAL: no (Claude wires it into the 3D view - inside range, heads past shoulders - and checks the probe + stills)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: write `var m: String = str(b["move"])`. Array.insert
shifts indices: collect the new beats and append + sort once at the end. A multi-line lambda inside a call hangs the
parser in this repo - use a named static func. Do not name a variable `free` or reuse a loop variable name in one scope.

## Prior research
`python Tools/prior_research.py inside range pocket infighting` (old repo): S310_REAL_FIGHT_GAPS.md (footage: inside
17/20/31 %, punches 2-5 a burst), S4J_BOXMIND_DISTANCE.md (elite close+mid punch share 28.5-39 %), J50 (jam / smother
and clinch as defences), J_INSIDE1_JOHN.md (no published time share; Davis 2015 punch mix; weight class and style matter
more than the round).

## What would a human do?
A boxing analyst charting a bout marks each exchange long / mid / inside with a stopwatch: a pressure fighter walks in
behind her jab and stays to dig hooks and uppercuts until one steps out or they tie up; an out-boxer jabs at range and
rarely stays inside.

## Prefab check
Nothing to buy: a pure module over our own beat format.

## When done
Commit both files on qwen/insidebeats1, message ending `RESULT: tests/inside_beats_test.gd -> INSIDE_BEATS failures=0`,
and paste the last 20 lines of all three test runs in your final answer.
