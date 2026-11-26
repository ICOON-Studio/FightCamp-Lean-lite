# TASK JABLAND1 - the one bar the page still fails: the jab and the overhand land too often (S562)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Ring Switches).
Seat: Arena, its own clone of the code mirror. Estimate: 2-3 hours on 2 cores, nearly all of it probe runs.

## Why
`proto/twohands/order.html` holds 8 of 9 bars; the bar it fails in every measure since S558 is "every punch lands 30-65% of
the time and falls short at most 40%": the jab lands 69-74%, the overhand 78-81% (`docs/PUNCHCHANCE2_RESULT.md` table,
`ops/research/s558_balance/punch_chance_out/f84.txt`; the S561 handover: "base84 with the pull counter: the jab lands 74%,
back off in 35% of beats (the must bar is 40%)"). The owner wants the slice balanced on the instrument (S555: "perfectly
balance to move on"), and his question this session ("is there any point in holding both hands up or one hand up covers
all attacks on the head?") shows the guard must read as a real answer to the punch.
Known (memory, S555): a WEAKER strike lands MORE - the mix throws a cheap punch where it is least covered. So do not just
weaken the jab.

## Do
1. Read the rules above `// ---- the page` in order.html (ACT, COVER, STOPS, resolve) and `proto/twohands/tools/balance.mjs`
   (`table`, `play`, the bars; a tweak's `N`, `ACT` and `src` patches). Today's base: `play n=84` seed 1 and seed 2 with no
   tweak - save as `ops/research/s558_balance/results/jabland_base.txt` / `_s2.txt` (the RED: the landing bar fails).
2. Up to THREE versions, your own ideas, each the smallest rule change you can name, each as a tweak file
   `ops/research/s558_balance/jabland_<a|b|c>.json` (rules only by `src` patches or `N` / `ACT` numbers; no page edit). Say
   in one line each why it should cut the jab's and the overhand's landing without making another punch a must. Ideas to
   weigh (not orders): the overhand slow enough to be read (it is slow 3 already: is it the side line no hold stops at
   Mid?); the lead hand held high parries the jab at Long AND Mid; a jab that lands twice running is read the third time.
3. Each: one-rep trial `play n=12`, then `table` + `play n=84` seed 1 and seed 2; save `jabland_<x>.txt` / `_s2.txt`.
   COMMIT AND PUSH after each run.
4. `docs/JABLAND1_RESULT.md`: a table - per version and seed the 9 bars, each punch's land %, the must bar (back off,
   step in), the mirror. One line: "put on the page: <version>" (9 of 9 on both seeds, or 8 with the landing bar now
   passing and the reason the other failed) or "none: <the nearest and its miss>". End with `JABLAND1 DONE` or
   `JABLAND1 BLOCKED: <why>`.

## Feedback loops
- Less landing feeds fewer counters and less damage; longer bouts feed more beats for the stamina bars and more chances
  to read a repeated punch (the read feeds back on the punch it reads). Cap: the read already looks at the last three
  punching beats only; report knockdowns a bout and stoppages per version (the stoppage bar must not drop under 10%).
- One-rep trial first (n=12) for every version.

## Not allowed
Change no page (order.html, punch.html, kick.html, head.html, body.html) and delete no test. Node only. Open ONE pull
request at the end; never merge it.

## Contract
- OWNS: ops/research/s558_balance/jabland_a.json, ops/research/s558_balance/jabland_b.json, ops/research/s558_balance/jabland_c.json, ops/research/s558_balance/results/jabland_base.txt, ops/research/s558_balance/results/jabland_base_s2.txt, ops/research/s558_balance/results/jabland_a.txt, ops/research/s558_balance/results/jabland_a_s2.txt, ops/research/s558_balance/results/jabland_b.txt, ops/research/s558_balance/results/jabland_b_s2.txt, ops/research/s558_balance/results/jabland_c.txt, ops/research/s558_balance/results/jabland_c_s2.txt, docs/JABLAND1_RESULT.md
- RED_TEST: jabland_base.txt - the landing bar fails on today's page (jab ~70%, overhand ~78%)
- REGRESSION: proto/twohands/tools/rules_test.mjs 37 passed (the page is not touched)
- VISUAL: none

## Prior research
docs/RINGSWITCH_S558.md (the bars); docs/PUNCHCHANCE2_RESULT.md; ops/research/RINGSWITCH_BALANCE_BRIEF_KALLI.md and
_JOHN.md (S555 balance answers); memory project_s555_ring_switches_balance ("a weaker strike lands MORE").

## What would a human do?
Watch which guard the jab beats and why, then give the defender one honest answer to it, measured on two seeds.

## Prefab check
Not applicable.
