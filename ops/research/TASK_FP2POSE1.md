# TASK FP2POSE1 - fight player v2: the cross that crosses its legs and looks away; the stance that reads weak (owner C454, C458)

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
METHOD (owner S510): fight animation = fight player v2 only (scripts/fight3d/v2); no new fix layer outside it. Owner S510:
"i approve anything that" fixes the animation - no questions, fix and show.

## His notes (review board, marked stills)
- C454 on ops/Feedback/2026-11-21-10/marked.png (body correctives before/after, game camera, blue_cross): "bluse poseis totallly
  wrong , wtf is that legs doing and where the fuck is he looking at". The blue man's cross: the rear leg swings across behind
  the lead (legs scissored), the trunk tips sideways, and his head faces the camera, not his opponent.
- C458 on ops/Feedback/2026-11-21-11/marked.png (arms by Strength, close guard, broadcast): "wtf is this ? legs are weird and
  looks like a weak 12 year old kid wtf ???". The blue woman in guard: knees bent in toward each other, feet narrow, hips back,
  shoulders rounded - a timid stance, not a boxer's.

## Do
1. Find the cause in v2 before changing anything: which take (clip) the blue_cross still plays and at which frame; whether the
   leg cross is in the take itself, the stance refit (S529), the step layer or the facing; whether the head aims at the
   opponent's head (the gaze / look-at) and why not at this frame; for C458 the guard take's knee and foot spacing against
   a real boxing stance (feet ~shoulder width, lead foot toward the opponent, knees over the toes, chin down, hips under the
   shoulders). Write the causes with numbers (foot spacing in cm, knee angle, head-to-target angle) in
   `docs/FP2POSE1_RESULT.md`.
2. Fix inside v2 at the cause (the take's leg retarget, the stance refit, the gaze target) - not a correction layer on top.
   If the body itself reads slight (C458 "weak"), say what part is body shape (BODYTEX2 owns body shape - do not edit its
   files; write what it should change) and what part is pose.
3. Before/after stills of the SAME frames (blue_cross contact, guard close, red_lead_hook) on the game camera via
   `tools/fight3d_still.gd` / still_framing `save_if_framed` on the hidden desktop; open them yourself; post with
   `python ops/Tools/review_add.py --stage S536 --rating "<your read>" --title "Blue cross legs + gaze, guard stance: before / after (your C454, C458)" <files>`.
   The owner closes it, not a test.

## Prior research
ops/research/FIGHTPLAYER2_SCOPE_S510.md; memory: S529 v2 stance refit, S528 Mixamo boxing steps, guard protects the head (S531),
fight camera follows the turn (S530); research/topics/footwork.md (stance).

## What would a human do?
Put the clip on a loop next to a real cross: the rear foot pivots on the ball and the heel turns out, the feet never cross, the
eyes stay on the target. A boxer in guard stands balanced and a little bladed, not knock-kneed.

## Prefab check
Mixamo boxing clips already in his Downloads (S528) - check whether a cleaner cross take exists before re-authoring one.

## Contract
OWNS: scripts/fight3d/v2/ (only the files the cause names), docs/FP2POSE1_RESULT.md, ops/previews/s536_fp2pose/
RED_TEST: a check in tests/player2_test.gd: on the blue cross take the feet never cross the body's midline and the head faces
the opponent within a bound you set from the real reference (red on today's take)
REGRESSION: tests/player2_test.gd tests/choreographer_test.gd tests/arm_build_test.gd
VISUAL: yes - game camera stills, before / after, opened by you

## Rules
Do not touch scripts/fight3d/Gloves.gd or the ring lights (GLOVEFACE1 owns them) nor the body textures (BODYTEX2).
Godot only through `python ops/Tools/godot_slot.py run --who fp2pose1 -- <command>`; windowed renders on the hidden desktop only.
Never stage LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd, tools/export.sh. Stage explicit paths, commit to main with the
Co-Authored-By line, push, report in two lines, stop.
