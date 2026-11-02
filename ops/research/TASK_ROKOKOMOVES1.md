# TASK ROKOKOMOVES1 - one actor in the fight: the guard as long captured takes + every move Rokoko has, cut and in

Model: Ziva (Godot editor seat, wt/ZIVA, effort MAX). Discipline: BOXING (demo). Runs AFTER ZIVAGUARD1's report (same chat).

## Why (operator S274, after the same-seed A/B and the ActionForge read: "the movement in the fight is not natural like in
## actionforge" -> "fix !!!")
Measured on the 20 s fighters-only fight (tools/fight_studio_render.gd as_game seed=94301 bodies=09,04 clip_log=1): each man
switches clip ~31 times in 20 s (every ~0.6 s) and only ~45 % of what he plays is the Rokoko actor (guard, jab, cross); the
rest is old in-place loc_ walk clips, Mixamo catch / rear hook / body cross, the hand-authored lead hook. ActionForge plays
one actor's continuous take - that is the look he wants. Claude already did: clips_only_base (the re-bending room layers
off), captured punches play to their full length (no early hand-back), the punch clock fix.

## Part A - the guard is long captured takes that crossfade, never a 2 s loop
Today `FightClipRokoko.ROLES.idle` = FightingIdle 40.867-42.867 (2.0 s, seam 2.8 deg). Claude measured (S274): the take is
in a boxer's guard over ~8-20 s and ~36-44 s (both fists 0.35-0.46 m from the head, stance 0.50-0.58 m) but the actor moves
so much (38 deg in 0.5 s) that no 9-12 s window loops cleanly (best seams 42-55 deg). Build the guard the way fight games do:
2-4 long guard windows (8-12 s each, cut where the fists stay at the chin) as `_variants` of the idle role that are NOT
looped - each ends by crossfading (0.3 s) into the next variant; the player resumes a guard where it left off after a punch
(position + time away), so the actor's rhythm carries on under the punches.
Acceptance: rokoko_clips_test green plain + as_game with a new check "guard never restarts within 3 s of a punch" (read
the guard's take position on re-entry) and "no guard frame with a fist > 0.50 m off the head"; the 20 s render beside the
board's rk_FightingIdle.

## Part B - every other move from the Rokoko takes
FIRST (S274, operator on the before/after video: "0:14-0:18 it shows that it transition to other animation is far from
smooth"; measured by the fight session, s274_committed clip_log seed 94301 bodies 09,04): blue's Mixamo boxing_cross_body
13.7-14.9 s (pelvis 0.77-0.92 m, feet 0.21 -> 0.83 m) cuts straight into the Rokoko jab at 15.0 s (feet 0.18 m, upright) - two
actors joined in ~0.3 s; at 16.3 s the native boxing_lead_hook stands 0.944 m pelvis vs the Rokoko guard's 0.90 and pops.
So the first rows replaced are: boxing_cross_body (S272 label: ShadowBoxing ~11.80 s = rear straight to the body), then
boxing_lead_hook and boxing_rear_hook (look for hooks inside the Rokoko combos; none clean was found in S272 - if none passes
the gates, report it and keep the current clip). Show the 14-18 s window of the 20 s render before/after.
Takes on disk: assets/anim/rokoko_combat/{Boxing, ShadowBoxing, FightingIdle, KnockOut_Loser, KnockOut_Winner}_mixamo.fbx,
labels in punch_labels.json (S272: 5 of 10 cuts are combos; Shadow 19.50 loads a rear uppercut; 11.80 = rear straight to the
body). Find, cut guard-to-guard (tools/rokoko_path_probe.gd, its afcut= mode works on Rokoko takes too: rk.<Take>), and wire
as FightClipRokoko rows: body jab / body cross, the combos as ONE clip each (one_two, jab-cross-hook if a clean one exists),
slips / rolls / blocks / catch from the takes' defensive moments, the knockdown and the winner's reaction. Every row: the
rokoko_clips_test gates (guard in/out, fist ahead at contact, stance <= 0.80 m, hips drop <= 0.10 m) and a 20 s fight.
Operator rule S274: motion from Rokoko + ActionForge (no Meshy); Ailive only for footwork and the duck/sway (operator on their
videos: "these animation are not bad", Q-S273-3) - the Ailive hooks/uppercuts stay out (rejected on sight). An Ailive take
stands wide and low (1.0-1.1 m, hips 23 cm under our guard): cut with FightClipRokoko "legs": "idle" if its legs fail the
stance gate. Moves Rokoko does not have stay on their
current clip and are listed in the report.

## Owned files
Godot/scripts/FightClipRokoko.gd, Godot/scripts/FightStagePlayer.gd (idle variants / resume only - sed -n windows, 6,0xx
lines), Godot/tests/rokoko_clips_test.gd, research/ZIVA_ROKOKOMOVES_S274.md.

## Parse gate and tests
`python Godot/tools/check_scripts.py <touched .gd>`; rokoko_clips_test, mocap_pure_test, punch_retime_test,
fight_clip_slice_test plain AND `-- as_game`. Renders with --quit-after (a render without it hung 1h45, S274).

## Prior research
FOOTWORK_PLAN_S273.md, ANIM_TOOLKIT_S274.md, MOVE_SOURCES_S272.md, TASK_ZIVARATE1.md, ACTIONFORGE_HOWTO_S247.md.

## What would a human do?
A fight-game animator cuts every usable move out of the session's takes, keeps the actor's idle long and blends between
idle takes instead of looping a short one.

## Prefab check
n/a - our own takes.

## The one trap
Never hand-pose or stretch a take to fill a missing move - a move Rokoko does not have stays on its old clip and goes in the
report.

## Contract
OWNS: Godot/scripts/FightClipRokoko.gd, Godot/tests/rokoko_clips_test.gd, research/ZIVA_ROKOKOMOVES_S274.md
RED_TEST: Godot/tests/rokoko_clips_test.gd -> ROKOKO_CLIPS PASS
REGRESSION: rokoko_clips_test
VISUAL: yes
