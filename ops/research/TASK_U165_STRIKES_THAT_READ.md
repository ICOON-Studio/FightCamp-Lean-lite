# TASK_U165 - strikes that READ: G75's onset-to-impact floors (Cursor, census + a grounded fix)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S68, 2026-09-24.

## Why
The operator on take three, verbatim: "still some moves are being executed extremely fast like uh, elbows ... weird uh,
hand movement". Your U164 capped PEAK SPEED per class. Grok's G75 (`research/G75_STRIKE_SPEEDS.md`, READ §2 and §4
WHOLE - it is the spec) says speed is not what reads: an elbow travels 20-40 cm, so even at a real 6-8 m/s it is
1-1.5 frames at 30 fps, "a smear". What reads is ONSET->IMPACT DURATION (load + travel). G75 §4 gives a minimum
on-screen onset->impact per class (jab 6 frames, cross 7-8, hooks/uppercuts 10, elbows 6 / spinning elbow 12, straight
knee 8, teep 7, roundhouses 10-12, spinning back kick 12) and a hard rule: below 6 frames @30 fps a strike stops reading.
Elbows have NO speed band (G75: NOT FOUND) - so U164 could not touch them, and they are exactly what the operator named.

## Part 1 - the census (extend YOUR `tools/u164_source_speed_census.gd`, or a sibling `tools/u165_onset_census.gd`)
For every bound strike clip (124): onset (first frame the STRIKING effector - your U164 effector, never the support limb -
leaves its guard/rest with sustained velocity; state the threshold you used and why) -> contact (`clip_phases.json`
contact) in frames @30 fps AS PLAYED (vendor length x tempo, with `human_speed_tempo` OFF and ON), the class, and G75's
floor for it. Flag every clip under its floor, with the shortfall in frames. Add G75's floors to
`assets/data/strike_speed_anchors.json` with the G75 citation per row (the floor's own source column, verbatim).

## Part 2 - the grounded fix, behind a switch `readable_onset` (default OFF)
For flagged clips, stretch ONLY the load->contact window (not the retract, not the whole clip) so onset->impact meets
the class floor - a time-warp of that span, applied in the playback path you already own beside `_apply_human_speed_tempo`.
Contact must still land on the engine's scored impact time (the room schedules on it - check how `_contact_s` is read
and keep that contract). Composes with `human_speed_tempo` (either, both, neither). Print before/after frames beside G75.
Then a 10 s side-by-side OFF | ON on seed 92012 at an ELBOW (find a seed/time with a landed elbow; name it) -
`research/_captures/watch_loop/u165_readable_onset_ab.mp4`, MP4 < 50 MB, rendered through
`powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>` + `tools/record_room.gd`,
and open its contact sheet yourself before reporting. The operator's eye decides.

## Owned files
`Godot/tools/u164_source_speed_census.gd` or a new `Godot/tools/u165_onset_census.gd`,
`Godot/assets/data/strike_speed_anchors.json`, `Godot/scripts/FightStagePlayer.gd` (the onset warp only - it is ~2,000
lines: grep `_apply_human_speed_tempo`, `_contact_s`, `play_role` and read windows), `Godot/scripts/FightWorldLiveScreen.gd`
(the switch only), `Godot/tools/record_room.gd` (the switch arg only), a new `Godot/tests/fight_readable_onset_test.gd`
(ON: every flagged clip's played onset->impact >= its floor AND contact time unchanged; OFF byte-identical; 4+ mutants
caught), `research/U165_DIGEST.md`.

## Gate (tier: scripts edited)
Parse gate (`python Godot/tools/check_scripts.py <touched .gd>`) before any test; the new test with mutants; then
`--only fight_stage`, `--only fight_strike`, `--only fight_world`, `--only fight_human_speed` (one `--only` per run; read
`total=` each time; ceiling fight_stage 10/1, the documented fight_stage_realism red). No full suite.
Branch `cursor/u165-readable-onset` off `origin/master` (U164 is merged there). Commit with explicit paths, push,
`python Tools/agent_comms.py send --from cursor --to claude --topic U165 --body "<clips flagged OFF/ON, worst shortfall, elbow before/after frames, test checks, mutants, MP4 path>"`.
Do NOT edit HANDOFF.md.

## The one trap
Stretching a window moves every frame after it: if contact shifts, the struck man reacts before the blow lands (the room
schedules reactions on the scored time). Warp the load span to END exactly at the original contact time - start it
earlier - and assert the contact time in the test, not just the duration.
