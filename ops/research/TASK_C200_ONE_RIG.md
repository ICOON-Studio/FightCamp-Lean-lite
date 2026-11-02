# TASK C200 - CODEX - ONE RIG, ONE NAMING CONVENTION (readiness audit T3, J49 G6)
Model: gpt-6-astra, MEDIUM (`CODEX_MODEL=gpt-6-astra`), CODEX_WEB=live. Owner: codex. Assigned S74, 2026-09-25.

## Why
`research/S74_READINESS_AUDIT.md` scored G6 FAIL: three conventions live side by side - UE4 (RamsterZ,
`Godot/scripts/FightClipRetarget.gd:54 UE4_TO_OURS`), Cascadeur (`CASCY_TO_UE4`), and fighter meshes that are not in
metres (Tripo exports). Every new motion source costs a retarget map and a scale fix.

## What would a human do?
J49 S3/S4 (UFC animation team GDC talks): a studio LOCKS the skeleton, bone names, rest pose and units before content,
and every source passes through ONE import-time conversion to that rig. Answer in the digest how a small studio does
this in practice (Blender/Godot import scripts, retarget presets) before choosing the method.

## Deliver
1. `research/C200_RIG_SPEC.md`: the canonical fighter rig - bone list and names, parent chain, rest pose, forward
   axis, units (metres), height reference; which of today's meshes (f01-f12) already match and which do not.
2. One import-time converter every clip source passes through (UE4, Cascadeur, glTF from video tools) - extend the
   existing retarget path, do not fork it.
3. `Godot/tests/rig_convention_contract_test.gd`: fails when a clip or mesh arrives in another naming convention or
   scale; prove it with two mutants (a renamed bone, a centimetre mesh).
No SMPL/SMPL-X/MANO/BUDDI anything (licence bar - see G95_BODY_MODEL_LICENCES.md).

## Owned files
`Godot/scripts/FightClipRetarget.gd` (large - `grep -n` then `sed -n` windows), a new converter script if needed,
the test, the spec, `research/C200_DIGEST.md`.

## Gate (tier: script edited)
Parse gate, the new test, then `python Godot/tools/run_tests.py --only <x>` one at a time for clip_retarget, cascy,
fight_clip, fight_world_live, fight_stage (fight_stage 10/1 is the baseline: fight_stage_realism is a known red).
Worktree `C:\Users\user\AppData\Local\Temp\FightCamp-C200`: `git worktree add ... -b codex/c200-one-rig origin/master`.
Commit explicit paths, push the branch, send one line with agent_comms.py. Do NOT read HANDOFF.md or CURRENT_STATUS.md.

## The one trap
The RamsterZ path is proven (Q47) - `UE4_TO_OURS` must keep producing byte-identical poses for every bound RamsterZ
clip. Hash a bound clip's posed bones before and after.
