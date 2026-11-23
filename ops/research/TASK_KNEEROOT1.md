# TASK KNEEROOT1 - where does the knee cave-in come from when our leg bakes are OFF? + gloves that move on their own (S537)

Status: DONE (collected 07ae5199f; marked S540)

Model: claude-fable-5-2 (Agent SDK, API credit). Discipline: boxing (demo). Standing approval for animation fixes (S510).
METHOD (S510 + owner S537): fight player v2 only; NO new correction layer; "use our research/clips"; before/after films on a
FIXED side camera on the punching boxer, both halves framed the same (memory feedback_before_after_films_s537).

## The owner's notes (review board, 2026-11-22)
- C462/C463 on ops/previews/s537_legs_off/recorded_blue_cross.png (CrossLegs/Stance/Drive `off := true`): "this is so bad why
  you twist the knee so much ? reduce the twist by 95%", "not sure why you twist and bend the knee ... the original clip is
  fine". Marked copies: ops/Feedback/2026-11-22-01/marked.png, -02. The blue boxer is knock-kneed: knees in, feet wide.
- C464 + C466 (s537_fp2pose3 guard still + loop film): "why the gloves doing their own thing ?", "reds gloves move on their
  own". ops/Feedback/2026-11-22-03/marked.png.
- C465: "blue fighter doesnt look like human, fix his pose" (cross contact). ops/Feedback/2026-11-22-04/marked.png.

## Do
1. Ground truth: pose the SOURCE take (the bought clip as imported, no v2 layers) at the same frame on the same fixed side
   camera, and the game's v2 player at that frame. Measure per leg: knee valgus (knee inside the hip-ankle line, cm), knee
   flex, foot yaw, stance width - source vs game. Same for the guard gloves over a 4 s idle: glove drift (cm) source vs game.
2. Bisect: switch the v2 stages after the clip one at a time (retarget / rest-pose correction, MHRig corrections, foot plant /
   FEET / SLIDE / JUMPS, stance width, step wire, guard/arm layers, look-at/gaze, any IK) and find which stage moves the knee
   inside and which moves the gloves. Read the code, cite file:line. Do NOT edit LineGrade.gd, LiveRound.gd, StepWire.gd,
   MHRig.gd (others' uncommitted edits) - if the cause is in one, report it and stop there for that file.
3. Fix at the cause so the game matches the source within 2 cm (knee) and the gloves stay where the clip puts them; prefer
   REMOVING our stage over adding one. Tests in tests/player2_test.gd: a KNEEMATCH and a GLOVEMATCH check red now, green after;
   player2_test, choreographer_test, arm_build_test, file_limits_test, golden_path_test green.
4. Film + stills on the fixed side camera (hidden desktop only), source left / game right, cross + guard idle, both boxers.
   Open the frames yourself and say plainly if the difference shows. ops/previews/s537_kneeroot1/, docs/KNEEROOT1_RESULT.md
   (the cause in one plain sentence first, numbers table, file:line, what was removed).

## Prior research
docs/FP2POSE2_RESULT.md, FP2POSE3_RESULT.md, FP2POSE4_RESULT.md (the leg bakes that made it worse), ops/research/
CROSS_POWER_S439.md, K46_BOXER_FEET_DURING_PUNCHES.md, memory feedback_anim_from_research_clips_s537.

## What would a human do?
Put the raw clip next to the game frame by frame and switch things off until the two match.

## Prefab check
None.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who kneeroot1 -- <command>`, one run at a time, output to files;
windowed only via tools/hidden_desktop.py. Nothing opens on the owner's monitors. No script over 500 lines. `git add -- <new>`
then `git commit -m ... -- <your paths>` with `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>`, pull --no-rebase
--no-edit, push, report in two lines, stop.
