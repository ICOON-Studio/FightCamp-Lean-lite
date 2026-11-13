# TASK COACHMARKET1 - QWEN (qwen3-coder) - the assistant market: four coaches, growth, the second slot, the Signature rate, letting go

Status: OPEN (S458, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: PROGRESSION (approved, owner Q-S294-211 "Yes, go ahead"). Spec: ops/research/PROGRESSION_MAP_S448.md section 4 M6 "COACHES:
SPEED, SLOTS AND A MARKET" (READ IT) and section 10 task 11. A PURE module + its test: no wiring (Claude wires it into PadWeek, the
staff screen and the Monday review after the merge; the COACHMARKET1 probe tunes the numbers later).

## Contract
OWNS: scripts/rules/CoachMarket.gd, tests/coach_market_test.gd
RED_TEST: tests/coach_market_test.gd -> COACH_MARKET failures=0
REGRESSION: learn_slots_test, specialty_test, coach_check_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file. Read, never edit:
- scripts/state/Data.gd lines 29-40: COACHES (Luke Reid "reid", Marcus Hale "hale": id, name, kind, salary a WEEK, rating, spec, note,
  areas {pads, bag, sparring, conditioning, strength}). S411 rule: `rating` is the average of `areas`, rounded.
- scripts/rules/LearnSlots.gd: slots(assistant_pads) - 2 slots at pads 65+. Reuse it, never copy the 65.
- scripts/rules/MoveTree.gd: STEP_IDS (the footwork nodes).

## What to build (CoachMarket.gd under 250 lines; pure static; preloads Data, LearnSlots and MoveTree only)
Constants:
- MAX_HIRED := 2 (two assistants at once, each paid).
- NEW_COACHES: two Dictionaries in Data.COACHES' exact shape (ESTIMATES, the probe tunes them):
  - {"id": "price", "name": "Jamie Price", "kind": "Sessional assistant coach", "salary": 380, "spec": "Pad work",
     "note": "young, three evenings a week", "areas": {"pads": 60, "bag": 56, "sparring": 55, "conditioning": 50, "strength": 44}}
  - {"id": "mendez", "name": "Rosa Mendez", "kind": "Sessional assistant coach", "salary": 520, "spec": "Footwork",
     "note": "three evenings a week", "areas": {"pads": 62, "bag": 58, "sparring": 72, "conditioning": 60, "strength": 48}}
  Each also gets "rating" = the rounded average of its areas (compute it in the test, write the number in the const).
- GROWTH := {coach id: {area: [sessions per +1, ceiling]}}: reid {pads: [10, 82]}, hale {pads: [10, 70]}, price {pads: [8, 72]},
  mendez {pads: [10, 68]}. An area not listed does not grow.
- FOOTWORK_MULT := 1.2 (mendez only, on MoveTree.STEP_IDS nodes). SIGNATURE_DRILL_SESSIONS := 40, SIGNATURE_DRILL_MULT := 1.2.
Functions:
1. `market() -> Array`: Data.COACHES + NEW_COACHES (copies, deep), in that order.
2. `coach(id: String) -> Dictionary`: one from market(), {} when unknown.
3. `can_hire(hired: Array, id: String) -> bool`: false when id is unknown, already in hired, or hired.size() >= MAX_HIRED.
4. `area_now(id: String, area: String, sessions: int) -> float`: the area's start value + floor(sessions / per), capped at the ceiling;
   an area not in GROWTH returns its start value whatever the sessions.
5. `sessions_to(id: String, area: String, target: float, sessions: int) -> int`: pad sessions still needed to reach target; 0 when
   already there; -1 when target is over the ceiling (or the area does not grow).
6. `second_slot(id: String, sessions: int) -> bool`: LearnSlots.slots(area_now(id, "pads", sessions)) == 2.
7. `signature_rate(pads: float) -> float`: clamp((pads - 55) / 20, 0.25, 1.0). (Luke 74 -> 0.95, Marcus 58 -> 0.25, Jamie at 72 -> 0.85.)
8. `node_mult(id: String, node_id: String, move_sessions: int) -> float`: 1.0; x FOOTWORK_MULT when id == "mendez" and node_id is in
   MoveTree.STEP_IDS; x SIGNATURE_DRILL_MULT when move_sessions (that coach's pad sessions on that one move) >= SIGNATURE_DRILL_SESSIONS.
9. `let_go(id: String) -> Dictionary`: {cost: one week's salary, keeps_growth: true}. The caller keeps the sessions count on the coach.
10. `milestone(id: String, sessions: int) -> String`: the next pads milestone, in role words only, NO names and no he/she (operator
    S448: names only in headers): "<role>: <n> pad sessions to 65: second slots" while under 65, then "<role>: <n> pad sessions to
    <ceiling>: top pads" while under the ceiling, "" at the ceiling. Role = "The young coach" (price), "The footwork coach" (mendez),
    "The pads coach" (reid), "The conditioning coach" (hale).

## The test (red on main first: the file does not exist)
tests/coach_market_test.gd (extends SceneTree, prints `COACH_MARKET failures=<n>`, quits with the count):
- market(): 4 coaches, ids reid, hale, price, mendez; each has every key Data.COACHES rows have; each rating = round(average of areas).
- Changing a returned dict does not change the next market() (deep copies).
- can_hire: [] + "price" true; ["reid", "hale"] + "price" false (two at once); ["reid"] + "reid" false; "nobody" false.
- area_now: price pads 0 -> 60, 8 -> 61, 96 -> 72, 500 -> 72; reid pads 25 -> 76; hale bag 100 -> 72 (does not grow).
- sessions_to: price pads target 65 from 0 -> 40; reid 65 from 0 -> 0; mendez 70 -> -1.
- second_slot: price at 0 false, at 40 true; reid at 0 true; hale at 0 false; mendez at 0 false, at 30 true (62 + 3 = 65).
- signature_rate: 74 -> 0.95, 58 -> 0.25, 72 -> 0.85, 40 -> 0.25, 90 -> 1.0.
- node_mult: mendez on a STEP_IDS node 1.2, on "Jab" 1.0; reid on "Jab" at 40 sessions 1.2, at 39 1.0; mendez on a step at 40 = 1.44.
- let_go("hale").cost == 1090.
- milestone: price 0 -> "The young coach: 40 pad sessions to 65: second slots"; price 40 -> "...: 56 pad sessions to 72: top pads";
  price 96 -> ""; no milestone string contains a coach's name, " he ", " she ", " his ", " her ".
- Two different coaches give different area_now / milestone for the same sessions (the module reads the coach, not a constant).

## Traps
- Read ops/research/GDSCRIPT_TRAPS.md first (typed Dictionary reads, no `:=` on a Variant, `%%`, Array[Dictionary] const copies:
  use .duplicate(true)).
- Godot jobs only through `python ops/Tools/godot_slot.py run --who COACHMARKET1 -- <godot.exe> ...`; the plain win64 exe, never _console.
- Do not delete or weaken any test. Under 500 lines a file. Never edit Data.gd (the two new coaches live in CoachMarket.gd).

## Prior research
- PROGRESSION_MAP_S448.md M6 (this), M2 (the slots, LearnSlots), section 9 COACHMARKET1 probe row; RPG 11 (growth +1 per 10 sessions).

## What would a human do?
A club owner hires the coach the boxers need now (a pads man for a second move in learning, a strength coach for bodies) or bets on a
young coach who gets better with work; letting one go costs a week's pay and the coach keeps what was learned.

## Prefab check
None: Data.COACHES holds the two coaches the game has; this adds the market and the growth on top.

Test command: `python ops/Tools/godot_slot.py run --who COACHMARKET1 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
--headless --audio-driver Dummy --path . --script res://tests/coach_market_test.gd`
RESULT line for the PR body: `RESULT: tests/coach_market_test.gd -> COACH_MARKET failures=0`.
