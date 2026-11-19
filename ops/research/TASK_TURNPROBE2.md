# TASK TURNPROBE2 - measure turning pro's three failing lines the right way (probe, no screen)

Status: OPEN (S526, Claude main). Discipline: boxing. Model: Goose (cloud) - a probe, no window.
Previous: docs/TURNPROBE1_RESULT.md (2 of 9 pass), docs/TURNTUNE1_RESULT.md (Goose #389: no ESTIMATE constant moves lines
2, 4 or 7; it named the probe's own measures as part of the cause). Decision S526 (Claude): before any mechanic change,
measure those three lines the way the design means them. tools/turn_pro_probe.gd stays as it is (copy it).

## What to change in the copy (tools/turn_pro_probe2.gd)
- Line 4 "a YES debut loses the gym money in 40-70% of debuts": measure THE DEBUT'S OWN MONEY - the gym's cash change from
  signing day to the week after the debut bout, minus the same span in the paired NEVER career (same seed, same index).
  TURNPROBE1 read total cash at week 104, where months of member dues hide the debut.
- Line 7 "each ask is the best in 10%+ of offers": for each YES offer, play the career forward once per ask (later2,
  later4, softer, split, price, costs, and no ask) from the same snapshot (Sim state deep-copied, same rng seed) to the
  week after the debut, and record which ask ends with the most gym cash + the boxer's purse kept. Shares of "best ask".
  TURNPROBE1's bot picked the ask with the largest by_debut number, which always named costs.
- Line 2 "PREP beats YES by $1,500+ at week 104": print the paired diff per career (same seed and index) and its median,
  plus the week each signed and the purse each got - so the reason PREP and YES end equal is visible.
- Keep lines 1, 3, 5, 6, 8, 9 as TURNPROBE1 prints them. N = 30 careers a bot (argument as TURNTUNE1 added).

## Contract
OWNS: tools/turn_pro_probe2.gd, docs/TURNPROBE2_RESULT.md
RED_TEST: tools/turn_pro_probe2.gd -> TURNPROBE2 done
REGRESSION: pro_call_test, pro_offer_wire_test, pro_contract_test (read-only: run them, never edit them)
VISUAL: no
NOT YOURS: every file in scripts/ and tests/, tools/turn_pro_probe.gd, docs/TURNPROBE1_RESULT.md. The result page is
WRITTEN BY THE PROBE. PR body: `RESULT: tools/turn_pro_probe2.gd -> line2_median=<$> line4=<pct> line7=<ask:pct,...>`.
Each file under 500 lines (split a helper into tools/turn_pro_probe2_fork.gd, also owned, if needed). Pilot first and
print the projected time; stop at 90 minutes (the forward plays per ask cost the most: cut N to 20 if the pilot says so).

## Prior research
`python ops/Tools/prior_research.py turnpro pro offer` -> TASK_TURNPROBE1, TASK_TURNTUNE1, the TURNPRO1 design map s7.

## What would a human do?
A manager judges a contract by what that fight does to the gym's month, and judges each request by trying it - not by
the size of one number on the offer sheet.

## Prefab check
None: a copy of tools/turn_pro_probe.gd.

## The one trap
The forward plays must start from the SAME snapshot and rng seed, or the "best ask" is noise. Prove it: "no ask" played
twice from one snapshot must end to the dollar.
