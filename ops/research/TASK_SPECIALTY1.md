# TASK SPECIALTY1 - QWEN (qwen3-coder) - held moves: the weekly hold, the fade, frozen weeks, the coach's hold list

Status: OPEN (S456, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: PROGRESSION (approved, owner Q-S294-211 "Yes, go ahead"). Spec: ops/research/PROGRESSION_MAP_S448.md section 4 M3 (lines
120-137, READ IT) and section 10 task 8. A PURE module + its test: no wiring (Claude wires it into PadWeek's week and the Monday review
after the merge).

## Contract
OWNS: scripts/rules/Specialty.gd, tests/specialty_test.gd
RED_TEST: tests/specialty_test.gd -> SPECIALTY failures=0
REGRESSION: move_tree_test, move_mastery_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file. Read, never edit:
- scripts/rules/MoveTree.gd: PUNCH_IDS, STEP_IDS, DEFENCE_IDS, COMBO_PUNCHES, STYLES, mastery(f, id), the style-naming function near line 145.
- scripts/rules/MoveMastery.gd: tiers 30 / 60 / 85 (Usable / Sharp / Signature), decay_week (the Usable floor of 30).

## What to build (Specialty.gd under 200 lines; pure static; preloads MoveTree and MoveMastery only)
Constants: HOLD_SHARP 20.0, HOLD_SIGNATURE 40.0, FADE 1.5, SHARP_FLOOR 50.0, SIGNATURE_FLOOR 70.0, SPAR_UNITS 180.0.
1. `line_for(m: float) -> float`: the drill units a week the move needs to hold: 40.0 at 85+, 20.0 at 60+, 0.0 under 60.
2. `units(pads: Dictionary, bag: Dictionary, spar_cards: Array, spar_units := SPAR_UNITS) -> Dictionary`: drill units each MOVE got this
   week. pads / bag = {card: units} where a card is "move:<id>" or "combo:<key>"; a combo's units are split EVENLY over its punches
   (MoveTree.COMBO_PUNCHES[key]) and added to each punch. Sparring: spar_cards (cards on the sparring night, same "move:"/"combo:" form)
   are expanded to their moves, each move counted ONCE (a move named twice counts once), and spar_units is split evenly over those
   distinct moves. Keys of the result: bare move ids ("Jab", "step_in"). Unknown combo keys are skipped.
3. `frozen(phase: String, fight_week: bool, injured: bool) -> bool`: true when phase == "taper", or fight_week, or injured; else false.
4. `week(f: Dictionary, got: Dictionary, frozen_week: bool) -> Dictionary`: the Sunday check over every move at 60+ (punches in
   f["moves"], steps and defences in f["steps"]; read with MoveTree.mastery). Returns
   `{moves: {id: new}, steps: {id: new}, held: Array, faded: Array}` - NEW dictionaries (never mutate f):
   - frozen_week -> nothing changes, every 60+ move is in `held`.
   - got[id] >= line_for(m) -> held, unchanged.
   - else a Signature (85+) falls FADE but not below SIGNATURE_FLOOR; a Sharp (60 to 85) falls FADE but not below SHARP_FLOOR; it goes in
     `faded`. Moves under 60 are copied unchanged (their fade is MoveMastery.decay_week's job, not this module's).
5. `coach_holds(f: Dictionary, plan_moves: Array) -> Array`: the moves the coach holds by default: every move in plan_moves that is at
   60+, plus every Signature (85+), each once, in MoveTree order (PUNCH_IDS, then STEP_IDS, then DEFENCE_IDS).
6. `dropped(f: Dictionary, plan_moves: Array) -> Array`: the 60+ moves NOT in coach_holds (what the Monday list shows as dropped).
7. `needs_flag(f: Dictionary, got: Dictionary, holds: Array, frozen_week: bool) -> Array`: the Signature moves that will fade this week
   and are NOT in holds (they raise an amber need); empty in a frozen week.

## Test (tests/specialty_test.gd, extends SceneTree, prints "PASS ..." / "FAIL ..." lines and a last line `SPECIALTY failures=<n>`,
quits with that count). Expected values FROM THIS BRIEF, not from your code. At least:
- line_for(59.9) 0, line_for(60) 20, line_for(85) 40.
- units: pads {"combo:1-2": 60} -> Jab 30, Cross 30; spar_cards ["move:Jab", "combo:1-2", "move:Lead hook"] -> 3 distinct moves, 60 each;
  4 distinct moves -> 45 each.
- frozen("taper", false, false) true; frozen("peak", false, false) false; frozen("build", false, true) true.
- week: Sharp Jab 62 with 10 units -> 60.5 and in faded; with 20 units -> 62 and in held; a move at 50.8 (under 60) unchanged and in
  neither list; Sharp 60.0 with 0 units -> 58.5; Signature 86 with 30 units -> 84.5; frozen week -> all unchanged and all 60+ in held;
  a step "step_in" 65 in f["steps"] with 0 units -> 63.5 in the returned steps; f itself unchanged after the call.
  The floors (50 / 70) are a clamp: test them with FADE temporarily irrelevant by a direct check that a Signature at 85.0 with 0 units
  gives 83.5 (85 - 1.5, above 70) - the floors guard later tuning of FADE.
- coach_holds with plan ["Jab", "step_in"] and Jab 62, step_in 65, Cross 88, Lead hook 61 -> ["Jab", "Cross", "step_in"];
  dropped -> ["Lead hook"].
- needs_flag: Cross 88 with 10 units, holds without Cross -> ["Cross"]; frozen -> [].
Prove the test can fail: break one function locally, see FAIL, restore.

## Prior research
PROGRESSION_MAP_S448.md M3 (the hold rule, HOLD1 sets the numbers later); PadWeek.spar_pool (CODE) for how sparring shares; LearnSlots.gd
(SLOTS1) as the style of a merged pure module.

## What would a human do?
A coach keeps a fighter's best punches sharp by drilling them a little every week; skip it and they dull, but never back to beginner.
Fight weeks, tapers and injuries freeze the decline.

## Prefab check
Pure GDScript arithmetic over dictionaries; no library or asset applies.

## Traps
- Keys: punches are capitalised names ("Jab", "Lead hook"); steps/defences are snake_case ids. Do not lower-case.
- Never read GameState.gd or FightRealtime.gd. Parse gate before running the test. No script over 500 lines.
- Headless only: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/specialty_test.gd`
  (never the _console.exe; nothing opens on screen).
