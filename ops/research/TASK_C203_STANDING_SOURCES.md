# TASK C203 - CODEX - RE-AUTHOR THE STANDING SOURCES THAT CROUCH
Model: `gpt-6-astra`, MEDIUM (`CODEX_MODEL=gpt-6-astra`), web OFF. Owner: codex. Assigned S76, 2026-09-25. 3D lane.

## Why
C202 (merged S76 as a diagnosis, `research/C202_DIGEST.md`) proved the hook crouch is IN THE SOURCE: at
t=0.866667 `H2H_HookPunch_InPlace.FBX` has pelvis Y 0.764 m and knees 123.4/122.2 deg, and the retarget matches it.
Crossfade and foot-lock-off do not remove it; hip-carry-off floats the body (rejected). Its verdict: "A safe next
intervention needs coherent support-foot/leg/pelvis authoring or an explicitly approved replacement source." So fix the
SOURCE, not the join.

## What would a human do?
A game animator runs a pass over the whole standing set against the guard reference: every clip whose pelvis drops
below the fighter's guard height by more than a stated tolerance gets its lower body re-keyed - pelvis raised, knees
re-solved with IK so both feet stay planted where the source put them - while the upper body (the punch itself) is left
untouched. The fixed take ships as a new file beside the original, and the game switches to it only after review.

## Do
1. CENSUS first: for every standing strike/reaction source bound in the game (`FightClipBinding`), print min pelvis
   height (m above the mat) and max knee flexion over the clip, against the guard reference (the idle's own pelvis
   height - measure it, print it). Name every clip below the floor. Tool `Godot/tools/c203_standing_census.gd`.
2. Re-author the worst clips (at least the hook) in Blender 5.2.1: raise the pelvis to within the tolerance you state,
   IK the legs so the feet keep their source contacts, leave spine/arms/head keys untouched. Export beside the original
   as `<name>_v1.<ext>`; never overwrite a source.
3. Wire the `_v1` files behind a NEW switch, default OFF (`standing_sources_v1`); OFF = byte-identical poses
   (3600/3600 hash as C198/C202 did).
4. Evidence: re-run the census on the `_v1` files; before/after MP4 of C202's seed (2288268096, Larkin f01 vs Pereira
   f02, boxing) through `Tools/godot_hidden.ps1` at 854x480, md5 both; pelvis/knee/toe table before vs after.

## Owned files
New `Godot/tools/c203_*.gd`, new `*_v1` clip files beside their originals, the switch in `Godot/scripts/FightStagePlayer.gd`
(~3,600 lines - NEVER open whole; `grep -n` then `sed -n` windows), `research/C203_DIGEST.md`, MP4s under
`research/_captures/watch_loop/`. `FightClipRetarget.gd` READ-ONLY; RamsterZ pose hash `83f6a766...f9ea` unchanged.

## Gate (tier: script edited)
Parse gate first. Then `python Godot/tools/run_tests.py --only fight_stage,fight_world,fight_clip,fight_body_layers --jobs 1`
(fight_stage_realism is a known red - equal or better). ONE Godot/Blender process at a time: the operator is using this PC.
Worktree: `git fetch origin && git worktree add -b codex/c203-standing-sources C:/Users/user/AppData/Local/Temp/FightCamp-C203 origin/master`;
copy the main checkout's `Godot/.godot/imported` into it rather than re-importing. Commit explicit paths (never `.godot/`),
push the branch, then `python Tools/agent_comms.py send --from codex --to claude --topic C203 --body "<census, clips fixed, hashes, md5s, tests>"`.
Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
Raising the pelvis without re-solving the legs gives C202's floating body again (toes 0.23 m off the mat). The feet must
stay on their source contacts; print toe height above the mat before and after.
