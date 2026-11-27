# TASK MMCTOY1 - Mixed Martial Cards' distance structure on our boxer: a toy page, measured (S569)

Kind: probe. Model: Fable 5.2 console worker (PC, main checkout). Discipline: boxing (Puncher's chance).
Owner S569, after reading how Mixed Martial Cards handles distance: "i care about the way they structured it and their
rules", then "Build the toy". Seat rules: ops/research/WORKER_S566.md (commit by pathspec, no questions, watchdog before
each table; KICKFIX5 and COUNTERS2 run tables beside you: jobs=2, jobs=1 on CPU AMBER, wait on RED).

## Read first
ops/research/MMC_DISTANCE_S569.md (their rules, our words), ops/research/CARDREF1_REFERENCE_GAMES.md s1 (their turn),
docs/ONEACT1_RESULT.md + proto/twohands/tools/make_one.py + ops/research/s558_balance/oneact_v2.json (HOW a toy page is
made: a tweak file of `src` patches on order.html's rules, a make_*.py for the page part; order.html is never edited),
docs/LONG2_RESULT.md (Long is a corridor), docs/FEINTFIX2_RESULT.md (the feint loop).

## The idea, translated (you decide the exact rules; write each decision and why in the result)
Their distance is not a place: it is which answers are allowed. On our boxer:
1. TWO PLACES + the clinch: OUTSIDE (today's Long) and THE POCKET (today's Mid and Inside as one: every punch whose
   reach includes Mid or Inside lands there). The clinch is entered from the pocket, as today from Inside.
2. LONG RANGE = the jab and the body jab: they reach Outside and the pocket, and a long range punch is never COUNTERED
   by a reaction (no counter bonus off it, no "he misses, you counter" on it). It is beaten only by a read: a punch
   planned for the moment he steps in from Outside is a step-in counter (+N.counter health, LONG3's idea).
3. CREATE DISTANCE = the back off from the pocket: it puts the men Outside AND ends the beat there (every later moment of
   both men is not played), and the other man gets the LEAD next beat. Define the lead in our simultaneous beats (one
   proposal: the man with the lead wins a tie in the same moment / his first moment is played first) and say why.
   A step in in the same moment cancels it (today's "a step in beats a back off" = their Pursue).
4. THE FEINT IS A MODE of a real punch, not its own move: pick a punch, then normal or feint. A feint does no damage; if
   he answered it (held that line, or planned a counter on it) he is OFF RHYTHM next beat (no counter bonus and no guard
   switch in his first moment); if he did not, the feinter loses the lead. No feint-then-overhand chain beyond that.
5. Everything else stays: damage, stamina, guards, knockdowns, judges, 6 beats a round (or say why 8).
Versions: M1 = 1-5 as written. M2 only if M1 fails its trial: one change aimed at the bar that killed it, one line why.

## Do
1. ops/research/s558_balance/mmc_m1.json (tweak, `src` pairs exact text of order.html, no trailing newline) +
   proto/twohands/tools/make_mmc.py -> proto/twohands/mmc.html (the page part: the strip / help say "Outside" and
   "Pocket", the feint as a mode toggle on a punch card, "lead" shown on the player's card). `node --check` every js.
2. Its own look-ahead table (`balance.mjs table tweak=... out=E:/FightCamp/wt_tmp/MMCTOY1/m1.vt.json iters=300
   jobs=<n>`), one-rep trial n=12 seed 1, then `play who=mix opp=mirror n=84` seeds 1 and 2, `opp=0|1|2 n=84` seed 1,
   the feint loop (probe_clinch.mjs, n=60). Control: today's order.html the same way (reuse KICKFIX5's or COUNTERS2's
   control runs if they are today's page at the same n and seeds - say which).
3. `node proto/twohands/tools/page_play_test.mjs mmc.html` passes; a full-size headless-Edge still (beat_shot.mjs) of a
   plan with a feint mode and of a beat that ended on Create distance, opened before the commit.
4. docs/MMCTOY1_RESULT.md: the rules as built (five lines), one table (today v M1 [v M2]: page bars passed with each red
   bar's number, Outside / Pocket / clinch shares, the jab's share, the feint chosen / bitten / called, how often a beat
   ends on Create distance, who holds the lead how long, stoppages, knockdowns), the feint loop beside today's, THREE plain
   lines for the owner: how it plays, what got better, what got worse. Last line `MMCTOY1 DONE` or `MMCTOY1 BLOCKED: <why>`.
   One version.js line for the new page (pull first, next free 0.569.<n>), and the page on the ops board jump list if
   there is one for toys (look how one.html was added).

## Bars
- The page's nine bars at least as many as today's page on the same seed; mirror 40-60%.
- Outside is a place you fight from, not a corridor: Outside 20-45% of beats, the jab thrown in 10%+ of all beats.
- The feint is a choice and a read: feint mode chosen 5-20% of punches; bitten 30-60% of feints; the feint-then-power
  loop (probe_clinch) at most 30% against every man.
- Create distance is a tool, not a must: a beat ends on it in 5-20% of beats.

## Feedback loops
- The lead: creating distance hands the lead over -> the man with the lead attacks -> the other backs off to create
  distance -> the lead flips back: a ping-pong. Cap: report lead changes a round and beats in a row with the same lead at
  n=12 first; if create distance ends over 30% of beats at n=12, stop and change it (M2).
- Long range is safe from counters -> the jab is thrown more -> more beats Outside -> the step-in counter pays more -> fewer
  step ins -> more Outside: capped by "Outside at most 45%" and "jab 10%+" (both ways); reported at n=12.
- Off rhythm: biting a feint -> no counter next beat -> the feinter feints again: capped by "feint 5-20%" and the loop bar.
- One-rep trial n=12 before any n=84.

## Prior research
The files under "Read first"; prior_research.py "feint lead initiative distance".

## What would a human do?
A boxing coach: at range you live off the jab and the man who walks in onto it pays; up close you trade; when you want
out you take a step back and the exchange is over - and he gets to come at you. A feint is a punch you pull, not a dance.

## Prefab check
Not applicable (our own rules; their rules read, not copied: no card text, numbers or art of theirs).

## Contract
- OWNS: ops/research/s558_balance/mmc_m1.json, ops/research/s558_balance/mmc_m2.json,
  ops/research/s558_balance/results/mmc_m1_n12_s1.txt (and the other mmc_* result files), proto/twohands/tools/make_mmc.py,
  proto/twohands/mmc.html, proto/twohands/version.js (one line), docs/MMCTOY1_RESULT.md
- RED_TEST: today's order.html: Long is a corridor (LONG2), the feint loop 35/53/37% (bar 30)
- REGRESSION: node proto/twohands/tools/rules_test.mjs; node proto/twohands/tools/page_play_test.mjs order.html
- VISUAL: full-size stills of mmc.html (a feint-mode plan, a Create-distance beat), opened before the commit

## Not yours
order.html and every other page, ring_ui.js / body_ui.js / hand_ui.js / strip_ui.js / clock_ui.js, balance.mjs, kick.html
(KICKFIX5). No push to the public test repo. Never "Ring Switches" in a result; the game is Puncher's chance.
