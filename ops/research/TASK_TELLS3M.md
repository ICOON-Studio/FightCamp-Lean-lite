# TASK TELLS3M - the tells, version 3, measured on the instrument with bars against the control (S564, probe)

Kind: probe. Model: Arena (cloud). Discipline: boxing (order.html rules). Seat: Arena on ICOON-Studio/FightCamp-Lean-lite.
Estimate: 3-4 hours (10 pairs, n=84, about 20 min a pair on 2 cores).

## Why
Owner S563: "do you thinkwe should show opponents itentions like more draditional card games or it is fine the way it is
?" - every playtester chose ONE body tell, never his whole plan. TELLS2M (docs/TELLS2M_RESULT.md) measured version 2 at
n=12 and stopped on its stop rule. Two of its findings changed version 3, and the playtest round ALLPLAY2B (Arena and Ziva,
ops/research/allplay2/) gave the third:
1. The lie rate followed the PLAYER: against the strong mix bot the Jabber's and the Slugger's conditions held on 41-46%
   of beats; against a careful player the Slugger lied 2 of 18. Version 3 caps him: at most 2 fakes a round, never two
   beats running, and gives the Slugger and the Body Snatcher a second condition of their OWN state.
2. "A lie is always a bluff" was not true: a fake shoulder hid a body cross + lead uppercut (Ziva, 5 damage) and a double
   uppercut (Arena, 7). Version 3 fakes only when his real beat does less damage than the smallest punch the cue promises.
3. The old bars could not be met: the control (BOT 0) already beats the page's men 67-83% (their skill is under 1, S555
   design). The lead decided (S564): the bars are restated RELATIVE TO THE CONTROL, below.
Version 3 is `tellOf(opp, plan, c, 3)` in `proto/twohands/tools/tells.mjs` (LIES3, CAP3); the probe already takes it:
`node proto/twohands/tools/probe_tells.mjs bot=<0|1|2> opp=<0|1|2|mirror> n=84 jobs=2 seed=2 v=3`. With `v=3`, BOT 2
knows the whole rule (a condition holds and the cap is not reached).

## What to run (no new tool; the probe is on main since S564)
1. One-rep trial: the 10 pairs at n=12 seed=1 v=3 (BOT 0 v mirror, and BOT 0 / 1 / 2 v each man). Stop rule: none on win
   share this time; stop only if a pair's stoppages go over 60%.
2. Full: the same 10 pairs at n=84 seed=2 v=3. Commit and push each txt as it finishes:
   `ops/research/allplay2/tells3m_b<bot>_<man>.txt` (man = jabber, slugger, bodysnatcher, mirror).

## Bars (each pass or fail with the number; the control is BOT 0 against the same man, same seed)
- TELL ALONE IS NOT THE FIGHT: BOT 1 wins at most BOT 0 + 5 points of decided bouts, against each man.
- THE TELL HELPS A LITTLE: BOT 1 takes less health from him than BOT 0, against at least two of the three men.
- FINDING THE LIE PAYS: BOT 2 wins at least BOT 1 + 10 points, OR takes at least 2 health a bout less than BOT 1, against
  each man.
- His fakes on 15-30% of beats against every bot (the cap's job: it was 9-38% in TELLS2M).
- Of his fakes, the real beat did LESS damage than the cue's smallest punch in 100% (the probe can count it: a fake's
  real plan damage from ACT; report the share and any exception).
- Stoppages 10-40% in every pair.
- BOT 0 about 50% against the mirror mix (the control of the control).

## Feedback loops
- Tell -> covered lines -> his punches land less -> he loses more -> nothing feeds back into how he lies (his AI does not
  know it is read). Version 3's cap is on the lies themselves (2 a round, not two running); report whether BOT 1 now
  sits inside its bar. A fake costs him 1 stamina: report his stamina at each bell beside TELLS2M's.
- One-rep trial first (above); a pair whose stoppages pass 60% is not run at n=84.

## Not allowed
No page edit, no edit to rules.mjs, balance.mjs, tells.mjs, play_cli.mjs or any test; delete no test; never commit
`*.vt.json`. You MAY add a counter to probe_tells.mjs for the bluff-share bar (keep `v=2` output unchanged and its test
green). One pull request at the end; never merge it.

## Contract
- OWNS: proto/twohands/tools/probe_tells.mjs (the bluff counter only), ops/research/allplay2/tells3m_b0_mirror.txt (and one
  txt per bot and man, same pattern), docs/TELLS3M_RESULT.md
- RED_TEST: proto/twohands/tools/probe_tells_test.mjs (5 passed before and after)
- REGRESSION: rules_test.mjs 37 passed, page_play_test.mjs 4 passed, probe_tells_test.mjs 5 passed
- VISUAL: none

## Result
`docs/TELLS3M_RESULT.md`: one table - bot | against | wins of decided | health he dealt a bout | knockdowns a bout |
stoppages | his fakes per beat | bluff share | his stamina at the bells - with TELLS2M's trial numbers beside it, then the
bars, then three plain lines: is version 3 worth showing on the page, and what to change if not. End with `TELLS3M DONE`
or `TELLS3M BLOCKED: <why>`.

## Prior research
docs/TELLS2M_RESULT.md, ops/research/DESIGN_TELLS2.md, ops/research/allplay2/ALLPLAY2B_ARENA.md (arena/) and
ALLPLAY2B_ZIVA.md (ziva/), ops/research/allplay2/tell_rates_v3_ai.txt and tell_rates_v3_guard.txt (the version 3 rates
against the AI and a careful player), ops/research/RINGSWITCH_READ_BRIEF_KALLI.md.

## What would a human do?
A designer compares the tester bot with the same bot given no tell, so the opponents' built-in weakness does not pass for
the tell's worth.

## Prefab check
Not applicable (our rules).
