# TASK_Q163 - what unit are the RamsterZ sources in? Fix the probe's reading, then re-measure the seven holds (Qwen, full branch)

Model: qwen3-coder, medium, `--yolo`. Owner: qwen. Assigned S63, 2026-09-24, after Q162.

## Why - Q162's conclusion is not accepted as stated
Q162 reported that the seven RamsterZ `.fbx` holds have source contacts of ~0.02-0.04 m and concluded
"both men authored at nearly the same position". Three things contradict that:
1. Your own Q161 renders of the same pairs show two clearly separate men.
2. Your origin table reads source hip-to-hip **0.0318 m** against game **0.3026 m** on five different
   clips - a factor of almost exactly TEN, and the same pair of numbers on five clips.
3. `s31_contact_probe.gd:_check_hold` divides every source distance by 100 ("Cascy exports
   centimetres"). That is Cascadeur's unit. Nobody has established RamsterZ's.
So the likely cause is a UNIT or SCALE mismatch in how the probe reads a RamsterZ source (or the
same t=0 rest frame read five times), not the clips. Find out which.

## Part 1 - establish the unit, with evidence
For one RamsterZ pair (start with `Paired_FullMount_H2H_ArmBar`), print from the loaded source
(`FightClipRetarget._load_fbx` + `_index` + `_globals` + `_local_at`) the raw hip-to-head distance of
ONE man at t=0 and at the middle of the clip, before any division. A standing or kneeling adult's
hip-to-head is ~0.6-0.9 m: whatever factor maps the raw number there is the unit. Cross-check with
the FBX's own `UnitScaleFactor` if the importer exposes it, and with what `FightClipRetarget` does to
RamsterZ clips in `retarget_clip` (grep for the scale it applies). Also print the source hip-to-hip at
t=0 AND mid-clip for all seven, to rule out "five clips read the same rest frame".

## Part 2 - fix and re-measure
Make the probe convert each source by ITS OWN unit (Cascadeur keeps /100; RamsterZ gets the factor
Part 1 found). Re-run all seven with `--live-key` and redo the SOLVE / FINE / UNUSABLE table. Show
`mma_dirty_boxing` and `bjj_guard` still read exactly as before.

## Owned files
`Godot/tools/s31_contact_probe.gd` (the RamsterZ path only), `research/Q163_DIGEST.md` (new).
Do NOT edit FightClipRetarget.gd or PairedStagePlayer.gd - if the ENGINE has the same unit bug, report
it with the line; Claude fixes the engine.

## Gate (tier: a tool edited)
Parse gate; the two unchanged-output checks; the seven keys. No suite. Branch `qwen/q163-ramsterz-units`,
worktree off `origin/master`. One `agent_comms.py send` per part. Do NOT edit HANDOFF.md.
Trap: a number that is "mathematically correct but physically meaningless" is a bug in the measurement
until proven otherwise - check the instrument before you report the subject.
