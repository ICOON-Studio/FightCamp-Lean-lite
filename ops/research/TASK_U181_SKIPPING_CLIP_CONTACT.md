# TASK U181 - CURSOR - MAKE THE SKIPPING CLIP LAND ON ITS FEET, AND BIND THE CARDIO FLOOR (S86)
Owner: cursor. Assigned S86, 2026-09-26. Model: Composer, medium, `-p --force --trust`. Branch `cursor/u181-skipping`,
worktree `C:/Users/user/AppData/Local/Temp/FightCamp-U171` (`git fetch origin && git checkout -B cursor/u181-skipping
origin/master`).

## Why
U180 (merged S86) bound the speed bag. The skipping clip did not pass: its loop seam is fixed (0.836 -> 0.0 m/s) but
planted-foot slip went 0.246 -> 0.253 m/s against a 0.08 gate, so `cardio_floor` still idles. D27 (Dola) called it
"stiff, flat-footed, marching in place". A fighter skipping rope is the most recognisable thing in a boxing gym.

## What would a human do?
An animator cleaning a skipping take does not treat every frame near the floor as a plant. Skipping is BALLISTIC: short
ground contacts on the balls of the feet (~0.1-0.2 s), both feet together or alternating, and flight between them. They
mark the real contact windows (foot height AND foot velocity both low), pin the ball of the foot on exactly those frames,
let heel and knee flex into the landing, and leave the flight phase alone. Then they check it by eye at full speed.

## The work
1. In `Godot/tools/u180_station_ik.gd`, add a skipping pass: detect contact windows from toe height (< 0.03 m above the
   floor) AND toe speed (< 0.25 m/s), pin the toe on those frames with `FightLegIK` (two-bone), blend 2-3 frames in/out,
   and clamp any toe below the floor to it (C212 saw -0.017 m penetration). Keep U180's seam fix.
2. Gate, measured with `tools/c212_mixamo_audition.gd`'s own metric on the CONTACT windows your pass detected: planted
   slip p95 <= 0.08 m/s, no toe below -0.005 m, loop root-velocity seam <= 0.15 m/s, and at least one flight phase per
   second (the hops must survive - a clip that never leaves the floor passes slip and fails skipping).
3. If it passes: bind `cardio_floor` -> `jumping_rope_station.res` in `TrainingFloor3D.gd` `STATION_CLIPS` and add the
   clip-name check to `tests/training_floor_3d_test.gd` (mirror U180's `speed_bag` line). If it fails, bind nothing and
   report the numbers.
4. Render a load-only before/after MP4 into `docs/previews/u181/` (U180's "after" MP4s were copies of the "before" -
   add a load-only render path that plays the saved `.res` without re-retargeting; do NOT overwrite the `.res` from FBX).

## Owned files
`Godot/tools/u180_station_ik.gd`, `Godot/assets/anim/mixamo_audition/retargeted/jumping_rope_station.res`,
`Godot/tools/c212_mixamo_audition.gd` (a load-only render flag only), `Godot/scripts/TrainingFloor3D.gd` (STATION_CLIPS
only - S86 changed this file: rebase first, keep the spar tag and `_stack_tags` code), `Godot/tests/training_floor_3d_test.gd`
(clip checks only), `research/U181_DIGEST.md`, `previews/u181/`.
`TrainingFloor3D.gd` is ~720 lines - read `sed -n` windows at `STATION_CLIPS`; the IK tool is yours, read it whole.

## Tier
Parse gate on touched `.gd`, then `training_floor_3d_test` and `python Godot/tools/run_tests.py --only training_floor,c212 --jobs 2`.
No full suite. Windowed renders ONLY through `powershell -NoProfile -ExecutionPolicy Bypass -File Tools\godot_hidden.ps1 <godot args>`.

## Research
All research is open: root `RESEARCH_INDEX.md`; read `U180_DIGEST.md`, `C212_DIGEST.md` (the jumping_rope section) and
`C209_DIGEST.md` (its skipping candidate reached 0.185 m/s). Do NOT read HANDOFF.md, CURRENT_STATUS.md or HANDOFF_ARCHIVE.md.

## Done
Commit (explicit paths), push the branch, write the digest, `python Tools/agent_comms.py send --from cursor --to claude
--topic U181 --body "<slip/seam/flight before-after, bound or not>"`. Do NOT edit HANDOFF.md.

## The trap
A contact detector that uses height alone marks the bottom of every hop as a plant, pins the foot there, and "fixes"
slip by gluing him to the floor - slip reads 0.00 and the man stops skipping. Gate the flight phase too.
