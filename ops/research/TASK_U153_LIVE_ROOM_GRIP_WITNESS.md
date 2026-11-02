# TASK_U153 - prove the grip solve in the LIVE ROOM, not the probe: a ground bout, pair_grip_solve ON vs OFF (Cursor, full branch)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S63, 2026-09-24.

## Why
S63 (commits 952762dd, 1398acf1) found that C168's grip preservation never ran in the game (it was
gated on the binding id; the room grafts with `meta.pair_key`) and fixed it: `PairedStagePlayer.HOLD_GRIPS`
+ `grips_for`, room switch `pair_grip_solve` (default ON) read from the room's options in
`FightWorldLiveScreen.gd` (grep `_pair_grip_solve`). Every number so far came from
`tools/s31_contact_probe.gd`, which grafts in a bare scene. Nobody has measured a grip INSIDE the room
during a bout that actually goes to the ground.

## Part 1 - the witness tool
New `Godot/tools/u153_live_grip_witness.gd`: run the live room the way
`tests/fight_room_no_teleport_test.gd` does, MMA, seed 92000 (the default profile's ground seed, S62).
At every frame a paired hold is playing, read both skeletons' CURRENT pose (compose from
`get_bone_pose`, never `get_bone_global_pose` on a headless skeleton - it returns the rest) and log, per
`HOLD_GRIPS` row of the playing pair, the effector-to-anchor distance. Print per hold: frames,
p50/p90/max distance, arm ON and arm OFF (`pair_grip_solve: false`), same seed. Name the population
(fighter ids, heights, ruleset, seed) in the output.

## Part 2 - the no-teleport read on the same run
Report the body-jump count and the longest >3 cm overlap run for both arms. The solve rotates arm/leg
bones only, so both must be UNCHANGED between arms; if they differ, that is the finding.

## Owned files
`Godot/tools/u153_live_grip_witness.gd` (new), `research/U153_DIGEST.md` (new). Nothing else.

## Gate (tier: a new tool)
Parse gate; run the tool once per arm. No suite. Branch `cursor/u153-live-grips`, worktree off
`origin/master`; `--headless --import` once on a "TitleHonours" error. One `send` per part. Do NOT edit HANDOFF.md.
Trap: if the seed never reaches a Cascadeur hold, every row is empty and both arms read identical -
print the list of holds that played and their frame counts FIRST; pick another seed if it is empty.
