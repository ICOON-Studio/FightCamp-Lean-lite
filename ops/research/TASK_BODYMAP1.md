# TASK BODYMAP1 - QWEN - where the punches land: six places on each boxer, the round's numbers, the corner's fixes (Lean)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_BODYMAP1 (branch qwen/bodymap1). Commit there; do not push.

## Why
The operator approved (board Q-S294-29, "Yes, build it") a body map: six places on each boxer light up where punches land,
the corner minute fixes one place, and the corner card shows the round's numbers behind each call. Plan:
`Game research/S316_BODY_MAP_PLAN.md` (copied below in short). You write ONE pure module: the six places' values
from the round's beats, the round's punch tally, and the corner jobs' effect. Claude wires it into the 3D view and the
corner card - not your job.

## The beats you get (read `scripts/rules/RoundScript.gd`, `scripts/rules/ClinchBeats.gd`, `scripts/rules/InsideBeats.gd`
and `tests/inside_beats_test.gd` - same beat format and the same style of module)
One exchange = an Array of beats, each `{"t": float, "who": "a"|"b" (the one who THROWS), "move": String,
"result": "lands"|"blocked"|"misses"|"none", ...}`; some carry "big": true (a power shot) or "combo": true.
Punch moves: jab, cross, lead_hook, body_hook, rear_uppercut. Other moves ("inside", "clinch", "step_out", ...) are not
punches - ignore them. Build test rounds the way `tests/inside_beats_test.gd` does (RoundScript.build, 6 exchanges a round).

## Owned files (create both; touch nothing else)
- `scripts/rules/BodyMap.gd` (new, under 220 lines, `extends RefCounted`, static functions only, ZERO preloads)
- `tests/body_map_test.gd` (new, `extends SceneTree`, same shape as `tests/inside_beats_test.gd`; it MAY preload
  RoundScript (and BurstShape/InsideBeats if that test does) to build rounds; prints `BODY_MAP failures=<n>`;
  quit(1 if failures else 0))

## The module
```
const PLACES := ["head", "left_eye", "right_eye", "nose", "left_ribs", "right_ribs"]   # the DEFENDER's own left/right
## Settled bands (Game research topics/body_damage.md - do not retune): fine > 55, hurt <= 55, critical <= 35, doctor <= 15.
const HURT := 55.0
const CRITICAL := 35.0
const DOCTOR := 15.0
## Points one landed punch takes off. GAME-DESIGN ESTIMATES (see test 5): you may change these four numbers so the
## bounds in test 5 hold; report the values you end on and the measured landed punches per round.
const FACE_HIT := 2.5      # the eye / nose a head punch lands on
const HEAD_HIT := 1.2      # the chin/brain ("head") on every head punch; hooks and uppercuts x1.5
const RIB_HIT := 3.0       # a body_hook on its side's ribs
const BIG_MULT := 2.0      # a beat with "big": true
## A face place falling to CRITICAL or below opens a cut there; a cut place takes CUT_MULT damage until the cutman closes it.
const CUT_MULT := 1.5

static func fresh() -> Dictionary
## -> {"a": {"places": {place: 100.0, ...}, "cuts": {}, "relief": {}}, "b": {...}}
static func add_beats(map: Dictionary, beats: Array, south: Dictionary) -> void
## In place. south = {"a": bool, "b": bool} (a southpaw's lead hand is her RIGHT). For every punch beat with result
## "lands": the defender is the other boxer; damage goes to the places below.
static func value(map: Dictionary, who: String, place: String) -> float
## places[place] + relief.get(place, 0), capped at 100.
static func band(v: float) -> String
## "fine" | "hurt" | "critical" | "doctor" by the settled bands.
static func tally(beats: Array) -> Dictionary
## -> {"a": {"thrown": {kind: n}, "landed": {kind: n}, "pct": {kind: 0..100 int}}, "b": {...}} over kinds
## "jab", "straight" (cross), "hook" (lead_hook), "uppercut" (rear_uppercut), "body" (body_hook), "total".
static func corner(map: Dictionary, who: String, cutman: String, second: String) -> void
## In place, between rounds. cutman: "" | "enswell_left" | "enswell_right" | "cut"; second: "" | "ice_left" |
## "ice_right" | "water" | "clear". Effects below; relief lasts ONE round.
static func end_round(map: Dictionary) -> void
## Clears every relief and every "closed" mark (call after the round that follows the corner).
```
Where a landed punch goes (attacker orthodox: lead hand = left; southpaw: lead = right; facing each other, the attacker's
LEFT hand lands on the defender's RIGHT side):
- jab (lead hand, straight): nose 60 %, else the eye on the defender's side opposite the attacker's lead hand
  (orthodox jab -> defender's right eye). Plus HEAD_HIT.
- cross (rear hand, straight): nose 50 %, else the defender's eye on the rear hand's side (orthodox cross -> left eye).
  Plus HEAD_HIT.
- lead_hook: the defender's eye on that side (orthodox lead hook -> right eye). Plus HEAD_HIT x 1.5.
- rear_uppercut: nose. Plus HEAD_HIT x 1.5.
- body_hook (thrown with the lead hand): the defender's ribs on that side (orthodox -> right ribs = the liver). No head.
"Random" picks use an rng seeded from the beat: `hash(str(beat["t"]) + str(beat["who"]) + str(beat["move"]))`, so the same
beats always give the same map (no rng parameter). Values never go below 0.
Corner effects:
- enswell_left / enswell_right: that eye gets relief = enough to lift it ONE band up (to 1 point above that band's floor:
  doctor -> 16, critical -> 36, hurt -> 56); nothing on a "fine" eye.
- cut: every cut place is "closed" for the next round: no CUT_MULT there (the cut stays; it reopens at end_round).
- ice_left / ice_right: that ribs place gets relief = 15 % of (100 - its value) (real: 10-20 % of the sting).
- water / clear: no change to the map (CornerJobs handles energy and the head) - accept and ignore them.
- Only one cutman job and one second job are possible; anything else is ignored.

## Tests (all must pass; 300 seeds per case unless said)
1. fresh(): both boxers, six places at 100, no cuts. A round with no landed punch changes nothing. (Write this first and
   see it fail: module missing.)
2. Sides: orthodox a, one landed lead_hook -> b's right_eye drops and b's head drops x1.5 of a jab's head drop; one
   body_hook -> b's right_ribs; southpaw a -> left_eye / left_ribs. A blocked or missed punch changes nothing. A "big"
   beat takes BIG_MULT. A punch by b lands on a.
3. Bands: band(56)=fine, band(55)=hurt, band(35)=critical, band(15)=doctor, band(0)=doctor; value() caps at 100.
4. Cuts and the corner: a face place reaching CRITICAL opens a cut; the next hit there takes CUT_MULT; after corner(...,
   "cut", "") the next hit there is normal, after end_round CUT_MULT again. enswell lifts one band exactly as above and
   end_round removes it; ice gives 15 % of the missing points on that side only; "water"/"clear" change nothing.
5. A realistic bout (RoundScript, 3 rounds, both orthodox in half the seeds, one southpaw in the other half; print the
   mean landed punches per round per boxer): after round 3 the LOSER of the bout has at least one place "hurt" or worse
   in 40-90 % of seeds; any place "doctor" after round 3 in at most 8 % of seeds; the winner ends all "fine" in at least
   50 % of seeds; "head" is never the lowest place in more than 40 % of seeds.
6. tally(): totals equal the counted punch beats per boxer; pct = landed * 100 / thrown (0 when none thrown).
7. Same beats -> same map (determinism), and add_beats over two exchanges equals add_beats over their concatenation.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/body_map_test.gd
```
NEVER the `_console.exe`. Output must show `BODY_MAP failures=0` and no `SCRIPT ERROR`. A script error in `_initialize`
HANGS the run: if there is no output in 60 s, kill it and fix the error. Parse gate first:
`... --headless --path . --check-only --script res://scripts/rules/BodyMap.gd`. Also run `tests/inside_beats_test.gd`
the same way (must stay green). Only the four constants marked ESTIMATES may be tuned, and only for test 5; if a bound
in test 5 still fails, say so in your final answer with the measured value - never widen a bound.

## Contract
OWNS: scripts/rules/BodyMap.gd, tests/body_map_test.gd   (Lean repo)
RED_TEST: tests/body_map_test.gd -> BODY_MAP failures=0
REGRESSION: inside_beats_test
VISUAL: no (Claude wires the live figure, the corner card figure and the stills)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: write `var m: String = str(b["move"])`. A multi-line
lambda inside a call hangs the parser in this repo - use a named static func. Do not name a variable `free` or reuse a
loop variable name in one scope. Dictionaries are passed by reference: fresh() must build new inner dictionaries per
boxer (no shared {} literal const).

## Prior research
`python Tools/prior_research.py body damage cutman enswell region` (old repo): topics/body_damage.md (SETTLED bands),
G132_LIVE_DAMAGE_AND_THE_CORNER.md (the cutman's jobs: enswell held on swelling, pressure + adrenaline on a cut, ice buys
one round, body damage not closed in 60 s - 10-20 % of the sting), G44 (what a manager does mid-fight), S316_BODY_MAP_PLAN.md.

## What would a human do?
A cutman watches where the punches land all round - the eye the jab keeps finding, the ribs the hook digs - and in the
minute holds the iced enswell on the swelling eye or presses the cut closed; the chief second ices the ribs and reads the
round's numbers (CompuBox-style: thrown, landed, by kind) to pick the next round's plan.

## Prefab check
Nothing to buy: a pure module over our own beat format (EA UFC region bars and Fight Night Champion's face damage are the
references for the LOOK, which Claude builds).

## When done
Commit both files on qwen/bodymap1, message ending `RESULT: tests/body_map_test.gd -> BODY_MAP failures=0`, and paste
the last 20 lines of both test runs plus the four constants' final values in your final answer.
