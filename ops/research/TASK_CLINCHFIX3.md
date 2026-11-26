# TASK CLINCHFIX3 - the clinch loop: his habit read sees clinches (S564, probe)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Ring Switches, order.html). Seat: Arena on
ICOON-Studio/FightCamp-Lean-lite. Estimate: 2-3 hours on 2 cores.

## Why
CLINCHFIX2 (docs/CLINCHFIX2_RESULT.md, S564): on today's page the clinch loop (step in, feint, cross, clinch the next beat)
wins 38% / 63% / 70% against the Jabber / Slugger / Body Snatcher (no-clinch control 12 / 13 / 7%). The two economy fixes
cut the loop to 15-27% but left the clinch and the push off dead (2-3% of beats) and knockdowns at 2.6-2.8 a bout: 6 of 9
bars. The lead (S564) found why the economy is the wrong lever: order.html line 228 puts only beats WITH A PUNCH into the
habit history, so his habit read (`ai()`, "he reads habits", OPP.read) can never see a player who clinches every Inside
beat. The fix that keeps the clinch alive: the history records clinch beats too, and his existing read answers them. The
mirror (balance.mjs who=mix opp=mirror) does not use `ai()`, so the nine bars should not move; the loop against the page's
men should fall.
Trial on the PC (S564, n=12, H1): the loop 58% / 33% / 42% against 38% / 63% / 70% - smaller and noisy; measure it.

## Versions (tweak files on main, both load: tweak_check.mjs)
- H0: today's page - reuse CLINCHFIX2's P0 numbers (`results/clinch2_p0*.txt`), no rerun.
- H1: `ops/research/s558_balance/clinch_habit_read.json` - a clinch beat enters the habit history. Nothing else.
- H2: `ops/research/s558_balance/clinch_habit_read_plus1.json` - H1 AND the clinch gives +1 stamina instead of +2.
Each: `probe_clinch.mjs tweak=<f> n=60`, then `balance.mjs table tweak=<f> out=<own folder>/<v>.vt.json iters=300 jobs=2`
and `balance.mjs play who=mix opp=mirror n=84 tweak=<f> table=<vt> seed=1 jobs=2` and the same with `seed=2`. Outputs
`ops/research/s558_balance/results/clinch3_<h1|h2>[_s2|_loop].txt`; commit and push after each.

## Bars
- The loop under 30% against every man (n=60), and at least 15 points under H0's against the Slugger and the Body Snatcher.
- 8 of 9 bars on both seeds (H0 holds 8 of 9; its one fail, punches landing over 65%, is JABLAND1's).
- The clinch and the push off each at least 3% of beats in the mirror (CLINCHFIX2 P1/P2 failed here).
- Report his habit read firing a bout against the loop (count `readOf` on his plans) - it is the mechanism; if it rarely
  fires, say so with the number.

## Feedback loops
- Clinch habit -> his read answers it -> the loop wins less -> a player clinches less -> fewer clinches in his history ->
  the read fires less. Self-limiting by design: the read only fires on 2 of the last 3 beats, at OPP.read odds; cap = the
  existing read rules, unchanged. The one-rep trial is done (above).

## Not allowed
No page edit, no edit to rules.mjs, balance.mjs, probe_clinch.mjs or any test (you may add a read-count line to a COPY of
probe_clinch under your own name); delete no test; never commit `*.vt.json`. One pull request at the end; never merge.

## Contract
- OWNS: ops/research/s558_balance/results/clinch3_h1.txt (and the same pattern for h2, _s2, _loop),
  docs/CLINCHFIX3_RESULT.md
- RED_TEST: none (a probe; H0 is the red: the loop at 38/63/70%)
- REGRESSION: rules_test.mjs 37 passed
- VISUAL: none

## Result
`docs/CLINCHFIX3_RESULT.md`: the loop table (H0 / H1 / H2 x three men + the no-clinch control), the 9 bars per seed, the
clinch and push-off shares, his read a bout. One line: "put on the page: <version>" or "none: <the nearest and its
miss>". End with `CLINCHFIX3 DONE` or `CLINCHFIX3 BLOCKED: <why>`.

## Prior research
docs/CLINCHFIX2_RESULT.md, docs/RINGSWITCH_S558.md (THE CLINCH), ops/research/allplay2/ (four playtesters: "the clinch is a
free delete"), memory project_s558_allplay_body_ui.

## What would a human do?
A designer lets the opponent notice a repeated trick, as a real opponent would, before making the trick itself weaker.

## Prefab check
Not applicable (our rules).
