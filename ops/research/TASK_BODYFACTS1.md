# TASK BODYFACTS1 - QWEN (qwen3-coder) - our fighters get a height and a reach

Status: OPEN (S448 side session, for the S449 lead). Discipline: boxing. Model: qwen3-coder.
Mechanic: PROGRESSION (approved, owner Q-S294-211 "Yes, go ahead"). Spec: ops/research/PROGRESSION_MAP_S448.md section 4 M5 "BODY FACTS"
and section 10 task 2. THE DEFECT: the duel already pays reach on the jab and height inside (scripts/rules/Duels.gd `facts`, lines
~409-418; REACH_PER_CM, HEIGHT_PER_CM, cap 4), but only when BOTH boxers carry "height" and "reach". Opponents do (AttrGen.body,
NationalField, Data rivals); OUR fighters never get the keys (Data.fighter_state), so the edge is 0 in every bout of ours.

## Contract
OWNS: scripts/rules/BodyFacts.gd, tests/body_facts_test.gd, scripts/state/Data.gd:242-253, scripts/state/SaveGame.gd:27-45
RED_TEST: tests/body_facts_test.gd -> BODY_FACTS failures=0
REGRESSION: save_load_test, tale_of_tape_test, tape_rows_test, first_week_test, golden_path_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file. Read, never edit:
- scripts/rules/AttrGen.gd `body(rng, sex, limit_kg)` (~line 226): the generator opponents use. Call it, do not copy it.
- scripts/rules/Duels.gd `facts` (~409): what reads the keys.
- scripts/fight3d/FightCast.gd `body_scales` (~38): the 3D already scales a body to f["height"] (clamped 0.88-1.12 of the mesh).
- scripts/rules/TaleOfTape.gd: shows f["height"] / f["reach"] when present.

## What to build (under 120 lines in BodyFacts.gd)
1. NEW pure `scripts/rules/BodyFacts.gd`, one preload (AttrGen):
   - `fill(f: Dictionary) -> void`: when f has no "height" (or no "reach"), set both from `AttrGen.body(rng, sex, limit)` with
     an rng seeded from the fighter's name (stable: the same fighter always gets the same body; use `hash(str(f["name"]))`).
     sex from f["sex"] ("w"/"m"; AttrGen treats anything but "men"/"m" as women), limit from f["limit"] (kg).
     A fighter that already has the keys is never changed.
2. `Data.fighter_state` (lines 242-253): call `BodyFacts.fill` on the dict it returns (one line; keep the merge as it is).
3. `SaveGame.from_dict` (lines 27-45): in the loop that already calls `FighterProfile.ensure(f)` for every fighter, also call
   `BodyFacts.fill(f)`, so old saves get bodies on load.

## The test (red on main first)
tests/body_facts_test.gd (extends SceneTree, prints `BODY_FACTS failures=<n>`, quits with the count):
- `Data.fighter_state` on a raw women's lightweight (copy the raw shape of Data's quick-start fighter) returns "height" and "reach";
  height 150-185, reach within height - 6 .. height + 12. RED on main today (no keys).
- Same raw dict twice -> the same height and reach (stable).
- A raw dict that already has height 171 / reach 175 keeps them.
- A men's welterweight's height is above the women's lightweight's mean by at least 5 cm over 50 generated names.
- `Duels.facts(ours, opponent)["reach"]` is not 0 for our fighter against `Data.OPPONENTS[0]` (or the first rival with a reach).
- A Career round trip: build a Career with one fighter, erase its height/reach, `SaveGame.from_dict(SaveGame.to_dict(c))` -> keys back.

## Traps
- Read ops/research/GDSCRIPT_TRAPS.md first (typed Dictionary reads, no `:=` on a Variant).
- Godot jobs only through `python ops/Tools/godot_slot.py run --who BODYFACTS1 -- <godot.exe> ...`; the plain win64 exe, never _console.
- Data.gd and SaveGame.gd: edit only inside the owned line windows. Do not delete or weaken any test.
- The game text rule: no he / she in comments you add to game-facing strings (no_pronoun_test).

## Prior research
- ops/research/PROGRESSION_MAP_S448.md M5 (why: body facts were a dead edge for our side).
- AttrGen.body header: heights from England Boxing class spans (men about 1.4 cm a kg over 172 at 60 kg, women 8 cm shorter), reach =
  height + 3 +- 4 (sports-sim critic).

## What would a human do?
A club measures every boxer's height and reach on the first day; the tale of the tape reads them; a longer boxer's jab lands from further.

## Prefab check
None needed: the generator exists (AttrGen.body); this task only calls it for our side.

Test command: `python ops/Tools/godot_slot.py run --who BODYFACTS1 -- "$LOCALAPPDATA/Programs/Godot/Godot_v4.7.2-stable_win64.exe"
--headless --audio-driver Dummy --path . --script res://tests/body_facts_test.gd`
RESULT line for the PR body: `RESULT: tests/body_facts_test.gd -> BODY_FACTS failures=0`.
