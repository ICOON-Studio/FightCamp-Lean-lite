# TASK WALK1 - CURSOR (GPT-5.6 Sol High) - the shown stance is not the planned stance: find the layer that squashes it

Status: OPEN (S399, Claude main) - PRIORITY, ahead of the fighter model. Operator S399: "why do you even care for such
detail when you cant even make walking look normal". Discipline: boxing. Runs AFTER SOUTHPAW2 (same files).

## Contract
OWNS: scripts/fight3d/BoxerFootwork.gd, scripts/fight3d/BoxerFootworkRig.gd, scripts/fight3d/FootPlant.gd, scripts/fight3d/RingFeet.gd, scripts/fight3d/KneeTrack.gd, tools/stance_probe.gd, tests/stance_shown_test.gd
RED_TEST: tests/stance_shown_test.gd -> STANCE_SHOWN failures=0
REGRESSION: ring_feet_test, foot_plant_test, boxer_footwork_test, knee_track_test, fight_polish_test, corner_warm_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/footwork_film.gd -- out=E:/FightCamp/tmp/walk1 seg=side,standoff

## What is measured (S399, main)
- PLAN (BoxerFootwork.gd:46-57): STANCE_LEN 0.50 m ball to ball along the fight line, STANCE_WID 0.32 across it, rear heel
  1.6-4.8 cm over the bounce, a stepping foot lifts 4.5 cm (flat-footed 2.5).
- SHOWN (tests/southpaw_legs_test from PR #74, run on main, Maria orthodox at rest): length 0.275, width 0.373 -> she stands
  SQUARE (wider than long), not bladed. Real boxing stance: longer than wide, about 0.30-0.36 x height long and
  0.12-0.18 x height wide (1.75 m: 0.53-0.63 by 0.21-0.32) - the plan's numbers are right, the screen is not.
- Film (E:/FightCamp/tmp/walk_s399/side.mp4, footwork_film side): both heels flat, the feet barely leave the canvas on the
  forward steps (0:04.2-0:05.4 burst), the body glides; knees fall inward (SOUTHPAW2 measures that one).

## Do
1. tools/stance_probe.gd + tests/stance_shown_test.gd FIRST (headless, the fight's boxer on FightStage as ring_feet_test
   builds it, stage processing, fixed clock). Per frame, from the pose AS SHOWN (global bones after every modifier): ball to
   ball length along her facing and width across it, rear and lead heel height over the ball, the stepping foot's peak
   lift per step. Print the same numbers for the PLAN (BoxerFootwork's targets) beside them. Bars (all must FAIL on main):
   - shown length within 10 % of the planned length x her scale, shown width within 10 % of the planned width x scale;
   - rear heel shown within HEEL_REAR (+-0.5 cm) over the bounce; never flat (< 0.8 cm) while bouncing;
   - a stepping foot's peak lift >= 60 % of LIFT_M (flat-footed: of FLAT_LIFT_M);
   - a planted ball moves < 1 cm while planted (no skate).
2. Then switch layers off one at a time in the probe (FootPlant, BoxerFootworkRig, KneeTrack, RingFeet, the guard clip's own
   leg keys) and print which one turns the planned 0.50 into the shown 0.275. Write that table in the PR body. Fix the cause
   there, inside OWNS (one writer per foot bone: if two layers write the same foot, one of them stops).
3. Every REGRESSION green; if SOUTHPAW2 merged, run its tests/guard_valgus_test.gd too. Start every Godot run
   through `python ops/Tools/godot_slot.py run --who cursor -- <godot cmd>`. Do not loosen a bar, do not drop samples.

## Result lines (PR body)
RESULT: STANCE_SHOWN main <n> failures -> after failures=0
RESULT: shown length/width main <l>/<w> -> after <l>/<w> (plan <l>/<w> x scale)
RESULT: rear heel main <min-max> -> after <min-max>; step lift main <x> -> after <x>; skate main <x> -> after <x>
RESULT: squashed by <file:line> (the layer table)
RESULT: regression <pass/fail per test>

## What would a human do?
Stand side-on in a boxing stance: lead foot forward, rear foot back and out, rear heel up; step by lifting the foot, not by
sliding the body.
