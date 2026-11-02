# TASK_C183 - closed guard, authored to the real no-gi grips: overhook + head cup + crossed ankles on the lumbar (Codex, full branch)

Model: `gpt-6-astra`, medium (3D animation design). Owner: codex. Assigned S63, 2026-09-24, after C182.

## Why
C182 Part 3 measured your C170 closed guard on the S63 tree: the ankle lock now passes (solved foot
row) but the bottom man's wrist grip still peaks at 32.98%. Grok's G84 (`G84_WHERE_THE_HANDS_ARE.md`,
section 2) names exactly that as the animator's miss: *"bottom wrists glued to top's wrists at 1.0 (the
C170 failure mode) instead of an overhook at mid-upper-arm + a head cup."* The shipped
`Cascy_ClosedGuard` pair holds its "collar" hands 0.49 m from the neck - a preserved miss. So the
authoring is wrong, not the solve.

## The job (THE LOOP from TASK_C171, same gates)
1. Declare in `tools/s31_contact_probe.gd` `bjj_guard` BEFORE authoring: bottom (A) crossed ankles on
   the top man's lower back (heels into lumbar), A's one arm OVERHOOKING B's upper arm at 0.3-0.6 along
   it, A's other hand CUPPING B's occiput/neck; top (B) postured, hands on A's hips or biceps (not the
   chest). Knees wrapped at B's waist.
2. Author in Cascadeur (your `build_*.py` pattern), 4 s, a posture fight; no punches required.
3. Update `PairedStagePlayer.HOLD_GRIPS["Cascy_ClosedGuard"]` (THAT ROW ONLY) to the hand/foot rows you
   declared (e.g. `[0, "LeftHand", "RightUpperArm"]`); the ankle row stays.
4. Probe with `--live-key`, solve ON and OFF, both columns; render + `Tools/paired_contact_sheet.py`; OPEN it.

Gate: every declared row <= 30% with the solve ON (a CEILING), the OFF column printed beside it, and a
sheet in which the ankles are visibly crossed BEHIND the top man and one arm visibly wraps his arm.

## Owned files
`Godot/assets/anim/audition/cascadeur/Cascy_ClosedGuard_*.glb`, `Godot/tools/s31_contact_probe.gd`
(bjj_guard rows only), the one HOLD_GRIPS row in `Godot/scripts/PairedStagePlayer.gd`,
`Tools/cascadeur/build_closed_guard*.py`, `previews/c183_*.png`, `research/C183_DIGEST.md`.

## Gate (tier: assets + one table row)
Parse gate; `python Godot/tools/run_tests.py --only paired_clip_mount,fight_hold_binding,technique_id_reference,c168,c169,paired_stage`.
No suite. Branch `codex/c183-closed-guard`, worktree off `origin/master`. One `send` per step. Do NOT edit HANDOFF.md.
Trap: a solved row at ~0% is by construction - the OFF column and the opened sheet are the evidence.
