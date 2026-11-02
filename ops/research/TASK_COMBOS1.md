# TASK COMBOS1 - QWEN - combos she trains on the pads, and the energy they cost (Lean, pure rules module)

Model: Qwen (qwen3-coder, --yolo). Discipline: boxing (demo). Repo: E:\FightCamp\Lean (NOT the old Game repo).
Workspace: your own worktree E:\FightCamp\wt\LEAN_COMBOS1 (branch qwen/combos1). Commit there; do not push.

## Why
The operator approved combos (design: this folder's COMBOS_DESIGN_S302.md, read it first) and added: "combos should
also be associated with energy (stamina) in the fight". You write ONE pure module with every rule; Claude wires it into
training, the fight result, the 3D ring and the screens.

## Owned files (create both; touch nothing else)
- `scripts/rules/Combos.gd` (new, under 300 lines, `extends RefCounted`, static functions only, ONE preload:
  `const MoveMastery := preload("res://scripts/rules/MoveMastery.gd")`)
- `tests/combos_test.gd` (new, `extends SceneTree`, same shape as `tests/habit_beats_test.gd`; print
  `COMBOS failures=<n>`; quit(1 if failures else 0))

## Read first
- `scripts/rules/MoveMastery.gd` (tier, cap, gain, decay_week) - reuse them, never copy the maths.
- `scripts/state/Data.gd` line ~156: MOVES = ["Jab", "Cross", "Lead hook", "Body hook", "Uppercut", "Check hook"].
- `scripts/rules/BoutRules.gd` WEAPON_MASTERY (30.0), weapons_edge (the size of edge a combo may add).

## The module (exact names; Claude codes against them)
```
const LEARN_AT := 30.0              # every punch of the combo at least this (a weapon) to learn it
const BOOK := [                     # id, the moves (Data.MOVES names), the ring beats (RoundScript move names), counter?
	{"id": "1-1", "moves": ["Jab", "Jab"], "beats": ["jab", "jab"], "counter": false},
	{"id": "1-2", "moves": ["Jab", "Cross"], "beats": ["jab", "cross"], "counter": false},
	{"id": "1-1-2", "moves": ["Jab", "Jab", "Cross"], "beats": ["jab", "jab", "cross"], "counter": false},
	{"id": "2-3", "moves": ["Cross", "Lead hook"], "beats": ["cross", "lead_hook"], "counter": false},
	{"id": "1-2-3", "moves": ["Jab", "Cross", "Lead hook"], "beats": ["jab", "cross", "lead_hook"], "counter": false},
	{"id": "1-2-3-2", "moves": ["Jab", "Cross", "Lead hook", "Cross"], "beats": ["jab", "cross", "lead_hook", "cross"], "counter": false},
	{"id": "3b-3", "moves": ["Body hook", "Lead hook"], "beats": ["body_hook", "lead_hook"], "counter": false},
	{"id": "1-2-3b", "moves": ["Jab", "Cross", "Body hook"], "beats": ["jab", "cross", "body_hook"], "counter": false},
	{"id": "1-6-3", "moves": ["Jab", "Uppercut", "Lead hook"], "beats": ["jab", "rear_uppercut", "lead_hook"], "counter": false},
	{"id": "slip 2-3", "moves": ["Cross", "Check hook"], "beats": ["cross", "lead_hook"], "counter": true},
]
static func row(id: String) -> Dictionary                      # the BOOK row, {} if unknown
static func unlocked(moves: Dictionary) -> Array               # ids whose every move >= LEARN_AT (book order)
static func missing(id: String, moves: Dictionary) -> Array    # move names still under LEARN_AT ("needs Lead hook")
static func cap(id: String, moves: Dictionary, technique: float, ring_iq: float) -> float
	# min(MoveMastery.cap(technique, ring_iq), the lowest mastery among its moves): never sharper than its weakest punch
static func drill(m: float, id: String, minutes: float, coach_skill: float, station_tier: int, cap_value: float) -> float
	# MoveMastery.gain(m, "pads", minutes * 2.0 / len(moves), coach_skill, station_tier, 1.0, cap_value): 4 punches = half speed
static func fade(m: float, drilled: bool) -> float              # MoveMastery.decay_week
static func next_to_learn(moves: Dictionary, combos: Dictionary) -> String
	# the unlocked combo with the lowest mastery under LEARN_AT, shortest first then book order; "" if none
static func edge(combos: Dictionary, energy: float) -> float
	# power points for the round: per combo at USABLE (>=30) 0.12, SHARP (>=60) 0.20, SIGNATURE (>=85) 0.30, total cap 0.6,
	# times energy_scale(energy)
static func pick(combos: Dictionary, max_len: int, roll: float) -> Dictionary
	# a combo she throws: only >= LEARN_AT and len <= max_len, weighted by mastery; roll 0..1 chooses; {} if none
static func interval(m: float, same_hand: bool, energy: float) -> float
	# seconds contact to contact inside the combo: lerp(0.45, 0.30, clamp(m / 100, 0, 1)), +0.10 same hand
	# (Piorkowski 2011: 0.35 s alternating, 0.45 s same hand), +0.08 when energy < TIRED_AT
static func opponent_combos(opp: Dictionary) -> Dictionary     # id -> mastery from opp["style"] and scout words:
	# "Out-boxer" {"1-1": 55, "1-2": 50}, "Pressure fighter" {"1-2-3": 50, "3b-3": 45}, "Counter-puncher" {"slip 2-3": 55,
	# "1-2": 45}, "Slugger" {"2-3": 55, "1-2-3b": 40}, anything else {"1-2": 45}; then words in opp["threat"] + opp["weak"]
	# (lower case): "double" or "doubles the jab" -> "1-1" 60; "body" -> "3b-3" 50; "left hook" or "hook" -> "2-3" 50
static func describe(id: String, m: float) -> String           # "Sharp 1-2-3 (M64)" (MoveMastery.tier, Title case)

## ENERGY (the operator's addition). ESTIMATES until John's research lands; keep every number a named const.
const TANK := 100.0
const ROUND_COST := 18.0            # a round of single punches at conditioning 50
const COMBO_COST := 1.1             # per punch thrown inside a combo
const LONG_EXTRA := 0.15            # each punch past the 2nd costs this much more (a 4-punch combo: 1 + 0.15 + 0.30 extra)
const TIRED_AT := 40.0
static func combo_cost(length: int) -> float     # COMBO_COST * sum over punches k=1..length of (1 + LONG_EXTRA * max(0, k - 2))
static func uses(combos: Dictionary, corner: String) -> int
	# combos she throws in a round: 2 + 1.5 per combo at >= LEARN_AT, max 8, floor; corner "calm" x0.7, "body" x1.2 (floor)
static func round_spend(combos: Dictionary, corner: String, conditioning: float) -> float
	# (ROUND_COST + uses * combo_cost(average length of her usable combos, rounded; 2 if none)) * (1.5 - conditioning / 100)
static func recover(energy: float, conditioning: float) -> float   # min(TANK, energy + 8 + 0.2 * conditioning): the 60 s break
static func energy_scale(energy: float) -> float   # clamp(energy / 60, 0.4, 1.0)
static func tired_penalty(energy: float) -> float  # power points lost: 0 at >= TIRED_AT, else (TIRED_AT - energy) * 0.05, max 2.0
static func max_len(energy: float, speed_cap: int) -> int   # mini(speed_cap, 1 + int(energy / 34)), at least 1
```

## Tests (all must pass) - fighters as plain Dictionaries, TWO THAT DIFFER (never identical fighters)
A moves {"Jab": 62, "Cross": 48, "Lead hook": 33, "Body hook": 12, "Uppercut": 0, "Check hook": 0}
B moves {"Jab": 35, "Cross": 31, "Lead hook": 5, "Body hook": 40, "Uppercut": 31, "Check hook": 30}
1. unlocked(A) = ["1-1", "1-2", "1-1-2", "2-3", "1-2-3", "1-2-3-2"]; unlocked(B) = ["1-1", "1-2", "1-1-2", "1-2-3b", "slip 2-3"];
   missing("3b-3", A) = ["Body hook"]; missing("1-6-3", B) = ["Lead hook"].
2. cap("1-2-3", A, 70, 60) = 33 (the lead hook); cap("1-2", A, 30, 30) = MoveMastery.cap(30, 30) = 58.
3. drill: a 4-punch combo gains about half a 2-punch combo's points in the same minutes (within 10%); never past cap.
4. edge: 0 with no combos; three SIGNATURE combos at energy 100 = 0.6 (the cap); the same at energy 24 = 0.24.
5. pick never returns a combo under LEARN_AT or longer than max_len; over 1,000 rolls a combo at 80 is picked more
   often than one at 35; {} when nothing qualifies.
6. interval: m 0 alternating = 0.45, m 100 = 0.30, same hand +0.10, tired +0.08.
7. combo_cost(2) = 2.2, combo_cost(4) = 1.1 * (1 + 1 + 1.15 + 1.30); longer always costs more per punch.
8. ENERGY over a 3-round bout (spend, recover, spend, recover, spend from TANK): a conditioning-80 fighter ends with more
   energy than a conditioning-45 one with the same combos; "calm" ends with more than "body"; tired_penalty is 0 at
   >= 40 and 2.0 at 0; max_len(100, 4) = 3, max_len(20, 4) = 1.
9. opponent_combos: an "Out-boxer" with weak "Doubles the jab" has "1-1" at 60; unknown style -> {"1-2": 45}.
Write test 1 first and see it fail (the module missing), then build the module.

## The one test command (from the worktree root)
```
"%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe" --headless --audio-driver Dummy --path . --script tests/combos_test.gd
```
NEVER the `_console.exe`. Output must show `COMBOS failures=0` and no `SCRIPT ERROR`. A script error in `_initialize`
HANGS the run: if there is no output in 60 s, kill it and fix the error. Also run `tests/move_mastery_test.gd` (stays green).

## Contract
OWNS: scripts/rules/Combos.gd, tests/combos_test.gd   (Lean repo)
RED_TEST: tests/combos_test.gd -> COMBOS failures=0
REGRESSION: move_mastery_test
VISUAL: no (Claude wires the ring and checks a film)

## The one trap
GDScript `:=` on a Variant from a Dictionary is a parse error: `var m: float = float(combos[id])`. Integer division in
`uses` must floor (int()). `BOOK` rows are Dictionaries inside a const Array: read them, never modify them.

## Prior research
research/G49_THE_EXCHANGE.md s2 (combos ~half of attacks, 12 types = half of combos, jab more accurate in a
combo); G53_THE_COMBINATION_INTERVAL.md + Piorkowski 2011 p.11 (0.35 s / 0.45 s contact to contact); COMBOS_DESIGN_S302.md.

## What would a human do?
A coach builds combos on the pads one at a time from punches the boxer already owns, and a tired boxer throws one or
two punches instead of four.

## Prefab check
No asset or library: a pure rules module over our own data. None needed.
