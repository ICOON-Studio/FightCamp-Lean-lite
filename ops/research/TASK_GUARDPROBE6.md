# TASK GUARDPROBE6 - probe guard v6 (Hands High / Normal / Loose before settle) on a greybox (DEPTH_SCOPE_S534 change 2)

Model: claude-fable-5-2 console in this checkout. MEASUREMENT ONLY: tools/ and docs/, nothing under scripts/.

## Why
Guard map v6 (DESIGN_GUARDDMG1_V6.md) puts covering into the exchange edge before settle. Arena's code-checked critic gave
6/7/5 ("a depth claim that rests on unmeasured numbers ... is a hope"); Kalli and John pending. Owner S534: critics must give
8+ on depth and fun, and the probe comes first. The tie-up guard defect Arena found is FIXED on main (GuardState.after).

## Do
Build the probe v6 section 5 and Kalli's point 10 describe, as a flagged local rule in a tool (the Hands edge added to the
exchange edge sum before settle; the v6 sizes as the starting ESTIMATE): four opponent types (light presser, heavy presser,
counter-puncher, volume) x amateur 3 rounds and pro 4 / 6 rounds, today's rules as the control. Bars: no Hands setting best
against all four; each setting best against at least one; High against a tiring heavy presser beats Normal by 5+ wins in
100; High against a fresh heavy presser loses by 5+. Re-size once if it fails. Reuse tools/guard*_probe*.gd where you can.

## Deliverable
`docs/GUARDPROBE6_RESULT.md`: the table, PASS / FAIL per bar, the sizes to build.

## Contract
OWNS: tools/guardprobe6.gd, docs/GUARDPROBE6_RESULT.md
RED_TEST: none (measurement). REGRESSION: none. VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who guardprobe6 -- <command>`. Other sessions have uncommitted edits
(LineGrade.gd, LiveRound.gd, StepWire.gd) - read them, never stage them. Commit to main, push, report in two lines, stop.
