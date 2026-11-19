# TASK TURNGAP1 - the debut's opponent gap -> win chance curve, on one fixed boxer (probe, no screen)

Status: OPEN (S530, Claude main). Discipline: boxing. Model: Goose (cloud) - a probe, no window.

## Why
TURNPROBE3B measured debuts won 94% (target 65-80%), but its gap arms never reached the deal. Turning pro v5 then moved the
gap 1.0 -> 1.6 to make debuts harder - and the Arena critic (ops/research/DESIGN_TURNPRO1_V5_CRITIC_ARENA.md, 10/10 item 1)
showed the sign: `Roster.gd` 306 sets the debutant's rating to `night - opp_gap`, so a BIGGER gap is a WEAKER opponent. The
number must come from a measured curve.

## What to build (probe-side only - do NOT edit scripts/ or tests/)
New `tools/turn_gap_probe.gd` (under 350 lines). Population: 20 boxers at the moment of their first pro offer, taken from
`Career.quick_start()` careers played forward with tools/turn_pro_probe3.gd's loop (or built at pro_ready with the game's
own record and stats - say which). For EACH boxer, deep-copy the career once per gap and sign the plain deal through
`Roster.turn_pro` after setting the gap WHERE THE DEAL READS IT (`ProOfferWire.signed` output / the deal's `opp_gap`, the
value Roster.gd 306 uses - print it from the built debutant to prove the override arrived). Gaps: -4, -2, -1, 0, 1, 2, 4,
8. Play to the debut's result row in c.results (newest first). 10 seeds a boxer a gap.
Print per gap: win share (all boxers), median [p10..p90] of the boxer's win share, and `BoutRead.likely` / `BoutRead.band`
for the same pair at signing (what the offer would say). Last lines: the gap whose win share lands in 65-80% and the gap
for 70-85%.

## Pass line (print it)
`TURNGAP1 done gap6580=<gap> gap7085=<gap> override_ok=<yes|no>`.

## Deliverable
`tools/turn_gap_probe.gd`, `docs/TURNGAP1_RESULT.md`, one PR adding only those two files. Pilot first; under 60 minutes.

## Contract
OWNS: tools/turn_gap_probe.gd, docs/TURNGAP1_RESULT.md
RED_TEST: tools/turn_gap_probe.gd prints TURNGAP1 done
REGRESSION: tests/pro_debut_test.gd, tests/pro_offer_wire_test.gd (read-only)
VISUAL: no

## The trap
TURNPROBE3B set opp_gap on c.pro_offer's offers and turn_pro rebuilt the deal without it - all gaps read 94%. Print the
debutant's built rating and the gap it used for one boxer per gap before the sweep; if they do not move, stop and say so.

## Prior research
ops/research/TURNPROBE3_READ_S530.md, docs/TURNPROBE3B_RESULT.md, the Arena v5 critic (item 1 only), scripts/state/Roster.gd
(turn_pro, line ~306), scripts/state/ProOfferWire.gd (signed), scripts/rules/BoutRead.gd (likely, band).
## What would a human do?
Put the same boxer in against six opponents of different levels and count the wins before choosing the matchmaker's rule.
## Prefab check
None: our own probe.
