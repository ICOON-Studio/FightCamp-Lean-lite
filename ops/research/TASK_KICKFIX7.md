# TASK KICKFIX7 - the kicks: F7 on the rebuilt kick.html, after KICKFIX6 (S571)

Kind: probe. Model: Opus 5.5 or Fable console worker (PC; balance runs). Discipline: kickboxing (Puncher's chance, kick.html).
Seat rules: ops/research/WORKER_S566.md. Read first: docs/KICKFIX6_RESULT.md (control + F6 numbers), docs/KICKFIX5_RESULT.md,
ops/research/TASK_KICKFIX6.md (same tools: E:/FightCamp/wt_tmp/KICKFIX6/run.sh, kf_play.mjs).
Memory: before each table check the watchdog; wait while RED, RAM 88%+, ArcheAge open or llama-server > 4 GB.

## Why
KICKFIX6 (28 Nov): the control fails 4-5 of 9 bars (stoppages 96-98%, kicks land 88-91%, no strike in 56-61% of beats).
F6 halves stoppages (50%) and knockdowns (2.7) but still 4 of 9: the low kick lands 90%, the head kick dies (2% of beats at
3 stamina), the feet go first in 62% of ordered beats.

## Do
1. Count first (no table): in the F6 n=12 log, every low kick thrown at a man whose leg was covered (c.leg: feet hold / back
   off / a feet teep) - how many, and why each still landed. The fix follows what this shows (one line of why).
2. F7 = kick_fix_f7.json: F6 + that leg-cover fix (target low kick lands 50-65%) + head kick st 2 (ACT.headk) + the clinch
   smothers kicks (KICKFIX5's idea; the clinch is at 1-2% of beats on every version). Own table, n=12 trial, then n=56 seeds 1, 2.
3. If F7 fails, at most one more (F8), one line of why.
4. The winner goes on kick.html ONLY through kick_page.json / make_kick.py, as KICKFIX6 step 4.
5. docs/KICKFIX7_RESULT.md - table (control and F6 from KICKFIX6, then F7, F8), what the player feels; last line
   `KICKFIX7 DONE` or `KICKFIX7 BLOCKED: <why>`.

## Feedback loops
The limp loop (low kicks land -> limp -> no back off -> more low kicks): limp bouts and stoppages after a limp, as before
(F6: 8/12 limp bouts, 4 to the bell). A leg cover that works shortens it; cap = N.limp. Trial n=12 before every n=56.

## Contract
- OWNS: ops/research/s558_balance/kick_fix_f7*.json, kick_fix_f8*.json, results/kickfix7_*.txt, docs/KICKFIX7_RESULT.md,
  kick_page.json (winner only), proto/twohands/kick.html (make_kick.py only), proto/twohands/version.js (one line)
- RED_TEST: F6's nine bars (4 of 9) - the number to beat
- REGRESSION: node proto/twohands/tools/kick_test.mjs; node proto/twohands/tools/page_play_test.mjs kick.html
- VISUAL: none unless the winner goes on the page

## Not yours
order.html and every other page. No public push. Never "Ring Switches".

## Prior research
KICKFIX5_RESULT, KICKFIX6_RESULT, ONERULES1_RESULT, memory S559 kickboxer first.

## What would a human do?
A kickboxing coach: a planted lead leg eats low kicks; lifting it (the check) or stepping back takes the leg away - the
kicker pays for a checked kick. Head kicks are rare but cheap enough to threaten.

## Prefab check
None needed: a balance change to our own page.
