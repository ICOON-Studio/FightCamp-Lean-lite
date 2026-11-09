# TASK HEADAIM2 - QWEN (qwen3-coder) - a blocked or slipped head punch is still thrown at the head

Status: OPEN (S417, Claude main). Discipline: boxing. Model: qwen3-coder. Standing animation item (operator S401).
Source: the operator, on a jab in the Moves preview: "this punch does not aim for the head". In his picture the fist meets the partner's raised gloves at about shoulder height.

## Contract
OWNS: scripts/fight3d/PunchReach.gd, scripts/fight3d/FightStage.gd, scripts/fight3d/BeatFire.gd, scripts/fight3d/MoveStudio.gd, scripts/fight3d/MovePlayer.gd, tests/head_aim_test.gd, tools/head_aim_shown_probe.gd, docs/HEADAIM2_RESULT.md
RED_TEST: tests/head_aim_test.gd -> HEAD_AIM failures=0
REGRESSION: beat_clips_test, short_punch_test, golden_path_test
VISUAL: yes

## What Claude already found (S417, read from the code; do not re-derive)
1. A LANDED punch is already aimed. `FightStage.land()` (scripts/fight3d/FightStage.gd line 123) arms `PunchReach.arm()` with `target_point(other, body)`, and PunchReach carries the glove front onto the face around contact. The fight (BeatFire._punch, the `stage.land` call near line 187) and the Moves preview (MovePlayer.gd line 468) both use it.
2. A BLOCKED, SLIPPED or MISSED punch is never armed (PunchReach.gd header: "Blocked and missed punches are never armed"). It plays the bought clip as it is. HEADAIM1 measured those raw clips: pro_left_jab ends 0.061 of body height under the chin against a boxer of the SAME height, and lower against a taller one.
3. That is his picture. In the Moves preview the partner defends every jab (`MoveStudio.defends(kind)` returns true for "jab"; MovePlayer.gd line 461-464 calls `MoveStudio.defend` and never `stage.land`). So the jab he watched was the raw clip, at shoulder height.
4. HEADAIM1's "different height" pair was mh_boxer_10 (a woman, 162 cm) against mh_boxer_01 (a man, 183 cm). Women never fight men in this game. Heights are in scripts/rules/Faces.gd (`CM` women, `MEN_CM` men). Use women only here.

## Prior research
docs/HEADAIM1_RESULT.md and tools/head_aim_probe.gd (the raw clips). ops/research/S320_DIGEST.md and S321_DIGEST.md (tools/hit_gap_probe.gd: how the landed reach was measured and fixed). scripts/fight3d/PunchReach.gd whole (230 lines). ops/research/GDSCRIPT_TRAPS.md.

## What would a human do?
A boxer throws the jab at the other's face whether or not it lands. Blocked, it stops on the gloves in front of the face. Slipped, it passes through where the head was. It never drops to the shoulder. So: fit the HEIGHT of an un-landed head punch to the target's face, and leave its depth and its sideways line as the clip threw them.

## Prefab check
PunchReach already has the two-bone solve, the weight window (IN_S, HOLD_S, OUT_S), the fade when a clip is cut (FADE_S) and the chest lean. Reuse all of it. No new solver.

## The job
1. PunchReach: a height-only mode. Same `arm` path with one more flag (or a small `aim()` beside it). In `_reach`, in height-only mode, the wanted glove-front point is the clip's own glove front this frame with only its up component replaced by the target's, and the target height is LATCHED when the punch is armed (a slipping head ducks; the fist must go where the head was, not chase it down). Depth and sideways are not touched: a blocked glove must not be carried onto the face.
2. FightStage: `aim(who, clip, at_s, contact_s)` beside `land()`: arms the height-only mode at `target_point(1 - who, false)`. No lunge, no step-in, no `land_f` (those belong to a landed punch).
3. BeatFire._punch: every head punch that does not land (blocked, slipped, pulled, weaved, missed) calls `stage.aim`. Body punches (body_hook, any clip containing "kidney" or "body") are never aimed here.
4. Moves preview: the defended jab calls it too. MovePlayer.gd is 664 lines, already over the 500-line rule: it must not grow. Change only the `MoveStudio.defend(...)` call line there and do the work inside MoveStudio.gd (199 lines).
5. The control arm: user argument `noaim` switches the new aim off everywhere (like `nosettle` in PunchReach). On by default.

## tests/head_aim_test.gd (write it FIRST; it must be RED on main and you paste that red run in the PR body)
Headless, `Engine.max_fps = 30`. A FightStage with two WOMEN: A = mh_boxer_10 (162 cm), B = mh_boxer_12 (178 cm). Three setups: A punches B (up), B punches A (down), A punches A (level). Print each height in cm from Faces.CM and in metres from the skeleton.
For jab, cross, lead_hook, rear_hook (the plain take BeatClips.punch picks with an empty context), un-landed (`stage.play` then `stage.aim`), with the target standing in guard:
- read `stage.glove_front(who, hand)` and the face point (`stage.target_point(other, false)` taken at the moment of arming) on the contact frame and the two frames each side, AFTER the skeleton's modifiers have run that frame (the Gloves node follows the shown skeleton; read it the way MovePlayer._measure_reach does, one frame later than the animation position, and say in a comment which frame you read);
- HEIGHT bar: the smallest of those five |glove front height - face point height| is at most 0.06 m, in all three setups;
- DEPTH control: the flat (horizontal) distance from glove front to face point at contact differs from the `noaim` run by at most 0.03 m. The aim moves height only.
- LANDED control: the same four punches through `stage.land` read the same glove-to-target distance with and without `noaim`, within 0.01 m. Landed punches must not change.
- INSTRUMENT check: with `noaim` the HEIGHT bar must FAIL for the jab in the "A punches B" setup (print the number, expect about 0.25 m or more). If it passes there, your ruler is broken: stop and report.
- SMOOTH check: over the whole clip, the largest one-frame jump of the punching wrist with the aim on is at most the `noaim` run's largest jump plus 0.03 m.
Run the `noaim` arm as a second process (user args are read once at load). Print one line per punch and setup: `AIM <setup> <clip> dy=<m> flat=<m> noaim_dy=<m> jump=<m>`. End with `HEAD_AIM failures=N`.

## tools/head_aim_shown_probe.gd and docs/HEADAIM2_RESULT.md
The same read for EVERY head punch clip that plays (HEADAIM1's 36), three setups, aim on and `noaim`: one table row each, metres. Then one paragraph of numbers only: how many are within 0.06 m with the aim on, how many were with `noaim`, the worst clip and its number. If a clip cannot reach the bar (the arm runs out: an uppercut thrown up at a taller boxer), say which and by how much. Do NOT loosen the bar and do NOT add an ease, an offset or a tolerance inside the read to pass it.

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who qwen -- <godot.exe> --headless --audio-driver Dummy --path . --script <script>` (never the console build). No file over 500 lines. No images: Claude films it and judges the look, then the operator. Plain `--script` tests are the control arm for other features; this one ships on.
No fixed he or she in any text you write: "the boxer", "the target", a name.

## The one trap
The target height must be latched at arming. If you read `target_point` every frame, the fist follows a slipping head down and the test (target standing in guard) will not catch it. Add one case that does: play the slip on the target after arming and check the latched height did not move by more than 0.01 m.

## Result lines (PR body)
RESULT: tests/head_aim_test.gd -> HEAD_AIM failures=0
RESULT: tests/beat_clips_test.gd -> BEATCLIPS failures=0
RESULT: tests/short_punch_test.gd -> SHORT_PUNCH failures=0
RESULT: tests/golden_path_test.gd -> GOLDEN_PATH failures=0
