# TASK BODYTRACK1 - QWEN - the body view's colours and words: Burn read like tyre temperatures (Lean)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_BODYTRACK1 (branch qwen/bodytrack1). Commit there; do not push.

## Why
"The body is the track" (operator Q-S294-38 "Build it"; plan `E:\FightCamp\Game\research\BODY_TRACK_PLAN_S321.md`):
`scripts/rules/BodyLoad.gd` (on main, read it whole - 211 lines) keeps a Burn 0..100 per body part per boxer. Step 3 shows
both bodies on the fight screen, every part coloured by its Burn the way a racing game colours tyre temperatures. Claude
draws the view; you write the ONE pure module that decides each part's colour, its words and when it pulses.

## Owned files (create both; touch nothing else)
- `scripts/rules/BodyTrack.gd` (new, under 150 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/body_track_test.gd` (new, `extends SceneTree`, same shape as `tests/body_rates_test.gd`; it MAY preload BodyLoad;
  prints `BODY_TRACK failures=<n>`; quit(1 if failures else 0))

## The module
```
const PARTS := ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm", "core", "legs"]   # same as BodyLoad.PARTS
## Band edges = BodyLoad.band: fresh < 25 <= warm < 50 <= hot < 75 <= burning.
## Colours at each band's CENTRE (12.5, 37.5, 62.5, 87.5); between centres the colour is a straight lerp; below 12.5 it is
## fresh's colour, above 87.5 burning's.
const COLOURS := {"fresh": Color("#3fa7ff"), "warm": Color("#5ccf6a"), "hot": Color("#f2c230"), "burning": Color("#e8473a")}
## Her own words for the parts (lead = her jab side).
const NAMES := {"lead_shoulder": "Jab shoulder", "rear_shoulder": "Power shoulder", "lead_arm": "Jab arm",
	"rear_arm": "Power arm", "core": "Body", "legs": "Legs"}

## The band of a Burn value (same edges as BodyLoad.band, written here so the module has no preload).
static func band(burn: float) -> String

## The part's colour for a Burn value (continuous, see above). Alpha 1.
static func colour(burn: float) -> Color

## Where a BodyLoad part sits on HER body: "left_shoulder", "right_shoulder", "left_arm", "right_arm", "core", "legs".
## Orthodox: lead = her LEFT. Southpaw: lead = her RIGHT.
static func body_place(part: String, southpaw: bool) -> String

## True when the Burn moved UP into a higher band (25, 50 or 75 crossed going up) - the view pulses that part once.
## Going down (the minute's rest) never pulses.
static func pulse(prev: float, now: float) -> bool

## One line for the part's tooltip: "<NAME>: <band>" e.g. "Jab shoulder: hot".
static func label(part: String, burn: float) -> String

## The corner's one-line read of a boxer: her most burnt part when it is hot or burning, "Legs burning" /
## "Jab shoulder hot" (NAME + " " + band); "" when every part is fresh or warm. burns = {part: burn} (missing part = 0).
## A tie goes to the part earlier in PARTS.
static func worst_line(burns: Dictionary) -> String
```

## Tests (all must pass)
1. Write this first and see it fail (module missing): colour(0.0) == COLOURS.fresh and colour(100.0) == COLOURS.burning.
2. Band edges: band(24.9) "fresh", band(25.0) "warm", band(49.9) "warm", band(50.0) "hot", band(75.0) "burning"; and for
   every v in 0, 5, 10 .. 100 band(v) equals BodyLoad.band(v).
3. Centres: colour(37.5) == COLOURS.warm, colour(62.5) == COLOURS.hot (compare with is_equal_approx).
4. Lerp: colour(50.0) is halfway between warm and hot (each channel within 0.01).
5. Continuous: for v from 0 to 100 in steps of 0.5, no channel jumps more than 0.05 between neighbours.
6. Red rises: the red channel never falls from 37.5 to 100 in steps of 1.
7. body_place: orthodox lead_shoulder -> "left_shoulder", rear_arm -> "right_arm"; southpaw lead_arm -> "right_arm",
   rear_shoulder -> "left_shoulder"; core and legs the same both ways.
8. pulse: (20, 30) true, (30, 40) false, (40, 80) true, (80, 40) false, (24.9, 25.0) true, (25.0, 25.0) false.
9. label("lead_shoulder", 60.0) == "Jab shoulder: hot"; label("legs", 0.0) == "Legs: fresh".
10. worst_line: {} -> ""; {"legs": 49.0} -> ""; {"legs": 80.0, "core": 60.0} -> "Legs burning";
    {"lead_shoulder": 60.0, "rear_shoulder": 60.0} -> "Jab shoulder hot".
11. Same input -> same output.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/body_track_test.gd
```
NEVER the `_console.exe`. Output must show `BODY_TRACK failures=0` and no `SCRIPT ERROR`. No output in 60 s = a script
error hanging `_initialize`: kill it and fix. Parse gate first: `... --headless --path . --check-only --script
res://scripts/rules/BodyTrack.gd`. Also run `tests/body_load_test.gd` the same way (must stay green). Do NOT change any
constant or a test bound to make a test pass - report the measured value instead.

## Contract
OWNS: scripts/rules/BodyTrack.gd, tests/body_track_test.gd   (Lean repo)
RED_TEST: tests/body_track_test.gd -> BODY_TRACK failures=0
REGRESSION: body_load_test
VISUAL: no (Claude draws the body view with it and checks the fight-screen stills)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: write `var c: Color = COLOURS["warm"]`,
`var v: float = float(burns.get(p, 0.0))`. Color.lerp takes (to, weight). No multi-line lambdas inside a call.

## Prior research
`python Tools/prior_research.py body track tyre temperature burn colour` (old repo): BODY_TRACK_PLAN_S321.md (operator:
"see the body as the track on MSM"; the glass body preview tools/preview_body_track.gd coloured blue fresh -> green ->
yellow -> red burning, like tyre temperatures); BodyLoad.band (the four bands this module colours).

## What would a human do?
A race engineer reads tyre temperatures as four colours on a car outline - blue cold, green right, yellow hot, red
overheating - and calls the one that matters on the radio ("rear left is overheating"). A boxing cornerman does the same
with a tired fighter: one sentence about the part that is going, nothing about the rest.

## Prefab check
Nothing to buy: a pure colour/word module over our own numbers (F1-game tyre widgets are the look reference only).

## When done
Commit both files on qwen/bodytrack1, message ending `RESULT: tests/body_track_test.gd -> BODY_TRACK failures=0`, and paste
the last 20 lines of both test runs in your final answer.
