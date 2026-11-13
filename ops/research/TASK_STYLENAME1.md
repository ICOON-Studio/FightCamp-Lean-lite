# TASK STYLENAME1 - QWEN (qwen3-coder) - the named style: which one, when it goes, what it changes, the extra plan line

Status: OPEN (S457, Claude main). Discipline: boxing. Model: qwen3-coder.
Mechanic: PROGRESSION (approved, owner Q-S294-211 "Yes, go ahead"). Spec: ops/research/PROGRESSION_MAP_S448.md section 4 M4 (READ IT)
and section 10 task 8 ("styles, their effects as numbers"). A PURE module + its test: no wiring (Claude wires the effects into the fight
levers and the Monday check after the merge; STYLE1, a later probe, tunes every number).

## Contract
OWNS: scripts/rules/StyleName.gd, tests/style_name_test.gd
RED_TEST: tests/style_name_test.gd -> STYLE_NAME failures=0
REGRESSION: move_tree_test, specialty_test, file_limits_test, no_pronoun_test
VISUAL: no
NOT YOURS: every other file. Read, never edit:
- scripts/rules/MoveTree.gd: STYLES (the six sets), PUNCH_IDS, mastery(f, id), styles_held(f) (style names whose three moves are all 60+).

## What to build (StyleName.gd under 200 lines; pure static; preloads MoveTree only)
Constants:
- MAX_LINES := 7 (a plan never goes past 7 lines, even with the style's extra line).
- EFFECTS := one row per style, the lever it moves and by how much (ESTIMATES from the map, STYLE1 tunes them later):
  "Out-boxer": {"lever": "range_open", "add": 0.1}
  "Volume puncher": {"lever": "combo_energy", "mult": 0.9}
  "Boxer-puncher": {"lever": "mid_edge", "add": 0.1}
  "Pressure fighter": {"lever": "pressure_answers", "mult": 1.2}
  "Slugger": {"lever": "knockdown", "mult": 1.1}
  "Counter-puncher": {"lever": "counter_edge", "add": 0.15, "when": ["loadup", "press"]}
Functions:
1. `named(f: Dictionary) -> String`: f.get("style", "") if that style is still in MoveTree.styles_held(f), else "".
2. `can_name(f: Dictionary, style: String) -> bool`: true when style is in MoveTree.styles_held(f).
3. `monday(f: Dictionary) -> Dictionary`: the Monday check, returns NEW values, never mutates f:
   `{style: String, lost: String, auto: bool}`.
   - f["style"] set and still held -> style kept, lost "", auto false.
   - f["style"] set and NOT held -> style "", lost = the old style name.
   - then, when style is "" and EXACTLY ONE style is held -> that style, auto true (a fighter holding two sets names one on the board:
     with two or more held and none named, style stays "").
4. `effect(f: Dictionary, lever: String, opp_mode := "") -> float`: the named style's value for that lever: its "add" (an edge, neutral
   0.0) or its "mult" (a multiplier, neutral 1.0). Any other lever, or no named style -> neutral for that lever's kind (a lever whose
   style row uses "mult" is neutral 1.0; one using "add" is neutral 0.0; an unknown lever 0.0). A row with "when" counts only when
   opp_mode is in its list, else neutral.
5. `plan_cap(f: Dictionary, coach_cap: int) -> int`: coach_cap + 1 when a style is named (named(f) != ""), never above MAX_LINES; else
   min(coach_cap, MAX_LINES).
6. `two_held(f: Dictionary) -> bool`: two or more styles held at once (the probe's "under 1 in 4" count).

## Test (tests/style_name_test.gd, extends SceneTree, prints "PASS ..." / "FAIL ..." lines and a last line `STYLE_NAME failures=<n>`,
quits with that count). Build the fighter dict by hand: punches in f["moves"] (capitalised: "Jab", "Cross", "Lead hook", "Body hook",
"Uppercut", "Check hook"), steps and defences in f["steps"] (snake_case: "step_in", "step_out", "step_back", "pivot_out", "tie_up",
"roll_out"). Expected values FROM THIS BRIEF, not from your code. At least:
- Out-boxer held: moves Jab 62, steps step_out 61, step_back 60 -> can_name "Out-boxer" true; "Slugger" false.
- named: f["style"] = "Out-boxer" while held -> "Out-boxer"; with step_back 59.9 -> "".
- monday: named + held -> {style "Out-boxer", lost "", auto false}; named + step_back 59 -> {style "", lost "Out-boxer", auto false};
  no style, only Out-boxer held -> {style "Out-boxer", lost "", auto true}; no style, Out-boxer AND Volume puncher held (add Cross 60,
  pivot_out 60) -> style "", auto false; f itself unchanged after every call.
- effect: Slugger named (Body hook 60, Lead hook 60, roll_out 60, f["style"] "Slugger") -> effect "knockdown" 1.1, effect "range_open"
  0.0, effect "combo_energy" 1.0; no style -> "knockdown" 1.0. Counter-puncher named (Lead hook 60, step_out 60, Check hook 60) ->
  effect "counter_edge" with opp_mode "loadup" 0.15, "press" 0.15, "range" 0.0, "" 0.0.
- plan_cap: named, coach_cap 5 -> 6; named, coach_cap 7 -> 7; not named, coach_cap 5 -> 5; not named, 9 -> 7.
- two_held: Out-boxer + Volume puncher held -> true; only Out-boxer -> false.
Prove the test can fail: break one function locally, see FAIL, restore.

## Prior research
PROGRESSION_MAP_S448.md M4 (styles, effects, the extra line, one style at a time, lose the hold = the style goes next Monday); M3 and
scripts/rules/Specialty.gd (the hold that keeps a move at 60+, merged S457); LearnSlots.gd as the style of a merged pure module.

## What would a human do?
A coach names a boxer by what the boxer holds: a jab and good feet make an out-boxer. Let the feet go stale and that boxer is not an out-boxer any more;
the style is a label earned and kept by work, and it changes how the boxer fights.

## Prefab check
Pure GDScript arithmetic over dictionaries; no library or asset applies.

## Traps
- Keys: punches are capitalised names; steps/defences are snake_case. Do not lower-case. Read every mastery with MoveTree.mastery(f, id).
- Do not write pronouns (he/she/him/her/his/hers) in strings or comments: tests/no_pronoun_test.gd fails on them.
- Never read GameState.gd or FightRealtime.gd. Parse gate before running the test. No script over 500 lines.
- Headless only: `%LOCALAPPDATA%\Programs\Godot\Godot_v4.7.2-stable_win64.exe --headless --audio-driver Dummy --path . --script res://tests/style_name_test.gd`
  (never the _console.exe; nothing opens on screen).
