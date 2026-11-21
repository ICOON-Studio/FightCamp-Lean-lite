# TASK DEPTHPRICE1A - price the four solved fight-night choices, on a greybox (DEPTH_SCOPE_S534 change 1)

Model: claude-fable-5-2 console in this checkout. MEASUREMENT ONLY: tools/ and docs/, nothing under scripts/.

## The four one-answer rows (DEPTH_AUDIT_S534 part 1, with their measurements)
- 27 Round pace Push / Steady / Save (PaceAim.PACE_EDGE, PACE_SPEND): "Push while wind > 45" best in 14 of 19 cells (PUSHPROBE2).
- 30 Corner minute recover points: "always ice the whole minute" best in 14 of 19 and 17 of 20 cells (PUSHPROBE2).
- 21 Fight-week load Rest up / Tick over / Train through (FightWeek.STOP_TANK): one answer at design stage.
- 22 Sparring partner (PartnerMatch.EDGE): the closest match always (+3.7 / +5.3 wins in 100); the favour barely exists.

## Do
For each row propose ONE price in something scarce the game already has - read the code first, use existing numbers. The
audit's examples: ice takes the seconds the talk needs; Push spends wind that round 3 needs against a fresh opponent; Train
through spends the tiredness Peak Camp needs; the closest partner costs the favour or money a cheaper partner does not.
Measure it on a greybox: extend the existing probes (tools/push_probe*.gd, the fight-week and partner probes; read
docs/PUSHPROBE2_RESULT.md and the others first) with the price as a flagged local rule; arms = today (control) and priced.
Bars: the choice moves the result 3+ wins in 100 between best and laziest, and no option best in more than 6 of 10 cells.
If a price fails, try one re-size, then report.

## Deliverable
`docs/DEPTHPRICE1A_RESULT.md`: per row - the price, the numbers (control vs priced), PASS / FAIL, the exact constants to build.

## Contract
OWNS: tools/depthprice1a_probe.gd (or the extended probes), docs/DEPTHPRICE1A_RESULT.md
RED_TEST: tools/depthprice1a_probe.gd (a measurement probe)
REGRESSION: tests/golden_path_test.gd (unchanged: nothing under scripts/ is touched)
VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who depthprice1a -- <command>`. Other sessions have uncommitted edits
(LineGrade.gd, LiveRound.gd, StepWire.gd) - never stage them. Commit to main, push, report in two lines, stop.
