# TASK BODYREPORT1 - QWEN - the fight teaches the gym: the body report after each bout (Lean, update 29)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_GYMBILLS1 (branch qwen/bodyreport1). Commit there; do not push.

## Why
Operator S323 approved the make-it-a-game plan ("Build it"; `E:\FightCamp\Game\research\MAKE_IT_A_GAME_PLAN_S323.md`,
decision 5 "THE FIGHT TEACHES THE GYM"): after each bout a body report names the part that burned first ("her legs went in
round 2") with one click to set next week's training focus there; the next fight shows the difference. You write the ONE
pure module; Claude wires it into the result page and the fighter's plan.

## Owned files (create both; touch nothing else)
- `scripts/rules/BodyReport.gd` (new, under 140 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/body_report_test.gd` (new, `extends SceneTree`, same shape as `tests/training_load_test.gd`; prints
  `BODY_REPORT failures=<n>`; quit(1 if failures else 0))

## The input
`rounds`: an Array, one Dictionary per round in order (round 1 first): {part: burn 0-100 at that round's bell} with the part
keys of BodyLoad.PARTS: "lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm", "core", "legs" (a missing key = 0).

## The module
```
const PARTS := ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm", "core", "legs"]
const WENT_AT := 50.0   # a part "went" the first round its burn reaches this (BodyTrack's hot band)
const NAMES := {"lead_shoulder": "jab shoulder", "rear_shoulder": "power shoulder", "lead_arm": "jab arm",
	"rear_arm": "power arm", "core": "body", "legs": "legs"}
## Next week's training focus for the part that went (a stat key of Data.STATS): legs and body -> roadwork and circuits
## (conditioning); the jab side -> a cleaner, cheaper jab (technique); the power side -> strength (power).
const FOCUS := {"lead_shoulder": "technique", "lead_arm": "technique", "rear_shoulder": "power", "rear_arm": "power",
	"core": "conditioning", "legs": "conditioning"}
const FOCUS_LABEL := {"technique": "Technique", "power": "Power", "conditioning": "Conditioning"}

## The first part to reach WENT_AT: {"part": key, "round": 1-based round}. Within one round, the part with the highest burn
## wins (ties: the earlier key in PARTS). {} when no part ever reaches WENT_AT.
static func first_went(rounds: Array) -> Dictionary

## The part with the highest burn at the last bell ("" for no rounds; ties: earlier key in PARTS).
static func worst_at_end(rounds: Array) -> String

## The report for one fighter (her first name `who`):
## a part went -> {"part", "round", "focus", "line": "<who>'s legs went in round 2", "advice": "Next week: Conditioning"}
## none went -> {"part": "", "round": 0, "focus": "", "line": "<who> held up for all <n> rounds", "advice": ""}
## (n = rounds.size(); "1 round" when 1).
static func report(rounds: Array, who: String) -> Dictionary

## The difference to her last bout's report (both from report()), for the next result page:
## same part, later round now -> "Her legs held until round 3 this time (round 2 last fight)";
## same part, same round -> "Her legs went in round 2 again";
## same part, earlier round now -> "Her legs went sooner: round 1 (round 2 last fight)";
## last went and now none went -> "Her legs held up this time (they went in round 2 last fight)";
## anything else (no last report, a different part, neither went) -> "".
## Use NAMES[part] after "Her ". ("they" for legs, "it" for every other part, in the held-up line.)
static func change_line(last: Dictionary, now: Dictionary) -> String
```

## Tests (all must pass)
1. Write this first and see it fail (module missing): first_went([]) == {}.
2. first_went([{"legs": 30, "core": 20}, {"legs": 55, "lead_shoulder": 52}, {"legs": 70}]) == {"part": "legs", "round": 2}.
3. Highest in the round wins: first_went([{"lead_shoulder": 60, "legs": 51}]) == {"part": "lead_shoulder", "round": 1}.
4. Tie -> earlier key: first_went([{"core": 50, "legs": 50}]) == {"part": "core", "round": 1}.
5. Nothing reaches 50: first_went([{"legs": 49.9}, {"legs": 49.9}]) == {}.
6. worst_at_end([{"legs": 80}, {"legs": 40, "rear_arm": 41}]) == "rear_arm"; worst_at_end([]) == "".
7. report(test-2 rounds, "Lucy") == {"part": "legs", "round": 2, "focus": "conditioning",
   "line": "Lucy's legs went in round 2", "advice": "Next week: Conditioning"}.
8. report([{"lead_arm": 51}], "Maria").focus == "technique" and its line == "Maria's jab arm went in round 1";
   report([{"rear_shoulder": 90}], "Maria").advice == "Next week: Power".
9. report([{"legs": 10}, {"legs": 20}, {"legs": 30}], "Lucy").line == "Lucy held up for all 3 rounds";
   report([{"legs": 10}], "Lucy").line == "Lucy held up for all 1 round".
10. change_line: last legs r2 / now legs r3 -> "Her legs held until round 3 this time (round 2 last fight)";
    legs r2 / legs r2 -> "Her legs went in round 2 again"; legs r2 / legs r1 -> "Her legs went sooner: round 1 (round 2
    last fight)"; legs r2 / none -> "Her legs held up this time (they went in round 2 last fight)";
    core r1 / none -> "Her body held up this time (it went in round 1 last fight)"; {} / legs r2 -> "";
    legs r2 / core r2 -> "".
11. Same input -> same output; report() never changes the rounds array.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/body_report_test.gd
```
NEVER the `_console.exe`. Output must show `BODY_REPORT failures=0` and no `SCRIPT ERROR`. No output in 60 s = a script error
hanging `_initialize`: kill it and fix. Parse gate first: `... --headless --path . --check-only --script
res://scripts/rules/BodyReport.gd`. Do NOT change a constant or a test number to pass - if the brief contradicts itself,
keep the constant, report the measured value and why.

## Contract
OWNS: scripts/rules/BodyReport.gd, tests/body_report_test.gd   (Lean repo)
RED_TEST: tests/body_report_test.gd -> BODY_REPORT failures=0
REGRESSION: body_track_test
VISUAL: no (Claude wires it into the result page)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: write `var v: float = float(r.get(p, 0.0))`. Dictionary
equality in the test: compare field by field (or with `==` on two Dictionaries built the same way - both work in Godot 4,
but print both sides on a FAIL). Walk PARTS in order for every tie-break, never `keys()` of the input.

## Prior research
Game `research/MAKE_IT_A_GAME_PLAN_S323.md` (decision 5). Lean `scripts/rules/BodyLoad.gd` (PARTS, the burn 0-100)
and `scripts/rules/BodyTrack.gd` (bands: hot from 50; NAMES) - read, do not change, do not preload.

## What would a human do?
After a bout the coach watches the tape and says where she faded - "her legs went in the second, so this week it's
roadwork" - and checks next fight whether that part held longer.

## Prefab check
Nothing to buy: a pure rules module over our own state.

## When done
Commit both files on qwen/bodyreport1, message ending `RESULT: tests/body_report_test.gd -> BODY_REPORT failures=0`, and
paste the last 20 lines of the test run in your final answer.
