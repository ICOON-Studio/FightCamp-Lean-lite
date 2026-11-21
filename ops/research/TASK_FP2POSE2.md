# TASK FP2POSE2 - fight player v2: the cross's legs (owner C454 "wtf is that legs doing"), round 2 after FP2POSE1

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
METHOD (owner S510): fight player v2 only; no new correction layer. Owner S510: "i approve anything that" fixes the animation.

## Where FP2POSE1 left it (docs/FP2POSE1_RESULT.md, 905a7465c + 92df2ae12)
Gaze fixed (blue cross head 86 -> 9 deg off the opponent). NOT fixed, and the part of C454 that still shows in its own after
still (ops/previews/s536_fp2pose/1_blue_cross_contact.jpg): on the cross the feet stay close and near-crossed, and the rear
heel never lifts or turns - "flat rear foot on all 8 cross takes (needs a re-bake item + film)"; the guard's foot width
varies 23-51 cm from the foot pins; the Mixamo cross takes in his Downloads (S528) were never measured.

## Do
1. Measure all 8 cross takes in v2 (and the Mixamo cross takes as candidates): foot spacing at guard and at contact (cm),
   rear heel height and rear foot yaw at contact, the feet's crossing of the stance line. Reference (state the source): a
   real cross keeps the feet about shoulder width, the rear heel lifts and the rear foot turns in ("squash the bug"), the
   feet never cross. Write it in `docs/FP2POSE2_RESULT.md` before changing anything.
2. Fix at the cause, inside v2: re-bake / re-pick the cross takes (the bake pipeline the takes came from), or the foot pins
   that set the guard width - whichever the numbers point at. If a Mixamo take is cleaner, use it (same licence rules).
3. Film it: before/after of the blue cross and a guard-to-cross-to-guard loop on the game camera, still_framing
   save_if_framed, hidden desktop; open them yourself; post with
   `python ops/Tools/review_add.py --stage S536 --rating "<your read>" --title "Cross legs: rear heel and foot spacing (your C454)" <files>`.
   The owner closes it, not a test.

## Contract
OWNS: scripts/fight3d/v2/ (only what the cause names), the cross take files the fix re-bakes, docs/FP2POSE2_RESULT.md,
ops/previews/s536_fp2pose2/
RED_TEST: a check in tests/player2_test.gd - at cross contact the rear heel is lifted and the feet do not cross the stance
line (red on today's takes)
REGRESSION: tests/player2_test.gd tests/choreographer_test.gd tests/arm_build_test.gd tests/file_limits_test.gd
VISUAL: yes

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who fp2pose2 -- <command>`, ONE run at a time; if the queue is RED for
memory, wait. No script over 500 lines (Player2.gd is AT 500 - move code out, never in). Commit ONLY your paths:
`git add -- <new>` then `git commit -m "..." -- <paths>`. Never stage LineGrade.gd, LiveRound.gd, StepWire.gd, MHRig.gd,
tools/export.sh. Co-Authored-By line, push, report in two lines, stop.
