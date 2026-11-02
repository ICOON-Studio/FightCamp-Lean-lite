# TASK_U160 - the operator's take-three verdict: moves too fast (elbows), and the hands while moving (Cursor, full branch)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S66, 2026-09-24.

## Why - the operator's verdict on take three, VERBATIM (2026-09-24)
"This video is much better I see still some moves are being executed extremely fast like uh, elbows I think and when
the hands like class but not uh, during the moving animation there is some uh, weird uh, hand movement let's say
They're still clipping, but it's much, much better than everything else. I've seen so far. Keep working on it. It's
still needs a lot. But you're, I think you are on the right uh, path now."
Take three is `research/_captures/watch_loop/take3_s65_seed92012.mp4` (seed 92012, MMA, live room). His three
items: (1) moves too fast, ELBOWS named; (2) weird HAND movement while the fighters MOVE, and when hands clash;
(3) clipping. **Yours are (1) and (2).** Clipping goes to Codex after C190.

## Lead already found (check it, do not trust it)
`FightStagePlayer._kick_playback` (`scripts/FightStagePlayer.gd:166`) caps tempo at `KICK_TEMPO_MAX` and seeks no
later than contact - `KICK_MIN_WINDUP_S` - but ONLY for `_is_kick_throw_role` (kick / knee / teep / roundhouse).
**Elbows and punches get neither cap**: a seeked elbow skips its wind-up and a fast tempo multiplies the rest.

## Part 1 - measure, per strike class, before touching anything
Seed 92012, MMA, 60 s, the S65 demo pair (grappler 175 cm vs striker 185 cm - print it). For every strike played in
the live room: class (punch / elbow / knee / kick - use `assets/data/clip_phases.json`, CORRECTED in S66: effector
inside the technique's limb), clip, seek, tempo, the striking effector's peak speed ON SCREEN, and the same clip's
peak speed at native speed from frame 0 (clip_phases.json has `peak_speed_mps`). Report the ratio screen/native per
class (median, p90, max) and name the worst ten plays. A real elbow is not faster than its own source clip.
Then the hands with NO strike playing: per-frame wrist speed and any single-frame jump while walking/stepping, and
which writer moves them (walk splice / `FightBodyLayers`, arm IK, the C186 12 m/s hand clamp, the guard pose).
And when the two men's gloves meet: glove-to-glove interpenetration depth and how the arms resolve it.

## Part 2 - fix it in PLAYBACK (never in clip data)
Extend the wind-up/tempo protection to every strike class the measurement convicts (elbows at least), from
clip_phases.json's own start/contact where it has them. Fix the hand defect at the writer Part 1 names. Behind room
switches if behaviour changes for the default room: `strike_speed_caps` (and a second switch for the hands if it is a
separate mechanism), default OFF until the operator's A/B.
**Coordinate with Codex C190**, running in parallel on `codex/c190-strikes-whole`: its `strikes_play_whole` plays a
strike from frame 0 at speed 1 and would make a strike cap moot when ON. Yours is the cap for the room with that
switch OFF, and for anything it does not cover. Keep your edits inside the kick/strike playback helpers and the hand
writer; whichever of you lands second merges the other.

## Part 3 - evidence
The Part 1 table after the fix (ratio per class). A 10 s side-by-side OFF | ON on seed 92012 at a moment with an
elbow and with both men stepping (`research/_captures/watch_loop/u160_speed_hands_ab.mp4`, MP4 <50 MB, via
`Tools\godot_hidden.ps1` and `tools/record_room.gd`). OPEN it as a contact sheet before reporting.

## Owned files
`scripts/FightStagePlayer.gd` (strike playback caps and the hand writer only), `scripts/FightWorldLiveScreen.gd` (the
switch(es) and call sites only), `scripts/FightBodyLayers.gd` only if Part 1 convicts it, a new
`Godot/tools/u160_speed_probe.gd`, a new `tests/fight_strike_speed_test.gd` (switch ON: no strike's on-screen peak
exceeds its native peak by more than the ratio you justify from the source; OFF byte-identical - prove with mutants),
the mp4, `research/U160_DIGEST.md`.

## Gate (tier: scripts edited)
`python Godot/tools/check_scripts.py <touched .gd>`; `fight_strike_speed_test` with mutants caught; then
`python Godot/tools/run_tests.py --only fight_stage` then `--only fight_world` then `--only fight_reaction`
(ONE `--only` per invocation - a second replaces the first; read `total=`). `fight_stage_realism_test` is a
documented CEILING red. Branch `cursor/u160-speed-and-hands`, worktree off `origin/master`, `--headless --import`
once first. Commit, push, `python Tools/agent_comms.py send --from cursor --to claude --topic U160 --body "..."` per
part. Do NOT edit HANDOFF.md. READ SCOPE: read any script/tool/test you need (large files in `sed -n` windows).
Trap: the spec can be the defect - C186 met a 0.15 m/frame threshold by holding punches to half a real fist's speed.
The target is the SOURCE clip's own speed, not a number that looks calm.

## ROUND 2 (S66, 2026-09-24) - round 1 moved nothing; find what actually does
Round 1 (`52553eb5`) is NOT merged: its own Part 3 table is IDENTICAL to Part 1 (punch 1.85, knee 2.13, kick 5.47) and
wrist jumps while stepping went 92 -> 95. The digest says why - most plays had seek 0, so a seek/tempo cap cannot touch
them - which means seek/tempo is not the cause on this seed. Keep the caps code on the branch; do not ship switches that
change nothing.
1. **Measure in take four's configuration**: `strikes_play_whole` (C190) and `reactions_play_whole` (U159) ON - both are
   on master now. Then the same with both OFF. Print both tables. Take four is what the operator will judge.
2. **Attribute the ratio** for the worst ten plays: split the on-screen effector speed into (a) the clip's own local
   motion at the tempo used, (b) the root/placement/warp motion added by the room, (c) IK / arm solve / C186 hand clamp.
   Whichever term owns the excess is the fix; name it with numbers.
3. `kickboxing_jab_lowkick` (5.47x, seek 0.54) is a KICK the kick cap should hold - check `_is_kick_throw_role`
   (`FightStagePlayer.gd`): a role containing "jab" returns false, so a jab-lowkick combo escapes the kick cap. Fix the
   classification from the effector (`clip_phases.json` `effector`), not the role name.
4. Hands while stepping: skipping C186's bend made it worse (92 -> 95). Find the frame the wrist jumps on and the writer
   that moved it (walk splice entry/exit, a clip sample boundary, a guard-pose blend) - print the per-writer delta on
   the worst five jumps before changing anything.
5. Elbows: the operator named them and your slice had none. Find a seed or window with elbows (MMA or Muay Thai demo
   pair, different fighters - never identical) and measure them.
Same owned files and gate. Digest under `## Round 2`. The trap: an "after" table identical to "before" is a finding,
not a delivery - say what did move it.

## ROUND 3 (S66, 2026-09-24) - the elbow the operator saw, and the hand jump at the clip boundary
Round 2 (`d44c0c19`, not yet merged - S67 collects it) found both: with take-four ON the worst kick is 2.54x, but the
ELBOW `karate_empiuchi` plays at **4.64x** its source (Muay Thai seed 92020), and the 52.8 m/s wrist jump is an
inter-frame room step / walk-clip boundary (`loc_strafe_right`, frame 1068), not `hand_continuity`.
1. Attribute the 4.64x elbow exactly as round 2 did the kick (clip local / placement-warp / IK) and fix the owner,
   take-four ON. Target: at or under its source speed plus the ratio you justify; print before/after for every elbow.
2. The hand jump: fix the boundary (entry/exit blend of the walk clip, or the room's per-frame step) so no wrist moves
   more than its own clip does across that frame; before/after count of jumps > 8 m/s while stepping.
3. `strike_head`'s effector in `clip_phases.json` reads RightFoot (a generic role, 3 clips) - say which bone it
   should be timed on; do not edit the JSON (Claude owns it), report it.
Same owned files and gate; digest under `## Round 3`. Trap: an elbow slowed below its own source is a second defect.

## ROUND 4 (S66, 2026-09-24) - rounds 1-3 compared two different speeds
Your own U162 (`0c28615e`) settled it: the retarget runs at 0.883x its source (median), max 1.072x, NO clip over 1.5x;
`karate_empiuchi` is 0.86x. U160's "4.64x" (and every ratio in rounds 1-3) was LIVE WORLD speed divided by
`clip_phases.json`'s CHEST-RELATIVE speed - two different quantities (up to 3.2x apart on elbows by your own check).
So round 3's `_whole_strike_tempo_cap` (tempo 0.332) plays a real elbow at a THIRD of its speed: it must NOT ship.
1. Revert the whole-strike tempo cap on your branch (keep the walk-join smoothing and the effector-based kick cap).
2. Re-measure every strike class LIKE FOR LIKE: the source clip on the vendor rig in WORLD space (with its own root
   motion) vs the live room in WORLD space, take-four ON and OFF, plus an MMA and a Muay Thai seed with elbows (two
   different fighters). Then attribute any excess (clip / placement-warp / IK / body layers) as round 2 did.
3. If nothing is faster than its source, say so plainly: then "elbows look too fast" is a READABILITY problem (a real
   elbow is ~0.2 s), and the answer is presentation (anticipation, contact hold, camera), not speed - propose it.
4. Hand jumps: re-count before AND after with ONE rule, and report both.
Same owned files and gate; digest under `## Round 4`. Trap: never divide a world speed by a chest-relative one.
