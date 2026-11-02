# TASK G108 - GROK - REAL FINISH RATES BY SPORT AND LEVEL (sourced anchors)
Owner: grok. Model: Grok Expert (Research mode, NEVER Build). Assigned S81, 2026-09-26. Pure research, no code.
Save target: `research/G108_FINISH_RATES.md` (Grok pastes inline; Claude saves).

## Why
FightCamp's fight engine is gated against real numbers. A census (Q181) just compared our finish rates to bands it did
not source ("~25-40%" boxing, "~30-50%" kickboxing, "~53%" MMA), and our kickboxing sits at 7% finishes - a real engine
problem or a wrong band, we cannot tell. The next census (Q183) decides a global engine default on these bands.

## What would a human do?
A sports-data analyst builds the anchor from a named dataset at a named level and time window (e.g. "UFC 2015-2025, all
bouts, n=..."), states what counts as a finish, and never mixes amateur with pro or 3-round with 12-round.

## Questions (tag SOURCED with URL + date / PROXY / JUDGEMENT; give n and the time window for every number)
1. **Finish rate (KO/TKO, SUB, DQ separately) by sport and level**: amateur boxing (3x3 min, headguard rules where
   relevant; RSC rate), pro boxing small-hall (4-8 rounds) vs championship; kickboxing (Glory, ONE kickboxing, K-1,
   amateur WAKO/IFMA); Muay Thai; MMA (UFC, regional promotions like Cage Warriors, amateur MMA).
2. **Knockdowns per fight** for the same buckets, where published.
3. **Draw rate** by sport (boxing draws vs MMA draws).
4. **Leg-kick share of strikes** in MMA and kickboxing (share of significant strikes to the legs), with the dataset.
5. A table FightCamp can gate against: sport x level -> finish %, KO %, SUB %, draw %, knockdowns/fight, leg share %,
   each with source, n and window. Mark any cell you could not source as UNSOURCED rather than filling it.

## Deliverable
One markdown memo inline, titled G108_FINISH_RATES, <= 1,500 words, ending with the table.
