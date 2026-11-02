# TASK_Q162 - do the eight RamsterZ family holds lose their grips in the game? Measure, then declare (Qwen, full branch)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S63, 2026-09-24, after Q161.

## Why
S63 (commit 952762dd) made the paired holds' grip solve run in the live room:
`PairedStagePlayer.HOLD_GRIPS` + `grips_for` bake a two-bone hand/foot IK into the grafted clip so
each declared grip keeps the SOURCE clip's hand-to-anchor offset. Measured, live key, OFF -> ON:
side control 133% -> 2%, closed guard ankle lock 23.8% -> 0.0003%. **It is gated to Cascadeur
clips only** (`authored_pair` in `graft_pair`), so the eight RamsterZ `.fbx` holds you rendered in
Q161 - the holds 176 grappling techniques lean on - get NO solve. Nobody knows whether they need
one. That is this task: a measurement first, a decision second.

## Part 1 - measure (no engine edit)
Extend `Godot/tools/s31_contact_probe.gd` with a `RAMSTERZ_CONTACTS` table: for each of the eight
keys in your Q161 table, declare the hand/foot grips you SEE in your Q161 frames (e.g. the armbar's
two hands on the arm, mount's knees) as [name, bone, "a"/"b", bone, "a"/"b"] rows, exactly like
`HOLD_CONTACTS`. Route those keys through `_check_hold` (it already compares source vs game per
row over 241 samples). Run all eight with `--live-key`. **Trap you must check first:** RamsterZ
pairs are NOT authored on a shared origin (`PairedStagePlayer.gd`, the comment above
`authored_pair`: `Paired_FullMount_Takedown_BodyLock_Loop` is 3.17 source units apart and relies
on per-clip re-centring). So a source offset between the two men may be meaningless for them. Print,
per key, the source hip-to-hip distance next to the game's; where they disagree by more than 0.3 m,
say the source offsets for that pair are not usable and do not report its contact drift as a finding.

## Part 2 - the decision table
One row per key: worst contact drift (game vs source), whether the origin check passed, and your
call: SOLVE (drift > 30% and origins usable), FINE (<= 30%), or UNUSABLE (origins disagree). Claude
decides whether to widen `authored_pair` from that table - you do NOT edit PairedStagePlayer.gd.

## Owned files
`Godot/tools/s31_contact_probe.gd` (the RAMSTERZ table + routing only; Codex owns the turtle and
closed-guard rows - do not touch HOLD_CONTACTS), `research/Q162_DIGEST.md` (new).

## Gate (tier: a tool edited)
`python Godot/tools/check_scripts.py Godot/tools/s31_contact_probe.gd`; run the probe on
`mma_dirty_boxing` and `bjj_guard` before and after your edit and show their output is unchanged;
then the eight keys. No suite. Branch `qwen/q162-ramsterz-grips`, worktree off `origin/master`;
on a "TitleHonours" parse error run `--headless --import` once. One `agent_comms.py send` per part.
Do NOT edit HANDOFF.md.
Trap: a view straight down on two men lying on the mat is NOT a standing clinch - in Q161 you read
two overhead `high` frames as standing; they show the same ground hold as the side view.
