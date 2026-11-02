# TASK NOREF1 - QWEN - no referee in the ring: a clinch ends with both boxers pushing each other off slowly

Status: OPEN (S370, Claude). Seat: Qwen (qwen3-coder) via ops/Tools/seat_dispatch.py.
Discipline: boxing (the demo).

## Why
Operator S369, watching Tess vs Amy live: "remove ref and make them recover their positions pushing slowly each other".
Five agent rounds (REFBREAK1, branch agy/refbreak1 - reference only, never merge) could not make the referee's break look
right (Argon 2/10: his arm through a boxer's waist, phantom pushes). The referee leaves the ring; the boxers part themselves.

## Read first
- scripts/fight3d/Clinch.gd: start() / release() / floor_m() / LET_GO (the gap eases back to range) - and how CornerIK
  (`ik.reach(side, target)`, `ik.look`, `ik.upright`) puts a hand on the other's body.
- scripts/fight3d/BeatFire.gd:42-46: a "step_out" beat with "ref" calls `stage.clinch.release()` (the break).
- tools/ref_break_probe.gd + tools/clinch_check.gd: the headless harness (a real FightStage, three scripted clinch holds and
  their breaks in ~15 s, a pose tap AS SHOWN). Your probe copies its harness; do not edit either file.
- On agy/refbreak1 (reference): 08513c5 Clinch BREAK_HOLD_S - they keep the tie's arms 0.35 s after the break, then let go.

## The job
1. scripts/fight3d/FightCast.gd:46 and scripts/fight3d/TapeFilm.gd:81: no `Referee.build(stage)` - the ring has two
   boxers and nobody else (stage.referee stays null; every caller already checks for null). Leave Referee.gd on disk.
2. NEW scripts/fight3d/PushOff.gd (RefCounted, under 150 lines; Clinch.gd is 478 lines, so the push lives here):
   `static func begin(stage: Node3D) -> void` and `static func step(stage: Node3D, delta: float) -> bool` (true while it
   runs). The break, in three parts, about PUSH_S = 1.2 s in all:
   a. HANDS (0 - 0.3 s): each boxer puts both gloves on the other's chest/shoulders (CornerIK reach to the other's
      Spine2/chest), still at the tie's gap - the arms bend, the heads come up (`ik.upright`).
   b. PUSH (0.3 - 0.9 s): both straighten the arms and step back, one slow step each (stage.step(i, -1), the feet
      planted by FootPlant - no glide); the gap eases from the tie's gap to range with a smoothstep, never a snap.
   c. GUARD (0.9 - 1.2 s): the hands come off (`reach(side, null)`), guard up (`stage.guard(i)`), range as before.
   Clinch.release() calls PushOff.begin(stage) instead of letting go at once; Clinch._process calls PushOff.step while it
   runs (keep Clinch.gd under 500 lines - move code OUT of it if you need room).
3. scripts/fight3d/BeatFire.gd:42-46: the "ref" step_out beat now means "they push off": both boxers get the step out
   (the push), not only `who`; rename the comment ("S370: no referee - they push each other off").
4. scripts/rules/MoveWords.gd:14,37,40,41: the words lose the referee: "Tied up: make the space or push off.", "Wrap the
   arms and smother the punches until you both push off.", break = "Both push off, one slow step back to long range.",
   push_off = "Push off first: make the space on your terms." (Knockdowns / stoppage words keep their referee - he still
   stops fights off camera; only the ring figure goes.)
5. NEW tools/push_off_probe.gd (copy the harness of tools/ref_break_probe.gd): per break, print one PUSHOFF line, then
   PUSHOFF_SUMMARY with PASS/FAIL; fewer than 3 breaks = VOID (exit 1). The bars (never loosen one):
   - ref = 0: no node named like a referee in the stage, stage.referee == null;
   - hands: in part a each boxer has a glove within 0.06 m of the other's torso (the push touches);
   - through: no glove/forearm deeper than 0.04 m into the other's torso or head (capsules as ref_break_probe);
   - slow: the hip-to-hip gap goes from the tie's gap to within 0.05 m of range in 0.7 - 1.6 s (never under 0.7 = a snap);
   - glide: each planted foot slides < 0.03 m (FootPlant holds it).
6. Add tests/clinch_rest_test.gd's expectations only if they named the referee (read it; keep it green either way).

## Acceptance (Claude measures on your branch; numbers from the run, never from a description)
- tools/push_off_probe.gd: PUSHOFF_SUMMARY ... PASS (3+ breaks).
- clinch_rest_test, clinch_beats_test, fight_flow_test, golden_path_test, inside_exits_test green.
- Argon judges the before/after films (the break: two boxers pushing off slowly, nobody else in the ring); the operator
  judges after.

## Deliver
Commit on your branch only the OWNS files; the dispatcher runs the tests, films and opens the PR. Write
docs/qwen/NOREF1_result.md: what you changed, per numbered point, and the PUSHOFF lines.

## Contract
OWNS: scripts/fight3d/PushOff.gd, scripts/fight3d/Clinch.gd, scripts/fight3d/FightCast.gd:40-50, scripts/fight3d/TapeFilm.gd:75-85, scripts/fight3d/BeatFire.gd:40-48, scripts/rules/MoveWords.gd:10-45, tools/push_off_probe.gd, docs/qwen/NOREF1_result.md
RED_TEST: tools/push_off_probe.gd -> PUSHOFF_SUMMARY
REGRESSION: clinch_rest_test, clinch_beats_test, fight_flow_test, golden_path_test, inside_exits_test
VISUAL: yes
FILM: --resolution 1280x720 --script res://tools/clinch_check.gd

## Prior research
ops/research/S369_DIGEST.md (REFBREAK1 superseded), memory project_fight_feedback_s369, real-fight numbers in
scripts/rules/InsideExits.gd:13-15 (John J_INSIDE3: a tie-up ends with a step back 84 %, push-off on your own).

## What would a human do?
In pro boxing without a break call, two tired fighters in a tie-up each put a glove on the other's chest and shove off,
taking one or two steps back to range - slow, heavy, deliberate.

## Prefab check
No engine node does a two-person push; CornerIK + FootPlant + stage.step already exist - compose them.
