# TASK LONG3 - the jab that meets him does HEALTH: Long range, round three (S569, probe)

Kind: probe. Model: Arena (cloud, ICOON-Studio/FightCamp-Lean-lite) - or an Opus console worker on the PC if Arena is at
its daily limit AND no game is open. Discipline: boxing (Puncher's chance, order.html).
Estimate: 3-5 hours of balance runs.

## Why
LONG2 (docs/LONG2_RESULT.md, read it first) found the page's solver is BLIND TO POINTS: `worth()` counts health, stamina,
guard, ground and being kept out, never points. So K3 (a head jab landing at Long worth 2 points) changed no choice: its
table was byte-identical to the page's. K2 (the waiting cross +1 health when he walks onto it) was nearest: 8 of 9 page
bars on both seeds, but the rear hand still has no job at Long and the jab stays at 6-8% of beats. LONG2's own next step:
"put the jab half into HEALTH, which the solver can see". Since then the page changed: v0.568.12 (the feint fix, a
feinting hand guards nothing before its feint; vtable.json rebuilt). Measure on TODAY's page.

## Versions (tweak files: `src` patches only; order.html is never edited)
- J: a jab or body jab that lands in the moment he steps in from Long is a counter (+N.counter: 2 health), as a counter is
  today. Nothing else changes.
- JK: J + K2's cross half (copy the cross half from ops/research/s558_balance/long2_k2.json exactly).
- J0 = today's page with its own vtable.json: the control (do NOT reuse LONG2's K0: the feint fix changed the page).
Write `ops/research/s558_balance/long3_check.mjs` the way long2_check.mjs is written: every anchor matches the page once.

## Do
1. `node ops/research/s558_balance/long3_check.mjs` passes. One-rep trials n=12 seed 1 on the page's table for J and JK
   (gate: Long at most 60%, stoppages 5-50%).
2. For each version: its own table (`balance.mjs table tweak=<f> out=<outside the repo> iters=300 jobs=<cores>`), then
   `play who=mix opp=mirror n=84` seeds 1 and 2, the Long count (proto/twohands/tools/probe_long2.mjs, seeds 1 and 2), the
   lazy run (`who=sensible,random opp=mirror n=42 seed=1`). J0 the same way. Commit + push each result as
   `ops/research/s558_balance/results/long3_<j0|j|jk>[_s2|_count|_count_s2|_lazy|_trial].txt`; never a `*.vt.json`.
3. docs/LONG3_RESULT.md: one table (version x seed: page bars passed, each red bar with its number, the LONG2 bars below),
   K2 and J0 beside it; THREE plain lines for the owner: which version (if any) goes on the page and what the player
   feels at Long. Last line `LONG3 DONE` or `LONG3 BLOCKED: <why>`.

## Bars (LONG2's, against J0)
- The page's nine bars: 8 or 9 of 9 on BOTH seeds, never fewer than J0 on the same seed; mirror 40-60%.
- The jab works at Long: the head jab in 10%+ of all beats; the share of Long beats with nothing thrown DOWN against J0.
- The rear hand has a job at Long: a cross from Long in 5-15% of the beats that start at Long, landing 30-65%.
- Long does not swallow the bout: Long at most 45% of beats, Inside at least 20%; stoppages 10-40%; knockdowns 0.5-2.5.
- The man walking in still gets in: steps in from Long that get in unhit fall by at most 5 points against J0 (the page was
  already under LONG2's 60% bar at 50-54%; report the share beside J0); "step in" 20%+ of beats;
  "lead held high" never a must (under 40% of beats).
- No lazy plan: `who=sensible` and `who=random` win no more than in J0 (n=42, seed 1).
- The feint loop (probe_clinch.mjs, loop + no clinch, n=60) not worse than J0 against any man, on a passing version.

## Feedback loops
- The jab that meets him -> stepping in from Long costs health -> fewer step ins -> more beats at Long -> more jabs that
  wait for him -> fewer step ins: capped by "step in 20%+", "Long at most 45%" and "Inside at least 20%". The n=12 trial
  reports step in and Long first; under 20% step in at n=12 = stop that version and say so.
- The jab +2 -> he steps in behind a high lead -> the body jab lands under it -> he stops stepping in: report step in by
  lead height (as LONG2 did).
- Health -> knockdowns: a counter jab feeds knockdowns; knockdowns 0.5-2.5 is the cap; report it at n=12 too.
- One-rep trial first: n=12 before any table, for every version.

## Not allowed
Change no page, no tool and no test (tweak files and long3_check.mjs only). One pull request at the end; never merge it.

## Contract
- OWNS: ops/research/s558_balance/long3_j.json, ops/research/s558_balance/long3_jk.json,
  ops/research/s558_balance/long3_check.mjs, ops/research/s558_balance/results/long3_j0.txt (and the other long3_* result
  files), docs/LONG3_RESULT.md
- RED_TEST: K2 at n=84: 8 of 9 both seeds, the jab at 6-7% of beats (bar 10%), cross from Long landing 8-12% (bar 30-65%)
- REGRESSION: node proto/twohands/tools/rules_test.mjs (RULES_TEST 37 passed); node ops/research/s558_balance/long3_check.mjs
- VISUAL: none

## Prior research
docs/LONG2_RESULT.md, docs/LONG1_RESULT.md, ops/research/TASK_LONG2.md (the Long count, the bars), docs/FEINTFIX2_RESULT.md
(the page's current rules), ops/research/s558_balance/long2_k2.json.

## What would a human do?
A boxing coach: the jab is the tool at long range because the man walking in walks INTO it - it hurts him and resets him,
it does not just score. Make the jab that meets a step in cost him health, which is what our solver plays for.

## Prefab check
Not applicable (our own rules).
