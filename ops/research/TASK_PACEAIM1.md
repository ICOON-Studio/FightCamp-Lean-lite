# TASK PACEAIM1 - QWEN - Pace (Push / Steady / Save) and Aim (head / body / a hurt place): what each costs and buys (Lean)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_PACEAIM1 (branch qwen/paceaim1). Commit there; do not push.

## Why
"The body is the track" (operator Q-S294-38 "Build it"; plan `E:\FightCamp\Game\research\BODY_TRACK_PLAN_S321.md`,
"The player's decisions"): like a racing manager's driver mode, the player sets her PACE - Push (more punches and pressure,
burns faster), Steady, Save (she cools down, throws less, gives rounds away) - and her AIM - where she goes on the other
boxer's body (the head, the body, or a place that is already hurt). You write the ONE pure module that turns those two
choices into numbers; Claude wires them into the 30-second exchanges (scripts/rules/Exchanges.gd) and the shout bar.
`scripts/rules/BodyLoad.gd` already reads `ctx.pace = {"a": "push"|"steady"|"save"}` (its PACE multipliers) - read it
(211 lines) and do NOT change it.

## Owned files (create both; touch nothing else)
- `scripts/rules/PaceAim.gd` (new, under 160 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/pace_aim_test.gd` (new, `extends SceneTree`, same shape as `tests/body_track_test.gd`; it MAY preload BodyLoad;
  prints `PACE_AIM failures=<n>`; quit(1 if failures else 0))

## The module
```
const PACES := ["push", "steady", "save"]
const AIMS := ["", "head", "body", "left_ribs", "right_ribs", "head_hurt"]   # "" = her own game (no aim)
## The exchange's edge for her (points on Exchanges' scale: a "best" shout is +15, an "ok" one +5).
const PACE_EDGE := {"push": 6.0, "steady": 0.0, "save": -6.0}
## Her energy spend in the exchange, times (Exchanges/LiveRound's per-exchange cost).
const PACE_SPEND := {"push": 1.35, "steady": 1.0, "save": 0.6}
## Punches she throws (and so lands) in the exchange, times.
const PACE_OUTPUT := {"push": 1.25, "steady": 1.0, "save": 0.75}
## Save: energy she gets back during the exchange (she breathes), on top of spending less.
const SAVE_RECOVER := 3.0
## Aim: the share of her landed punches that go to the body (Exchanges.BODY_SHARE 0.2 is her own game).
const AIM_BODY_SHARE := {"": 0.2, "head": 0.08, "body": 0.5, "left_ribs": 0.6, "right_ribs": 0.6, "head_hurt": 0.08}
## Aim at a place that is already hurt (BodyMap band "hurt" or worse): the extra edge, and the extra damage there, times.
const HURT_AIM_EDGE := 4.0
const HURT_AIM_DAMAGE := 1.3
## Aim at the body when HER OPPONENT's core or legs are hot or burning (Burn >= 50): the body work pays - extra edge.
const BODY_ON_TIRED_EDGE := 3.0
## Aiming costs a little accuracy: an aimed exchange's edge (any aim but "") has this taken off before the bonuses.
const AIM_COST := 1.5

## Her edge in one exchange from pace and aim.
## opp_hurt = {"head": bool, "left_ribs": bool, "right_ribs": bool} (that place hurt or worse);
## opp_burn = {"core": 0..100, "legs": 0..100} (missing = 0).
## = PACE_EDGE[pace] (unknown pace = steady)
##   - AIM_COST when aim != ""
##   + HURT_AIM_EDGE when aim is "left_ribs"/"right_ribs" and that rib is hurt, or aim is "head_hurt" and the head is hurt
##   + BODY_ON_TIRED_EDGE when aim is "body"/"left_ribs"/"right_ribs" and opp_burn core or legs >= 50
static func edge(pace: String, aim: String, opp_hurt: Dictionary, opp_burn: Dictionary) -> float

## Spend multiplier, output multiplier, recovery (unknown pace = steady's numbers).
static func spend(pace: String) -> float
static func output(pace: String) -> float
static func recover(pace: String) -> float        # SAVE_RECOVER for "save", else 0.0

## Body share of her landed punches for an aim (unknown aim = "").
static func body_share(aim: String) -> float

## Damage multiplier on a landed punch at `place` (a BodyMap place: head, left_ribs, right_ribs, ...) for an aim:
## HURT_AIM_DAMAGE when the aim names that place ("head_hurt" names "head") AND the place is hurt (opp_hurt), else 1.0.
static func damage(aim: String, place: String, opp_hurt: Dictionary) -> float

## The shout-bar words. pace_word: "push" -> "Push now!", "steady" -> "Stay steady", "save" -> "Take this one easy".
## aim_word: "" -> "", "head" -> "Head hunt", "body" -> "Go to the body", "left_ribs" -> "Her left ribs!",
## "right_ribs" -> "Her right ribs!", "head_hurt" -> "Finish the head!". Unknown -> "".
static func pace_word(pace: String) -> String
static func aim_word(aim: String) -> String

## The aims worth offering against her now (the shout bar shows only these): always "", "head", "body"; plus
## "left_ribs" / "right_ribs" / "head_hurt" for each hurt place in opp_hurt, in AIMS order.
static func offers(opp_hurt: Dictionary) -> Array
```

## Tests (all must pass)
1. Write this first and see it fail (module missing): edge("steady", "", {}, {}) == 0.0.
2. Pace: edge("push", "", {}, {}) == 6.0; edge("save", "", {}, {}) == -6.0; an unknown pace gives steady's 0.0.
3. Aim cost: edge("steady", "head", {}, {}) == -1.5; edge("steady", "body", {}, {}) == -1.5.
4. Hurt aim: edge("steady", "left_ribs", {"left_ribs": true}, {}) == 2.5 (= -1.5 + 4.0); with the left ribs NOT hurt it is
   -1.5; "head_hurt" with {"head": true} gives 2.5.
5. Body on a tired body: edge("steady", "body", {}, {"legs": 60.0}) == 1.5; with legs 40 and core 40 it is -1.5;
   "right_ribs" with right ribs hurt AND core 55 gives 5.5 (-1.5 + 4 + 3).
6. spend/output/recover: push 1.35/1.25/0.0, steady 1.0/1.0/0.0, save 0.6/0.75/3.0; unknown = steady.
7. body_share: "" 0.2, "head" 0.08, "body" 0.5, "left_ribs" 0.6; unknown 0.2; every AIMS value is in 0..1.
8. damage: ("left_ribs", "left_ribs", {"left_ribs": true}) == 1.3; same with the place not hurt == 1.0;
   ("left_ribs", "right_ribs", {"right_ribs": true}) == 1.0; ("head_hurt", "head", {"head": true}) == 1.3; ("body", "left_ribs",
   {"left_ribs": true}) == 1.0.
9. Words: pace_word for all three and an unknown ("" ); aim_word for all six AIMS and an unknown ("").
10. offers({}) == ["", "head", "body"]; offers({"right_ribs": true, "head": true}) == ["", "head", "body", "right_ribs",
    "head_hurt"] (AIMS order); a false entry adds nothing.
11. The trade (pace is a real choice): over 6 exchanges with a base spend of 5.0 each, Push spends more than Steady spends
    more than Save minus its recovery (6 * 5 * 1.35 > 6 * 5 * 1.0 > 6 * (5 * 0.6 - 3.0)), and Push's edge > Steady's > Save's.
12. BodyLoad agrees on the direction: one exchange of beats (build it like tests/body_load_test.gd) added to two fresh loads
    with ctx pace {"a": "push"} and {"a": "save"}: every part of "a" with work ends higher with push.
13. Same input -> same output.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/pace_aim_test.gd
```
NEVER the `_console.exe`. Output must show `PACE_AIM failures=0` and no `SCRIPT ERROR`. No output in 60 s = a script error
hanging `_initialize`: kill it and fix. Parse gate first: `... --headless --path . --check-only --script
res://scripts/rules/PaceAim.gd`. Also run `tests/body_load_test.gd` the same way (must stay green). Do NOT change any
constant or a test bound to make a test pass - if the brief contradicts itself, keep the constant, report the measured
value and why.

## Contract
OWNS: scripts/rules/PaceAim.gd, tests/pace_aim_test.gd   (Lean repo)
RED_TEST: tests/pace_aim_test.gd -> PACE_AIM failures=0
REGRESSION: body_load_test
VISUAL: no (Claude wires it into Exchanges / the shout bar and checks the fight)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: write `var e: float = float(PACE_EDGE.get(pace, 0.0))`,
`var hurt: bool = bool(opp_hurt.get("head", false))`. Float equality in tests: use is_equal_approx. No multi-line lambdas
inside a call.

## Prior research
`python Tools/prior_research.py pace output punch rate tired body` (old repo): BODY_TRACK_PLAN_S321.md (Pace = driver mode,
Aim = tap her body, the trade "win this round, or have hands up in round 9"); J_COMBOENERGY1_JOHN.md (energy 69/48/31 by
round, conditioning sets the refill); Exchanges.gd EDGE scale (best +15, ok +5, wrong -7) and BODY_SHARE 0.2 / BODY_CALL 0.5.

## What would a human do?
A trainer in the corner sets the pace for the next round - "step on it, this round is yours to take" or "take this one
off, get your legs back" - and tells her where to go: "the body, she's slowing", "the left ribs, you hurt her there".
Pushing wins rounds and empties the tank; saving gives a round away to win the last one. Aiming at what is already hurt
pays more than spreading the punches.

## Prefab check
Nothing to buy: a pure numbers module over our own exchange model (racing-manager driver modes are the reference only).

## When done
Commit both files on qwen/paceaim1, message ending `RESULT: tests/pace_aim_test.gd -> PACE_AIM failures=0`, and paste the
last 20 lines of both test runs in your final answer.
