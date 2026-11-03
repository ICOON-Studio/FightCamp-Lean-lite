# TASK LOCOWALK1 - CURSOR - real walking clips for our boxers (back off in guard, walk in guard, walk relaxed)

Status: OPEN (S377, Claude). Operator S377, watching the knockdown count's walk to the neutral corner: "the walking on the
clip is so bad", "their legs dont really move they slide across ... who can fix these clips? is it rigging issue or what?
why you fail to fix simple clip animations?".

## What is already fixed (do not redo)
- THE SLIDE: scripts/fight3d/StepRoot.gd (S377) moves a body only as far as the clip's planted foot pushes it (forward
  kinematics on the clip's keys). With it the corner walk's planted ankle holds (p90 0.017 m/s, tools/knockdown_film.gd).
- THE RIG IS FINE: punches, falls and the countdown rise bend the MetaHuman bodies correctly.

## What is missing - the clips (your job)
The library (assets/anim/baked) has exactly two walking clips and neither reads right on our boxers:
- `af_walk` (ActionForge corner-crew walk): limps on a boxer, a leg kicks back, gloves hang (filmed with `-- nofeet noknee`:
  the clip itself, not our layers).
- `loc_retreat` / `loc_advance` / `loc_strafe_*` (the fight's step loops): a deep crouch, hips 0.17 m below rest, knees cave
  in, legs cross (same with `-- nofeet noknee`).
Make three clips that do:
1. `walk_back_guard` - a boxer backing off calmly in a high guard: upright (hips no more than 0.08 m below rest), stance
   width kept, feet never cross, 4-6 steps, loops cleanly. This replaces `retreat` in KnockdownCount (WALK_CLIP).
2. `walk_guard` - walking forward in the same guard (for coming back out after BOX! and later the fight's resets).
3. `walk_relaxed` - walking with hands down, a boxer between rounds / the ring walk (to replace af_walk in FightIntro /
   CornerMinute later - do not wire it there in this task).

## Route
- Ludo CLI (`ludo agent-help`): `ludo model animate --model <rigged boxer glb> --prompt "..." --mode rot_only` (0.2 credits a
  call, 4 candidates each). Cap the spend: LUDO_MAX_CREDITS=6. Auth is the operator's (`ludo account` must answer; if it
  does not, stop and write that in your output - never ask for a key).
- The rig and the import route into `assets/anim/baked/<name>.res`: read ops/research/LUDO_ANIMATION_BRIEF_S196.md,
  ops/research/BAKEOFF_BLENDER_RETARGET.md and tools/clip_gltf.gd first; the baked clips keep the Hips position as deltas
  from the source rest (FightClips._add_baked) and FightClips.BAKED / load_into name them.
- Prompts: name the posture (upright boxer, high guard, elbows in, chin down), the step (heel-to-toe walk backward, feet
  under the hips, no crossing), the tempo (about 1.5 steps a second), in place (no root travel - StepRoot makes the travel).

## Bars (prove each clip; numbers in your output)
- StepRoot.travel(...)['loop'] for the clip: walk clips travel 0.5-1.5 m per loop in their own direction (back / forward).
- Hips: lowest Hips position key no more than 0.08 m below the first frame's rest height (loc_retreat: 0.17).
- Knees: over the loop each knee's bend axis stays within 25 deg of its hip's side axis (no caving in, FIGHT9 bar).
- In the ring: set KnockdownCount.WALK_CLIP to `walk_back_guard`, run tools/knockdown_film.gd (all four modes: default,
  stop=KO, stop=RSC, stop=KO skip) - every PASS line kept, the walk's slide p90 <= 0.05 m/s.
- Eyes: film the default knockdown_film and run `eyes index` + `eyes burst <id> <walk second> --count 16 --span 3`; put
  the burst sheet path in your output. A crouch, a cross-step or a frozen leg pose while the body moves = not done.

## Not yours
The fight's own footwork (Footwork / RingPlace / FootPlant) and every other fight3d file belongs to the FIGHT9 loop -
touch only what the Contract lists.

## Contract
OWNS: assets/anim/baked/walk_back_guard.res, assets/anim/baked/walk_guard.res, assets/anim/baked/walk_relaxed.res, scripts/fight3d/FightClips.gd, scripts/fight3d/KnockdownCount.gd, tools/knockdown_film.gd, ops/research/LOCOWALK1_NOTES.md
RED_TEST: tools/knockdown_film.gd -> KNOCKDOWN failures=0
REGRESSION: beat_clips_test, golden_path_test, move_clips_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/knockdown_film.gd
