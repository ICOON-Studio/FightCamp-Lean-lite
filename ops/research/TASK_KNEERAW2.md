# TASK KNEERAW2 - QWEN (qwen3-coder) - the knee table, round 2: make the two rulers agree

Status: OPEN (S407, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: Claude read qwen/kneeraw1. Its conclusion ("the raw take is bow-legged, the source is not the fault") cannot stand: the raw and game columns use opposite signs, and the game column is still read outside skeleton_updated.

BASE: qwen/kneeraw1

## Contract
OWNS: tests/guard_valgus_test.gd, tools/guard_knee_probe.gd, tools/raw_fbx_knee.py, docs/KNEERAW1_RESULT.md
RED_TEST: tests/guard_valgus_test.gd -> GUARD_VALGUS_INSTRUMENT ok
REGRESSION: guard_valgus
VISUAL: no

## Prior research
docs/KNEERAW1_RESULT.md on this branch and ops/research/TASK_KNEERAW1.md. tools/stance_probe.gd shows the working way to read a pose inside skeleton_updated: copy it. Read ops/research/GDSCRIPT_TRAPS.md before writing GDScript.

## What would a human do?
Hold both rulers against the same known length before comparing anything they measured.

## Prefab check
None needed.

## Faults to fix (each one was found by reading the code)
1. SIGN. tools/guard_knee_probe.gd `_valgus` uses `signf(-hip_from_center.dot(lateral))`. tools/raw_fbx_knee.py `valgus` uses `-1.0 if hip_from_center.dot(lateral) < 0 else 1.0`, which is the opposite. Both axes are right-handed, so the RAW columns are flipped against the game columns. Medial must mean towards her own centre line in both. Add a selftest to the Python file: a made-up pose with the knee moved inward must read + on both legs, printing `RAWKNEE_SIGN ok`. Run it in the same Blender command.
2. READ POINT. `_measure` reads get_bone_global_pose after `await process_frame`, so step 2 of KNEERAW1 was not done. Connect skeleton_updated and capture the pose inside it, the way tools/stance_probe.gd does. Do the same in tests/guard_valgus_test.gd where it prints real numbers.
3. CLIP ONLY. That arm sets `RkClips.enabled = false`, so it does not play pro_idle (`pro_on()` is false). Keep the captured route on and switch the leg layers off.
4. PROOF THE LAYERS ARE OFF. `_disable_leg_layers` matches node names that may not exist. Print how many modifiers it found and switched, by name. Print for each arm the clip playing (`assigned_animation`) and `rig.w` at frame 30 and frame 120. The GAME arm must not force `want`/`w`: RingFeet.tick decides them in the game, so `want = 1.0` at the top of `_initialize` is out.
5. SAME SCALE. The source actor and our boxers differ in size. Add one column to every row: valgus divided by that leg's hip-to-ankle length.

## The job
1. Fix the five faults. Rerun all arms and the raw take (`blender -b --factory-startup --python tools/raw_fbx_knee.py -- E:/FightCamp/packs/mocaponline_punch_pro/Boxing_01_v2/FBX/Box1_M3_Idle.fbx`).
2. Rewrite docs/KNEERAW1_RESULT.md from the new numbers only. One table, one line per arm, per leg, per stance. Then answer: where does the knee first differ from the source take by more than 0.02 of leg length, and in which direction? If nowhere, say so.
3. Show one layer switched off changing the reading, with both numbers. If none changes it, say that plainly.
4. Name the arm and frame that shows the largest inward knee, for a still.

## Rules
scripts/ is out of bounds: this task only measures. Do not reuse any number from round 1. Godot through `python ops/Tools/godot_slot.py run --who kneeraw2 -- <godot cmd>`, headless, --audio-driver Dummy, never _console.exe. PR body: the table and the exact pass lines.

## The one trap
Round 1's summary said a fault was fixed when the code still had it. Before you write that something is fixed, quote the line that fixes it.
