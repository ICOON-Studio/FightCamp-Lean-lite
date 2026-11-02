# TASK_REFBREAK1 - the referee parts the clinch with his hands ON them, never through them (Antigravity)

Model: gemini-3.8-flash-high (agy). Discipline: boxing (demo). Seat: Antigravity, worktree E:\FightCamp\wt\LEAN_REFBREAK1,
branch agy/refbreak1 (from Lean main 553b541). FILE TOOLS ONLY: read and write files, run NO shell commands - Claude runs
every probe, test and film on your branch and tells you the numbers.

## Why
Gemini 4 Argon judged 30 s of a live round 2/10 (S367). Its worst moment, checked on full-resolution frames: "the
referee's break crouches between them with an arm through Blue's waist". The operator wants the fight watchable; the
referee is on screen exactly when the camera is closest (he shows only to break a clinch).

## What the probe says on main (RED, run by Claude, deterministic - two runs identical)
`tools/ref_break_probe.gd` (the clinch_check.gd harness: a real FightStage, the game's cast with the referee, three
scripted clinch holds and their breaks in 16 s; pose as shown, after the IK):
```
REFBREAK break=1 t=1.23-6.19 frames=150 worst_pen_m=-0.014 part=right hand into=red torso at_t=4.42 through_frames=0 touch_red_m=0.014 touch_blue_m=0.150
REFBREAK break=2 t=6.22-11.19 frames=150 worst_pen_m=0.168 part=right forearm into=red torso at_t=9.59 through_frames=3 touch_red_m=-0.050 touch_blue_m=-0.057
REFBREAK break=3 t=11.22-16.02 frames=145 worst_pen_m=0.164 part=left forearm into=blue torso at_t=14.56 through_frames=7 touch_red_m=-0.096 touch_blue_m=-0.081
REFBREAK_SUMMARY breaks=3 worst_pen_m=0.168 through_frames=10 of 445 worst_touch_m=0.150 FAIL
```
Read it as: in breaks 2 and 3 his forearm goes 16-17 cm into a boxer's torso during the push; in break 1 his push never
reaches Blue (15 cm short). Both are wrong: a referee's hands land ON both chests and push them apart.

## The cause (read scripts/fight3d/Referee.gd first - 370 lines)
- `part()` plays the canned clip `af_push` and `_move()` slides his body to `_spot(IN_M, 0.0)`: 0.45 m off the boxers'
  line, square between them. The clip's arms reach wherever the clip says, aimed at nothing.
- `_keep_clear(KEEP_PUSH_M)` keeps only his ROOT 0.42 m from each boxer's ROOT; it knows nothing about his arms or
  their torsos, so a forearm can still pass through a body.
- `build()` already calls `CornerIK.attach(skel, r.body)` (scripts/fight3d/CornerIK.gd: two-bone arm IK,
  `reach(side, target: Callable | null)`, eases in/out over EASE_S) but throws the handle away - nothing aims his hands.

## The job (Referee.gd only)
1. Keep the CornerIK handle (`r.ik = CornerIK.attach(...)`).
2. During "part": aim each hand at a point ON a boxer's chest - left hand to one boxer, right hand to the other - with
   `ik.reach("Left", <Callable returning the point>)` and `ik.reach("Right", ...)`; release both (`reach(side, null)`)
   when the push ends. The point: on her chest surface facing him (her UpperChest bone, pushed out toward him by about
   her torso's half-depth, ~0.12 m), so the palm rests on the shirt line, not inside it. Read the boxers' skeletons from
   `stage.boxers[i]["skel"]` (Skeleton3D) and their bones by the humanoid names ("UpperChest", "Hips", "Head").
3. Stand where both hands can reach without the forearms crossing a body: pick the push spot from the two chest points
   (out from their midpoint, on his side, far enough that an arm of ~0.6 m reaches each chest with the elbow bent), not
   the fixed IN_M. Keep `_keep_clear` but make it keep his torso clear of theirs during the push.
4. Nothing else changes: not Clinch.gd's timing (CLINCHMERGE is a separate task), not the boxers, not the clips, not the
   camera. The other modes ("watch", "in") keep their behaviour.

## Acceptance (Claude measures every line on your branch; numbers from the run, never from a description)
- `ref_break_probe.gd`: `REFBREAK_SUMMARY ... through_frames=0 ... worst_touch_m <= 0.050 PASS`, 3 breaks - no limb
  deeper than 0.02 m into a body, and in every push a hand within 0.05 m of EACH boxer's torso.
- `tools/clinch_check.gd`: every one of its six lines the same PASS/FAIL as on main (the holds are not your job, but
  you must not make one worse).
- Green: `fight_flow_test clinch_rest_test clinch_beats_test golden_path_test`.
- Film: the probe harness filmed on the hidden desktop before (main) and after (your branch), 1280x720, 30 fps;
  Gemini 4 Argon (Tools/gemini_judge.py) judges both; the after-film must name NO referee clipping at the breaks and
  score at least the before-film. Then the operator's visual OK. Merge only then.

## Deliver
Edit Lean `scripts/fight3d/Referee.gd`, then write `docs/agy/REFBREAK1_result.md`: what you changed and why (by
function), and what you expect each acceptance line to read. Do not paste numbers you did not get from Claude.

## Contract
OWNS: Lean/scripts/fight3d/Referee.gd, Lean/docs/agy/REFBREAK1_result.md
RED_TEST: Lean/tools/ref_break_probe.gd (FAIL on main 553b541: worst_pen_m 0.168, through_frames 10, worst_touch_m 0.150)
REGRESSION: fight_flow_test, clinch_rest_test, clinch_beats_test, golden_path_test, clinch_check (six lines unchanged)
VISUAL: ops/previews/S368/refbreak_before.mp4 vs refbreak_after.mp4 (Argon judges both; the operator judges after)

## Prior research
S313 (Referee.gd header): an amateur referee keeps off the line, steps in on a clinch, calls "Break!" and parts them
with both hands. S322/S323/S348/S359: his spot, the on-screen keep-out, the lens keep, hidden while he only watches -
all in Referee.gd comments; keep them working. S367: ops/research/GEMINI_JUDGE_PILOT_S367.md (Argon's film verdict).

## What would a human do?
A referee steps in close, puts one open hand flat on each boxer's chest (or shoulder) and pushes them apart; his arms
are bent, his body stays outside the pair, and his hands follow their chests as they separate.

## Prefab check
CornerIK (already attached to him) is exactly the two-bone hand IK this needs; no new asset, no new clip.
