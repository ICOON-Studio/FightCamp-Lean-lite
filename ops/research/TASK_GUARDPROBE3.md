# TASK GUARDPROBE3 - size the opponent's adaptation so guard posture is a real choice (probe, headless)

Status: DONE (collected; S529 marked) (S527, Claude main). Discipline: boxing. Model: Goose (cloud), default.

## Why
GUARDPROBE2 (docs/GUARDPROBE2_RESULT.md, tools/guard_probe2.gd): HIGH guard leaves the least damage in 12 of 12 cells. The
posture multipliers (scripts/rules/GuardWear.gd POSTURE_*: HIGH head 0.80 / body 1.15, LOW the mirror) make HIGH best
whenever the body share is under 0.50, and measured body shares are 0.21-0.40. The design's answer is adaptation: the same
posture for N rounds -> the opponent shifts S of her punches to the open target (body vs HIGH, head vs LOW).
Read ops/research/GUARDWEAR_WIRE_S524.md (bottom two sections) first.

## What to build (probe-side only - do NOT edit scripts/)
New `tools/guard_probe3.gd`, extending guard_probe2's cells (6 opponent styles x am3 + pro6). Probe-side, per round: the
body share = the cell's measured share, plus S once our boxer has held the same posture N rounds (reset when it changes).
Arms: N in {2, 3}, S in {0.15, 0.25, 0.35}. Bots: HIGH always, LOW always, NEUTRAL always, SWITCH (HIGH, then LOW for
the rest of the bout once the shift has happened), WATCH (NEUTRAL, then the posture that covers where she now aims).
50 bouts a cell minimum (pilot first; print the projected time; stay under 80 minutes total - cut to fewer arms, never to
fewer bouts). Measure total damage taken (through-guard leak split head/body as guard_probe2 does) per bot per cell.

## Pass line (print it)
For each (N, S): in how many of the 12 cells each bot is best. PASS when no bot is best in more than 60% of cells AND at
least three bots are best in 15%+ of cells. Print the smallest (N, S) that passes, or NONE with the closest arm.

## Deliverable
`tools/guard_probe3.gd`, `docs/GUARDPROBE3_RESULT.md` (tables + the RESULT line), one PR adding only those two files.
RESULT: tools/guard_probe3.gd -> <the pass line>

## Contract
OWNS: tools/guard_probe3.gd, docs/GUARDPROBE3_RESULT.md
RED_TEST: tools/guard_probe3.gd prints GUARDPROBE3 done
REGRESSION: none (no game code touched)
VISUAL: no

## Prior research
GUARDPROBE1, GUARDPROBE2 results; GUARDWEAR_WIRE_S524.md; DESIGN_GUARDDMG1_V4 maps.
## What would a human do?
A coach watches where the opponent's shots go and tells his boxer to lower the guard when she starts digging the body.
## Prefab check
None: a pure probe on our own rules.
