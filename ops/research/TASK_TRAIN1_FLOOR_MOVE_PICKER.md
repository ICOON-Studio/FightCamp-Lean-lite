# TRAIN1 - train a move from the training floor (station -> fighter -> move with animated preview -> TRAIN THIS)

Model: Codex (gpt-6-astra, medium) or Claude if no seat; worktree E:/FightCamp/wt/<seat>, branch from origin/master.
Nothing opens on the operator's screen (godot_hidden.ps1 for stills; view images with the file tool only).

## Why (operator 2026-10-03, verbatim, on the scene tree)
"in this scene i want to be able to select the move i want to train , be able to preview it in animation , why we have
training floor with no options to train" and "this needs also to be displayed in 2.5d the fighter training with the coach
etc", then "the whole training selection scene needs revamping and modernazation , you have all tools to make it the
strongest hub of the game after the 3d fight". Operator S150: TRAIN1 goes AHEAD of TUT1.

THIS RUN = SLICE 1 (the working picker on today's floor). The revamp continues after it: the painted 2.5D floor with
fighter + coach living loops (M41 concept), progress bars / round-end floats / drill mastery (TRAINING_LOOP_DESIGN S4-S5).
Build slice 1 so those layers sit on top of it: StationMovePicker takes a station id and needs nothing from the floor art.

## Prior research
`research/TRAINING_LOOP_DESIGN.md` (S6 "tap a station: who trains there, what it builds, the preview gain";
coach in the mitt pocket; preview before committing - Uma Musume), `G112_TRAINING_LOOP.md` (real gyms, 13 sims),
`SCENE_TREE_REVIEW_INPUT.md` (the map; the floor today is doors only). Rooms go 2.5D (S147): painted still + pins.
K85 / M41 / J61 (in flight S150) review the tree and draw the 2.5D floor with fighter + coach - fold their verdicts in.

## What would a human do?
Walk to the bag, call the fighter over, show him the move on the pads, then drill it. In the game: click the station,
pick the fighter, see the move played, press TRAIN THIS.

## Prefab check
Ours already: `GameState.get_technique_training_options/plan` + `assign_technique_training` (l.5228-5299, engine
`TechniqueTrainingCoordinator.gd` 758 lines - station + coach requirements), the animated move preview
`UIKit.technique_preview` / `technique_preview_begin_playback` (UIKit l.742-984, used by SkillsMovesPanel hover).
Demo palette = certified boxing moves only (`assets/data/certified_moves.json`, D27).

## Owned files
- `Godot/scripts/TrainingFloorPanel.gd` (738 lines) - the floor scene; add station pins
- `Godot/scripts/StationMovePicker.gd` (NEW) - the picker pop-up
- `Godot/tests/station_move_picker_test.gd` (NEW)
- `previews/train1/` (stills)

## Spec
1. Floor: each owned station (heavy bag, mitts/pad spot, ring, speed bag...) is a click pin with an icon + tooltip
   (station name). Switch `career.floor_move_picker` (default `empty_gym_start()`); OFF = today's floor, byte-identical.
2. Click -> StationMovePicker pop-up over the floor (never full-screen): fighter chips (roster, own sport, a booked
   fighter marked) -> the moves THIS station can train for him (`get_technique_training_options` filtered to options
   whose station resolves to this station's instance_id; boxing demo: only certified moves) -> each move row plays its
   animated preview on hover/select (`technique_preview_begin_playback`) + the plan line (weeks, coach needed, gain).
3. TRAIN THIS -> `assign_technique_training(fighter, technique)`; the pin then shows the fighter's name + move.
   Blocked plans show the blocker in plain words (no coach, station full, injured) - never a silent refusal.
4. 2.5D look comes from M41 (painted floor with fighter + coach at a station); until it lands, pins sit on today's floor.

## The test (write first) - `tests/station_move_picker_test.gd`
Two DIFFERENT boxers (DevJump, different stats). ON: the bag pin lists only moves whose plan station is the bag; every
listed move is in certified_moves.json; TRAIN THIS sets the fighter's technique training to that move; a blocked plan
shows its blocker text. OFF (control): no pins, floor node tree identical to before. Print the population and counts.

## Gates
Parse: `python Godot/tools/check_scripts.py <touched .gd>`. Test: headless `--script tests/station_move_picker_test.gd`.
Then `python Godot/tools/run_tests.py --only training,floor,technique,skills --jobs 2`. Stills via
`Tools\godot_hidden.ps1 ... -- as_game` (note the `--`), open every still before reporting.

## The one trap
`as_game` must follow `--` or the game switches stay OFF (S150 found a capture doc line without it).
