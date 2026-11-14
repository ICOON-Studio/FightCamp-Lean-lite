# TASK PELVIS1 - measure the rig's hips against the source take (a probe; no fix, headless)

Status: OPEN (S472, Claude main). Discipline: boxing. Model: qwen3-coder (Qwen), default.

## Why now
tests/guard_knee_test.gd (the rear knee against the source take Box1_M3_Idle) is red: rear mean -0.031 / -0.017 against
the take's +0.029 (bar 0.03). S472 proved the knee and the foot are NOT the cause: the knee now stands 18 deg inside the
toes exactly as the take does (scripts/fight3d/BoxerFootworkRig.gd REAR_BAND_DEG 18), and giving the rig the take's
stance (rear toes 45 deg, wider feet) made the test WORSE. The remaining suspect is the hips: the take turns its pelvis
line 68.6 deg off the lead toes (tools/stance_raw.py on the take). Nobody has measured the rig's pelvis that way.

## What to do (measure only - change no game script)
1. Write tools/pelvis_probe.gd (extends SceneTree, headless, `--fixed-fps 60`): build the stage the way
   tests/guard_knee_test.gd does (same two boxers, same settle: SETTLE_S, read inside skeleton_updated), and on the
   settled guard frames print, per boxer, the SAME numbers tools/stance_raw.py prints for the take:
   ball_to_ball along / across (front = the lead foot's toe line), rear_toe_yaw_vs_lead, hips_above_balls,
   pelvis_line_vs_front (left hip - right hip, flattened, angle from the front), rear_ankle_vs_hip_across.
   Bones: LeftUpperLeg/RightUpperLeg (hips), LeftFoot/RightFoot (ankles), LeftToes/RightToes (balls), Hips.
   One line per number: `PELVIS boxer=<i> <name>=<value>`, then `PELVIS_PROBE done`.
2. Run it, and run `blender -b --factory-startup --python tools/stance_raw.py -- E:/FightCamp/packs/mocaponline_punch_pro/Boxing_01_v2/FBX/Box1_M3_Idle.fbx 30`
   (Blender: "C:/Program Files/Blender Foundation/Blender 5.2/blender.exe").
3. Write docs/PELVIS1_RESULT.md: a table, take v boxer 0 v boxer 1, for every number; then ONE paragraph naming the
   biggest difference in plain words. No fix.

## Pass lines
- `PELVIS_PROBE done` and 6 numbers per boxer; stance_raw.py's 4 STANCE_RAW lines; the table in the result doc.
- RESULT: tools/pelvis_probe.gd -> PELVIS_PROBE done

## Contract
OWNS: tools/pelvis_probe.gd, docs/PELVIS1_RESULT.md
RED_TEST: tests/guard_knee_test.gd -> GUARD_KNEE failures=2 (stays red: this task measures, it does not fix)
REGRESSION: boxer_footwork_test (BOXER_FOOTWORK failures=0), guard_knee_test (GUARD_KNEE failures=2, unchanged)
VISUAL: no
NOT YOURS: every script under scripts/, every test under tests/, tools/stance_raw.py. No number changed anywhere.
Runs only through `python ops/Tools/godot_slot.py run --who pelvis1 -- <godot> --headless --audio-driver Dummy --fixed-fps 60 --path . --script res://tools/pelvis_probe.gd`
(never the _console exe, never a window, never wrapped in `timeout`). One run at a time. Nothing opens on a monitor.

## Prior research
tools/stance_raw.py and the S472 table in scripts/fight3d/BoxerFootworkRig.gd (band table comment); tests/guard_knee_test.gd
header (how the knee is read, SETTLE_S); ops/research/KNEEPLANE_S408.md (the take's knee numbers).
## What would a human do?
Put the rig and the take side by side in the same numbers before touching anything.
## Prefab check
None: our own measure.
