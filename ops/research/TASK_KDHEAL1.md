# TASK KDHEAL1 - does a knockdown heal too much? Three get-up numbers measured (S563, measure loop)

Kind: probe. Model: Arena (cloud). Discipline: boxing (order.html). Seat: Arena on ICOON-Studio/FightCamp-Lean-lite.
Estimate: 1-2 hours of balance runs.

## Why
The ALLPLAY2 playtest (S563, `ops/research/allplay2/`): a man at 0 health gets up on 6 health the first time, 4 the
second (`N.kd = [6, 4]` in order.html). Ziva: "I went down at 1 health with my bar cut to 5 and came back on 6 health ...
the correct play at 1 health is to walk into a punch, which is what I found myself doing from bout 4 onward." Arena: "A
knockdown HEALS you ... an odd reward for being dropped." Before anyone proposes a rule to the owner, the balance tool
says what lower get-up numbers do to the bars. Nothing goes on the page from this task.

## Versions (tweak files, N only; one run at a time; commit and push each result txt as it finishes)
- KD0: today, `N.kd = [6, 4]` (the control; reuse the latest order.html result if one is in
  `ops/research/s558_balance/results/` for the same page, else run it).
- KD1: `N.kd = [4, 3]` (`ops/research/s558_balance/kd_heal_1.json`).
- KD2: `N.kd = [4, 2]` (`kd_heal_2.json`).
- KD3: `N.kd = [3, 2]` (`kd_heal_3.json`).
One-rep trial first: n=12 each; drop a version whose stoppages go over 60% before its full run. Then n=84 for the rest
(`balance.mjs table tweak=<f> out=<vt> iters=300 jobs=<cores>`, then `balance.mjs play who=mix opp=mirror n=84 tweak=<f>
table=<vt>`).

## What to report per version
The nine bars (pass / fail with the number), knockdowns a bout, stoppages, the share of bouts decided by a knockdown in
the last round, and the comeback share (the man behind on health after round 1 wins). Then one line each: does the
"walk into a punch at 1 health" pull go away (the share of beats a man on 1-2 health throws with both hands, from the
tool's beat counts, if it gives them; say so if it does not).

## Feedback loops
- A lower get-up -> more stoppages -> shorter bouts -> fewer rounds to come back. Cap: the stoppage bar (10-40%).
- A lower get-up -> a man near 0 holds more -> fewer knockdowns. Report knockdowns a bout for each.
- One-rep trial first (above).

## Not allowed
No page edit, no edit to rules.mjs, balance.mjs or any test; delete no test; never commit `*.vt.json`. One pull request
at the end with docs/KDHEAL1_RESULT.md; never merge it.

## Contract
- OWNS: ops/research/s558_balance/kd_heal_1.json, ops/research/s558_balance/kd_heal_2.json,
  ops/research/s558_balance/kd_heal_3.json, ops/research/s558_balance/results/kd_heal_0.txt,
  ops/research/s558_balance/results/kd_heal_1.txt, ops/research/s558_balance/results/kd_heal_2.txt,
  ops/research/s558_balance/results/kd_heal_3.txt, docs/KDHEAL1_RESULT.md
- RED_TEST: today's [6, 4] (the playtest's "a knockdown heals")
- REGRESSION: rules_test.mjs 37 passed, page_play_test.mjs 4 passed (the page is not edited)
- VISUAL: none

## Result
`docs/KDHEAL1_RESULT.md`: one table - version | bars passed | each red bar with its number | knockdowns a bout | stoppages
| comeback share - then which version (if any) should be proposed to the owner and what it changes for the player in two
plain lines. End with `KDHEAL1 DONE` or `KDHEAL1 BLOCKED: <why>`.

## Prior research
ops/research/allplay2/ziva/ALLPLAY2_ZIVA.md (5. TO REACH 10/10, item 1), ops/research/allplay2/arena/ALLPLAY2_ARENA.md
(item 10), docs/RINGSWITCH_S558.md (the bars), docs/PUNCHCHANCE1_RESULT.md (the comeback share).

## What would a human do?
A designer who sees players walk into punches on purpose finds what pays them for it, and measures taking that pay away
before writing the new rule.

## Prefab check
Not applicable (our rules).
