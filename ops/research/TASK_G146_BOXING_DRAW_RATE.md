# TASK G146 - How often does a professional boxing bout end in a draw?

Owner: Grok (Research / Expert mode, never Build). Model: Grok Expert. Tier: research, no gate.
Advances: ACTIVE MILESTONE "PLAYABLE WITH A BOXER" - step (6)/(7): the result of a watched bout must read as boxing.

## Why
The game's boxing census (Q211 re-run on master 22d71d18, 60 bouts, 8 x 3-min rounds, three differentiated
matchups) ends **11.7% of all bouts in a draw** - about a quarter of all decisions. UFC's sourced rate is 0.7%
(G108). Our record has NO sourced professional boxing draw rate (G108 line 39: "Modern pro draw rate UNSOURCED").
Without that anchor we cannot tell an engine defect from a fixture of evenly matched men.

## What would a human do?
A boxing statistician counts outcomes on BoxRec by year and level (4-, 6-, 8-, 10-, 12-rounders) and splits draws
(majority / split / unanimous draw) from technical draws. A judge-panel analyst also asks how often a round is scored
10-10 and how often the three judges' totals are level.

## Prior research
- `research/G108_FINISH_RATES.md` (finish/KO rates; draw rate UNSOURCED for boxing)
- `research/J1_ORGANIZATION_RULES_AND_JUDGES.md` (three judges, 10-point must)
- searched: draw, draw rate, boxing, judges, scorecard (prior_research.py, S119)

## Prefab check
None: this is a statistic, not a system. Datasets are welcome - name any public BoxRec-derived dataset, its licence and n.

## Ask - answer ONLY these, each with source URL + date + n
1. Professional boxing draw rate as % of all bouts (any recent window, 2015+ preferred), and by scheduled length if
   available (4/6 vs 8 vs 10/12 rounds).
2. Share of DECISIONS that are draws (so it compares to "decision incl. draws").
3. Split between unanimous / majority / split draws and technical draws, if published.
4. Frequency of 10-10 rounds on professional boxing cards (any study of judges' scorecards).
Tag each figure SOURCED / PROXY / UNSOURCED. Do not guess a number to fill a cell.

## Deliver
One file, `research/G146_BOXING_DRAW_RATE.md`: a table (metric, value, n, window, source, tag) plus at most
10 lines of reading. No code.
