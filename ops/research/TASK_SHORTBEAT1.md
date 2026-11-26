# TASK SHORTBEAT1 - a short opening beat each round: one moment, one action (S567, measure)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Puncher's chance, order.html).
Seat: Arena on ICOON-Studio/FightCamp-Lean-lite. Estimate: 3-4 hours.

## Why
Owner S567, after a read of Toribash (ops/research/TORIBASH_NOTES_S567.md: its matches open with a short turn and the turns
grow): "Yes, measure it". Each of our rounds opens at Long with a full three-moment beat in which only a jab reaches. The
idea: the FIRST beat of every round is a FEEL-OUT beat - one moment, and each man may use at most ONE action (one hand's
punch, or the feet; the other hand held high or low as now; no clinch). Beats 2-6 are unchanged.

## What to measure, in this order (one run at a time; commit and push after each)
0. CONTROL S0: the page as it is, `balance.mjs play who=mix opp=mirror n=84 seed=1` and `seed=2` on the page's own table
   (proto/twohands/vtable.json), and against the three men (`opp=0|1|2`, n=84, seed 1). Count for beat 1 of each round:
   which plans are chosen (share of beats with 0, 1, 2, 3 actions), the range after it, health dealt in it, stamina spent.
1. S1 - THE FEEL-OUT BEAT as above, as a tweak (a patch on the rules above the page's `// ---- the page` mark: read
   `proto/twohands/tools/rules.mjs` `load(seed, page, patch)` and how MOMENTGAP1 did it, ops/research/s558_balance/moment_gap_b.json;
   the solver and both men's choices must respect the limit in beat 1). Trial n=12 seed=1; then its own table
   (`balance.mjs table tweak=... out=...`, jobs as the runner allows) and n=84 on seeds 1 and 2, mirror and the three men.
2. S2 - S1, plus the feel-out beat costs no stamina for a step (a free step in or back off in beat 1 only). Same runs.
   Only if S1 shows beat 1 turning into "both hold" in more than 60% of rounds.
3. Stop there. Say which of S0 / S1 / S2 to show the owner as a toy page, or none.

## The bars
- The page's nine bars (balance.mjs prints them) on both seeds: S1 / S2 must pass at least as many as S0 on the same seed,
  and never lose "mirror 40-60%".
- Beat 1 is a decision: no single beat-1 plan in more than 50% of rounds; "both men do nothing" in under 40%.
- Rounds do not get slower: health dealt a round within 10% of S0; stoppages within 5 points of S0.
- The man who steps in on the feel-out beat is not simply ahead: his round win share (rounds where he, alone, stepped in
  on beat 1) between 40% and 60%.
- The jab's share of punches thrown is reported beside S0 (the page: the two jabs about 27%).

## Feedback loops
- A one-action opening makes the step in the only way to change the range -> both step in -> every round starts at Inside
  after one beat -> Long disappears: the bar is "Long at least 15% of all beats" beside S0's number; report it.
- A cheap opening gives both men a stamina rest (two held hands) -> more stamina for beat 2 -> bigger beat-2 exchanges ->
  more knockdowns: report knockdowns a bout beside S0; over S0 + 0.4 = failed.
- One-rep trial first: n=12 before any table.

## Not allowed
No page edit, no `rules.mjs` / `balance.mjs` / `play_cli.mjs` edit (a probe file of your own that imports them is fine), no
test deleted or loosened. ONE pull request at the end; never merge it.

## Contract
- OWNS: ops/research/s558_balance/short_beat_s1.json, ops/research/s558_balance/short_beat_s2.json,
  ops/research/s558_balance/results/shortbeat1_*.txt, proto/twohands/tools/probe_shortbeat.mjs, docs/SHORTBEAT1_RESULT.md
- RED_TEST: S0 beat-1 counts (what the opening beat is today)
- REGRESSION: rules_test.mjs 37, page_play_test.mjs 4
- VISUAL: none

## Result
`docs/SHORTBEAT1_RESULT.md`: one table (S0 / S1 / S2 by seed: bars passed, each red bar with its number, the beat-1 counts,
Long share, health a round, knockdowns, stoppages, jab share), then three plain lines: which version to show the owner,
what the player would see, what is still wrong. End with `SHORTBEAT1 DONE` or `SHORTBEAT1 BLOCKED: <why>`.

## Prior research
ops/research/TORIBASH_NOTES_S567.md, docs/MOMENTGAP1_RESULT.md (a wait slot: free anywhere lost two bars, feet-only held),
docs/LONG2_RESULT.md (Long: what the page does today).

## What would a human do?
Boxers spend the first seconds of a round at range, one probing jab or a half step, before they commit.

## Prefab check
Not applicable (our rules).
