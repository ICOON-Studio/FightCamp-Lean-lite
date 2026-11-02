# TASK_U162 - a retargeted strike runs ~4x faster than its source: find why (Cursor, full branch)

Model: Composer, medium, `-p --force --trust`. Owner: cursor. Assigned S66, 2026-09-24.

## Why
The operator, 2026-09-24 (verbatim): "still some moves are being executed extremely fast like uh, elbows". Your U160 round 3
found `karate_empiuchi` playing at 4.64x the effector speed `clip_phases.json` records for its source, at tempo 1.0, and
"fixed" it by capping the whole-strike tempo to 0.332. That makes the screen number right by playing the clip at a third
speed - if the RETARGETED clip is ~4x faster than its source, the cap hides a retarget defect, and every other clip with
the same defect is still wrong. C189 (Codex) had measured our fighter playing clips whole as matching the vendor
mannequin - so either this clip is an outlier, or the two measurements define speed differently.

## Part 1 - a census, not one clip
For EVERY bound strike clip (124, `clip_phases.json`): the striking effector's peak speed (a) in the SOURCE clip on the
vendor rig, (b) after `FightClipRetarget` on f01 (and f02 - two different bodies, print both heights), both at tempo 1.0
from frame 0, 60 Hz, world space, same bone definition. Ratio b/a per clip; median, p90, max; list every clip over 1.5x.
Check the definitions first: `clip_phases.json` `peak_speed_mps` was measured by Claude's corrected Q167 tagger on f01
(effector = the technique's own limb, chest-relative) - a chest-relative number and a world number are not the same
speed. Make both arms use ONE definition and say which.

## Part 2 - the cause
For the outliers: frame rate / bake (Godot resamples glTF - the S62 `bake_fps` trap), a mis-sized scale on the
effector chain, a slice window that drops frames, mirroring, or a time-scale in the import. Name the cause with numbers.
Fix it in the retarget/slice path (never in clip data), and then say what U160's tempo cap should become (if the
cause is fixed, the cap may be unnecessary - measure with and without).

## Owned files
`scripts/FightClipRetarget.gd` / `scripts/FightClipSlice.gd` (only if Part 2 convicts them), a new
`Godot/tools/u162_retarget_speed_census.gd`, a new `tests/fight_retarget_speed_test.gd` (a retargeted clip's effector
peak within the ratio you justify of its source; mutants caught), `research/U162_DIGEST.md`.

## Gate (tier: scripts edited)
Parse gate; the new test with mutants; `run_tests.py --only fight_clip_retarget`, then `--only fight_cascy_retarget`,
then `--only fight_strike` (one `--only` per invocation; read `total=`). Branch `cursor/u162-retarget-speed` off
`origin/master`. Commit, push, `agent_comms.py send --from cursor --to claude --topic U162`. Do NOT edit HANDOFF.md.
Trap: two speeds measured in different frames (chest-relative vs world) will disagree without anything being broken -
prove the definitions match before you call a clip fast.
