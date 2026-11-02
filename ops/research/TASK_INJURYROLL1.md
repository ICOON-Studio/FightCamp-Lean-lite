# TASK INJURYROLL1 - QWEN - injuries and suspensions: what a bout and a training week can cost (Lean, update 28)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_GYMBILLS1 (branch qwen/injuryroll1). Commit there; do not push.

## Why
Operator S323 approved the make-it-a-game plan ("Build it"; `E:\FightCamp\Game\research\MAKE_IT_A_GAME_PLAN_S323.md`,
decision 2 "INJURIES AND SUSPENSIONS"): today nothing in a career can hurt a fighter (the fighter page always prints
"Injuries: None"). You write the ONE pure module with the real-world numbers; Claude wires it into bouts, the weekly
training load, the fighter page and booking.

## Owned files (create both; touch nothing else)
- `scripts/rules/InjuryRoll.gd` (new, under 200 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/injury_roll_test.gd` (new, `extends SceneTree`, same shape as `tests/gym_bills_test.gd`; prints
  `INJURY_ROLL failures=<n>`; quit(1 if failures else 0))

## The module
```
## Real-world numbers (research S323): competition injury 6.8 per 1000 bout-minutes -> ~6 % a 3x3 bout, 72 % head/neck,
## cuts 20 % (Alevras 2022 meta-analysis); training 1.3 per 1000 h -> ~1.3 % a 10 h week; ~33 days lost per injury
## (Loosemore 2015); load this week vs 4-week average >= 1.5 = 2-4x risk (Gabbett 2016); England Boxing KO rule 4.1.2.
const BOUT_BASE := 0.06          # injury chance of a 3-round bout at middling damage (worst place 50)
const TRAIN_BASE_10H := 0.013    # injury chance of a 10-hour training week at a safe load
const SAFE_RATIO := 1.3          # load ratio up to this = no extra risk
const SPIKE_RATIO := 1.5         # load ratio from this = SPIKE_MULT risk
const SPIKE_MULT := 3.0
const KO_DAYS := 30              # a stoppage to the head: 30 days out
const KO_SECOND_WINDOW := 90     # a second within this many days ...
const KO_SECOND_DAYS := 90       # ... = this many days out
const KO_THIRD_WINDOW := 365     # a third within this many days ...
const KO_THIRD_DAYS := 365       # ... = this many days out
const FACE_CUT_LINE := 35.0      # a face place (left_eye/right_eye/nose) at or below this doubles the cut weight
## Bout injury types: [type, weight, min_days, max_days]. cut+nose+head = 72 % (head/neck share).
const BOUT_TYPES := [["cut", 20, 14, 21], ["nose", 15, 21, 35], ["head", 37, 21, 35], ["hand", 18, 35, 56], ["ribs", 10, 21, 35]]
const TRAIN_TYPES := [["hand", 40, 14, 28], ["ribs", 30, 14, 21], ["strain", 30, 7, 14]]
const NAMES := {"cut": "Cut", "nose": "Broken nose", "head": "Head knock", "hand": "Hand injury", "ribs": "Rib injury",
	"strain": "Strain"}

## Chance a bout injures this fighter. damage = {"places": {place: 0-100 health}, "rounds": int}.
## worst = the lowest value in places (100 when places is empty or missing); s = (100 - worst) / 100;
## chance = BOUT_BASE * (rounds / 3.0) * (0.4 + 1.2 * s), clamped to 0.0..0.4. rounds defaults to 3.
static func bout_chance(damage: Dictionary) -> float

## Days out for a NEW stoppage to the head on `day`. history = the days of earlier head stoppages (ints, any order).
## Count earlier ones with 0 <= day - h <= KO_THIRD_WINDOW and with 0 <= day - h <= KO_SECOND_WINDOW.
## >= 2 within the third window -> KO_THIRD_DAYS; else >= 1 within the second window -> KO_SECOND_DAYS; else KO_DAYS.
static func ko_days(history: Array, day: int) -> int

## A bout's roll. damage as above plus optional "head_stoppage": bool, "ko_history": Array, "day": int.
## head_stoppage true -> {"injured": true, "type": "ko", "days_out": ko_days(ko_history, day)} - no dice.
## Otherwise: rng = RandomNumberGenerator, rng.seed = seed; injured = rng.randf() < bout_chance(damage).
## Not injured -> {"injured": false, "type": "none", "days_out": 0}. Injured -> pick a type from BOUT_TYPES by weight with
## the SAME rng (rng.randf() * total weight, walk the list; cut weight x2 when any face place <= FACE_CUT_LINE), then
## days_out = rng.randi_range(min_days, max_days).
static func bout_roll(seed: int, damage: Dictionary) -> Dictionary

## This week's load against the 4-week average. last4 = the earlier weeks' hours (0-4 floats).
## avg = mean(last4); 1.0 when last4 is empty or avg <= 0. ratio = this_week / avg.
static func load_ratio(this_week: float, last4: Array) -> float

## Risk multiplier from the load ratio: 1.0 up to SAFE_RATIO; SPIKE_MULT from SPIKE_RATIO; linear in between
## (1.0 + (ratio - SAFE_RATIO) / (SPIKE_RATIO - SAFE_RATIO) * (SPIKE_MULT - 1.0)).
static func load_mult(ratio: float) -> float

## A training week's chance: TRAIN_BASE_10H * hours / 10.0 * load_mult(ratio), clamped to 0.0..0.3.
static func training_chance(hours: float, ratio: float) -> float

## A training week's roll: same shape as bout_roll (rng.seed = seed; randf() < training_chance; type from TRAIN_TYPES;
## days with randi_range). Never "ko".
static func training_roll(seed: int, hours: float, ratio: float) -> Dictionary

## Whole weeks out: ceil(days / 7.0) as int (0 -> 0).
static func weeks_out(days: int) -> int

## One line for the fighter page: type "none" -> "No injuries"; "ko" -> "Suspended 30 days (stopped to the head)"
## (the real days_out); else "<NAMES[type]> - out <weeks_out> weeks" ("Hand injury - out 6 weeks"; "1 week" when 1).
static func line(inj: Dictionary) -> String
```

## Tests (all must pass)
1. Write this first and see it fail (module missing): bout_chance({"places": {}, "rounds": 3}) is about 0.024.
2. bout_chance: worst 50 rounds 3 -> 0.06; worst 100 -> 0.024; worst 0 -> 0.096; worst 50 rounds 4 -> 0.08 (all within 1e-6).
3. ko_days: ([], 100) -> 30; ([40], 100) -> 90; ([5], 100) -> 30; ([10, 60], 100) -> 365; ([10, 60], 400) -> 30.
4. bout_roll with head_stoppage true, ko_history [40], day 100 -> {"injured": true, "type": "ko", "days_out": 90}.
5. load_ratio(10, [10, 10, 10, 10]) == 1.0; load_ratio(15, [10, 10, 10, 10]) == 1.5; load_ratio(8, []) == 1.0.
6. load_mult: 1.0 -> 1.0; 1.3 -> 1.0; 1.4 -> 2.0; 1.5 -> 3.0; 2.2 -> 3.0.
7. training_chance: (10, 1.0) -> 0.013; (10, 1.6) -> 0.039; (15, 1.4) -> 0.039.
8. weeks_out: 0 -> 0; 1 -> 1; 7 -> 1; 8 -> 2; 30 -> 5.
9. line: none -> "No injuries"; {"type": "ko", "days_out": 30} -> "Suspended 30 days (stopped to the head)";
   {"type": "hand", "days_out": 40} -> "Hand injury - out 6 weeks"; {"type": "strain", "days_out": 7} -> "Strain - out 1 week".
10. Determinism: bout_roll(123, d) twice -> equal dictionaries; training_roll the same.
11. Real-world bounds over seeds 1..20000, damage {"places": {"nose": 50.0, "head": 80.0}, "rounds": 3}: injury rate
    5.2-6.8 %; of the injuries, cut+nose+head share 64-80 %; mean days_out 24-36.
12. A cut face doubles cuts: same seeds, nose 30.0 instead of 50.0 -> the cut share of injuries is higher than in test 11.
13. Training bounds over seeds 1..20000: (10, 1.0) rate 0.9-1.7 %; (10, 1.6) rate between 2.5x and 3.5x of it.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/injury_roll_test.gd
```
NEVER the `_console.exe`. Output must show `INJURY_ROLL failures=0` and no `SCRIPT ERROR`. No output in 60 s = a script error
hanging `_initialize`: kill it and fix. Parse gate first: `... --headless --path . --check-only --script
res://scripts/rules/InjuryRoll.gd`. Do NOT change a constant or a test number to pass - if the brief contradicts itself,
keep the constant, report the measured value and why.

## Contract
OWNS: scripts/rules/InjuryRoll.gd, tests/injury_roll_test.gd   (Lean repo)
RED_TEST: tests/injury_roll_test.gd -> INJURY_ROLL failures=0
REGRESSION: gym_bills_test
VISUAL: no (Claude wires it into the bout, training week and fighter page)

## The one trap
GDScript `:=` on a Variant from a Dictionary or Array is a parse error: write `var w: int = int(t[1])`. Integer division
truncates: compute in floats. Make ONE RandomNumberGenerator per roll, seed it once, and draw the hit, the type and the
days from it in that order - a second rng or a reseed breaks test 10/11. No multi-line lambdas inside a call.

## Prior research
Game `research/MAKE_IT_A_GAME_PLAN_S323.md` (the numbers table and their sources). Lean `scripts/rules/BodyMap.gd`
(the places and their 0-100 health - read, do not change) and `scripts/rules/GymBills.gd` (module + test shape to copy).

## What would a human do?
A club coach and the England Boxing medical officer: after a bout the doctor checks cuts, hands, ribs and the head; a
stoppage to the head is an automatic suspension recorded on the boxer's card, longer for repeats. In the gym the coach
watches the training load - a sudden jump in hours is when boxers get hurt.

## Prefab check
Nothing to buy: a pure numbers module over our own state.

## When done
Commit both files on qwen/injuryroll1, message ending `RESULT: tests/injury_roll_test.gd -> INJURY_ROLL failures=0`, and paste
the last 25 lines of the test run in your final answer.
