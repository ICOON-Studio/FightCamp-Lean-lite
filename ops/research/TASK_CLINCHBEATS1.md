# TASK CLINCHBEATS1 - QWEN - when the two boxers clinch, and when the referee breaks them (Lean, real-fight gap 4)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_CLINCHBEATS1 (branch qwen/clinchbeats1). Commit there; do not push.

## Why
Real amateur bouts clinch 2.5 -> 3.2 -> 4.8 times a round (rounds 1-3), about 4 s each, rising as the boxers tire; the
referee steps in and they part to long range. Our 3D fight never clinches (`research/S310_REAL_FIGHT_GAPS.md`
in the old repo, row "Clinch"). The operator chose to build it ourselves (board Q-S294-22: "Build it free").
You write ONE pure module that decides WHEN clinches happen inside one 30 s exchange and how long each lasts. Claude
wires it into the 3D view (the tie-up pose and the referee) - not your job.

## The beats you get (read `scripts/fight3d/ExchangeBeats.gd` build/_show_game and `scripts/rules/RoundScript.gd`)
One exchange = an Array of beats, each `{"t": float seconds 0..30 (sorted ascending), "who": "a"|"b", "move": String,
"result": "lands"|"blocked"|"misses"|"none", "caption": String, ...}`. Punch moves = `RoundScript.PUNCHES`
(jab, cross, lead_hook, body_hook, rear_uppercut); the rest (step_in, step_out, slip, clinch, tired, count, say) are not
punches. Build test exchanges with `RoundScript.build(rl, "Out-boxer", "Pressure fighter", 30.0, seed)` where
rl = {"n": 1..3, "won": bool, "mine": 60.0, "theirs": 0.0, "corner": "", "lines": [], "names": ["Lucy", "Maria"]}
and take `["beats"]`.

## Owned files (create both; touch nothing else)
- `scripts/rules/ClinchBeats.gd` (new, under 200 lines, `extends RefCounted`, static functions only, ZERO preloads -
  pass the punch list in, or copy the five punch ids into a const)
- `tests/clinch_beats_test.gd` (new, `extends SceneTree`, same shape as `tests/round_style_test.gd`; it MAY preload
  RoundScript to build exchanges; prints `CLINCH_BEATS failures=<n>`; quit(1 if failures else 0))

## The module
```
## Real numbers (Davis et al. 2015, elite amateur 3x3 min; 2023 women's WC finals 4.06 +- 2.27 s a clinch):
const PER_ROUND := [2.5, 3.2, 4.8]       # clinches a 3:00 round, rounds 1, 2, 3+ (round 4+ uses the last)
const DUR_MEAN_S := 4.1
const DUR_SD_S := 2.3
const DUR_MIN_S := 1.5
const DUR_MAX_S := 8.0
const BREAK_S := 0.8                      # referee "break": both step back before the next punch
## Inserts clinch beats into one exchange (in place, kept sorted) and returns them.
## ctx = {"n": round 1..12, "sit": the exchange's situation (Exchanges.MODES keys: press, range, counter, loadup,
##        tiring, hurt, she_tired, she_hurt), "energy": {"a": 0..100, "b": 0..100}, "habits": {"a": [ids], "b": [ids]}}
static func apply(beats: Array, ctx: Dictionary, rng: RandomNumberGenerator) -> Array
```
A clinch beat: `{"t", "who": the boxer who ties up, "move": "clinch", "result": "none", "caption": "", "dur": seconds,
"break_t": t + dur}` followed by TWO beats at break_t: `{"t": break_t, "who": "a", "move": "step_out", "result": "none",
"caption": "", "ref": true}` and the same for "b" (the referee parts them, both step back to long range).
Rules:
1. How many: on average PER_ROUND[n] / 6 clinches per exchange, scaled by the situation (more when someone is hurt or
   tired, more when pressing - the presser closes the distance - fewer at long range). You pick the multipliers; the
   tests below bound the result. Never more than 2 in one exchange.
2. Who ties up: the hurt or tired one in hurt/she_hurt/tiring/she_tired ("she_*" = "a", hurt/tiring = "b"); otherwise
   the one who just took a landed punch, else either. A boxer with habit "clinches_when_tired" whose energy is under 50
   clinches twice as often.
3. Length: normal(DUR_MEAN_S, DUR_SD_S) clamped to DUR_MIN_S..DUR_MAX_S.
4. Where: only in a window [t, t + dur + BREAK_S] with NO punch beat inside it and inside 0.5..29.0 s. Prefer right
   after a landed punch (a boxer who is hit grabs). If no window fits, shorten the clinch to fit (never below
   DUR_MIN_S) or skip it. Never move or delete an existing beat; never change any "result".

## Tests (all must pass; 300 seeds per case; exchanges built as above, rounds n = 1, 2, 3)
1. RoundScript.landed-style count: every punch beat (who, move, result, t) is still there and unchanged after apply.
2. Beats stay sorted by "t"; every clinch window [t, break_t + BREAK_S] holds no punch beat; 0.5 <= t and break_t <= 29.5.
3. Average clinches per ROUND (6 exchanges, with a realistic mix of situations: press 0.35, range 0.25, counter 0.15,
   loadup 0.1, tiring 0.1, hurt 0.05): round 1 in 1.5..4.0, round 3 in 3.0..6.5, and round 3 > round 1 + 1.0.
4. Mean clinch duration 3.0..5.5 s; none outside DUR_MIN_S..DUR_MAX_S.
5. "hurt" exchanges clinch at least twice as often as "range" exchanges; the hurt one ("b" in hurt) is the holder in
   >= 70 % of hurt clinches; "she_hurt" -> "a" in >= 70 %.
6. clinches_when_tired: with habits {"a": ["clinches_when_tired"]} and energy a = 40, "a" ties up more often than
   without the habit (same seeds); with energy a = 90 the habit changes nothing.
7. Each clinch is followed by exactly two "ref" step_out beats at its break_t, one per boxer.
8. Same seed, same input -> the same output (determinism).
Write test 1 first and see it fail (the module missing), then build the module.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/clinch_beats_test.gd
```
NEVER the `_console.exe`. Output must show `CLINCH_BEATS failures=0` and no `SCRIPT ERROR`. A script error in
`_initialize` HANGS the run (quit is never reached): if there is no output in 60 s, kill it and fix the error.
Parse gate first: `... --headless --path . --check-only --script res://scripts/rules/ClinchBeats.gd`.
Also run `tests/round_script_test.gd` the same way (must stay green).

## Contract
OWNS: scripts/rules/ClinchBeats.gd, tests/clinch_beats_test.gd   (Lean repo)
RED_TEST: tests/clinch_beats_test.gd -> CLINCH_BEATS failures=0
REGRESSION: round_script_test
VISUAL: no (Claude wires it into FightView with the tie-up pose and the referee, and checks a film)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: write `var m: String = str(b["move"])`. Array.insert
shifts indices: collect the new beats and append + sort once at the end. A multi-line lambda inside a call hangs the
parser in this repo - use a named static func.

## Prior research
`python Tools/prior_research.py clinch referee break` (old repo): K38_THE_CLINCH_BY_SPORT.md (Davis 2015 counts and
totals, 2023 women's WC 4.06 +- 2.27 s), J38_THE_CLINCH_BREAK.md (what breaks a clinch: the referee's call; no rule
clock), J14_THE_REFEREE.md, topics/clinch.md; S310_REAL_FIGHT_GAPS.md row "Clinch" (filmed: R1 1:14 chest-to-chest
tie-up, R1 5:22.9 heads together + referee parts them). Lean assets/data/fight_habits.json "clinches_when_tired".

## What would a human do?
An amateur referee: lets a clinch run while either boxer is working, calls "Break!" after a few seconds of holding, and
both take a step back before boxing on. A tired or hurt boxer grabs right after taking a shot; the fresher one, often
the presser, walks into it.

## Prefab check
Nothing to buy for the rules: a pure module over our own beat format. The 3D tie-up (no two-boxer clinch clip is sold:
Fab, MoCap Online, Reallusion checked, S311) is built by Claude from our own clips - not in this task.

## When done
Commit both files on qwen/clinchbeats1, message ending `RESULT: tests/clinch_beats_test.gd -> CLINCH_BEATS failures=0`,
and paste the last 20 lines of both test runs in your final answer.
