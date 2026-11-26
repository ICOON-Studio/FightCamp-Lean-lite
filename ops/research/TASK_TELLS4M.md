# TASK TELLS4M - the tells: a reader bot that reads, then a blind cover that costs (S566, measure loop)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Puncher's chance, order.html).
Seat: Arena on ICOON-Studio/FightCamp-Lean-lite. Estimate: 3-4 hours.

## Why
TELLS3M (`docs/TELLS3M_RESULT.md`, read it first; brief `ops/research/TASK_TELLS3M.md`): version 3 passes 4 of 7 bars. Its
fake band (15-28% of beats) and "a fake never hides a bigger punch" (2,771 of 2,771) hold. Three bars fail:
- TELL ALONE IS NOT THE FIGHT: blind following wins +8 / +10 / +29 points over the no-tell control (bar +5), because a
  fake now hides under 3 damage: obeying every cue costs nothing.
- FINDING THE LIE PAYS: BOT 2 is behind BOT 1 - but BOT 2 is wrong in the probe, not the design: it drops EVERY cue when
  `lieHolds` is true (also the cues that man never fakes) and never punches into a beat it believes is a bluff.
- Stoppages v the Jabber 43-50% (the control alone misses this bar: not a tells question, report only).

## What to measure, in this order (one run at a time; commit and push after each)
1. BOT 2 FIXED, rules unchanged (v=3): it ignores a cue only when `tell.cue` is the lying cue of that man AND `lieHolds`;
   then it plays the beat of BOT 0 with one held hand turned into its best reaching punch (the cheapest that reaches).
   n=12 seed=1 trial for the three men, then n=84 seed=2. Bar: BOT 2 >= BOT 1 + 10 points OR takes >= 2.0 less health,
   each man.
2. VERSION 4 in `tells.mjs` (a NEW branch beside 2 and 3: `tells.mjs` and `play_cli.mjs` are imported live by running
   playtests, every old call must keep its output): v3, except
   a. a fake `shoulder` may hide ONE punch of exactly 3 damage on a line the cover for that cue leaves open (never two
      punches, never more than 3);
   b. the Body Snatcher fakes `shoulder` too, on his second condition (the beat after he threw a body punch), inside the
      same cap of 2 fakes a round.
   Trial n=12 seed=1 for BOT 0 / 1 / 2 (fixed) v the three men + the mirror control; if no pair is over 60% stoppages,
   n=84 seed=2.
3. Stop there. Say whether version 4 is worth showing on the page, and if not, what you would change (do not run it).

## The bars (all against the same-seed BOT 0 control)
BOT 1 <= BOT 0 + 5 points, each man. BOT 1 takes less health than BOT 0 for at least 2 of 3 men. BOT 2 as in step 1. His
fakes on 15-30% of beats. The real beat behind a fake never does more than 3 damage and never two punches (count it:
100%). Stoppages 10-40% (the Jabber pairs reported beside their control). BOT 0 v the mirror 40-60%.

## Feedback loops
- A fake that can hide 3 damage -> blind covering is punished -> the bot stops obeying -> the tell is ignored: the bar
  "the tell helps a little" (BOT 1 takes less health) is the floor; a version where BOT 1 takes MORE health than BOT 0
  against 2 of 3 men has gone too far - report it as failed.
- His fakes cost him 1 stamina -> he tires -> he fakes on his low-stamina condition more: the cap (2 a round, never two
  beats running) holds it; report his stamina at each bell beside the numbers of TELLS3M.
- One-rep trial first: n=12 before any n=84.

## Not allowed
No page, no `rules.mjs` / `balance.mjs` edit, no test deleted or loosened. `probe_tells.mjs`, `tells.mjs` and
`probe_tells_test.mjs` may be extended (v=2 and v=3 output unchanged: prove it by the test and by one v=3 pair run again).
ONE pull request at the end; never merge it.

## Contract
- OWNS: proto/twohands/tools/probe_tells.mjs, proto/twohands/tools/tells.mjs, proto/twohands/tools/probe_tells_test.mjs,
  ops/research/allplay2/tells4m_*.txt, docs/TELLS4M_RESULT.md
- RED_TEST: TELLS3M at n=84: BOT 1 +8.3 / +10.3 / +28.7 points over the control; BOT 2 behind BOT 1 for every man
- REGRESSION: probe_tells_test.mjs, rules_test.mjs 37, page_play_test.mjs 4
- VISUAL: none

## Result
`docs/TELLS4M_RESULT.md`: the table of TELLS3M for step 1 and for version 4, the bars with their numbers, then three plain
lines: is version 4 ready for the page, what the player would see, what is still wrong. End with `TELLS4M DONE` or
`TELLS4M BLOCKED: <why>`.

## Prior research
docs/TELLS3M_RESULT.md, ops/research/DESIGN_TELLS2.md, memory S563 / S564 (5 of 5 testers: one body tell, never his plan).

## What would a human do?
A card player trusts a tell until it costs him once; the cost has to be real but small, or he stops looking.

## Prefab check
Not applicable (our rules).
