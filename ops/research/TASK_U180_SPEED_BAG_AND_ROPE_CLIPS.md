# TASK U180 - CURSOR - MAKE THE SPEED BAG AND SKIPPING CLIPS READ REAL (S84; launch after U178B is collected)
Owner: cursor. Assigned S84, 2026-09-26. Model: Composer, medium, `-p --force --trust`. Branch `cursor/u180-station-clips`,
worktree `C:/Users/user/AppData/Local/Temp/FightCamp-U171` (rebase on origin/master first).

## Why
S84 put the training floor in 3D. Fighters on the heavy bag and in the ring play C212's station clips (D27 read both as
real). The SPEED BAG and SKIPPING stations still idle because their clips fail: D27 (Dola) - speed bag "fists pass BEHIND
the bag, never strike it", skipping "barely - stiff, flat-footed, marching in place". C212's own verdicts agree: speed
bag needs hand-path IK to the fixed bag and support-foot cleanup; skipping needs contact-foot IK/height cleanup and a
velocity-aware loop seam.

## What would a human do?
A game animator given a mocap clip that misses its prop does not move the prop to the hands (C212 fitted the bag to the
hands; D27 still saw the fists behind it). They fix the clip to the prop: pin the prop where the real one hangs (a speed
bag board at ~1.6-1.9 m, the bag's centre just below eye height, 0.3-0.4 m in front of the chest), then solve the hands
onto its front surface at each strike with a two-bone IK layer, keeping the rhythm (alternating, rebound-driven, ~2-4 hits
a second). For skipping they pin the balls of the feet to the floor on contact frames and let the heels and knees flex.

## The work
1. `speedbag_station.res`: fix the hand paths to strike the FRONT of a bag at a fixed position you state in metres
   relative to the fighter (use the floor's own greybox: `TrainingFloor3D.gd` `"wall_board"` shape - board at 1.9 m, bag
   centre 1.72 m; move the greybox only if the real anchor says otherwise, and say so). Gate: fist-to-bag-surface gap at
   strike peaks p95 <= 0.03 m AND no fist centre behind the bag's front plane on any frame.
2. `jumping_rope_station.res`: contact-foot pinning (planted-foot slip p95 <= 0.08 m/s, C212 measured 0.246) and a loop
   seam root-velocity jump <= 0.15 m/s (C212: 0.836).
3. Bind both in `TrainingFloor3D.gd` `STATION_CLIPS` (`speed_bag` -> speedbag, `footwork_ladder_set` and
   `reaction_footwork_grid` stay idle unless you have a clip; skipping has no catalogue station - bind it to `cardio_floor`
   ONLY if the clip passes its gate, and say which). Extend `tests/training_floor_3d_test.gd` with the clip-name check
   for any station you bind.
4. Render before/after MP4s with `tools/c212_mixamo_audition.gd` (it measures the gaps) into `docs/previews/u180/`.

## Owned files
`Godot/assets/anim/mixamo_audition/retargeted/speedbag_station.res`, `.../jumping_rope_station.res`,
`Godot/tools/c212_mixamo_audition.gd` (measurement only; add your IK pass as a new tool `Godot/tools/u180_station_ik.gd`),
`Godot/scripts/TrainingFloor3D.gd` (STATION_CLIPS and the wall_board greybox only), `Godot/tests/training_floor_3d_test.gd`
(clip checks only), `research/U180_DIGEST.md`, `previews/u180/`.
`TrainingFloor3D.gd` is ~600 lines - read `sed -n` windows at `STATION_CLIPS` and `"wall_board":`; the audition tool is
small enough to read whole.

## Tier
Parse gate on touched `.gd`, then `training_floor_3d_test` and `python Godot/tools/run_tests.py --only training_floor,c212 --jobs 2`.
No full suite. Windowed renders ONLY through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`.

## Research
All research is open: root `RESEARCH_INDEX.md`; read `C212_DIGEST.md`, D27's verdicts in `S83_DIGEST.md` (Collected),
`G113_REAL_GYM_FLOOR_DIMENSIONS.md` (speed-bag platform 1.5 x 1.6 m zone). Do NOT read HANDOFF.md,
CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## Done
Commit (explicit paths), push the branch, write the digest, `python Tools/agent_comms.py send --from cursor --to claude
--topic U180 --body "<gaps before/after, what is bound>"`. Do NOT edit HANDOFF.md.

## The trap
C212 made the heavy bag "fit" by moving the bag to where the fists already were, and the gap number looked perfect
(0.019 m) while a human still saw a miss on the speed bag. A gap measured to a prop you placed FROM the motion cannot
fail. Fix the prop first, from the real anchor, then measure the motion against it.
