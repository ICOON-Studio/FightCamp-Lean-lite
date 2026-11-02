# TASK TRAININGLOAD1 - QWEN - the weekly trade-off: Light / Normal / Hard / Rest and the load gauge (Lean, update 29)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_GYMBILLS1 (branch qwen/trainingload1). Commit there; do not push.

## Why
Operator S323 approved the make-it-a-game plan ("Build it"; `E:\FightCamp\Game\research\MAKE_IT_A_GAME_PLAN_S323.md`,
decision 3 "A WEEKLY TRADE-OFF: TRAINING LOAD"): each fighter's week is Light / Normal / Hard (or Rest). Hard = bigger gains,
but this week's hours against her 4-week average is the injury risk (InjuryRoll, already on main). You write the ONE pure
module; Claude wires it into the fighter's week, the gauge and the injury roll.

## Owned files (create both; touch nothing else)
- `scripts/rules/TrainingLoad.gd` (new, under 140 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/training_load_test.gd` (new, `extends SceneTree`, same shape as `tests/injury_roll_test.gd`; prints
  `TRAINING_LOAD failures=<n>`; quit(1 if failures else 0))

## The module
```
## Real-world numbers (research S323): amateur boxers train ~8-15 h a week; acute:chronic load 0.8-1.3 = safe, >= 1.5 =
## 2-4x injury risk (Gabbett 2016). The same ratio thresholds as InjuryRoll.SAFE_RATIO / SPIKE_RATIO (copied, no preload).
const SETTINGS := {
	"rest": {"hours": 3.0, "gain": 0.25, "label": "Rest"},
	"light": {"hours": 6.0, "gain": 0.6, "label": "Light"},
	"normal": {"hours": 10.0, "gain": 1.0, "label": "Normal"},
	"hard": {"hours": 15.0, "gain": 1.3, "label": "Hard"},
}
const ORDER := ["rest", "light", "normal", "hard"]
const DEFAULT := "normal"
const CAMP_DEFAULT := "hard"
const HISTORY_WEEKS := 4
const SAFE_RATIO := 1.3
const SPIKE_RATIO := 1.5
const START_HOURS := 10.0     # a new fighter's history: HISTORY_WEEKS weeks of this

## Hours a week for a setting; an unknown setting -> DEFAULT's hours.
static func hours(setting: String) -> float

## Training gain multiplier for a setting (unknown -> DEFAULT's).
static func gain(setting: String) -> float

## A new fighter's load history: HISTORY_WEEKS copies of START_HOURS.
static func fresh_history() -> Array

## The history after a finished week: append hours, keep the last HISTORY_WEEKS (oldest first). Returns a NEW array.
static func push(history: Array, week_hours: float) -> Array

## This week's ratio for a setting against the history: hours(setting) / mean(history); 1.0 when history is empty or its
## mean <= 0.
static func ratio(setting: String, history: Array) -> float

## "safe" when ratio <= SAFE_RATIO, "high" when < SPIKE_RATIO, else "spike".
static func band(r: float) -> String

## The gauge's words: "Load 1.0x her usual - safe" / "Load 1.4x her usual - injury risk up" /
## "Load 1.5x her usual - injury risk 3x". One decimal, always ("1.0x").
static func gauge_line(r: float) -> String

## The setting a week defaults to: CAMP_DEFAULT in camp, else DEFAULT.
static func default_for(in_camp: bool) -> String

## The next setting in ORDER (wrapping hard -> rest) - the one-button cycle on the fighter card.
static func cycle(setting: String) -> String
```

## Tests (all must pass)
1. Write this first and see it fail (module missing): hours("normal") == 10.0.
2. hours: rest 3, light 6, normal 10, hard 15, "bogus" 10. gain: rest 0.25, light 0.6, normal 1.0, hard 1.3, "bogus" 1.0.
3. fresh_history() == [10.0, 10.0, 10.0, 10.0]; push([10,10,10,10], 15) == [10,10,10,15]; push([6], 10) == [6, 10];
   push does not change the array it was given.
4. ratio("hard", fresh_history()) == 1.5; ratio("normal", [6,6,6,6]) about 1.667; ratio("light", [10,10,10,10]) == 0.6;
   ratio("normal", []) == 1.0.
5. band: 1.0 safe; 1.3 safe; 1.4 high; 1.5 spike; 2.0 spike.
6. gauge_line: 1.0 -> "Load 1.0x her usual - safe"; 1.4 -> "Load 1.4x her usual - injury risk up";
   1.5 -> "Load 1.5x her usual - injury risk 3x".
7. A month of Hard from Normal settles: start fresh_history(), four times {r = ratio("hard", h); h = push(h, 15)} -> the
   four ratios are 1.5, 1.333.., 1.2, 1.0909.. (within 1e-3) - the spike is only the first week.
8. default_for(true) == "hard"; default_for(false) == "normal".
9. cycle: rest -> light -> normal -> hard -> rest; "bogus" -> "normal".

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/training_load_test.gd
```
NEVER the `_console.exe`. Output must show `TRAINING_LOAD failures=0` and no `SCRIPT ERROR`. No output in 60 s = a script
error hanging `_initialize`: kill it and fix. Parse gate first: `... --headless --path . --check-only --script
res://scripts/rules/TrainingLoad.gd`. Do NOT change a constant or a test number to pass - if the brief contradicts itself,
keep the constant, report the measured value and why.

## Contract
OWNS: scripts/rules/TrainingLoad.gd, tests/training_load_test.gd   (Lean repo)
RED_TEST: tests/training_load_test.gd -> TRAINING_LOAD failures=0
REGRESSION: injury_roll_test
VISUAL: no (Claude wires it into the fighter's week and the gauge)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: write `var h: float = float(SETTINGS[s]["hours"])`. `push`
must `duplicate()` before appending (test 3). Compare floats with absf(a - b) < 1e-3, never ==, in the test. For cycle,
the unknown case must return DEFAULT (not ORDER[0]).

## Prior research
Game `research/MAKE_IT_A_GAME_PLAN_S323.md` (decision 3 + the numbers table). Lean `scripts/rules/InjuryRoll.gd`
(load_ratio / load_mult - the same thresholds; read, do not change, do not preload).

## What would a human do?
A boxing coach plans each week's volume: a hard week before a fight, a light or rest week after one, and he watches for a
sudden jump in hours - that is when boxers get hurt. Sports scientists track it as this week's load over the 4-week average.

## Prefab check
Nothing to buy: a pure numbers module over our own state.

## When done
Commit both files on qwen/trainingload1, message ending `RESULT: tests/training_load_test.gd -> TRAINING_LOAD failures=0`,
and paste the last 20 lines of the test run in your final answer.
