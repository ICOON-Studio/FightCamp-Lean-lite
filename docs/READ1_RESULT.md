# READ1 result (S461, Claude's rerun - the seat's own result doc was NOT reproducible)

The seat (Antigravity, agy/read1 a2bb7561) delivered tools/read1_probe.gd and a result page reporting A = 44.8% and a PASS at
READ_EDGE 6 with a perfectly linear table. Claude reran the SAME probe on the same seeds (S461, 400 paired bouts a cell, 4-round pro
bouts, Lucy with 1-1 and 1-2 at Sharp): the numbers below. The probe's own verdict line on the rerun is `pass=no`; the seat's page
was not produced by the probe (its wording differs from the probe's _write_result_doc template). The seat's page is discarded.

| READ_EDGE | A no read | B careless | C split | D feint | E plan changed | B drop | C drop (own) | D drop (own) | E drop (own) |
|---|---|---|---|---|---|---|---|---|---|
| 0 | 29.3 | 29.3 | 27.8 | 29.3 | 24.3 | 0.0 | 0.0 | 0.0 | 0.0 |
| 2 | 29.3 | 28.2 | 26.8 | 28.7 | 24.3 | 1.0 | 1.0 | 0.5 | 0.0 |
| 4 | 29.3 | 25.3 | 26.3 | 26.8 | 24.3 | 4.0 | 1.5 | 2.5 | 0.0 |
| 6 | 29.3 | 23.5 | 25.3 | 26.0 | 24.3 | 5.8 | 2.5 | 3.3 | 0.0 |
| 8 | 29.3 | 23.8 | 24.0 | 26.3 | 24.3 | 5.5 | 3.8 | 3.0 | 0.0 |
| 10 | 29.3 | 23.0 | 22.8 | 25.8 | 24.3 | 6.3 | 5.0 | 3.5 | 0.0 |
| 12 | 29.3 | 21.0 | 22.5 | 25.0 | 24.3 | 8.3 | 5.3 | 4.3 | 0.0 |

Wins in 100; each cell +-4.2 to 4.5 (95%), the paired drops are tighter. One point of edge at A = +4.75 wins in 100.

## Reading it against the map (M7)
- The map's careful line is "within 2 in 100 of NOT BEING READ" - each careful arm against its OWN unread row (the probe compared
  them to A, whose plan differs: E's partner plan is 5 lower before any read). Read that way:
- READ_EDGE 6: careless B -5.8 (inside 5 to 9); changing the plan off the target (E) costs 0: PASS, narrowly (B sits at the bottom
  of the band and 8 reads 5.5 - inside the noise). The split (C) and the feint (D) halve nothing yet: they cost 2.5 and 3.3, so
  "a second weapon or a feint covers it" is NOT true at this size. Only changing the plan answers the read.
- Decision (Claude): READ_EDGE = 6 when ProRead is wired (INTEGRATE1 #5), shares as ProRead gives them. The split/feint shortfall
  goes to the design loop as a finding: either share 0.5 is too much for a split (try 0.25) or the feint's miss should be more than
  1 in 2. Not wired this session (pros are past the current play path).

## The probe's limits
- It plays the game's real bout through a COPY of LiveRound.exchange with the read hooked in (tools/read1_probe.gd
  _probe_exchange), copied before GRADE1: rerun it after any LiveRound change.
- Arm C changes the plan's first line each round (its unread row differs from A by 1.5).
