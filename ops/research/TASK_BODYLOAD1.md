# TASK BODYLOAD1 - QWEN - how worked each body part is (Burn), the core of "the body is the track" (Lean)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_BODYLOAD1 (branch qwen/bodyload1). Commit there; do not push.

## Why
The operator approved the core mechanic "the body is the track" (Q-S294-38 "Build it"; plan
`E:\FightCamp\Game\research\BODY_TRACK_PLAN_S321.md`). Like a racing manager reads tyre wear, the player reads each
boxer's body: every part coloured by how worked it is (Burn). Burning shoulders drop her guard, burning legs slow her feet,
burning arms take power off. The whole-fight energy (Tank) already exists (`scripts/rules/Combos.gd` TANK / after_round) and
punch damage (Hurt) already exists (`scripts/rules/BodyMap.gd`). You write ONLY the missing piece: per-part Burn, built from the
round's beats, refilled part of the way in the minute's rest, and the three effects the 3D view reads. Claude wires it in.

## The beats you get (same format as BodyMap / ClinchBeats / InsideBeats - read those three modules and
`tests/body_map_test.gd`, `tests/burst_shape_test.gd` `_build`)
One exchange = an Array of beats `{"t": 0..30 s sorted, "who": "a"|"b", "move": String, "result": "lands"|"blocked"|"misses"|"none", ...}`;
some carry "combo": true / "combo_id". Punch moves: jab, cross, lead_hook, body_hook, rear_uppercut. A "clinch" beat carries
"break_t" (ClinchBeats). An "inside" beat carries "end_t" (InsideBeats). A round = 6 exchanges (`RoundScript.build` gives one
exchange's beats; about 21 punches an exchange for both boxers, the real rate).

## Owned files (create both; touch nothing else)
- `scripts/rules/BodyLoad.gd` (new, under 250 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/body_load_test.gd` (new, `extends SceneTree`, same shape as `tests/body_map_test.gd`; it MAY preload RoundScript,
  BurstShape, ClinchBeats to build beats; prints `BODY_LOAD failures=<n>`; quit(1 if failures else 0))

## The module
```
const PARTS := ["lead_shoulder", "rear_shoulder", "lead_arm", "rear_arm", "core", "legs"]
## Lead hand (left for an orthodox boxer, right for a southpaw - the 3D mirrors her): jab, lead_hook, body_hook.
## Rear hand: cross, rear_uppercut.
const LEAD_MOVES := ["jab", "lead_hook", "body_hook"]
const REAR_MOVES := ["cross", "rear_uppercut"]
## Burn added per THROWN punch (any result) to that hand's shoulder and arm. Hooks and uppercuts load the arm more.
const SHOULDER_PER_PUNCH := 1.0
const ARM_PER_PUNCH := 0.7
const POWER_ARM_MULT := 1.3        # lead_hook, body_hook, rear_uppercut on the ARM only
## A punch thrown at combination cadence costs 1.39x (Combos.FAST_PUNCH, Arseneau 2011 bag VO2) - beats with "combo" or "combo_id".
const FAST_PUNCH := 1.39
## Every punch turns the trunk: core gets this per thrown punch.
const CORE_PER_PUNCH := 0.25
## Holding in a clinch (clinch t .. break_t), BOTH boxers, per second: both shoulders and core.
const CLINCH_PER_S := 0.6
## Legs per second of the exchange's 30 s (moving, bouncing); x SIT_LEGS for the boxer who moves more.
const LEGS_PER_S := 0.035
const SIT_LEGS := {"press": {"b": 1.3}, "range": {"a": 1.25, "b": 1.1}, "counter": {"a": 1.1}}
## Inside spells (inside t .. end_t) the feet stop: legs gain only this share during them.
const INSIDE_LEGS := 0.5
## Pace (the player's driver mode): effort per punch / per second.
const PACE := {"push": 1.2, "steady": 1.0, "save": 0.8}
## Tired muscles burn faster: gain x (1 + TANK_MULT x (1 - tank / 100)), tank = her Combos energy 0..100 at the exchange.
const TANK_MULT := 0.5
## The minute's rest gives back REST_BACK of each part's Burn x her conditioning (0.8 .. 1.2) - J68 / Combos QUICK_REFILL:
## about half to two thirds of the fast fuel returns in 60 s, so Burn never fully resets.
const REST_BACK := 0.55
## Body shots hurt -> she breathes harder -> refills slower (the reason boxers "go to the body").
const RIBS_HURT_REST := 0.7
## The corner's second works ONE part in the rest (ice + shake-out): that part loses SECOND_WORK more (modest, what corners do).
const SECOND_WORK := 12.0
## Effects start at EFFECT_FROM and are full at 100.
const EFFECT_FROM := 50.0
const GUARD_DROP_MAX := 1.0    # 0 = guard up, 1 = hands at the chest
const STEP_MIN := 0.6          # step size/speed scale at legs 100
const POWER_MIN := 0.75        # punch power scale at arms 100

static func fresh() -> Dictionary
	# {"a": {part: 0.0 ...}, "b": {part: 0.0 ...}}  (Burn 0 = fresh, 100 = burning; always clamp 0..100)

## Adds one exchange's work. ctx = {"sit": Exchanges.MODES key, "pace": {"a": "push"|"steady"|"save", "b": ...},
##   "tank": {"a": 0..100, "b": 0..100}, "rates": {"a": {part: 0.7..1.3}, "b": {...}}}  - every key optional
##   (defaults: no sit factor, steady, tank 100, rate 1.0). rates = the gym's training (lower = trained part burns slower).
## gain for a part = raw work x PACE x tank factor x rate.
static func add_exchange(load: Dictionary, beats: Array, ctx: Dictionary) -> void

## The minute's rest. cond = {"a": 0.8..1.2, "b": ...} (default 1.0); ribs_hurt = {"a": bool, "b": bool} (default false);
## second = {"a": part or "", "b": ...}: SECOND_WORK off that part after the refill.
## part after = burn x (1 - REST_BACK x cond x (RIBS_HURT_REST if ribs_hurt else 1.0)) - SECOND_WORK if worked; clamp 0..100.
static func rest(load: Dictionary, cond: Dictionary, ribs_hurt: Dictionary, second: Dictionary) -> void

static func burn(load: Dictionary, who: String, part: String) -> float
## The part the second works by default (the corner works itself - operator Q-S294-36 / Kalli SQ23): highest Burn,
## ties -> earliest in PARTS.
static func worst_part(load: Dictionary, who: String) -> String
## "fresh" < 25 <= "warm" < 50 <= "hot" < 75 <= "burning"
static func band(v: float) -> String
## 0..GUARD_DROP_MAX from the MEAN of the two shoulders, linear EFFECT_FROM -> 100.
static func guard_drop(load: Dictionary, who: String) -> float
## 1.0 .. STEP_MIN from legs, linear EFFECT_FROM -> 100.
static func step_scale(load: Dictionary, who: String) -> float
## 1.0 .. POWER_MIN from the MEAN of the two arms, linear EFFECT_FROM -> 100.
static func power_scale(load: Dictionary, who: String) -> float
```
`south` is not an input: lead/rear is already the right side for each boxer (the 3D mirrors a southpaw). Moves that are not
punches, clinch or inside beats add nothing.

## Tests (all must pass; 300 seeds; a "bout" = up to 3 rounds x 6 exchanges built with RoundScript.build (vary "n" 1..3 and
"mine" 3/10/20 like burst_shape_test) + BurstShape.apply + ClinchBeats.apply, pace steady, tank from Combos-like numbers
100 / 78 / 61 at the start of rounds 1 / 2 / 3, rest() between rounds with cond 1.0)
1. Write this first and see it fail (module missing): fresh() has every PART at 0 for both boxers; one jab thrown by "a"
   adds exactly SHOULDER_PER_PUNCH to a.lead_shoulder and ARM_PER_PUNCH to a.lead_arm and nothing to "b".
2. Hand sides: a cross loads rear_shoulder/rear_arm only; a lead_hook's arm gain = ARM_PER_PUNCH x POWER_ARM_MULT;
   a combo beat costs FAST_PUNCH x the single cost; a "none" beat with a non-punch move adds nothing.
3. Clinch: a clinch of 4.0 s adds 4.0 x CLINCH_PER_S to both shoulders and core of BOTH boxers.
4. Every value stays in 0..100 after any sequence (push pace, tank 0, rates 1.3, 3 rounds).
5. Calibration (steady, rates 1.0) - the busier shoulder of the boxer who throws more, mean over seeds:
   end of round 1 in 30..50, end of round 2 in 48..70, end of round 3 in 62..85. Print the measured means.
   DO NOT tune any constant to pass this: if a bound fails with these numbers, report the measured value in your final answer.
6. Pace: the same beats with "push" give more Burn than "steady", "save" less (every part with any work).
7. Rates: a part with rate 0.7 ends a round lower than the same part at 1.0 (same beats).
8. Rest: with cond 1.0, no ribs hurt, no second, every part after rest() == its value before x (1 - REST_BACK) (+-0.001); ribs_hurt
   true leaves more Burn than false; second = worst_part takes SECOND_WORK more off that part only.
9. Effects: guard_drop 0 at shoulders 50, GUARD_DROP_MAX at 100, monotone; step_scale 1.0 at legs <= 50, STEP_MIN at 100;
   power_scale same with POWER_MIN; band edges 24.9 / 25 / 50 / 75.
10. Same input -> same output (no rng in this module at all).

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/body_load_test.gd
```
NEVER the `_console.exe`. Output must show `BODY_LOAD failures=0` and no `SCRIPT ERROR`. A script error in `_initialize`
HANGS the run: if there is no output in 60 s, kill it and fix the error. Parse gate first:
`... --headless --path . --check-only --script res://scripts/rules/BodyLoad.gd`. Also run `tests/body_map_test.gd` the same
way (must stay green).

## Contract
OWNS: scripts/rules/BodyLoad.gd, tests/body_load_test.gd   (Lean repo)
RED_TEST: tests/body_load_test.gd -> BODY_LOAD failures=0
REGRESSION: body_map_test
VISUAL: no (Claude wires guard height / steps / power in the 3D and checks stills on the game camera)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: write `var m: String = str(b["move"])`. A multi-line lambda
inside a call hangs the parser in this repo - use a named static func. Do not name a variable `free` or reuse a loop variable
name in one scope. Dictionary defaults: `ctx.get("pace", {})` then `.get(who, "steady")`.

## Prior research
`python Tools/prior_research.py stamina fatigue rest refill shoulder` (old repo): J_COMBOENERGY1_JOHN.md (punch cost, combo
cadence 1.39x - Arseneau 2011; rounds end ~68/46/29), J68 corner ice (60 s rest refills 55-65 % of fast fuel - Bogdanis 1995
phosphocreatine half-time 56.6 s; ice does not refill stamina), BODY_TRACK_PLAN_S321.md (the design), K_CORNER_ICE_S321_KALLI.md
(the corner works itself; the player chooses only when two problems compete).

## What would a human do?
A boxing coach watches the shoulders first: a tired fighter's hands drop and her jab gets slow; then the legs (flat feet,
caught on the ropes). In the corner the second ices and shakes out the part that is going, and the cutman works cuts - the
fighter only listens. The coach reads which side is working most (the lead hand throws most punches).

## Prefab check
Nothing to buy: a pure module over our own beat format.

## When done
Commit both files on qwen/bodyload1, message ending `RESULT: tests/body_load_test.gd -> BODY_LOAD failures=0`, and paste the
last 20 lines of both test runs (with the calibration means of test 5) in your final answer.
