# TASK KNEERAW1 - QWEN (qwen3-coder) - the guard knock-knee: fix the measure, then raw clip against ours

Status: OPEN (S407, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: PR #101 (SOUTHPAW3) reported valgus +0.130 m blue lead, -0.098 red rear, the same with noproguard, and "no rig setting moved the knee by more than 1 mm". Claude read tests/guard_valgus_test.gd on that branch: the instrument cannot support those numbers. Do not reuse them.

BASE: qwen/southpaw3

## Contract
OWNS: tests/guard_valgus_test.gd, tools/guard_knee_probe.gd, tools/raw_fbx_knee.py, docs/KNEERAW1_RESULT.md
RED_TEST: tests/guard_valgus_test.gd -> GUARD_VALGUS_INSTRUMENT ok
REGRESSION: guard_valgus
VISUAL: no

## Prior research
`python ops/Tools/prior_research.py knock knee guard`. ops/research/RETARGET2B_RESULT.md (why the clips changed, and how a bar passed while the stance was wrong). tools/raw_fbx_feet.py is the Blender route for raw takes. tools/stance_probe.gd reads what is SHOWN after every modifier: copy how it does that. Read ops/research/GDSCRIPT_TRAPS.md before writing GDScript.

## What would a human do?
Check the ruler before believing the reading. Then lay the same measurement over the source take and over what the game draws, and see where the two part.

## Prefab check
None needed. tools/raw_fbx_feet.py and tools/stance_probe.gd already do most of it.

## Faults in the current test (all four must be gone)
1. `RkClips.enabled = false`. That turns off the captured route, so `pro_on()` is false and the test never plays pro_idle, the guard the game shows. `noproguard` therefore changed nothing, which is why the two runs matched.
2. Bones are read with get_bone_global_pose after the frame, outside skeleton_updated. S399 rule: that is the raw clip, not what is drawn. It is the likely reason no rig setting moved the knee.
3. "valgus" is the knee's offset along foot_dir x up, one fixed side for both legs. It is not inward. For one leg + means inward, for the other + means outward. Medial must be defined per leg: towards the fighter's own centre line.
4. Index 0 is labelled "lead" and is always the left leg. For a southpaw the left leg is the rear one. Lead and rear must come from the fighter's stance.

## The job
1. Merge origin/main into this branch. Commit the merge.
2. Rewrite the measure in tools/guard_knee_probe.gd, read inside `skeleton_updated`, per leg: knee offset from the ankle-to-ball vertical plane, + = towards her own centre line; knee gap; knee flexion angle. Print one row per corner, leg (lead/rear), arm.
3. Print four arms, red orthodox and blue southpaw in each, 30 frames in, then 120 frames as min/mean/max:
   - GAME: the path the game plays (captured route on, pro_idle guard, every layer as shipped).
   - noproguard (the Rokoko guard).
   - CLIP ONLY: pro_idle, every leg layer off (rig, foot plant, footwork).
   - RIG ON: `enabled` off, as the rig tests run it.
   State which of these the game actually shows in a fight, with the function that decides it.
4. tools/raw_fbx_knee.py (Blender, same way as raw_fbx_feet.py): the same per-leg numbers on the source take E:/FightCamp/packs/mocaponline_punch_pro/Boxing_01_v2/FBX/Box1_M3_Idle.fbx. The pack's actor stands in one stance: say which, and for a southpaw compare against the mirrored take. Run: `blender -b --factory-startup --python tools/raw_fbx_knee.py -- <fbx>`.
5. Write docs/KNEERAW1_RESULT.md: one table, RAW / CLIP ONLY / GAME / RIG ON, per leg and stance. Then one line answering where the knee first goes wrong: the source take, the bake, a runtime layer, or nowhere (the measure was the fault). Give the number that decides it. Name the frame and arm for a still.
6. Make tests/guard_valgus_test.gd use the corrected measure on the GAME arm and print `GUARD_VALGUS_INSTRUMENT ok` once it proves the sign: a synthetic pose that bends a knee inward must read +, one that bends it outward must read -, on both legs and both stances. Print the real numbers for information. Set no pass bar on them; Claude sets it after looking at a still.

## Rules
Change no game script: scripts/ is out of bounds, this task only measures. Do not change a number in any other test. Godot runs go through `python ops/Tools/godot_slot.py run --who kneeraw1 -- <godot cmd>`, headless, --audio-driver Dummy, never _console.exe. PR body: the table from step 5 and the exact pass line.

## The one trap
A number that does not move when you change the thing it should measure means the ruler is broken. Before you trust any arm, show one layer switched off changing the reading, or say plainly that it did not.
