# TASK_TAKEFIX1 - six punch takes kick a foot up or fling the rear glove back: clean them so they play again (Goose, FightCamp-Lean)

Model: Goose (cloud), repo ICOON-Studio/FightCamp-Lean branch main. Discipline: boxing (demo).
Why: S300's film saw stepping (_ft) takes kick the back leg up and wide-miss (_miss) takes fling the rear arm back
("right_cross_miss flings it 0.60 m behind her hips"). S301 switched those six off (BeatClips.OFF_TAKES), so a stepping
hook or a wide miss plays the same few takes. Clean takes = more variety in every exchange.

## The red probe (run it first, it must read red on main)
`$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/take_check.gd` (~30 s). Main today prints 6 OFF:
```
TAKE pro_left_hook_hurt_ft        OFF   lift 0.08 (plain 0.05) fling 0.19 (plain 0.06)
TAKE pro_left_hook_miss           OFF   lift 0.10 (plain 0.05) fling 0.30 (plain 0.06)
TAKE pro_right_cross_miss         OFF   lift 0.09 (plain 0.04) fling 0.60 (plain 0.00)
TAKE pro_right_hook_hard_ft       OFF   lift 0.18 (plain 0.13) fling 0.54 (plain 0.06)
TAKE pro_right_hook_miss          OFF   lift 0.10 (plain 0.13) fling 0.51 (plain 0.06)
TAKE pro_right_uppercut_hurt_ft   OFF   lift 0.10 (plain 0.06) fling 0.18 (plain 0.07)
TAKE CLEAN 18: ...
```
PASS: `TAKE CLEAN 24:` (all 24 _ft/_miss takes CLEAN under the probe's own margins: lift <= plain + 0.08 m, fling <= plain + 0.10 m).

## Owned files (edit only these)
- NEW `tools/take_fix.gd` (headless SceneTree tool, < 200 lines): loads each of the six baked takes, and rewrites ONLY the
  tracks that break the margin - the rear (right) arm chain (RightUpperArm/RightLowerArm/RightHand, with clavicle/shoulder if
  the rig has one) for a fling, the lifting leg chain (UpperLeg/LowerLeg/Foot) for a lift - by blending them toward the
  plain take's same tracks over the offending window (smooth weight in/out, ~0.1 s ramps, never a hard cut), keeps every
  other track and the punching arm untouched, and saves the take back with `ResourceSaver.save`. It prints one line per
  take with lift/fling before and after. Running it twice must change nothing the second time.
- The six baked takes in `assets/anim/baked/` (rewritten by the tool, committed):
  `mc_Box1_M3_Left_Hook_Hurt_FT.res`, `mc_Box1_M3_Left_Hook_Miss.res`, `mc_Box1_M3_Right_Cross_Miss.res`,
  `mc_Box1_M3_Right_Hook_Hard_FT.res`, `mc_Box1_M3_Right_Hook_Miss.res`, `mc_Box1_M3_Right_Uppercut_Hurt_FT.res`.
  Plain takes to blend toward: `mc_Box1_M3_Left_Hook.res`, `mc_Box1_M3_Right_Cross.res`, `mc_Box1_M3_Right_Hook.res`,
  `mc_Box1_M3_Right_Uppercut.res` (read only). Clip names in game = `pro_` + the stem after `mc_Box1_M3_`, lower case
  (FightClips.pro_name).
- `scripts/fight3d/BeatClips.gd` (254 lines) - only `OFF_TAKES` (lines ~40-44): remove each take that now reads CLEAN, and
  update the comment above it (S334 TAKEFIX1).
- `assets/data/clip_contact.json` - regenerate with `$GODOT_EXE --headless --path . --script res://tools/clip_contact.gd` and
  commit it (BeatClips reads hit timing from it).

## Guard rails (must stay green)
- `$GODOT_EXE --headless --audio-driver Dummy --path . --script res://tools/glove_height_check.gd` -> `GLOVE HIGH 0:`.
- The punching hand of each fixed take still reaches: `tools/clip_contact.gd` line for each of the six moves by no more than
  0.03 m vs main (main: left_hook_hurt_ft 0.44 m, left_hook_miss 0.36, right_cross_miss 0.28, right_hook_hard_ft 0.37,
  right_hook_miss 0.39, right_uppercut_hurt_ft 0.49 from the target) and its contact time by no more than 0.05 s.
- `GODOT_EXE=$GODOT_EXE sh tools/run_tests.sh` - 0 failures.

## Evidence
Your PR runs `.github/workflows/fight-stills.yml`: stills from the game's camera + every probe's numbers (the `clips` job
prints take_check) as a PR comment. Claude films the six takes; the operator's OK closes it.

## Prior research
Lean S300/S301 (tools/take_check.gd header and BeatClips.OFF_TAKES comment); Game repo `C223_DIGEST.md` (variants: a
correction window whose weight is exactly 0 at both ends, so the take's joins are untouched).

## What would a human do?
An animator opens the take in the DCC, keys the rear arm back to the guard during the fling (or copies the plain take's arm
layer over that window with an eased weight), checks the foot stays planted, and exports. The tool does the same with
Godot's Animation API: per-track key edits, eased in and out.

## Prefab check
None: a per-track blend between two takes of the same rig is a few Animation API calls (track_find, track_get_key_value,
track_set_key_value / rotation_track_interpolate). The clips are licensed MoCap Online Punch PRO in this private repo -
never copy them anywhere else.

## The one trap
Rewriting the whole take (or the punching arm) to the plain take makes it CLEAN but kills the take - it is then a duplicate
of the plain one. Only the offending chain, only in the offending window. Never edit take_check.gd or its margins.
GDScript: `var x := <Variant call>` is a parse error - type it. A .res rewritten by Godot is binary: commit only the six.

## Report
`RESULT: tools/take_check.gd -> TAKE CLEAN 24: ...`, take_fix.gd's before/after line per take, the six clip_contact lines
before/after, `GLOVE HIGH 0:` and the run_tests.sh summary line.
