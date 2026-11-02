# TASK_U158 - "the kicks are executed like bullets"; make the walk smoother (Cursor, full branch)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S65, 2026-09-24. **Takes priority over U157.**

## The operator's words on watch-loop take two (seed 92012, 2026-09-24, verbatim)
> the kicks are executed like their bullets their speed and animation are insanly high, tune some things down to
> make waking smother too
Take two: `research/_captures/watch_loop/take2_s65_seed92012.mp4` (and `take1_vs_take2_seed92012.mp4`).
It is recorded at a FIXED 30 fps step (`--fixed-fps 30`), so CPU load did NOT make it choppy - what he sees is the
motion. The live room is also watched live; measure both the recording path and a live run's frame time.

## Part 1 - kicks: measure what the room does to a kick clip
For every KICK beat in the 60 s take (round kick, body kick, push kick, axe kick, clinch knee...), print: the clip,
its native length, the presented duration on screen, the effective playback rate (`FightStagePlayer.play_role`:
`_ap.play(anim, crossfade, _tempo)` - `_tempo` is Q60's speed/fatigue factor), the `seek_s` it was ENTERED at
(a clip entered part-way skips its wind-up - a leg that appears already travelling reads as a bullet), the
crossfade in, and the kicking FOOT's peak world speed (m/s). Ground the foot speed: find MEASURED peak foot
velocities for roundhouse / front kicks in the biomechanics literature (cite authors, year, method) and compare.
Name the population (fighter ids, heights - U156 made the demo pair 175/185 cm -, ruleset, seed).

## Part 2 - fix the kicks
Fix what Part 1 names, in PLAYBACK, never in clip data: e.g. never seek a strike past its wind-up, cap the
tempo a strike may be sped up by, give the kick its real duration and let the engine beat wait for it. Show the
foot's peak speed after the fix inside the measured human range. Do NOT slow punches (C186/C187 own the hands).

## Part 3 - the walk
The lower-body walk rate is `speed_mps / native` (`FightStagePlayer.gd:~472`, `WALK_RATE_STEP`). Measure over the
60 s: how often the rate changes and by how much per frame, foot skating (planted foot world drift while
`_lock_feet` holds it), and the hips' per-frame speed. Smooth what jumps (rate easing, a longer lower-body blend),
keeping feet planted. Report before/after numbers.

## Part 4 - re-record and OPEN it
Seed 92012, MMA, default options, 60 s, 1280x720, 30 fps: `research/_captures/watch_loop/take3_u158_seed92012.mp4`
(MP4 <50 MB) and a BEFORE (take2_s65) | AFTER sheet at 0,5,...,55 s. OPEN both before reporting.

## Owned files
`scripts/FightStagePlayer.gd` (strike tempo/seek and the lower-body rate ONLY - Codex C187 is editing the hand
and root functions in the same file right now; keep to yours), `scripts/FightBodyLayers.gd`, a new
`Godot/tools/u158_kick_and_walk_probe.gd`, the mp4, `previews/u158_before_after.png`, `research/U158_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>`; then
`python Godot/tools/run_tests.py --only fight_stage,fight_world,fight_room,paired_stage,fight_body_layers,fight_walk`.
`fight_stage_realism_test` is red at baseline with 8 fails - a CEILING: no more than 8.
Windowed runs: `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <args>`.
Branch `cursor/u158-kicks-and-walk`, worktree off `origin/master`, `--headless --import` once first. Commit, push,
`python Tools/agent_comms.py send --from cursor --to claude --topic U158 --body "..."` per part. Do NOT edit HANDOFF.md.
`FightStagePlayer.gd` is ~2,880 lines - never open it whole; grep, then `sed -n 'A,Bp'` windows.
Trap: slowing EVERYTHING makes a fight look drugged - a kick is fast at the foot and slow in the wind-up; fix the entry and the cap, not the whole clock.
