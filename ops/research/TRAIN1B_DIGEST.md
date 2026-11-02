# TRAIN1B - the move you picked is drilled on the 3D training floor (slice 2)

Branch `cline/train1b` (Cline wrote the code; the run died twice on a Hub connection error while opening images, so Claude ran the last steps, S154).

## What now works
- The fighter at a station plays the clip of the Move Lab move picked in slice 1 (not the generic station loop). Switch: the same career switch as the slice-1 picker (`floor_move_picker`); OFF = today's floor.
- A reps bar over the fighter ("JAB 28 / 32") and a "+N JAB" gain float that rises and fades at each round end.
- Parse gate: 5/5 clean. `tests/train1b_floor_drill_test.gd`: 33 checks, 0 failures.
- Mutant: `_move_clip` made to return "" -> "FAIL: ON: A drills HIS move, not the station..." (test reads RED, as it must).
- `run_tests.py --only training_floor,station_move,floor_drawer,gym_floor,room_click,train1b --jobs 2`: SUITE total=6 fails=0.

## Stills (all three opened by Claude)
`docs/previews/train1b/`: `floor_off.png` (control, switch OFF: station loop, no bar, no float), `drill_float.png` (ON, wide: Kian Sterling at the heavy bag, "+6 JAB" float, bar "JAB 28 / 32"), `drill_bar.png` (ON, close: bar and float large over the bag).
Read-off: the clip plays at the bag, the bar and the float are readable. The "DRILL new drill - 0% to I" line is the old S85 mastery tag (0% towards mastery level I), identical in the OFF control; it is not clipped.
Known and accepted: in the wide shot the bar sits close to the wall clock and the pips; it is a camera-angle overlap, not a bug in the numbers.

## Owned files
`Godot/scripts/TrainingFloor3D.gd`, `TrainingFloorLayout.gd`, `TrainingFloorPanel.gd`, `Godot/tests/train1b_floor_drill_test.gd`, `Godot/tools/render_train1b_drill.gd`, `previews/train1b/*`.
