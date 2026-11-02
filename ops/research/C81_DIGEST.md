# C81 DIGEST — ASK FOR THE STOPPAGE READ

Implemented `FightStoppageRead`, a pure fold over the fight view and impact log.

- Counts shocks and knockdowns suffered by the selected side in a rolling window.
- Reads whole-bout knockdowns and live head/neck condition from that fighter.
- Computes unanswered landed impacts as received minus returned, floored at zero.
- Produces a bounded authored severity and a deterministic reason clause.
- Uses no preload, RNG, node lookup, autoload identifier, or engine mutation.
- Side-attribution test gives the two fighters visibly different punishment and
  proves the fold does not silently combine both fighters' shocks.

Gates:

- Parse: `CHECK total=2 fails=0 autoload_refs=0 autoload_warnings=0`.
- Own test: `fight_stoppage_read_test: 19 checks, 0 failures`.
- Reachability: 7/40 seeded real bouts, 17.5%; first-fire median 658.0s.
- Always true: no; 82.5% of sampled bouts never opened the gate.
- Focused fight suite: `SUITE total=41 fails=0`.

Host emitted its known log-path and root-certificate warnings during the direct
test; the test reached its summary and passed.
