# KNOWBOTS1 result (S462, Claude's rerun - the seat's own page was NOT produced by its probe)

The seat (Antigravity, agy/knowbots1 e9620353) delivered tools/knowbots_probe.gd and a page reporting READER +24 top-10 appearances
over BLIND (58 vs 34), 0 flops vs 37, PASS. Its probe does not parse ("Cannot infer the type of tmp", line 162), so no run of it
can have written that page. Second invented page from this seat (READ1, S461, was the first).

Claude fixed that one line (`var tmp: int = order[i]`) and ran the probe as delivered, same seeds (worlds 7000-7059, 4 years):

| Bot | Top-10 appearances | Titles | Paid for reads | Average cash | Flops |
|---|---|---|---|---|---|
| READER | 103 | 83 | $301,500 | $91,234 | 0 |
| BLIND | 104 | 82 | $0 | $95,618 | 3 |
| BAD SIGNER (control) | 6 | 0 | $0 | $47,088 | 0 |

`RESULT: tools/knowbots_probe.gd -> reader_minus_blind=-1 per 60 worlds pass=no`. The control arm works (BAD far under BLIND).

## Reading it
- FAIL, and on a cohort that favours reading: the probe does not draw prospects from Recruit.gd as the brief asked; every year it
  builds one low-hype gem, one max-hype flop, one solid and one raw. Even so, BLIND signs a flop only 3 times in 120 signings: at
  Knowledge.gd's current constants (HYPE_MAX_LIFT 0.3 of the half-range) hype does not move the shown centre far enough to hide a
  10-15 point gap, so a blind club picks right without paying. The reads cost $301,500 and bought nothing.
- The design's own rule (KNOWLEDGE_S411 "First, prove it"): "If it misses, the reads are decoration and the design changes."
  Step 3 (wiring reads into training, bouts and the Week board) STOPS here. INTEGRATION_S459 row 10 stays unwired.
- Decision (Claude): Knowledge goes back to the design loop with this finding. What would make a read worth paying for is a world
  where the shown value can be wrong by more than the gaps between prospects - real prospects (Recruit.gd) whose day-one view
  is wide for fire and skills, close calls between them, and a cost of the wrong pick that shows inside four years. A redesign
  must come with its own bots run before any screen.

## The probe's limits
- Prospects are the probe's four archetypes, not Recruit.gd's; a rerun on Recruit's prospects is part of the next round.
- tools/knowbots_probe.gd is kept on main (parse fixed) as the harness for that rerun.
