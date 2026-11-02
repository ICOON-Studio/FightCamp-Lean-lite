# TASK C202 - CODEX - THE HOOK/REACTION JOINS THAT CROUCH AND KNEEL
Model: `gpt-6-astra`, MEDIUM (`CODEX_MODEL=gpt-6-astra`), web OFF. Owner: codex. Assigned S75, 2026-09-25. 3D lane.

## Why
C198 pass 4 (merged S75 default-OFF) left this in its own "WHAT IS STILL WRONG": "Hook/reaction joins still crouch or
kneel implausibly. Career footage around 40-45 and 65-70 seconds exposes this clearly. Correct glove reach does not
make the whole-body action believable." (`research/C198_DIGEST.md`, video
`research/_captures/watch_loop/c198_pass4_career.mp4`, md5 47504b65d21abf219e545c44c2fdbcd0). The operator judges the
fight from the game camera; a man who drops to a knee to throw or take a hook reads as broken.

## What would a human do?
An animator scrubs the join frame by frame, finds WHICH bone chain drives the drop (pelvis height? knee flexion from a
blend of two clips with different stances? a hip-carry offset applied twice?), and fixes it at the source: the blend
weights, the root/pelvis carry, or the clip's own window - never by clamping the symptom. Write that diagnosis first,
with the per-frame pelvis height and knee angles printed for one bad join.

## Do
1. Reproduce: find the exact joins in the career recording (40-45 s, 65-70 s) - clip names, windows, blend/inertia mode
   - and print pelvis height (m above the mat) and both knee angles per frame across each join, on our tree.
2. Diagnose the cause with a CONTROL ARM: the same join with the suspected mechanism off (e.g. hip carry off, or
   inertia join replaced by a plain crossfade) must stop the drop, and a join that looks right must be unchanged.
3. Fix it behind a NEW switch (default OFF) in the owning script; OFF = byte-identical poses (3600/3600 hash like C198).
4. Evidence: before/after MP4 of the same seed/bout at 854x480 through `Tools/godot_hidden.ps1` (never `--position`),
   md5 both, and the pelvis/knee table before vs after. Pelvis must not fall below a standing-guard floor you state and
   source (e.g. from the RamsterZ idle's own pelvis height) during a standing exchange.

## Owned files
`Godot/scripts/FightStagePlayer.gd` (~3,600 lines - NEVER open whole; `grep -n` then `sed -n` windows),
`Godot/scripts/FightWorldLiveScreen.gd` (read-only unless the join lives there), new `Godot/tools/c202_*.gd`,
`research/C202_DIGEST.md`, MP4s under `research/_captures/watch_loop/`. `FightClipRetarget.gd` READ-ONLY;
RamsterZ pose hash `83f6a766...f9ea` unchanged.

## Gate (tier: script edited)
Parse gate first. Then `python Godot/tools/run_tests.py --only fight_stage,fight_world,fight_room,paired_stage,fight_body_layers,fight_clip`
(fight_stage_realism is a known red - equal or better). Fresh worktree:
`git fetch origin && git checkout -B codex/c202-reaction-joins origin/master`, then `--headless --path Godot --import` once
(if it fails on the Blender import path, copy the main checkout's `.godot/imported` as C201 did and say so).
Commit explicit paths, push the branch, then
`python Tools/agent_comms.py send --from codex --to claude --topic C202 --body "<cause, control arm, pelvis/knee before-after, md5s, tests>"`.
Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md. All research is open: root RESEARCH_INDEX.md.

## The one trap
A pelvis clamp makes the number pass and the body float - the legs stay bent under a hovering hip. Fix the cause the
control arm names; if the only fix is a clamp, report that and do not ship it.
