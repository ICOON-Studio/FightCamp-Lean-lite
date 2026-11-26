# TASK MOMENTGAP1 - may the player put an action in any moment of the beat (a wait between)? Measure it (S562)

Kind: probe. Model: Arena (cloud). Discipline: boxing (Ring Switches).
Seat: Arena, its own clone of the code mirror. Estimate: 2-3 hours on 2 cores, nearly all of it probe runs.

## Why
The owner, playing order.html (S562), on the order strip "1 Body jab then 2 Step in": "can i be able to select exactly on
which part of a beat i move ? or it breaks balance ?". Today a beat is three moments and the switches fill them in order
with NO gap: two actions are always moments 1 and 2. His ask: an action may sit in any moment (for example body jab in 1,
nothing in 2, step in at 3). The slice is balanced on the instrument (owner S555), so it is measured before it is built.

## Do
1. Read `proto/twohands/order.html` rules (above `// ---- the page`): `plan0`, `ordOf`, `perms` and the plan list around
   line 249 (every order of the active slots), `resolve` (moment i = index in `ord`), `cost`. Read
   `proto/twohands/tools/balance.mjs` (`loadTweaked`: a tweak's `src` is a list of [text on the page, its replacement]).
2. A tweak `ops/research/s558_balance/moment_gap_a.json` (rules by `src` patches only - the page file is NOT edited):
   a `'wait'` slot may stand in `ord`: an empty moment (nothing acts, no hand is out, it costs nothing). The plan list
   offers each order of the active slots with at most one wait inserted anywhere, as long as the beat stays at 3 moments
   or fewer. Everything else as today.
3. One-rep trial: `node proto/twohands/tools/balance.mjs table tweak=<a> ...` then `play n=12`: it loads, and how often a
   wait is chosen. Then `play n=84` with seed 1 and seed 2 (`jobs=` your cores). Save the outputs as
   `ops/research/s558_balance/results/moment_gap_a.txt` and `moment_gap_a_s2.txt`; COMMIT AND PUSH after each run.
4. If A fails bars the page passes today (base: 8 of 9), try ONE variant B of your own (for example: a wait costs 1
   stamina, or only the feet may be delayed) and say why.
5. `docs/MOMENTGAP1_RESULT.md`: the 9 bars per version and seed beside today's page; how often a wait is chosen and where
   (moment 1, 2 or 3); which single orders became a must (any order in over 40% of beats); one line: "put on the page:
   <version>" or "none: <the nearest and its miss>". End with `MOMENTGAP1 DONE` or `MOMENTGAP1 BLOCKED: <why>`.

## Feedback loops
- A wait lets a man let the other's punch pass and counter after it: it feeds the counter bonus (+1) and the "beaten to
  the punch" rule. Does it feed back (counters -> health gap -> more waiting)? Report counters a bout and the share of
  beats with a wait, both seeds. Cap: the beat stays three moments; at most one wait.
- One-rep trial first (step 3, n=12) to see it loads and the wait is chosen at all.

## Not allowed
Change no page (order.html, punch.html, kick.html, head.html, body.html) and delete no test. Node only. Open ONE pull
request at the end; never merge it.

## Contract
- OWNS: ops/research/s558_balance/moment_gap_a.json, ops/research/s558_balance/moment_gap_b.json, ops/research/s558_balance/results/moment_gap_a.txt, ops/research/s558_balance/results/moment_gap_a_s2.txt, ops/research/s558_balance/results/moment_gap_b.txt, ops/research/s558_balance/results/moment_gap_b_s2.txt, docs/MOMENTGAP1_RESULT.md
- RED_TEST: none (a measure)
- REGRESSION: proto/twohands/tools/rules_test.mjs 37 passed (the page is not touched)
- VISUAL: none

## Prior research
docs/RINGSWITCH_S558.md (the 9 bars and how they are read); docs/PUNCHCHANCE1_RESULT.md (a tweak measured on two seeds).

## What would a human do?
Try the freer order as a rule patch on the solver, two seeds, and keep it only if no bar breaks.

## Prefab check
Not applicable.
