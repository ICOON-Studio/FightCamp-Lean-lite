# J-UPSETS1 - how often does the better boxer win? (John, research)
Kind: research

Discipline: boxing (demo). Seat: John (deep research). Answer saved to research/J_UPSETS1.md by seat_queue.

## Why we ask
Our amateur bout (3 rounds, each round won by the higher of "fighter strength + a random roll") is almost fully decided
by ratings: a measured harness (Lean BALANCE1, 400 seeded bouts per cell) gives the stronger side 100% at a 5-point edge
and 0% at -5. That kills upsets. Before we change the randomness we need real numbers for how often favourites win.

## Questions (cite every number: source, year, sample size, link)
1. Pro boxing: share of bouts won by the betting favourite, overall and by odds band (pick'em, -150, -300, -500, -1000+).
   Closing odds studies (e.g. academic papers on boxing betting-market efficiency, BoxRec/odds datasets).
2. Amateur boxing (AIBA/IBA, Olympic, national championships): share won by the higher-seeded / higher-ranked boxer;
   upset rates in Olympic tournaments; anything on 3x3-minute bouts specifically.
3. Rounds: in pro and amateur scoring, how often does the bout winner lose at least one round? (round-by-round
   judges' cards: CompuBox / BoxRec / IBA scoring data). How often does the underdog win round 1?
4. Ranking gap vs win share: any study mapping a ranking or Elo/BoxRec-points gap to win probability (logistic fits).
5. Comparable sports sims: published favourite-win targets in sports management games (Football Manager, OOTP, WWE 2K
   universe, Fight Night/Undisputed career) if documented by the developers.

## Prior research
searched: upset favourite favorite odds win rate (Tools/prior_research.py) - K70_HONEST_OUTCOMES.md says upsets must be
legible against a stated favourite, but has no sourced favourite win rate. Nothing else in the record.

## What would a human do?
A sports-sim designer calibrates randomness against bookmaker closing odds: a market's favourite-win share by odds band is
the cleanest real-world target, then the sim's noise is tuned until its win share by rating gap matches that curve.

## Prefab check
Not a build task - no asset or library applies. Public odds datasets (e.g. Kaggle boxing odds, BoxRec) are named sources,
licence to be stated per dataset if used.

## Format
A table per question (number, sample, source link), then a one-paragraph recommendation: target win share for the
favourite at "slight", "clear" and "big" rating edges for a 3-round amateur bout.
