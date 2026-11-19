# TASK SIGPACE1 - can a boxer reach a Signature in two seasons, with camps and bouts? (probe)

Status: OPEN (S530, Claude main). Discipline: boxing. Model: Goose (cloud) - a probe, no window.

## Why
HOLD1 (docs/HOLD1_RESULT.md, full sweep S530) found no held Signature on any arm: the median mastery cap
(`MoveMastery.cap` = 40 + 0.4 x Technique + 0.2 x Ring IQ) stays under the 85 a Signature needs by season 2. But HOLD1 has
NO bouts - so no camp, no camp's focused morning, no fight-proven gain - and one pads coach at 58. Before anyone tunes the
cap or the hold, measure the pace on the game's own career loop.

## What to build (probe-side only - do NOT edit scripts/ or tests/)
New `tools/sig_pace_probe.gd` (under 450 lines). Population: the game's own careers - `Career.quick_start()`, one signed
boxer per career, played with the game's weekly pass (Sim.step_day) and the bout loop as tools/turn_pro_probe3.gd's
`_answer_open` does it (accept sheet offers, camps, weigh-ins, fight by the sim, goal five_round_engine). 30 careers x 2
seeds, 104 weeks, amateur only (decline pro offers). Arms: pads coach rating 58 (today) and 75 (a hired better coach -
CoachMarket's best pads), each with and without a camp's focused morning on the plan's main punch.
Per arm print, at weeks 26 / 52 / 78 / 104 (median [p10..p90]): Technique, Ring IQ, the mastery cap, the plan's best
move's mastery, the share of careers with any move at 85+ (Signature), weeks to the first Signature.

## Pass line (print it)
`SIGPACE1 done sig52=<share> sig104=<share> cap104=<median>` per arm. The map's reading is "a first Signature in about a
season of focused work"; report what the game gives, do not tune.

## Deliverable
`tools/sig_pace_probe.gd`, `docs/SIGPACE1_RESULT.md` (method, the tables, the pass lines), one PR adding only those two
files. Pilot with 4 careers first and print the projected time; stop at 90 minutes (cut careers, never seeds).
RESULT: tools/sig_pace_probe.gd -> SIGPACE1 done ...

## Contract
OWNS: tools/sig_pace_probe.gd, docs/SIGPACE1_RESULT.md
RED_TEST: tools/sig_pace_probe.gd prints SIGPACE1 done
REGRESSION: tests/move_mastery_test.gd (read-only)
VISUAL: no

## The trap
`Bouts.after_fight` clears f["bout"] in the same step as the fight - read results from c.results (newest first), never
from f["bout"]["done"] (TURNPROBE3's fork read every debut as lost that way). Print `arms=` and `pilot=` on the first line.

## Prior research
docs/HOLD1_RESULT.md, ops/research/TASK_HOLD1.md, tools/prog_probe.gd, scripts/rules/MoveMastery.gd, TURNPROBE3_READ_S530.md.
## What would a human do?
Follow a few real boxers through two years of camps and fights and see when the first move becomes theirs.
## Prefab check
None: our own probe.
