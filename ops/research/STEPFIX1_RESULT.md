# STEPFIX1 result (S559) - the step pictures already carry the man; the brief's premise does not hold

Worker: console (Opus 5.5). Brief: ops/research/TASK_STEPFIX1.md. Nothing re-rendered, tools/pics2d_anim_more.gd unchanged.

## What the frames show (read, not assumed)
`python tools/step_travel_check.py` (new, reads proto/twohands/img/anim; each man = the middle of his shorts, the stepping
man's front toe = his boot pixel nearest the other man; the hold reference = blue_lead_high at each range):

| run | stepper travels | front toe | other man | last frame v next hold | first frame v previous hold |
|---|---|---|---|---|---|
| blue_step_in_r2 | 69 px | 63 | 0 | 1 | **34** |
| blue_step_in_r1 | 75 | 123 | 0 | 1 | **41** |
| blue_back_off_r3 | 58 | 1 | 0 | 2 | **33** |
| blue_back_off_r2 | 53 | 40 | 1 | 2 | **33** |
| red_step_in_r2 | 62 | 38 | 0 | 2 | **32** |
| red_step_in_r1 | 66 | 45 | 0 | 2 | **35** |
| red_back_off_r3 | 48 | 8 | 0 | 5 | **28** |
| red_back_off_r2 | 39 | 33 | 0 | 5 | **28** |

(A back off moves the rear foot first; the front toe follows at the end, so its toe number is small while the body
travels.) Strip: ops/previews/s559_stepfix.png (Long hold, the 8 frames of blue_step_in_r2, Mid hold; drawn mirrored as
the page draws it; lines = the Long hold spots). Frames 2-7 show a real front-foot step and the body carried in.

So: **the take's hip travel does reach the pictures** (0.355 m = ~66 px; the brief read "the front boot stays within a few
pixels", which matches the OTHER man's boots, 120 px in every frame). The last frame lands on the next range's hold within
5 px. The bar that fails on every run is the FIRST frame: both men stand ~33 px to one side of the previous hold picture.

## Why the first frame jumps
`_solo` (tools/pics2d_anim_more.gd:103-106) aims the camera once, on the run's last pose, and keeps it still. The hold
pictures are framed on the pair's middle, and a range step moves that middle by half a step (~33 px). One man stepping
0.355 m with a still camera can match the hold it ends on OR the hold it starts on, never both: the brief's three bars
(stepper 25-45 px, other man under 5 px, last frame on the next hold) need the stepper to cover half his take's
travel, i.e. feet skating by half. The ways out, each with its cost:
1. Today: camera still, aimed on the end. A 33 px sideways snap of BOTH men as the step starts, then a clean step.
2. Camera follows the pair's middle through the run: no snap, but the man who does not step glides 33 px with planted
   feet on a blank background (reads as sliding - the same complaint).
3. Page side (switch.html, not mine): slide the whole picture by the snap over the step's first 0.1-0.2 s, or keep a
   running offset. Same look as 2.
4. Hold pictures framed on a fixed ring spot instead of the pair's middle: no snap and no glide, but every hold run
   re-rendered (out of this brief) and the pair drifts across the picture over a round.
Recommendation: 4 is the only honest one (nothing snaps, nothing slides); it is a re-render of the holds and the
guard with a fixed camera - fold it into the full re-render with the owner's new camera (pics2d_camera.json) rather
than render twice.

## The likelier cause of what the owner saw
"when i select step-in their feet have no animation and their position does not change": the page draws a step ONLY
when the range changes (switch.html:154-157 - a `range` event is made only when `S.range !== r0`). No picture, no
range change, at all when:
- he steps in at Inside (clamped at 1);
- he steps in and the opponent backs off the same beat (d = 0) - both men's feet moved, nothing is drawn;
- his step in was cancelled by the opponent's landed jab (`kept`, line 147) - the plan showed "step in";
- (and a step to Mid by a push at Inside shows the push, not the step).
Each of these leaves the hold picture unchanged, which is exactly "no animation, position does not change". The fix
is page-side (draw the step when a man's feet move, even when the range does not change: a step in met by a back off
= both runs; a cancelled step = say so in the caption). That is switch.html, outside this brief's OWNS - for Claude.

## Contract
- RED_TEST: `python tools/step_travel_check.py` -> STEP_TRAVEL FAIL on all 8 runs, bar "start" only (travel, other
  man and end all pass on today's frames).
- No render, so anim_check.mjs / page_play_test.mjs are untouched by this work.
- tools/pics2d_camera.json: not present during this work.
