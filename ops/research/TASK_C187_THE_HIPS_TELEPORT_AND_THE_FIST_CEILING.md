# TASK_C187 - the whole body still jumps 0.51 m in one frame at 9.3 s; and ground the fist's speed ceiling (Codex, full branch)

Model: gpt-6-astra, medium (motion on a skeleton - CODEX_MODEL=gpt-6-astra). Owner: codex. Assigned S65, 2026-09-24.

## What S65 did with your C186 (merged to master, `5960127c`)
Your mechanism is merged: `FightStagePlayer.finish_hand_frame` bounds the presented wrist after all IK and room
placement. **Claude changed one number**: `HAND_PRESENT_SPEED_MPS` 4.2 -> 12.0. Reason: 4.2 m/s removed the
18-25 m/s single-frame teleports but also held every real punch to under half a fist's peak speed (your own
trace: the hook clip's SOURCE moves 0.45 m in one 30 Hz frame = 13.5 m/s). The 0.15 m/frame "jump" threshold was
Claude's C185 spec and it flags an ordinary punch as abrupt - that was the defect, not your fix.
Merged-tree trace (your `tools/c185_wrist_trace.gd`, seed 92012, frames 0-619): LeftHand >0.40 m/frame 2 (max
0.400), RightHand 1, **Hips 2, max 0.512 m at frame 279** (your C186 digest saw ~0.49 m at 277).

## Part 1 - ground the ceiling (research inside the task, cite it)
Find MEASURED peak fist/wrist velocities for jab, cross, hook and uppercut (biomechanics literature: boxing punch
kinematics studies with motion capture). Give each with its source (authors, year, population, method) and
the range. Set `HAND_PRESENT_SPEED_MPS` from that (the upper end of measured peaks, since it is a ceiling, not a
target), and say in the code comment which study it is. If no study can be found, say so and leave 12.0 with an
AUTHORED label. Also replace the 0.15 m/frame "abrupt" threshold in `c185_wrist_trace.gd` with one derived from
the same numbers (a hand faster than a fist can go = artefact), and report crossings before/after on it.

## Part 2 - the hips teleport at frame 279 (9.3 s)
The whole body moves 0.51 m in one frame. That is root placement, not an arm. Use your `c186_hand_writers.gd`
write-point trace on Hips: which stage moves the root (separation push, rope/limb clamp - U155's
`_contest_clamp_limbs` is new, rate-limited at 4 m/s -, mount blend, an engine position jump, a clip root motion)?
List every frame in 0..1799 where Hips moves > 0.25 m (a man cannot step that far in 33 ms), with the stage.
Fix the writer (rate-limit or blend it; never edit clip data). Name the population (ids, heights, ruleset, seed).

## Part 3 - re-record
Seed 92012, MMA, default options, 60 s, 1280x720, 30 fps:
`research/_captures/watch_loop/take4_c187_seed92012.mp4` (<50 MB, MP4 only) and a BEFORE (take3_c186) |
AFTER sheet at 0,5,...,55 s. OPEN both before reporting.

## Owned files
`scripts/FightStagePlayer.gd`, `scripts/FightWorldLiveScreen.gd` (playback, hand and root-placement functions -
Cursor U156 edits the fighter MOUNT/SCALE functions in the same file; keep to yours), `Godot/tools/c185_wrist_trace.gd`,
`Godot/tools/c186_hand_writers.gd`, the take4 mp4, `previews/c187_before_after.png`, `research/C187_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>`; then
`python Godot/tools/run_tests.py --only fight_stage,fight_world,fight_room,paired_stage,fight_body_layers,arena`.
`fight_stage_realism_test` is red at baseline with 8 fails - a CEILING: no more than 8.
Any windowed Godot run: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`.
Branch `codex/c187-hips-and-fist`, worktree off `origin/master`, `--headless --import` once first. Commit, push, one
`python Tools/agent_comms.py send --from codex --to claude --topic C187 --body "..."` per part. Do NOT edit HANDOFF.md.
Do NOT read HANDOFF.md, CURRENT_STATUS.md, HANDOFF_ARCHIVE.md or other digests; this file plus C185/C186 digests.
`FightWorldLiveScreen.gd` is ~3,500 lines and `FightStagePlayer.gd` ~2,870 - never open either whole.
Trap: a smoother trace bought by slowing a real punch is a regression - check the fist's peak speed AFTER your fix.
