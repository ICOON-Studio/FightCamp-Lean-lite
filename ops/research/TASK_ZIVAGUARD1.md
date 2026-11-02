# TASK ZIVAGUARD1 - the guard's gloves sit forward and wide in the fight; on the board they are on the face, elbows in

Model: Ziva (Godot editor seat, wt/ZIVA, effort MAX). Discipline: BOXING (demo).

## First
`git fetch origin && git merge origin/master` in wt/ZIVA (master has HOOKTIME1 b82327f6 and the S274 hidden-desktop browser
guard). Override.cfg keeps Dummy audio. Never open a browser or an image viewer - read images with your file tool.

## Why (operator S273: "why the clip is so different than the animations from rokoko" / "whats the right fix")
The board's Rokoko take `rk_FightingIdle` (anim_orbit_render) shows the gloves ON the face, elbows tucked. In the fight
(tools/fight_studio_render.gd, fighters only - the operator's own request) the gloves sit forward and wide of the chin at the
pocket (you saw it at 14 s), WITH the guard layers already off (mocap_pure 799ff509). Something between the clip and the
screen still moves the hands. Find it by MEASURING both paths, not by looking.

## What to do
1. Add glove columns to both loggers (same units, the fighter's local frame, metres):
   - tools/fight_studio_render.gd `clip_log=1` (line ~80): per man, lead + rear glove to chin distance and glove x (width).
   - tools/anim_orbit_render.gd `pelvis_log=1`: the same columns for the orbited man.
2. Run both on the SAME clip (rk_FightingIdle / the fight's guard) and the same body (04): table of median + p90 per column.
3. Bisect the fight path with `off=` one switch at a time: face_drawn_foe, hand_contact_sync, glove_contact, reface_in_takes
   (and any other layer that writes hand/arm bones after the clip - list them with the line numbers you found). The switch whose
   OFF arm brings glove-to-chin within 3 cm of the board's number is the cause.
4. Fix it in the game, the smallest change (that layer skips captured takes, like mocap_pure does - or its target is wrong),
   switch stays in GAME_ON. Then a 20 s fight_studio_render clip (as_game, fixed fps) beside rk_FightingIdle.

## Acceptance
- Fight glove-to-chin median within 3 cm of the board's, both gloves, in guard AND between punches; stills via
  still_framing.gd save_if_framed only (both men head to feet, boots on).
- rokoko_clips_test, fight_clip_slice_test, punch_retime_test (red on master for an unrelated reason - Cursor JABRETRACT1;
  do not touch it), guard_pose tests if any: plain and as_game.
- Report: research/ZIVA_GUARD_S274.md - the two tables, the bisect table, the cause line, the fix, the clip path.

## Then (same chat, after the guard lands)
Cut the footwork step library from Rokoko FightingIdle (~70 s between punches). OPERATOR S274: fight motion comes from
Rokoko and ActionForge only (no Meshy; the Ailive hooks were rejected on sight) - the Ailive footwork take IS allowed (operator S274 on its
video: "these animation are not bad", board Q-S273-3 Keep for footwork) - assets/anim/ailive_boxing/ai_boxing_footwork.fbx (9.3 s),
AFMotion role ai_footwork; the Ailive hooks stay out. ActionForge takes may fill gaps (AFMotion roles). step in/out/left/right 0.25-0.45 m, pivot L/R, bounce in place, 2-3 each, guard-to-guard, ROOT
TRACK KEPT. Write a library JSON with per entry {id, move (local x/y metres start->end), turn_deg, length_s, kind} - the
shape Arena's StepPicker (TASK_STEPPICKER1.md) consumes. FOOTWORK_PLAN_S273.md is the plan.

## Prior research
FOOTWORK_PLAN_S273.md, TASK_ZIVARATE1.md (S273 sections), ZIVA_ANIM_REALISM_S272.md, S262 guard IK (ab8e4cdd/a77f28d9).

## What would a human do?
Put the two pictures side by side, then turn layers off one at a time until the picture matches.

## Prefab check
n/a (defect).

## The one trap
Do not re-pose the guard by hand to match the board - a hand-posed guard hides the layer that moves it, and it comes back.

## Contract
OWNS: research/ZIVA_GUARD_S274.md, Godot/tools/fight_studio_render.gd, Godot/tools/anim_orbit_render.gd
RED_TEST: n/a
REGRESSION: rokoko_clips_test
VISUAL: yes
