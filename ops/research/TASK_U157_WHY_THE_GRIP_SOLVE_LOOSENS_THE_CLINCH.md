# TASK_U157 - the grip solve makes the live cage-clinch grips WORSE, not better: find out why (Cursor, full branch)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S65 (queued behind U156), 2026-09-24.

## Your own finding (U153, merged in S65 - `research/U153_DIGEST.md`)
Live MMA room, seed 92001, `Cascy_CageClinch`, 240 frames. Effector-to-anchor distance, joint centres, metres:
`LeftHand->Neck` ON p50 0.317 vs OFF 0.275; `RightHand->Neck` 0.324 vs 0.295; `RightHand->LeftUpperArm` 0.283 vs
0.260. **The solve that exists to close these grips opens them by 2-4 cm** - and with it off they are still
0.26-0.30 m apart, which is not a grip either. The S63 probe (`tools/s31_contact_probe.gd -- mma_dirty_boxing`)
measured the same solve CLOSING grips (side control 133% -> 2%). Two instruments, opposite answers.

## Part 1 - which instrument is measuring what
Run both on the SAME hold and frames: the S63 probe's metric (surface gap as % of what?) and U153's joint-centre
distance. Print them side by side per grip. Is the probe's "grip" the same effector/anchor pair as
`PairedStagePlayer.HOLD_GRIPS` for CageClinch? Is a joint-centre distance of 0.28 m to `Neck` actually a hand on
the neck once hand and neck RADII are subtracted (a hand's centre sits ~0.05 m off its palm; a neck ~0.06 m)?
(Memory: measure the posed thing; headless `get_bone_global_pose()` returns REST.)

## Part 2 - the mechanism
If the solve really opens the live grips: print, per frame, the solve's target for each effector, where the
effector ends, and what writes it afterwards (the room's hand passes run after the solve - C186's
`finish_hand_frame` and the aim/overlap pushes are new in S65). Name the stage. Fix it so ON <= OFF on every grip,
or report why the target itself is wrong (e.g. an anchor on the wrong body, a stale rest pose).

## Owned files
`scripts/PairedStagePlayer.gd` (grip solve only), `scripts/FightPoseSolver.gd`, `Godot/tools/u153_live_grip_witness.gd`,
a new `Godot/tools/u157_grip_two_instruments.gd`, `research/U157_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>`; then
`python Godot/tools/run_tests.py --only paired_stage,fight_pose_solver,fight_hold,grip,fight_world`.
Branch `cursor/u157-grip-why`, worktree off `origin/master`, `--headless --import` once first. Commit, push,
`python Tools/agent_comms.py send --from cursor --to claude --topic U157 --body "..."` per part. Do NOT edit HANDOFF.md.
Name the population (fighter ids, heights, ruleset, seed, hold) in every output.
Trap: a solve that looks worse on one instrument and better on another is an instrument question first.
