# TASK COACHDEEP2 - deep coaches v2: the owner's 24 answers in the map, departure priced, chemistry sized, probe again (S539)

Model: claude-opus-5-5 (Code Mode tab). Discipline: boxing (demo). Map + greybox probe only: nothing under scripts/ changes.

## Why
Owner S539 "Yes, start v2" after the grilling. ops/research/COACHDEEP_GRILL_S539.md holds his 24 decisions - READ IT FIRST; where
it differs from DESIGN_COACHDEEP1.md, it wins. v1 (01ee138b2): probe PASS 5/5 but bar (a) at its limit (pair-by-chemistry best in
6 of 10), chemistry strength an estimate, a boxer leaving scored as cheap; written before his answers. Critics on v1 are out
(Kalli SQ302, Dola SQ303): when their answers land (ops/research/CRITIC_COACHDEEP1_BRIEF_KALLI.md / _DOLA.md, `python
ops/Tools/seat_queue.py list`), answer every item of their "to reach 10" lists in v2 (done / changed / refused with why).

## Do
1. ops/research/DESIGN_COACHDEEP2.md from v1 + the 24 answers: your evenings (Q19, every rating 8), wages by band (Q17) against
   the class-night trade (Q14: a class ~$350/week, his teaching keeps members), Luke Reid converted (Q18), notice + matching
   (Q20), courses (Q21), ceilings in words (Q22), the learned other corner (Q16, Q23), the five places it shows (Q24). Every CODE
   claim with file:line read today; the menu table; the phase plan (Q7); the cut list.
2. Probe v2 (tools/coachdeep2.gd + rules copy, from tools/coachdeep1*): the 4-boxer TEST CLUB, the same bars as v1 written before
   the run and not loosened, plus: (f) a departure is priced (a boxer leaving costs what the game says: his share of future
   purses / members / reputation - not a guess); (g) chemistry sized so pair-by-chemistry is best in at most 5 of 10 pairs; (h)
   the evening trade is real: in at least a third of the weeks a class is right over a boxer's session, and in at least a third
   the boxer is right; (i) hiring a second coach pays in at least one club size and does not in another (the wage trap that failed
   COACHHIRE1 must not come back: read docs/COACHHIRE1_RESULT.md).
3. docs/COACHDEEP2_RESULT.md. PASS -> ops/research/CRITIC_COACHDEEP2_BRIEF.md (CRITIC_PACK + CRITIC_ACCESS first, never a score;
   DEPTH / PLAY / GENERAL /10; reads the code, the probe and COACHDEEP_GRILL_S539.md; the list to 10 + a drawn 10/10 page via
   tools/render_mockup.py) and queue kalli and dola. FAIL -> what to change, stop.

## Contract
OWNS: ops/research/DESIGN_COACHDEEP2.md, tools/coachdeep2.gd, tools/coachdeep2_rules.gd, docs/COACHDEEP2_RESULT.md,
ops/research/CRITIC_COACHDEEP2_BRIEF.md
RED_TEST: tools/coachdeep2.gd (a probe)
REGRESSION: none (no game file changes)
VISUAL: no

## Rules
Work in main. Godot ONLY via `python ops/Tools/godot_slot.py run --who coachdeep2 -- <godot> --headless --audio-driver Dummy
--path . --script res://tools/coachdeep2.gd -- ...`, one run at a time; long output to E:/FightCamp/tmp/coachdeep2/, wait on its
done line. Read ops/research/GDSCRIPT_TRAPS.md. No script over 500 lines. Commit only your paths, push. When done run
`python ops/Tools/idle_guard.py ok COACHDEEP2-done`, report in two lines, stop.
