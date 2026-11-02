# TASK_C190 - the clip owns a strike's timing: play it whole, hit on its contact frame, decide again at recover (Codex, full branch)

Model: gpt-6-astra, medium (motion on a skeleton - CODEX_MODEL=gpt-6-astra). Owner: codex. Assigned S65, 2026-09-24.
**Starts after your C189 control arm reports** and uses Qwen Q167's `assets/data/clip_phases.json` (start/contact/recover
per clip) - if Q167 is not merged when you start, measure the phases of the clips you touch yourself and say so.

## Why - the operator's priority
Verbatim, 2026-09-24: "We are not buying other clips unless I see the quality that I see on the YouTube preview videos.
In our game, ask other agents why this is happening. Where, why is our pipeline doesn't handle it like in the preview
videos? I want this fixed." We OWN the reel's Hand to Hand Set. Grok G87 (`research/G87_PREVIEW_QUALITY.md`)
ranks the cause: the room ENTERS strikes part-way (seek), SPEEDS them to a 0.3-1.0 s beat (custom_speed) and CUTS
them at the next beat, so the chamber and the return to guard never play ("kicks like bullets", "no return of limbs
to neutral"); second, the strike's root motion is discarded and a walk is spliced onto the legs. Shipped games
(Tekken/MK frame data, UFC committed strikes, For Honor, Unreal Motion Warping) let the CLIP own a committed strike's
timing and warp WHERE it lands, never WHEN.

## YOUR C189 RANKED IT, AND IT REORDERS G87 - READ THIS FIRST (merged S65, `research/C189_DIGEST.md`)
Arm A (our fighter, whole clips) = wrist 16.6 / ankle 6.6 / hips 3.1 m/s; arm B (source mannequin) = 19.5 / 6.6 / 3.2 -
**the retarget is NOT the problem; our fighter can look like the preview.** Arm C (room entry/tempo/cut clocks) =
24.1 / 10.0 / 8.4. Arm D (live room) = ankle **52.8 / 75.2**, hips **27 / 33** m/s. One factor from D:
`body_layers=false` -> ankle 9.6 / 9.3; **`engine_positions=false` -> ankle 5.6 / 6.7, hips 3.4 / 3.6**. So the #1 cause
is the simulation PLACING the bodies and the walk layer splicing legs to follow it; seek/cut is #2; tempo had no
measured effect. **Step 0:** your C189 worktree predates S65's C187 (pelvis ownership joins smoothed) and U158 (walk
rate eased) - re-run arm D and the two one-factor supplements on current master FIRST and print them. Whatever the
live ankle/hips spikes still are after that is part of THIS task: B below applies to locomotion joins too, not only
to strikes, and the target is arm D reaching arm A's numbers with engine positions ON.

## The change (G87 section 3, A + B + C), behind ONE room switch `strikes_play_whole` (default OFF until the operator's A/B)
A. A committed strike clip plays from frame 0 at speed 1.0 and is never cut before its RECOVER time.
B. For the strike's window, the full body plays the clip: no walk splice on pelvis/legs; the clip's root motion moves
   the body, warped (bounded, <= 0.4 m, rotation <= 30 deg) so the CONTACT pose meets the simulation's target; after
   RECOVER the simulation takes position back and corrects the residual smoothly.
C. The simulation's hit is presented at the clip's CONTACT time, and the fighter's next strike may not start before
   his current clip's RECOVER time - the simulation QUEUES it. Hit/miss/damage stay the simulation's decision.
Coordinate with Cursor U158 (kick entry/tempo) - merge whichever lands first and build on it; do not duplicate.

**Two facts from your own C189 source baseline (f4aac113), carry them in:** (1) the vendor's punches peak at
13-19.5 m/s at the WRIST in the source (jab 18.2, straight 19.5, hook 18.6) and look smooth in the reel - so the
`HAND_PRESENT_SPEED_MPS` bound (12.0, S65) clips real captured motion; with `strikes_play_whole` ON a whole clip must
not be re-bounded - the bound exists only to hide the chopping this task removes. (2) `H2H_HitReaction01/02` have
2.5 s / 3.1 s of leading unkeyed time - a reaction must be entered at its first KEYED motion (Q167's start tag), or
it lands seconds after the blow.

## Protect the statistics (the simulation is calibrated to published numbers - J20)
Queuing strikes behind recovery lowers the presented strike rate. Measure, OFF vs ON, over 20 MMA bouts of a
NON-IDENTICAL pair (the R133 grappler vs striker; CLAUDE.md: never identical fighters) and 20 boxing bouts: strikes
thrown and landed per minute, knockdowns per bout, leg-strike share, decisions/finishes. Anything that moves away from
its J20 anchor is fixed at the SELECTION layer (which strike, how often), never by speeding a clip back up. Print the
anchors beside the numbers.

## Evidence the operator needs
Seed 92012, MMA, 60 s, 1280x720, 30 fps, OFF vs ON, same camera: `research/_captures/watch_loop/c190_strikes_whole_ab.mp4`
(side by side, MP4 <50 MB) and a sheet. Plus a close-up of 3 kicks and 3 punches, each OFF | ON. OPEN them before reporting.

## Owned files
`scripts/FightStagePlayer.gd` (strike playback), `scripts/FightWorldLiveScreen.gd` (the switch, strike scheduling,
root warp), `scripts/FightRealtime.gd` (ONLY the strike queue behind recovery - read `sed -n` windows, it is ~5,100
lines), `scripts/FightBodyLayers.gd`, a new `tests/fight_strike_whole_test.gd` (with the switch ON: no strike is seeked,
none plays at speed != 1, none is cut before recover; OFF is byte-identical to today - prove with mutants),
`Godot/tools/c190_strike_stats.gd`, the mp4s, `research/C190_DIGEST.md`.

## Gate (tier: scripts edited, reaches the engine)
Parse gate; `fight_strike_whole_test` with 3+ mutants caught; then
`python Godot/tools/run_tests.py --only fight_stage,fight_world,fight_room,fight_realtime,fight_scoring,judge_panel,paired_stage,fight_body_layers`
- `fight_stage_realism` (8) and `fight_scoring` (3) are CEILINGS. Windowed runs through `Tools\godot_hidden.ps1`.
Branch `codex/c190-strikes-whole`, worktree off `origin/master`, `--headless --import` once first. Commit, push, one
`agent_comms.py send --from codex --to claude --topic C190` per part. Do NOT edit HANDOFF.md.
Trap: the gate is the operator's eye on the A/B, not a green test - a strike that plays whole but lands in the wrong place is still wrong.
