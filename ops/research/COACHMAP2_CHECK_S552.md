# COACHMAP2 checked by hand (S552)

The worker's page `docs/COACHMAP2_RESULT.md` (commit fc207d8a1, FAIL on bars 1, 3, 4, 7b) against the code and its own raw
tables in `E:/FightCamp/tmp/coachmap2/`. Verdict: **the FAIL stands; nothing found that would turn a bar.**

| Claim on the page | Checked against | Holds? |
|---|---|---|
| The commit touched only its own paths | `git show --stat fc207d8a1`: the result page + `tools/coachmap2.gd`, `coachmap2_rules.gd`, `coachmap2_sum.py` | yes |
| The clue is right with chance 0.4 + 0.03 x tactics; hearing x (1 + 0.4 x chemistry); a warned boxer hears 15% less | `tools/coachmap2_rules.gd` l.20-25 (`CLUE_A`, `CLUE_B`, `LISTEN`, `WARN_HEAR`), `clue_q` | yes |
| Recover points 1 / 2 / 3 at cutman under 8 / under 14 / 14+ | `rec_points` l.30-32 | yes |
| Bout table: reader 76.2, file 66.2, live F 76.3, K 76.5, Reid 74.3, Reid bonded 74.8, Reid clash 73.0, YOU 73.7 (3 rounds) | `sum_corner.md`, 2,000 bouts an arm | yes, every number |
| Bar 1: the one-fact hire loses 10 lines in 1 of 100 gyms with all changes on | `sum_season.md` l.142 ("1 of 100 gyms (need 30)") | yes |
| The control differs by run order because `BoutRead.round_edges` caches by `RingDuel.stat_bucket` | `scripts/rules/BoutRead.gd` `_re_key` / `round_edges` (l.300-310): the key holds the bucket, not the stats | yes (same finding as S551, memory `reference_boutread_cache_run_order`) |

Not re-run: the bouts and seasons themselves (96,000 bouts, 10 season slices). Read, not replayed.

One thing the page says itself and the owner question should not hide: bar 4 fails partly by construction - today's live
corner reads the clue perfectly, so a coach's tactics can only take wins away. A coach that ADDS something at the top would
need a new rule and a new probe. Nine design rounds have not found one that reaches 8.

What passes and is in the game today: the known name pays with a pro and not without (bar 2); a careless owner loses people
and a careful one does not (bar 5); calling the corner live beats the same coach simmed by 7 to 13 wins in 100 (bar 7a).

Next: the owner's keep-or-cut call (board question, S552).
