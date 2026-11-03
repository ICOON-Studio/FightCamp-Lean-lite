# TASK LOCOWALK2 - CURSOR - real walking clips for our boxers, from Ludo's captured presets (round 2 of LOCOWALK1)

Status: OPEN (S378, Claude). Operator S377, watching the knockdown count's walk to the neutral corner: "the walking on the
clip is so bad", "their legs dont really move they slide across ... why you fail to fix simple clip animations?" and on the
route: "Try Ludo first".

## Why round 2
LOCOWALK1 (cursor/locowalk1, PR #31, closed unmerged) ran with a dead shell: Cursor's 11-03 update started running this
repo's `.claude/settings.json` PreToolUse hook without `CLAUDE_PROJECT_DIR`, so every shell call exited 2. Fixed on main
fa59bedc and proven (a Cursor run printed `git log -1` through the hook). With no shell it wrote a sine-wave leg generator
in FightClips.gd that did not compile. That route is closed: **no clip is generated, keyed or "procedurally" built in code -
every new .res comes from a Ludo GLB through tools/clip_gltf.gd import.** If any shell call fails, stop and write the exact
error at the top of your output; do not work around it.

## What is already fixed (do not redo)
- THE SLIDE: scripts/fight3d/StepRoot.gd moves a body only as far as the clip's planted foot pushes it. The clip must play
  IN PLACE (no root travel); StepRoot makes the travel.
- THE RIG: punches, falls and the countdown rise bend the MetaHuman bodies correctly.

## The clips (all baked to assets/anim/baked/<name>.res, committed as files - nothing is built at runtime)
1. `walk_back_guard` - a boxer backing off calmly toward the neutral corner, hands up: upright (hips no more than 0.08 m
   below rest), feet never cross, loops cleanly. Replaces `retreat` as KnockdownCount.WALK_CLIP.
2. `walk_guard` - walking forward, hands up (coming back out after BOX!).
3. `walk_relaxed` - walking with hands down (between rounds / ring walk; do NOT wire it anywhere in this task).
4. Part 2, only after 1-3 pass: `step_in_guard`, `step_out_guard`, `step_left_guard`, `step_right_guard` - one short boxing
   step each (~0.25-0.35 m, upright, stance kept: the near foot steps, the other follows). Deliver baked with their
   StepRoot travel numbers; do not wire them into Footwork (FIGHT9's).

## Route (exact)
1. A rigged boxer GLB on our skeleton (Godot = $GODOT_EXE, the 4.7.2 win64 exe; never a *_console.exe):
   `"$GODOT_EXE" --headless --path . --script res://tools/clip_gltf.gd -- export clip=mc_Box1_M3_Idle out=E:/FightCamp/wt/LOCOWALK2_ludo/boxer.glb glb=mh_boxer_10`
2. Pick presets for free first: `E:/FightCamp/tools/npm/ludo.cmd sprite list-animation-presets --json` lists every preset
   with a `preview_url` mp4. Download the previews of the candidates below and look at them
   (`eyes index <mp4>` + `eyes burst <id> 1.0 --count 12 --span 2`): pick the ones whose legs stay upright and never cross.
   - walk_back_guard: `walk_backward`, `backpedal` (then `walk_bwd_loop_quaternius` - Quaternius is the af_walk source, which
     limps on our boxer: last choice)
   - walk_guard: `walk_forward`, `walk_confident`
   - walk_relaxed: `walk_relaxed`, `walk_forward`
   - steps (part 2): `strafe_left` / `strafe_right` (one step cut out), `backstep`; else text:
     `ludo model animate --model boxer.glb --prompt "boxer in orthodox stance takes one short step forward, lead foot first,
     rear foot follows, hands up in a high guard, upright" --no-loop` (4 candidates per call)
3. Retarget a preset onto our boxer (0.5 credits a call):
   `E:/FightCamp/tools/npm/ludo.cmd model animate-preset --model E:/FightCamp/wt/LOCOWALK2_ludo/boxer.glb --preset-id <id> --in-place --crop-loop --out E:/FightCamp/wt/LOCOWALK2_ludo/<id>`
   Spend cap: 10 credits for the whole task (`ludo account` before and after; both numbers in your output). Auth is the
   operator's - if `ludo account` does not answer, stop and write that; never ask for a key.
4. Into the game: `"$GODOT_EXE" --headless --path . --script res://tools/clip_gltf.gd -- import glb=<ludo glb> like=mc_Box1_M3_Idle out=<tmp .res>`
5. Hands up: the walks come with swinging arms. `tools/locowalk_bake.gd` (new, yours) writes the final .res offline: hips
   (position + rotation) and both legs (upper leg, lower leg, foot, toes) from the walk; spine, chest, neck, head, shoulders,
   arms, hands and fingers from `mc_Box1_M3_Idle` (the guard) time-wrapped over the walk's length; loop_mode linear. For
   `walk_relaxed` keep the preset's own arms. Run it once per clip and commit the .res files.
6. FightClips.gd: a `LOCOWALK` name list loaded in `load_into` like the Pro stems (hold_root_xz + LOOP_LINEAR for the
   walks, not the single steps). Nothing that writes res:// at runtime.
7. tools/knockdown_film.gd: take the walk-knee lines from `git show 02c5441f -- tools/knockdown_film.gd` (the `walk_knees`
   capture, the "KNOCKDOWN walk knees" print and its two _check lines, slide p90 bar 0.05) - NOT its `bake` /
   `ensure_locowalk_baked` lines.

## Bars (prove each clip; numbers in your output)
- StepRoot.travel(...)['loop'] per walk clip: 0.5-1.5 m per loop in its own direction (back / forward).
- Hips: lowest Hips position key no more than 0.08 m below the first frame's rest height (loc_retreat: 0.17).
- Knees: over the loop each knee's bend axis stays within 25 deg of its hip's side axis (no caving in).
- In the ring: KnockdownCount.WALK_CLIP = `walk_back_guard`; tools/knockdown_film.gd in all four modes (default, stop=KO,
  stop=RSC, stop=KO skip) - every PASS line kept; the walk's slide p90 <= 0.05 m/s; "KNOCKDOWN walk knees" jerk p95
  <= 4.5 deg/frame^2 and flips <= 1.5/s.
- Eyes: film the default knockdown_film (FILM line below) and run `eyes index` + `eyes burst <id> <walk second> --count 16
  --span 3`; put the burst sheet path in your output. A crouch, a cross-step, swinging gloves in walk_back_guard, or one leg
  pose held while the body moves = not done.

## Not yours
The fight's own footwork (Footwork / RingPlace / FootPlant / StepRoot) and every other fight3d file belongs to the FIGHT9
loop - touch only what the Contract lists.

## Contract
OWNS: assets/anim/baked/walk_back_guard.res, assets/anim/baked/walk_guard.res, assets/anim/baked/walk_relaxed.res, assets/anim/baked/step_in_guard.res, assets/anim/baked/step_out_guard.res, assets/anim/baked/step_left_guard.res, assets/anim/baked/step_right_guard.res, scripts/fight3d/FightClips.gd, scripts/fight3d/KnockdownCount.gd, tools/knockdown_film.gd, tools/locowalk_bake.gd
RED_TEST: tools/knockdown_film.gd -> KNOCKDOWN failures=0
REGRESSION: beat_clips_test, golden_path_test, move_clips_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/knockdown_film.gd
