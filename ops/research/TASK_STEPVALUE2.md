# TASK STEPVALUE2 - what a step is worth against each style, for the learn card (pure table + test)

Status: OPEN (S485, Claude main). Discipline: boxing. Model: Arena (cloud, lite mirror), default.

## Why now
STEPVALUE1 is APPROVED (owner, board Q-S294-230 "Yes, build it after the fight week"). Map:
ops/research/DESIGN_STEPVALUE1_V1_KALLI_KALLI.md, build piece 6 ("StepValue: the section 5 targets read by the learn
card"), sections 4.1 and 5. Pieces 2+4 (scripts/rules/StepEffect.gd) are on main. Every number below is the map's
ESTIMATE; a later probe tunes them here. Nothing calls it yet; Claude wires the learn card after. Pure rules only.

## What to build: scripts/rules/StepValue.gd (extends RefCounted; pure static; NO preload, NO class_name)
Constants:
- `STYLES := ["Pressure fighter", "Slugger", "Out-boxer", "Counter-puncher", "Volume puncher", "Boxer-puncher"]`
- `TARGET := {` step id -> {style: wins in 100 at Sharp, OK grade} `}`. Each step has its BEST style (its target), its
  WRONG style (negative), and every other style the "against other styles" value (use the HIGH end of the map's range):

| step | best style: value | wrong style: value | every other style |
|---|---|---|---|
| step_back | Pressure fighter: 3.5 | Out-boxer: -1.5 | 1.0 |
| step_out | Slugger: 2.5 | Counter-puncher: -1.0 | 1.0 |
| pivot_out | Pressure fighter: 2.5 | Out-boxer: -0.5 | 0.0 |
| step_in | Out-boxer: 3.0 | Counter-puncher: -2.5 | 0.5 |
| cut_off | Out-boxer: 3.5 | Pressure fighter: -1.5 | 0.0 |
| herd | Volume puncher: 2.0 | Pressure fighter: -1.5 | 1.0 |
| feint | Counter-puncher: 4.0 | Pressure fighter: -1.0 | 0.5 |
| tie_up | Slugger: 3.0 | Out-boxer: -1.0 | 0.0 |
| roll_out | Slugger: 3.0 | Volume puncher: -1.0 | 1.0 |
| push_off | Pressure fighter: 1.5 | Out-boxer: -0.5 | 0.0 |

  Build TARGET with all 10 steps x all 6 styles filled (60 numbers) from that table.
- `TIER_WORTH := {"new": 0.0, "usable": 2.0 / 3.0, "sharp": 1.0, "signature": 4.0 / 3.0}`  (map 4.1: worth against Sharp)
- `TIER_FROM := [[85.0, "signature"], [60.0, "sharp"], [30.0, "usable"], [0.0, "new"]]` (mastery bar -> tier, highest first)
- `GRADE_MULT := {"good": 1.2, "ok": 1.0, "poor": 0.35 / 0.85}`  (the map's targets are AT OK grade; StepEffect scales
  OK by 0.85 already, so here good/ok/poor are relative to OK: good 1.2/0.85, ok 1.0, poor 0.35/0.85 - write
  `{"good": 1.2 / 0.85, "ok": 1.0, "poor": 0.35 / 0.85}`)
- `STACK_CAP := 5.0` (all of a boxer's steps together, against one style, never more than +5 in 100)

Functions:
1. `tier(mastery: float) -> String` - from TIER_FROM.
2. `worth(step: String, style: String, mastery: float, grade_word: String) -> float` - TARGET[step][style] x
   TIER_WORTH[tier(mastery)] x GRADE_MULT[grade_word] (unknown grade = "ok"); 0.0 for an unknown step or style.
   A NEGATIVE target is NOT scaled by grade (walking into it hurts the same however well you do it): negative x tier only.
3. `stack(steps: Dictionary, style: String, grades: Dictionary) -> float` - steps = {step id: mastery}; the sum of
   worth over them (grade from grades[step], default "ok"), with the POSITIVE part capped at STACK_CAP; negatives are
   added after the cap. Example: three steps at +2.5, +2.5, +1.5 and one at -1.0 -> min(6.5, 5.0) - 1.0 = 4.0.
4. `best_style(step: String) -> String`, `wrong_style(step: String) -> String` - the style with the highest / lowest
   TARGET for that step ("" unknown).
5. `learn_line(step: String, style: String, mastery: float, grade_word: String) -> String` - the learn card's line, game
   words, never jargon, names never used:
   worth > 0.05: "Worth about +%.1f in 100 against a %s" (style lower-cased, e.g. "a pressure fighter")
   worth < -0.05: "Walks into it against a %s: about %.1f in 100" (the minus sign shown, e.g. "-1.5")
   otherwise: "Little use against a %s"
   and when tier(mastery) == "new" append " (once usable)" and use the "usable" tier's worth for the number instead
   (so the card says what learning it to 30 buys).
6. `pick_for(styles_seen: Dictionary, my_grades: Dictionary) -> Array` - styles_seen = {style: how many of the next
   opponents / the region bring it}; returns all 10 step ids sorted by the weighted sum over styles of
   worth(step, style, 60.0, my_grades.get(step, "ok")) x count, highest first; ties keep STEPS order of
   ["step_in","step_out","step_back","pivot_out","cut_off","herd","feint","tie_up","roll_out","push_off"].
Comment block at the top in the house style: what it is, the owner's ruling quoted, the map path and sections, "every
number ESTIMATE until probes 2-7 pass", one usage line per function.

## Test: tests/step_value_test.gd (extends SceneTree; preload the module by path; prints "ok   <what>" / "FAIL <what>",
ends with one line `STEP_VALUE PASS fails=0` or `STEP_VALUE FAIL fails=<n>`, quit(0) on pass, quit(1) on fail)
Cover at least: TARGET has 10 steps x 6 styles; tier(29.9) "new", tier(30) "usable", tier(60) "sharp", tier(85)
"signature"; worth("step_back","Pressure fighter",60,"ok") == 3.5; worth(same, 85, "ok") == 3.5 x 4/3 (within 0.001);
worth(same, 40, "ok") == 3.5 x 2/3; worth(same, 10, "ok") == 0.0; worth(same, 60, "good") == 3.5 x 1.2/0.85;
worth("step_back","Out-boxer",60,"good") == -1.5 (negatives ignore grade); worth("nope","Slugger",60,"ok") == 0.0;
the cap: stack({"step_out":60,"roll_out":60,"tie_up":60}, "Slugger", {}) == 5.0 (2.5+3.0+3.0 = 8.5, capped);
cap then negative: stack({"step_back":60,"pivot_out":60,"push_off":60,"step_in":60}, "Out-boxer", {}) == -1.5 - 0.5 - 0.5
+ 3.0 = 0.5 (positive part 3.0 under the cap);
stack({"step_out":60,"roll_out":60,"tie_up":60,"step_in":60}, "Counter-puncher", {}) == 1.0 + 1.0 + 0.0 - 2.5 = -0.5
(no cap hit); best_style("feint") == "Counter-puncher", wrong_style("step_in") == "Counter-puncher";
learn_line("step_back","Pressure fighter",60,"ok") == "Worth about +3.5 in 100 against a pressure fighter";
learn_line("step_in","Counter-puncher",60,"ok") == "Walks into it against a counter-puncher: about -2.5 in 100";
learn_line("pivot_out","Slugger",60,"ok") == "Little use against a slugger";
learn_line("step_back","Pressure fighter",10,"ok") == "Worth about +2.3 in 100 against a pressure fighter (once usable)";
pick_for({"Pressure fighter": 3}, {})[0] == "step_back"; pick_for({"Counter-puncher": 2}, {})[0] == "feint".

GDSCRIPT TRAPS (each cost an earlier Arena PR a fix): never `var x := <an Array or Dictionary element>` (untyped
Variant -> parse error: write `var x: float = float(d["k"])`); Array has no join(); `"%.1f" % -1.5` gives "-1.5".

## Pass lines
RESULT: tests/step_value_test.gd -> STEP_VALUE PASS fails=0
(Arena's runner has no Godot: write the code and test exactly to this brief; Claude runs the test on the PC.)

## Contract
OWNS: scripts/rules/StepValue.gd, tests/step_value_test.gd
RED_TEST: tests/step_value_test.gd -> STEP_VALUE PASS fails=0 (red on main: the files do not exist)
REGRESSION: tests/step_value_test.gd (nothing else calls it yet; Claude wires the learn card after)
VISUAL: no
NOT YOURS: every other file. Both files under 500 lines. Never delete or weaken a test.
Run: `godot --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tests/step_value_test.gd` (Godot 4.7.2).
Work on your own branch, open a PR, never merge.

## Prior research
DESIGN_STEPVALUE1_V1_KALLI_KALLI.md sections 4.1, 5 (targets and caps), 10 piece 6; scripts/rules/StepEffect.gd (the
grade words and GRADE_MULT); scripts/rules/FireLevel.gd (1 in 2 / 3 in 4 / always by mastery).

## What would a human do?
A coach tells a boxer which move to learn next by who they will meet: "you've got three pressure fighters in the region,
learn the step back first."

## Prefab check
None: a table and a sort.
