# TASK DEPTHPRICE1B - price the four solved club choices, on a greybox (DEPTH_SCOPE_S534 change 1)

Model: claude-fable-5-2 console in this checkout. MEASUREMENT ONLY: tools/ and docs/, nothing under scripts/.

## The four one-answer rows (DEPTH_AUDIT_S534 part 1, with their measurements)
- 14 Class nights (ClubClasses.cash): "Free lunch within noise" - $6,094 more cash, wins +0.0 (MONEYFOUR2).
- 15 Stipend or day job (DayJob.LOST, GymSpend.set_half): day-job boxers reach a pro call in 3 of 180 careers, stipend 180 of 180.
- 17 Move with the fit-out loan (GymUpgrades.LOAN): never a trap in two years (LOANPROBE1).
- 7 Diet Hold or Cut: cut when over, hold when not - a chore with a fail state (a reading, not measured).

## Do
For each row propose ONE price in something scarce the game already has - read the code first, use existing numbers. The
audit's examples: class nights take the coach's evening that a pad night needs; the day job keeps the boxer's money and mood
up while the stipend costs real cash in a lean month; the loan bites in a bad quarter when members fall; the cut costs
strength or tank on the night. Measure it on a greybox: extend the existing probes (tools/gym_survive_probe.gd and the money
and career probes; read docs/LOANPROBE1_RESULT.md, docs/MONEYFOUR2_RESULT.md first) with the price as a flagged local rule;
arms = today (control) and priced. Bars: the choice moves the result (3+ wins in 100, or a real money or closure
difference), and no option best in more than 6 of 10 cells (gym kinds x seeds). If a price fails, try one re-size, then report.

## Deliverable
`docs/DEPTHPRICE1B_RESULT.md`: per row - the price, the numbers (control vs priced), PASS / FAIL, the exact constants to build.

## Contract
OWNS: tools/depthprice1b_probe.gd (or the extended probes), docs/DEPTHPRICE1B_RESULT.md
RED_TEST: none (measurement). REGRESSION: none (nothing under scripts/). VISUAL: no

## Rules
Godot only through `python ops/Tools/godot_slot.py run --who depthprice1b -- <command>`. Other sessions have uncommitted edits
(LineGrade.gd, LiveRound.gd, StepWire.gd) - never stage them. Commit to main, push, report in two lines, stop.
