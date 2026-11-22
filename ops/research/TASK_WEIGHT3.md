# TASK WEIGHT3 - weight v3: the depth moves to reading the opponent's cut (S537, owner "Yes, move it")

Model: claude-fable-5-2 (Code Mode console in E:\FightCamp\Lean). Discipline: boxing (demo).
Bar (owner S534): 8+ DEPTH and 8+ PLAY from two fresh critics, after the probe. FREE HAND.

## Decision (owner S537 "Yes, move it", on docs/WEIGHT2_PROBE5.md)
Round 5 FAIL: for OUR boxer STAY is best in 10 of 15 cells, UP right for nobody, CUT ties STAY at best. But the field's own
cut has teeth: unread, we win 47 % overall and 40.5 % against the hard cutters; reading the cut exactly is worth +1.11 rungs
(range read +0.92), and the late rounds against them swing (section 7). So:
- OUR side simple: a natural class; draining only when forced (a booking at a class below), at the measured cost; no
  diet/water/up menu.
- THE DEPTH: reading the opponent's cut. The tape's "On the scales" beside his walking weight (scouting / film / the
  Knowledge misread decide how sure the number is); the fight plan's late-round lines (pace, body work, pressure from round 3)
  pay against a drained man and cost against one who did not cut. A wrong read costs (KNOWMISREAD1).

## Do
1. Map `ops/research/DESIGN_WEIGHT3.md` from the code (file:line every CODE claim), the menu table (tape row, scouting, plan
   lines, result page) and what each is wired to.
2. Probe: copy tools/weight2_probe* to weight3_probe*; same field and cut model as round 5; arms = blind / range read / exact /
   WRONG read (believes a cutter who is not, and the reverse) x plan (flat / late push / early push). Bars: the read moves the
   result; no plan best in more than 6 of 10 cells; a wrong read clearly costs; best vs laziest 3+ wins in 100.
   `docs/WEIGHT3_PROBE.md`.
3. PASS -> chat critic `python ops/Tools/design_loop.py critic WEIGHT3 research/DESIGN_WEIGHT3.md --seat kalli` + a code-checked
   brief `ops/research/TASK_WEIGHT3CRIT.md` (do not run it). FAIL -> write which lever broke, stop.

## Prior research
docs/WEIGHT2_PROBE5.md (sections 7-9), DESIGN_WEIGHT2_V2.md, John SQ278/SQ280, docs/KNOWMISREAD1 result, DEPTH_AUDIT_S534.md.

## What would a human do?
A coach sees the other man made 60 kg but walks around at 67, and tells his boxer: "he'll be dry by the third, go to the body
and make him work".

## Prefab check
None.

## Contract
OWNS: ops/research/DESIGN_WEIGHT3.md, tools/weight3_probe.gd, tools/weight3_probe_rules.gd, tools/weight3_probe_sum.py,
docs/WEIGHT3_PROBE.md, ops/research/TASK_WEIGHT3CRIT.md
RED_TEST: tools/weight3_probe.gd (a measurement)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who weight3 -- <command>`; long output to a file, wait on its done
line. `git add -- <new>` then `git commit -m ... -- <your paths>` with `Co-Authored-By: Claude Opus 5.5
<noreply@anthropic.com>`, push, report in two lines, stop.
