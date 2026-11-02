# TASK_C185 - the punches have no hands and nothing returns to guard; the motion is abrupt (Codex, full branch)

Model: gpt-6-astra, medium (motion on a skeleton - CODEX_MODEL=gpt-6-astra). Owner: codex. Assigned S64 handover, 2026-09-24.

## The operator's words (take one, `research/OPERATOR_WATCH_TAKE1_VERDICT.md`)
> 1. I still seeing clipping, animation are very arbapt
> 2. i do not see any movement on the hands when they punch it 's almost like there is no normal return of limbs to their neutral position
Clipping goes to Cursor (U155). YOURS: the arms during strikes, the return to guard, and the abruptness.

## Part 1 - see it and measure it, on the take the operator watched
Reproduce take one exactly (your own C184 command: `tools/record_room.gd`, seed 92012, MMA, default options,
through `Tools\godot_hidden.ps1`). Then instrument ONE body, not the pair (memory: measure one body first):
for every strike beat in the first 20 s, log per frame the lead and rear WRIST world position relative to the
chest, the clip playing, its blend-in/out time and the beat's duration. Answer with numbers:
(a) does the striking hand actually travel toward the target (peak extension in metres vs the clip's own
source extension)? (b) after the strike, does the hand come back to the guard pose (distance to the idle
guard wrist position at +0.3 s, +0.6 s)? (c) where are the abrupt jumps - print every frame where any wrist or
the hips move > 0.15 m in one frame at 30 fps, and which transition caused it.
Name the population (fighter ids, heights, ruleset, seed) in the output. The playback path is
`scripts/FightStagePlayer.gd` + `scripts/FightWorldLiveScreen.gd` (grep `blend`, `crossfade`, `play(`).

## Part 2 - fix the mechanism, then re-record
Fix what Part 1 shows (e.g. an arm layer masked off, an additive/override layer pinning the arms to the idle,
blend times of 0, a missing recovery segment) in the playback, not by editing clip data. Re-record seed 92012
and build a side-by-side contact sheet BEFORE | AFTER at the same seconds (0,5,...,55), OPEN it before reporting.
Save `research/_captures/watch_loop/take2_c185_seed92012.mp4` (<50 MB).

## Owned files
`scripts/FightStagePlayer.gd`, `scripts/FightWorldLiveScreen.gd` (playback/blend only), a new
`Godot/tools/c185_wrist_trace.gd`, the take2 mp4, `previews/c185_before_after.png`, `research/C185_DIGEST.md`.
Cursor U155 also edits FightWorldLiveScreen.gd (separation/bounds only) - keep your edits to playback functions.

## Gate (tier: scripts edited)
Parse gate on touched .gd; then `python Godot/tools/run_tests.py --only fight_stage,fight_world,fight_room_no_teleport,paired_stage`.
Branch `codex/c185-hands`, worktree off `origin/master`, `--headless --import` once first. Commit, push, one
`python Tools/agent_comms.py send --from codex --to claude --topic C185 --body "..."` per part. Do NOT edit HANDOFF.md.
Trap: a green contact probe is not motion - the operator judged a VIDEO. Report what the video shows.
