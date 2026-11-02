# TASK ANGLE1 - why the `angle_guard` switch changes nothing (engine investigation + fix) - cloud Qwen

Model: Qwen (cloud-agent workflow, label `qwen`). Branch qwen/issue-<n> (the workflow makes it). Never open a window.

## Owned files
- `Godot/scripts/FightRealtime.gd` (8,390 lines - NEVER read whole; windows: `sed -n 1265,1280p` (option), `sed -n 1620,1632p` (state),
  `sed -n 4290,4312p` (_c228_circle_outside call in footwork), `sed -n 4440,4455p` (position history), `sed -n 4555,4600p` (the C228
  angle/guard census writer), `sed -n 5200,5225p` (the third use); `grep -n "_c228_\|C228_" Godot/scripts/FightRealtime.gd` for the rest)
- `Godot/tests/switch_gate_angle_guard_test.gd` (restore it from branch `qwen/g158b` commit dc72d792 - it is the FIXED test; do not
  weaken it)
- `research/ANGLE1_FINDINGS.md` (NEW)

## Prior research
- `research/G158B_FINDINGS.md` (read first): with the test fixed, both arms measure the same metric - angle-attack LANDED share
  (landed punches thrown from >= 20 deg off the line or outside the lead foot / all landed) - and read ON 0.097 (78/801) vs OFF 0.097
  (80/827). The switch has no effect.
- `research/TASK_C228_ANGLES_GUARD.md` + `research/C228_DIGEST.md`: what angle_guard was built to do (step to the outside
  angle before attacking; guard choice by angle) and the census it was tuned on.
- `research/G158_DIGEST.md` row `angle_guard`: the metric and population (12 seeds x 2 DIFFERENT boxers - never identical fighters).

## What would a human do?
Instrument before changing anything: count, per arm, how often `_c228_circle_outside` is CALLED, how often it CHANGES the direction, and
how often a punch is thrown right after an outside step. One of those three is zero or tiny - that is the bug.

## Spec
1. Instrument (temporary counters in state, printed by a throwaway probe in `Godot/tools/angle1_probe.gd`, NOT committed to the test):
   calls / direction changes / attacks within 0.5 s of an outside step, ON vs OFF, same 12 seeds x 2 boxers as the test.
2. Write `ANGLE1_FINDINGS.md`: the three counts per arm, the cause in one paragraph with file:line.
3. Fix the cause in FightRealtime.gd so the switch does what C228 says. The fix must leave the OFF arm BYTE-IDENTICAL (same log for the
   same seed with angle_guard false - check it with the existing determinism tripwire test if one exists, else print and diff a log hash).
4. If the honest answer is that the mechanism cannot raise the landed share (e.g. the angled punches land no more often), say so with the
   numbers and do NOT force the test green - leave it red and recommend retiring the switch.

## Done = (tier: script edited - parse + focused test + the related run)
`python3 Godot/tools/check_scripts.py Godot/scripts/FightRealtime.gd Godot/tests/switch_gate_angle_guard_test.gd`;
`$GODOT --headless --path Godot --script tests/switch_gate_angle_guard_test.gd` -> PASS with the switch ON and FAIL with
`G158_MUTANT=angle_guard`; `python3 Godot/tools/run_tests.py --only fight_ring_position --jobs 2` and `--only footwork --jobs 2` -> 0 fails
(note any test that needs LFS models and could not run in the cloud - say so, do not count it as passed). Report: the counts, the cause,
the fix, ON/OFF shares after, the mutant result, and the OFF-arm byte-identity check.

## The one trap
The metric is LANDED share, not thrown share - a fix that makes him step outside more but land no more from there is not a fix.
