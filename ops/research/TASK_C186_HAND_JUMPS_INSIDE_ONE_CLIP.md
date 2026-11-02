# TASK_C186 - the lead hand still jumps 0.85 m in one frame INSIDE one clip; find what moves it (Codex, full branch)

Model: gpt-6-astra, medium (motion on a skeleton - CODEX_MODEL=gpt-6-astra). Owner: codex. Assigned S65, 2026-09-24.

## Where C185 left it (your own digest, `research/C185_DIGEST.md`, merged to master in S65)
C185 found the walk layer was turning the torso and punching arm and fixed it (Spine rotation preserved across
the lower-body splice, `FightStagePlayer.gd:_advance_lower`). Lead-hook wrist error 0.195 -> 0.067 m; >0.15 m
per-frame crossings 84 -> 59. **What is left is NOT a transition**: the worst row is
`AFTER 271 9.0333 LeftHand 0.85202 hook_lead->hook_lead loc_strafe_right->loc_strafe_right` - same action clip,
same lower clip, and the hand moves 0.85 m in one frame. Your own switches say the layers are not it
(`diagnostic=no_layers` 61 crossings vs 59), inertia helps (`no_inertia` 93) and the procedural hand correction
helps (`raw` 90). So something ELSE writes the hand inside one clip.

## Part 1 - name the writer
Instrument `LeftHand` (and `RightHand`) at every write point in one frame on seed 92012 (MMA, default options,
the take-two population: A f05 wrestle-grappler, B f06 striker - print both ids and heights in the output):
after the AnimationPlayer sample, after the body-layer splice, after inertia, after aim / hand contact / any IK,
after the root placement for that frame. For the 10 worst same-clip rows in frames 0..1799, print which stage
moved the hand and by how much (memory: debug at the point of write). Candidates the code shows: hand aim toward
the target, the procedural hand correction, the root being re-placed (separation, the new U155 limb clamp
`FightWorldLiveScreen._contest_clamp_limbs`, rope clamp), a clip loop wrap (`hook_lead` re-started while the
action key did not change - check the clip time, not the key).

## Part 2 - fix it and re-record
Fix the writer that produces a >0.15 m single-frame hand move within one clip (rate-limit, blend, or stop the
re-start - whichever Part 1 names; never edit clip data). Re-run `tools/c185_wrist_trace.gd`: report crossings
BEFORE (59) and AFTER, and the worst same-clip row. Re-record seed 92012 (60 s, 1280x720, 30 fps) as
`research/_captures/watch_loop/take3_c186_seed92012.mp4` and a BEFORE (take2_c185) | AFTER sheet at
0,5,...,55 s; OPEN both before reporting.

## Owned files
`scripts/FightStagePlayer.gd`, `scripts/FightBodyLayers.gd`, `scripts/FightWorldLiveScreen.gd` (PLAYBACK / hand
functions only - Cursor U156 edits fighter SCALE in the same file; keep to your functions),
`Godot/tools/c185_wrist_trace.gd`, a new `Godot/tools/c186_hand_writers.gd`, the take3 mp4,
`previews/c186_before_after.png`, `research/C186_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>`; then
`python Godot/tools/run_tests.py --only fight_stage,fight_world,fight_room_no_teleport,paired_stage,fight_body_layers`.
`fight_stage_realism_test` is red at baseline (8 fails) - a CEILING: no more than 8, fewer is better, say so.
Any windowed Godot run goes through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`.
Branch `codex/c186-hand-writers`, worktree off `origin/master`, `--headless --import` once first. Commit, push, one
`python Tools/agent_comms.py send --from codex --to claude --topic C186 --body "..."` per part. Do NOT edit HANDOFF.md.
Do NOT read HANDOFF.md, CURRENT_STATUS.md, HANDOFF_ARCHIVE.md or any other digest; this file and C185_DIGEST.md are enough.
`FightWorldLiveScreen.gd` is ~3,300 lines - never open it whole; grep and read `sed -n 'A,Bp'` windows.
Trap: the action KEY staying `hook_lead` does not mean the clip did not restart - read the clip TIME.
