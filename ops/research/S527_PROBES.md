# S527 probe verdicts (Claude, Opus) - read from the primary result files on each Goose branch

## TURNPROBE2 (Goose #392, docs/TURNPROBE2_RESULT.md) - turning pro needs a design revise, not a constant
- 8 of 9 lines FAIL measured as the design means them (TURNTUNE1 already showed no constant moves them).
- The day-job half reads the SAME money for every bot ($12,110 at w52, -$2,417 at w104, both seed sets): a day-job boxer
  almost never reaches a pro offer in 104 weeks (1 signing in 150 careers), so the bot's choice never matters. That is a
  finding about the day job (mornings lost -> never 7 wins), not a probe wire. Lines 2-4 must be read on the stipend half.
- On the stipend half line 4 PASSES (debuts that lose gym money 67% / 40%; the 27% average was dragged by the day-job half).
- Real fails: the "costs" ask is the best answer in 68% of offers, softer / split / no-ask never (0%); RANK's door never
  closes (0/60); debut win rate at 1.5 is 60% (band 70-85); ambitious boxers sign Steady+ only 3% (band 70%+).
- Decision: TURNPRO revise at Dola with this table (asks that are never best are dead options; a day-job boxer's road to pro
  needs a design line), then two critics. No constant tuning.

## GUARDPROBE2 (Goose #395, docs/GUARDPROBE2_RESULT.md) - guard posture would be a dominant pick
- Body share of what lands on us is 21-40% by style (pressure fighters 38-40%), not the 6% S526b feared.
- Even so, HIGH guard leaves the least damage in 12 of 12 cells (6-13% less); LOW never wins. Only 2 bouts a cell, but the
  sign never flips. A posture choice with one right answer is not a choice: GuardWear.POSTURE_* is NOT wired.
- Decision: the defence tab waits for a posture design where LOW pays (body-puncher cells, a body-attack plan, or the
  cost of HIGH on our own output) - a design call at Dola, then a probe at 50+ bouts a cell.

## STEPTUNE1 (Goose #394) - not taken
- The run timed out at 100 min; the doc's TABLE section says "TODO" and its sizes came from a PARTIAL TREEVALUE3.
- Its cells read exactly +0.0 for step_in / roll_out / push_off. The full TREEVALUE3 (E:/FightCamp/tmp/treevalue3.txt):
  roll_out fires 0 times in every style = a PROBE defect: PlanBoard.pick takes the first any-time arrow on a card, and
  tie_up (any time, inside) came before roll_out. Fixed in tools/treevalue_probe.gd (_swept_first; `-- only=` filter).
  push_off fires 0.4-0.8 a bout and its DRAIN is read (RingDuel.opp_energy): a size case, not a wire.
- Next: the roll_out / push_off rerun (E:/FightCamp/tmp/treevalue4_rollout.txt), then STEPTUNE2 sizes from the full table.

## TREEVALUE4 rerun (S527 PC, docs/TREEVALUE4_ROLLOUT_PUSHOFF.txt) - roll_out fixed, push_off a size case
- roll_out now fires 1.2-2.4 a bout (was 0): the probe fix holds; without-arm fires 0; determinism control OK.
  Its worth is -0.8..+0.8 in 100 (targets: Slugger +3.0, Pressure +1.0, others ~+1): deny 0.40 on head hooks = ~7.6% of
  her landed punches, open 0.10, against its own tank 0.30. Too small, not miswired.
- push_off fires 0.4-0.8 a bout from the clinch card and changes nothing (wins equal in 4 of 6 styles over 1,200 bouts):
  its only lever is DRAIN 0.3 x 0.85 x BODY_COST 1.2 = ~0.31 of her 100-point tank a fire, against its own tank 0.4. Wired
  (RingDuel.opp_energy reads opp_drain), sized at nothing. A real push-off makes space on your own terms: an OPEN on the
  next exchange is the lever it lacks (Claude's call for STEPTUNE2: give it open, open_on "any").
- STEPTUNE2 (TASK_STEPTUNE2.md) sizes all ten rows from the full corrected table.
