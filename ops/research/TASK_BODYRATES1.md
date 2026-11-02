# TASK BODYRATES1 - QWEN - every boxer is a different car: how fast each body part burns (Lean)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_BODYRATES1 (branch qwen/bodyrates1). Commit there; do not push.

## Why
"The body is the track" (operator Q-S294-38 "Build it"; plan `E:\FightCamp\Game\research\BODY_TRACK_PLAN_S321.md`):
`scripts/rules/BodyLoad.gd` (on main, read it whole - 210 lines) adds Burn per body part and already takes
`ctx.rates = {"a": {part: 0.7..1.3}, "b": {...}}` - lower = that part burns slower. Nothing fills those rates yet, so every
boxer burns the same. You write the ONE pure module that turns a boxer's stats and style into her rates: the gym's training
(stats go up) then shows in the fight, and a pressure fighter burns her arms while an out-boxer burns her legs.

## Owned files (create both; touch nothing else)
- `scripts/rules/BodyRates.gd` (new, under 150 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/body_rates_test.gd` (new, `extends SceneTree`, same shape as `tests/body_load_test.gd`; it MAY preload BodyLoad;
  prints `BODY_RATES failures=<n>`; quit(1 if failures else 0))

## The module
```
const PARTS := ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm", "core", "legs"]   # same as BodyLoad.PARTS
const RATE_MIN := 0.7
const RATE_MAX := 1.3
## Stats are 0..100 (scripts/state/Data.gd STATS: power, speed, technique, defense, conditioning, fight_iq, chin).
## Conditioning is the big one: every part, -0.25 at 100 / +0.25 at 0 around 50 (linear).
const COND_ALL := 0.25
## Technique (relaxed, efficient punches - no wasted tension): shoulders and arms, +-0.10 around 50.
const TECH_UPPER := 0.10
## Speed (light, quick feet and hands): legs, +-0.08 around 50.
const SPEED_LEGS := 0.08
## Power punchers load up: arms +0.06 at power 100 (none below 50).
const POWER_ARMS := 0.06
## Style: which parts she works harder than the average boxer (multipliers before the clamp).
const STYLE := {
	"Pressure fighter": {"lead_arm": 1.08, "rear_arm": 1.08, "lead_shoulder": 1.05, "rear_shoulder": 1.05, "legs": 1.05},
	"Out-boxer": {"legs": 1.12, "lead_shoulder": 1.06},
	"Slugger": {"rear_arm": 1.10, "rear_shoulder": 1.08, "core": 1.05},
	"Counter-puncher": {"core": 1.05},
	"Boxer-puncher": {},
}

## Her rates: start 1.0 per part, add the stat terms, multiply by the style row (an unknown style = no change), clamp
## RATE_MIN..RATE_MAX. stats keys missing -> 50. Returns {part: float} with all six PARTS.
static func of(stats: Dictionary, style: String) -> Dictionary

## A rate in plain words for the body view's tooltip: "<= 0.85" -> "trained", ">= 1.15" -> "burns fast", else "average".
static func word(rate: float) -> String
```

## Tests (all must pass)
1. Write this first and see it fail (module missing): of({}, "Boxer-puncher") gives exactly 1.0 for all six PARTS.
2. Conditioning: of({"conditioning": 100}, "Boxer-puncher") gives 0.75 for every part; conditioning 0 gives 1.25.
3. Technique 100 lowers the four shoulder/arm rates by 0.10 and leaves core/legs at 1.0; speed 100 lowers legs by 0.08 only.
4. Power: 30 changes nothing; 100 raises the two arms by 0.06.
5. Style (stats all 50): an Out-boxer's legs rate (1.12) > a Pressure fighter's (1.05); a Pressure fighter's arms (1.08) >
   an Out-boxer's (1.0); an unknown style gives the same as Boxer-puncher.
6. Clamp: conditioning 0 + Pressure fighter + power 100 + technique 0 never exceeds RATE_MAX; conditioning 100 + technique
   100 + speed 100 never goes under RATE_MIN.
7. Monotone: raising conditioning in steps of 10 from 0 to 100 never raises any rate (any style).
8. Wired check with BodyLoad: one exchange of beats (build it like tests/body_load_test.gd does) added to two fresh loads,
   once with no rates and once with `rates` {"a": of({"conditioning": 80, "technique": 70}, "Boxer-puncher")}: every part
   of "a" with any work ends lower with the rates.
9. word(): 0.85 -> "trained", 1.15 -> "burns fast", 1.0 -> "average".
10. Same input -> same output.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/body_rates_test.gd
```
NEVER the `_console.exe`. Output must show `BODY_RATES failures=0` and no `SCRIPT ERROR`. No output in 60 s = a script
error hanging `_initialize`: kill it and fix. Parse gate first: `... --headless --path . --check-only --script
res://scripts/rules/BodyRates.gd`. Also run `tests/body_load_test.gd` the same way (must stay green). Do NOT change any
constant or a test bound to make a test pass - report the measured value instead.

## Contract
OWNS: scripts/rules/BodyRates.gd, tests/body_rates_test.gd   (Lean repo)
RED_TEST: tests/body_rates_test.gd -> BODY_RATES failures=0
REGRESSION: body_load_test
VISUAL: no (Claude feeds the rates into BodyBurn and checks the fight with tools/burn_probe.gd)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: write `var c: float = float(stats.get("conditioning", 50.0))`.
STYLE rows are nested Dictionaries: `var row: Dictionary = STYLE.get(style, {})`. Do not name a variable `free`; no
multi-line lambdas inside a call.

## Prior research
`python Tools/prior_research.py conditioning fatigue style stamina` (old repo): J_COMBOENERGY1_JOHN.md (conditioning sets the
refill 0.8..1.2 - Combos.refill), J68 (rest refill), BODY_TRACK_PLAN_S321.md ("every boxer is a different car": build,
attributes and style set each part's Burn rate; a pressure fighter burns arms, an out-boxer burns legs).

## What would a human do?
A strength-and-conditioning coach profiles the boxer: aerobic base first (it lifts everything), then the sport's specific
weak links - a tense, untrained puncher's shoulders go first, a mover's legs. Training the weak link is what camp is for.

## Prefab check
Nothing to buy: a pure module over our own stats.

## When done
Commit both files on qwen/bodyrates1, message ending `RESULT: tests/body_rates_test.gd -> BODY_RATES failures=0`, and paste
the last 20 lines of both test runs in your final answer.
