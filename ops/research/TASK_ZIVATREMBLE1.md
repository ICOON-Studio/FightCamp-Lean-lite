# TASK ZIVATREMBLE1 - the boxers' hands tremble in the guard (operator C124, S275)

Seat: Ziva (motion seat, worktree E:/FightCamp/wt/ZIVA, branch ziva/playtest - merge origin/master first: your ROKOKOMOVES1 part A+B
f51a79f3..44a76a97 is ON MASTER now, collected S275 by diff). Discipline: BOXING (demo). Model: Ziva, effort MAX.

## The defect (operator, verbatim, on review video s274_layers_ab.mp4 - same fight, same seed, game as shipped):
"their hands are trembling wtf is this"

## Measured by Claude S275 (instrument: Godot/tools/fight_motion_probe.gd, new TREMBLE section; numbers are per hand,
## the hand taken in its CHEST's frame so body travel does not count; a "reversal" = the hand reverses direction between
## frames with a zig-zag > 2 mm)
Run: `Tools\godot_hidden.ps1 --path Godot --script tools/fight_motion_probe.gd --fixed-fps 30 -- as_game seconds=12 seed=95501 [off=a,b] [set=k:v] [tremble_trace=1]`
| arm (12 s, seed 95501, as_game, master BEFORE your ROKOKOMOVES1) | guard (`idle`) reversals a+b | per hand per s | zig mean mm |
|---|---|---|---|
| as shipped | 80 | 2.2 | 14.9 |
| off=contact_solve | 31 | 0.9 | 15.1 |
| off=contact_stop | 42 | 1.2 | 15.8 |
| off=contact_solve,contact_stop | 16 | 0.4 | 26.4 |
| off=head_stop / strike_aim / crossfade | 80 | 2.2 | 14.9 (no effect) |
| off=inertia,inertial_joins | 79 | 2.2 | 21.2 |
| off=hand_offset_smooth | 100 | 2.8 | 18.4 (worse - it helps) |
| guard_ik=0 / angle_guard=0 / skip_hand_continuity_while_stepping=0 / shuffle_from_bell=0 | no help (shuffle off = worse) |
| set=push_attack_s:0.06,push_release_s:0.25 | 83 | 2.3 | 15.2 |
| set=push_attack_s:0.10,push_release_s:0.35 | 65 | 1.8 | 17.1 |
- The RAW clip has none of it: `tools/c124_idle_noise_probe.gd` (the guard window sampled on mh_boxer_08 outside a fight) = 0 reversals.
- The old 2.0 s loop also had a seam at the hands (end->start 14.5 / 10.1 mm vs 1-2 mm per ordinary frame) - your GuardClock windows
  replace that loop; confirm the new guard has no seam either (`c124_idle_noise_probe.gd -- built` prints C124_SEAM_BUILT).
- `_push_attack_s` / `_push_release_s` default 0.0 (FightWorldLiveScreen.gd ~976) = the eased push in `_apply_eased_push` snaps; the
  easing arms above show snapping is NOT the main cause.
- So ~80% of the guard tremble is the CONTACT family (contact_solve's hand_pushes + contact_stop) acting on two close guards.
  Open question for you: does `_solve_contacts` read the clip's pose or the previous frame's pushed pose (undo order of `_bend_arm`
  vs the AnimationPlayer's apply), i.e. is it a limit cycle; and which contacts fire in a plain guard (glove-glove? glove-head?).

## Do
1. Re-run the table's first and fourth rows on master WITH your ROKOKOMOVES1 (the new guard) - the numbers may move.
2. Find the mechanism with `tremble_trace=1` (prints every reversal with the clip time) + the contact stats.
3. Fix it so the guard is still: target <= 0.3 reversals per hand per second in the guard and zig mean <= 5 mm, WITHOUT gloves passing
   through heads/bodies (the reason contact_solve exists - S4a census: arm>torso/hand>torso/head>arm reach ZERO; keep that census).
   Gloves touching gloves in a guard is real boxing; a few mm of glove-glove overlap is invisible, a tremble is not.
4. Video: same seed, before | after side by side, 20 s, `--fixed-fps 30`, the game's camera; open it yourself.

## Test (red on master first)
Extend `tests/rokoko_clips_test.gd` or new `tests/guard_still_test.gd`: as_game, 12 s, seed 95501: guard reversals per hand per s <= 0.3
and the S4a penetration census unchanged (arm>torso, hand>torso, head>arm = 0). Plain arm unchanged.

## Contract
OWNS: Godot/scripts/FightContactSolve.gd, Godot/scripts/FightWorldLiveScreen.gd, Godot/tests/guard_still_test.gd
RED_TEST: Godot/tests/guard_still_test.gd -> GUARD_STILL failures=0
REGRESSION: rokoko_clips_test, fight_guard_contract_test
VISUAL: yes

## Prior research
S77 hand flicker ("the hands look like flickering sometimes", the flip guard in _apply_eased_push, tools/s77_camera_probe.gd);
ZIVA_ROKOKOMOVES_S274.md; ZIVAGUARD1 ("the pair-spacing family and the gait latch are the two the fight still needs").

## What would a human do?
Watch two real boxers at range: the gloves are still between punches; when they touch, they touch and stay. Fix the solver so a contact
holds, not re-solves every frame.

## Prefab check
None - our contact solver.

## The one trap
Turning contact_solve off makes the number pass and puts gloves inside heads - the census must stay at zero.
