# TASK CLINCHFIX2 - the clinch pays too well: measure the version where the push off gets a second job (S562)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Ring Switches).
Seat: Arena, its own clone of the code mirror. Estimate: 2-3 hours on 2 cores, nearly all of it probe runs.

## Why
`docs/RINGSWITCH_S558.md` (read "THE CLINCH" whole, lines 30-80): four of five players found a rote loop (step in, feint,
cross, clinch the next beat) that wins 43% / 53% / 43% against the Jabber / Slugger / Body Snatcher; without the clinch the
same script wins 3%. The milder clinches cut the loop (down to 5-27%) but each held only 7 of 9 bars on the balance tool:
the push off fell to 3% of beats, because it is the answer to a clinch and nobody needs it when the clinch pays less.
S559 wrote the version that gives the push off a second job but never measured it:
`ops/research/s558_balance/clinch_half_push_counter.json` (the clinch +1 stamina, the man tied up gets half his smothered
plan's stamina back, and a push off that lands puts him off balance: the pusher's later punches that beat are counters +1).
The page has changed since (S560 pull counter on order.html): measure on today's page.

## Do
1. Read `proto/twohands/tools/probe_clinch.mjs` and `proto/twohands/tools/balance.mjs`; check each `src` anchor of the
   tweak still matches today's `proto/twohands/order.html` (fix only the anchor text if the page moved, never the rule).
2. One-rep trial: `node proto/twohands/tools/probe_clinch.mjs tweak=<file> n=12` - it loads and the loop is played.
3. Versions (each: probe_clinch n=60 a man; then `balance.mjs table tweak=<file>` and `play n=84` seed 1 and seed 2):
   - P0: today's page (no tweak) - the base, on today's page.
   - P1: `clinch_half_push_counter.json` as it is.
   - P2: `clinch_net0_back_all.json` plus the same push-off counter (`clinch_push_counter_all.json`, new).
   Save outputs as `ops/research/s558_balance/results/clinch2_<p0|p1|p2>[_s2].txt` and `clinch2_<p>_loop.txt`. COMMIT AND
   PUSH after each run.
4. `docs/CLINCHFIX2_RESULT.md`: per version the loop wins against the three men, the 9 bars per seed, the push off's share of
   beats, clinches a bout. One line: "put on the page: <version>" (the mildest that holds 8 of 9 on both seeds AND brings
   the loop under 25% against every man) or "none: <the nearest and its miss>". End with `CLINCHFIX2 DONE` or
   `CLINCHFIX2 BLOCKED: <why>`.

## Feedback loops
- The push-off counter feeds counters (+1 health); more damage widens the health gap; a man behind clinches more; more
  clinches make the push off more useful. Cap in the rule: the counter lasts only the rest of that beat, the clinch works
  Inside only and not twice running. Report clinches a bout and push offs a bout per version and seed: if both rise
  together from P0, say so.
- One-rep trial first (step 2).

## Not allowed
Change no page (order.html, punch.html, kick.html, head.html, body.html) and delete no test. Node only. Open ONE pull
request at the end; never merge it.

## Contract
- OWNS: ops/research/s558_balance/clinch_push_counter_all.json, ops/research/s558_balance/clinch_half_push_counter.json, ops/research/s558_balance/results/clinch2_p0.txt, ops/research/s558_balance/results/clinch2_p0_s2.txt, ops/research/s558_balance/results/clinch2_p1.txt, ops/research/s558_balance/results/clinch2_p1_s2.txt, ops/research/s558_balance/results/clinch2_p2.txt, ops/research/s558_balance/results/clinch2_p2_s2.txt, ops/research/s558_balance/results/clinch2_p0_loop.txt, ops/research/s558_balance/results/clinch2_p1_loop.txt, ops/research/s558_balance/results/clinch2_p2_loop.txt, docs/CLINCHFIX2_RESULT.md
- RED_TEST: the loop wins 43% / 53% / 43% on the page (docs/RINGSWITCH_S558.md) - P0 reproduces it on today's page
- REGRESSION: proto/twohands/tools/rules_test.mjs 37 passed (the page is not touched)
- VISUAL: none

## Prior research
docs/RINGSWITCH_S558.md (THE CLINCH); ops/research/s558_balance/clinch_*.json; docs/PUNCHCHANCE1_RESULT.md (two seeds).

## What would a human do?
Make the scripted loop stop paying, then check the other bars still hold, on two seeds.

## Prefab check
Not applicable.
