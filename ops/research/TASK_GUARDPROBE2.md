# TASK GUARDPROBE2 - where do the punches go, by opponent? (probe before the guard posture choice)

Status: OPEN (S526, Claude main). Discipline: boxing. Model: Goose (cloud) - a probe, no window.
Why: ops/research/GUARDWEAR_WIRE_S524.md bottom (S526). Guard posture (GuardWear.posture_damage: HIGH head x0.80 body
x1.15 + 8% wear; LOW the mirror) is approved (DESIGN_GUARDDMG1_V4 s1) but not wired. Wired today it is a dominant pick
if body punches stay a small share. Measure the share before any posture rule is sized.

## The probe (tools/guard_probe2.gd)
1. Read how a settled bout splits damage between head and body today (LiveRound / the body map / BoutBurn.MIX -
   name the functions you read). Print the rule in one paragraph.
2. 200 seeded bouts per cell: our boxer (a fixed mid fighter, Data.fighter_state) against one shipped opponent of each
   style (the six of StepValue.STYLES; StepValue / tools/treevalue_probe.gd's STYLE_OPP lists them), amateur 3x3 and pro
   6x3. Print per cell: share of OUR damage taken to the body, to the head; the share of HER landed punches that were
   body punches; the same with her habit digs_body_when_hurt forced on (RoundStyle.opponent_habits) as a second arm.
3. Then the posture what-if, probe-side only (never edit scripts/): apply GuardWear.posture_damage to the through-the-
   guard leak (GuardState.wear_through's result split head / body by the measured share) and the +8% wear for HIGH, and
   print per cell which posture (HIGH / NEUTRAL / LOW) leaves our boxer with the least total damage, and by how much in %.

## Contract
OWNS: tools/guard_probe2.gd, docs/GUARDPROBE2_RESULT.md
RED_TEST: tools/guard_probe2.gd -> GUARDPROBE2 done
REGRESSION: guard_state_test, guard_wear_test, guard_notes_test (read-only: run them, never edit them)
VISUAL: no
NOT YOURS: every file in scripts/ and tests/. The result page is WRITTEN BY THE PROBE. PR body: `RESULT:
tools/guard_probe2.gd -> body_share=<min..max over cells> best_posture=<HIGH n / NEUTRAL n / LOW n of cells>`. Each file
under 500 lines. Pilot first, print the projected minutes; stop at 90 minutes of run time.

## Prior research
`python ops/Tools/prior_research.py guard posture body share` -> DESIGN_GUARDDMG1_V4.md s1, GUARDWEAR_WIRE_S524.md,
docs/GUARDPROBE1_RESULT.md, tools/guard_onoff.gd (the S525 on/off harness - copy its bout setup).

## What would a human do?
A coach raises the guard against a head hunter and drops the elbows against a body puncher. Before offering that choice,
check the opponents in this game actually differ in where they punch.

## Prefab check
None: reuse tools/guard_onoff.gd's harness.

## The one trap
Damage taken "to the body" may be counted in more than one place (m["damage"] and a body map): read which one the
stoppage and the result page use, and report that one.
