# TASK KICKFIX6 - the kicks, measured on the REBUILT kick.html (ONERULES1 step 3, S570)

Kind: probe. Model: Opus 5.5 or Fable console worker (PC; balance runs). Discipline: kickboxing (Puncher's chance, kick.html).
Seat rules: ops/research/WORKER_S566.md. Read first: docs/KICKFIX5_RESULT.md (F1-F6, the control, why each failed) and
docs/ONERULES1_RESULT.md.

## Why
Owner S569: "shouldnt kicks and everything else get worked all at once ? because how it knows the current changes ?".
Since v0.570.3 kick.html is BUILT from order.html (proto/twohands/tools/make_kick.py + ops/research/s558_balance/
kick_page.json): it now has the feint fix, the pull counter and STEPFIX1 - every KICKFIX number before today was measured
on the old hand-kept copy. KICKFIX5 left F5 (5 of 9 on seed 1) and F6 written, not run (the PC went RED on memory).

## Do
1. The kicks control on the rebuilt page: kick.html with no tweak, its own table, n=56 seeds 1 and 2 (the nine bars).
2. F6 (ops/research/s558_balance/kick_fix_f6.json - every anchor applies to the rebuilt page, checked S570): its own table,
   the n=12 trial gate, then n=56 on seeds 1 and 2.
3. If F6 fails, at most two more versions, one line of why each (KICKFIX5's own next ideas first).
4. The winner (or the best) goes on kick.html ONLY through kick_page.json / make_kick.py (never a hand edit of kick.html):
   add its src pairs to the page json, rebuild, kick_test.mjs + page_play_test.mjs kick.html, one version.js line.
5. docs/KICKFIX6_RESULT.md - the table (control, F6, ...), what the player feels; last line `KICKFIX6 DONE` or `KICKFIX6 BLOCKED: <why>`.
Memory: before each table check the watchdog; if llama-server (the local model) holds > 4 GB, wait - do not start beside it.
jobs=2 while BUILD1 and RULES569 run, jobs=3 if you are alone.

## Feedback loops
The limp loop (more low kicks thrown -> more limps -> no back off -> more low kicks): measured as limp bouts and
stoppages after a limp, as in KICKFIX5. Trial first (n=12) before every n=56.

## Contract
- OWNS: ops/research/s558_balance/kick_fix_f6*.json, kick_fix_f7*.json, kick_fix_f8*.json, ops/research/s558_balance/
  results/kickfix6_*.txt, docs/KICKFIX6_RESULT.md, ops/research/s558_balance/kick_page.json (only to add the winner),
  proto/twohands/kick.html (rebuilt by make_kick.py only), proto/twohands/version.js (one line)
- RED_TEST: the control's nine bars on the rebuilt page (the number to beat)
- REGRESSION: node proto/twohands/tools/kick_test.mjs; node proto/twohands/tools/page_play_test.mjs kick.html
- VISUAL: none (a measure); a full-size still of kick.html only if the winner goes on the page

## Not yours
order.html and every other page. No public push. Never "Ring Switches".
